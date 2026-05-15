import random

import numpy as np
from sklearn.decomposition import PCA
from sklearn.preprocessing import StandardScaler
from sklearn.pipeline import Pipeline
import numpy as np
import scipy
from scipy.constants import h, c, k
import matplotlib.pyplot as plt
from matplotlib.patches import Circle
from colour_system import cs_hdtv
import colour
from PIL import Image
from scipy.optimize import minimize
from colour import CCS_ILLUMINANTS
import pandas as pd
from scipy.ndimage import zoom as nd_zoom
from astropy.io import fits
from get_spectra import all_spectra, Spectrum
import os
from utils import parse_tag, IMG_to_npy, averaged_interp


def autoalign(channel_list):
    # a not very good function to automatically line up the curves of the planets because I was too lazy to do it myself
    # it translates and uniformally scales then
    # running this on saturn doesn't really work because it doesn't seem to know whether to align for saturn or titan
    align_scales = np.ones(3)
    # these defaults are tuned for the venus express images:
    align_points = (
        np.array([[280, 284], [277, 239], [233, 291]], dtype=float) * 512 / 550
    )

    from scipy.optimize import minimize_scalar

    n = len(channel_list)
    if n < 2:
        return

    def phase_shift_score(r, m):
        C = np.fft.fft2(r) * np.conj(np.fft.fft2(m))
        corr = np.fft.ifft2(C / (np.abs(C) + 1e-10)).real
        ry, rx = np.unravel_index(np.argmax(corr), corr.shape)
        score = corr[ry, rx]
        if ry > corr.shape[0] // 2:
            ry -= corr.shape[0]
        if rx > corr.shape[1] // 2:
            rx -= corr.shape[1]
        return int(rx), int(ry), score

    def _scale_channel(img, scale):
        if abs(scale - 1.0) < 1e-4:
            return img.astype(float)
        h, w = img.shape
        zoomed = nd_zoom(img.astype(float), scale, order=1)
        zh, zw = zoomed.shape
        out = np.zeros((h, w), dtype=float)
        oy = max(0, (h - zh) // 2)
        ox = max(0, (w - zw) // 2)
        sy = max(0, (zh - h) // 2)
        sx = max(0, (zw - w) // 2)
        ch = min(h - oy, zh - sy)
        cw = min(w - ox, zw - sx)
        out[oy : oy + ch, ox : ox + cw] = zoomed[sy : sy + ch, sx : sx + cw]
        return out

    ref_idx = n // 2
    ref = np.maximum(0, channel_list[ref_idx].arr).astype(float)

    shifts = np.zeros((n, 2))
    new_scales = align_scales.copy()

    for i in range(n):
        if i == ref_idx:
            continue

        img = np.maximum(0, channel_list[i].arr).astype(float)

        # coarse scale search
        best_score = -np.inf
        best_s = 1.0
        for s in np.arange(0.7, 1.45, 0.05):
            _, _, score = phase_shift_score(ref, _scale_channel(img, s))
            if score > best_score:
                best_score = score
                best_s = s

        # fine scale refinement
        result = minimize_scalar(
            lambda s: -phase_shift_score(ref, _scale_channel(img, s))[2],
            bounds=(best_s - 0.06, best_s + 0.06),
            method="bounded",
        )
        best_s = float(result.x)
        dx, dy, _ = phase_shift_score(ref, _scale_channel(img, best_s))

        new_scales[i] = best_s
        shifts[i] = [dx, dy]

    align_scales = new_scales
    centered = shifts - np.mean(shifts, axis=0)
    base = np.mean(align_points[:n], axis=0)
    for i in range(n):
        align_points[i] = base - centered[i]

    # edit the channels themselves
    mean_point = np.mean(align_points, axis=0).astype(int)
    max_val = max([np.max(el.arr) for el in channel_list])
    scaled = [
        _scale_channel(np.maximum(0, channel_list[i].arr), align_scales[i])
        for i in range(3)
    ]
    three_chan = np.stack(scaled, axis=2)
    for chan_i in range(3):
        three_chan[:, :, chan_i] = np.roll(
            three_chan[:, :, chan_i], -(align_points[chan_i][0] - mean_point[0]), axis=1
        )
        three_chan[:, :, chan_i] = np.roll(
            three_chan[:, :, chan_i], -(align_points[chan_i][1] - mean_point[1]), axis=0
        )
        channel_list[chan_i].arr = three_chan[:, :, chan_i]
    return channel_list


class Channel:
    def __init__(self, arr, filter_bounds):
        self.arr = arr
        self.filter_bounds = filter_bounds


def load_IMG(path):
    with open(path) as f:
        img = np.fromfile(f, dtype=">i2")[-512 * 512 :]
        img = img.reshape((512, 512))
    return img


def load_PNG(path):
    img = np.maximum(0,np.asarray(Image.open(path).convert("L")).astype(float)-1)
    return img


def create_ciexyz_data_by_lam_i(lam):
    cs = cs_hdtv

    with open("CIEXYZ.txt") as f:
        ciexyz_data = np.array(
            [
                [float(el) for el in line.split(" ")]
                for line in "".join(f.readlines()).split("\n")
            ]
        )

    ciexyz_data_by_lam_i = np.zeros((lam.shape[0], 3))

    for lam_el_i, lam_el in enumerate(lam):
        if len(np.where(ciexyz_data[:, 0] < lam_el)[0]):
            ciexyz_data_by_lam_i[lam_el_i] = ciexyz_data[
                np.where(ciexyz_data[:, 0] < lam_el)[0][-1]
            ][1:]
        else:
            ciexyz_data_by_lam_i[lam_el_i] = 0

    return ciexyz_data_by_lam_i


def spectrum_to_xyz(spectrum, ciexyz_data_by_lam_i):
    return np.sum(ciexyz_data_by_lam_i[:, :] * spectrum[:, None], axis=0)


def spectrum_arr_to_xyz(spectrum, ciexyz_data_by_lam_i):
    return np.sum(ciexyz_data_by_lam_i[None, :, :] * spectrum[:, :, None], axis=1)


def true_color(channels, reference_spectrum, type="reflectance"):
    def piecewise_from_λ_J_arr(λ_all, λ_set, J_arr):
        J_arr = np.maximum(J_arr, 0)
        piecewise_out = np.zeros((len(J_arr), len(λ_all)))
        sort_idx = np.argsort(λ_set)
        mask = λ_all < λ_set[sort_idx[0]]
        piecewise_out[:, mask] = J_arr[:, sort_idx[0]][:, None]

        for i in range(0, len(J_arr[0]) - 1):
            mask = np.logical_and(
                λ_all >= λ_set[sort_idx[i]], λ_all < λ_set[sort_idx[i + 1]]
            )
            piecewise_out[:, mask] = J_arr[:, sort_idx[i]][:, None] + (
                J_arr[:, sort_idx[i + 1]] - J_arr[:, sort_idx[i]]
            )[:, None] * (λ_all[mask] - λ_set[sort_idx[i]]) / (
                λ_set[sort_idx[i + 1]] - λ_set[sort_idx[i]]
            )

        mask = λ_all >= λ_set[sort_idx[-1]]
        piecewise_out[:, mask] = J_arr[:, sort_idx[-1]][:, None]
        return np.maximum(0, piecewise_out)

    def loss_M(M):
        P = np.reshape(
            np.dstack([channels[i].arr[::16, ::16] for i in range(len(channels))]),
            (
                channels[0].arr[::16, ::16].shape[0]
                * channels[0].arr[::16, ::16].shape[1],
                len(channels),
            ),
        )
        J = P * M[None, :]

        piecewise = piecewise_from_λ_J_arr(
            reference_spectrum[0],
            [np.mean(channels[i].filter_bounds) for i in range(len(channels))],
            J,
        )
        modified_spec = piecewise * reference_spectrum[1][None, :]
        filter_integrations = []
        filter_truevals = []
        for i in range(len(channels)):
            mask = np.logical_and(
                reference_spectrum[0] >= channels[i].filter_bounds[0],
                reference_spectrum[0] < channels[i].filter_bounds[1],
            )
            filter_integrations.append(np.mean(modified_spec[:, mask], axis=1))
            filter_truevals.append(np.ndarray.flatten((channels[i].arr[::16, ::16])))
        lossval = np.sum(
            (np.array(filter_integrations) - np.array(filter_truevals)) ** 2
        )
        return lossval

    res = minimize(loss_M, np.ones((len(channels),)))
    M = res.x
    P = np.reshape(
        np.dstack([channels[i].arr for i in range(len(channels))]),
        (channels[0].arr.shape[0] * channels[0].arr.shape[1], len(channels)),
    )
    J = P * M[None, :]
    piecewise = piecewise_from_λ_J_arr(
        reference_spectrum[0],
        [np.mean(channels[i].filter_bounds) for i in range(len(channels))],
        J,
    )
    modified_spec = piecewise * reference_spectrum[1][None, :]

    # to make sure it has the same average spectrum across the full disk as the reference given
    modified_spec = modified_spec / np.mean(piecewise, axis=0)

    as_xyz = spectrum_arr_to_xyz(
        modified_spec, create_ciexyz_data_by_lam_i(reference_spectrum[0])
    )

    if type=="reflectance":
        # Illuminant E is used because it was converted back to a reflectance spectrum
        as_rgb = np.maximum(
            0,
            colour.XYZ_to_sRGB(
                as_xyz,
                illuminant=CCS_ILLUMINANTS["CIE 1931 2 Degree Standard Observer"]["E"],
            ),
        )
    elif type=="D65":
        as_rgb = np.maximum(
            0,
            colour.XYZ_to_sRGB(
                as_xyz,
            ),
        )
    as_rgb = np.reshape(as_rgb, (channels[0].arr.shape[0], channels[0].arr.shape[1], 3))

    return (as_rgb / np.max(as_rgb) * 243).astype("uint8")
    plt.title("as_rgb")
    plt.imshow((as_rgb / np.max(as_rgb) * 243).astype("uint8"))
    plt.show()


# Venus Reflectance Spectrum

with open("Venus_PerezHoyos2018.txtU", "r") as f:
    perezhoyos_spectrum = np.array(
        [
            np.array([float(line.split(" ")[0]) * 1000, float(line.split(" ")[2])])
            for line in f.readlines()
        ]
    )


messenger_files = []
for f in os.listdir("MESSENGER/"):
    if f.startswith("CW0089565") and f.endswith("_RA_5.xml"):
        messenger_files.append(f.split(".")[0])
messenger_channels = []
for filename in messenger_files:
    tag_data = parse_tag(f"MESSENGER/{filename}.xml", "Optical_Filter")[
        "Optical_Filter"
    ]
    messenger_channels.append(
        Channel(
            np.maximum(0, IMG_to_npy(f"MESSENGER/{filename}.IMG") - 9),
            [
                float(tag_data["center_filter_wavelength"])
                - float(tag_data["bandwidth"]) / 2,
                float(tag_data["center_filter_wavelength"])
                + float(tag_data["bandwidth"]) / 2,
            ],
        )
    )
    # plt.imshow(IMG_to_npy(f"MESSENGER/{filename}.IMG"))
    # plt.show()

minnaert_messenger_channels = []
for filename in messenger_files:
    tag_data = parse_tag(f"MESSENGER/{filename}.xml", "Optical_Filter")[
        "Optical_Filter"
    ]
    minnaert_messenger_channels.append(
        Channel(
            np.minimum(np.load(f"minnaert_ratio_npy/{filename}.npy"),np.percentile(np.load(f"minnaert_ratio_npy/{filename}.npy"),99)),
            [
                float(tag_data["center_filter_wavelength"])
                - float(tag_data["bandwidth"]) / 2,
                float(tag_data["center_filter_wavelength"])
                + float(tag_data["bandwidth"]) / 2,
            ],
        )
    )


venus_express_channels = [
    Channel(
        load_IMG("VEX_2/V0942_0004_UV2.IMG"),
        [365 - 40 / 2, 365 + 40 / 2],
    ),
    Channel(
        load_IMG("VEX_2/V0942_0005_VI2.IMG"),
        [513 - 20 / 2, 513 + 20 / 2],
    ),
    Channel(
        load_IMG("VEX_2/V0942_0006_N12.IMG"),
        [935 - 70 / 2, 935 + 70 / 2],
    ),
]

mariner_10_channels = [
    Channel(
        load_PNG("Mariner10/polished_UV.png"),
        [330,390],
    ),
    Channel(
        load_PNG("Mariner10/polished_blue.png"),
        [410,530],
    ),
    Channel(
        load_PNG("Mariner10/polished_orange.png"),
        [540,630],
    ),
]

venus_express_channels = autoalign(venus_express_channels)

ZERO_THRESHOLD = (
    20  # any values below this will just be set to zero, to clean out noise
)
for chan_i in range(len(venus_express_channels)):
    # venus_express_channels[chan_i].arr[venus_express_channels[chan_i].arr<ZERO_THRESHOLD] = 0
    venus_express_channels[chan_i].arr = np.maximum(
        0, venus_express_channels[chan_i].arr - ZERO_THRESHOLD
    )


# The wavelengths in nm to use for the interpolation
lam = np.arange(300.0, 981.0, 5)

# Sun spectrum TCT uses

sun_fits = fits.open("sun_reference_stis_002.fits")
sun_fits.info()
sun_fits_data = sun_fits[1].data

solar_flux_interpolated = averaged_interp(
    sun_fits_data["wavelength"] / 10, sun_fits_data["flux"], lam
)


kuiper_interpolated = all_spectra["Venus_Kuiper_1969b"].get_reflectance().interp(lam)

perezhoyos_interpolated = (
    all_spectra["Venus_PerezHoyos2018"].get_reflectance().interp(lam)
)

pellier_interpolated = (
    all_spectra["christophe_pellier"].get_reflectance().interp(lam)
)

selsis_interpolated = all_spectra["Selsis et al., 2008"].get_reflectance().interp(lam)

vpl_interpolated = all_spectra["VPL Venus Flux"].get_reflectance().interp(lam)

vpl_interpolated = all_spectra["VPL Venus Flux"].get_reflectance().interp(lam)

USGS_interpolated = all_spectra["messenger_filters"].get_reflectance().interp(lam)

# all_spectra["messenger_filters"].get_reflectance().plot()

all_spectra[f"average"] = Spectrum(lam, selsis_interpolated+pellier_interpolated+perezhoyos_interpolated, "Intensity", "Venus")

average_interpolated = all_spectra["average"].get_intensity().interp(lam)

venus_reflectance_spectra = {
    "PerezHoyos": perezhoyos_interpolated,
    "average":average_interpolated,
    "Kuiper": kuiper_interpolated,
    "Pellier": pellier_interpolated,
    "Selsis": selsis_interpolated,
    "VPL": vpl_interpolated,
    "USGS": USGS_interpolated,
}

txt_names = {
    "christophe_pellier": "Venus_Pellier2020.txtA",
    "Selsis et al., 2008": "Venus_Selsis2008.txtU",
}
for all_spectra_key in txt_names:
    all_spectra[all_spectra_key].save_txt(
        f"for_TCT/{txt_names[all_spectra_key]}",
    )

for venus_reference_spectrum_key in venus_reflectance_spectra:
    # this is a reflectance spectrum
    venus_reference_spectrum_set = [
        lam,
        venus_reflectance_spectra[venus_reference_spectrum_key],
    ]

    as_rgb = true_color(mariner_10_channels, venus_reference_spectrum_set)
    Image.fromarray(as_rgb).save(f"venus_m10_{venus_reference_spectrum_key}.png")

    as_rgb = true_color(minnaert_messenger_channels, venus_reference_spectrum_set)
    Image.fromarray(as_rgb).save(f"venus_minnaert_messenger_{venus_reference_spectrum_key}.png")

    as_rgb = true_color(messenger_channels, venus_reference_spectrum_set)
    Image.fromarray(as_rgb).save(f"venus_messenger_{venus_reference_spectrum_key}.png")

    as_rgb = true_color(venus_express_channels, venus_reference_spectrum_set)
    Image.fromarray(as_rgb).save(f"venus_vex_{venus_reference_spectrum_key}.png")


# D65 Test
kuiper_interpolated = all_spectra["Venus_Kuiper_1969b"].get_intensity().interp(lam)

perezhoyos_interpolated = (
    all_spectra["Venus_PerezHoyos2018"].get_intensity().interp(lam)
)

pellier_interpolated = (
    all_spectra["christophe_pellier"].get_intensity().interp(lam)
)

selsis_interpolated = all_spectra["Selsis et al., 2008"].get_intensity().interp(lam)

vpl_interpolated = all_spectra["VPL Venus Flux"].get_intensity().interp(lam)

vpl_interpolated = all_spectra["VPL Venus Flux"].get_intensity().interp(lam)

USGS_interpolated = all_spectra["messenger_filters"].get_intensity().interp(lam)

all_spectra["messenger_filters"].get_intensity().plot()

all_spectra[f"average"] = Spectrum(lam, selsis_interpolated+pellier_interpolated+perezhoyos_interpolated, "Intensity", "Venus")

average_interpolated = all_spectra["average"].get_intensity().interp(lam)

venus_reflectance_spectra = {
    "PerezHoyos": perezhoyos_interpolated,
    "average":average_interpolated,
    "Kuiper": kuiper_interpolated,
    "Pellier": pellier_interpolated,
    "Selsis": selsis_interpolated,
    "VPL": vpl_interpolated,
    "USGS": USGS_interpolated,
}

txt_names = {
    "christophe_pellier": "Venus_Pellier2020.txtA",
    "Selsis et al., 2008": "Venus_Selsis2008.txtU",
}
for all_spectra_key in txt_names:
    all_spectra[all_spectra_key].save_txt(
        f"for_TCT/{txt_names[all_spectra_key]}",
    )

for venus_reference_spectrum_key in venus_reflectance_spectra:
    # this is a reflectance spectrum
    venus_reference_spectrum_set = [
        lam,
        venus_reflectance_spectra[venus_reference_spectrum_key],
    ]

    as_rgb = true_color(venus_express_channels, venus_reference_spectrum_set,type="D65")
    Image.fromarray(as_rgb).save(f"venus_vex_{venus_reference_spectrum_key}_D65.png")

    as_rgb = true_color(messenger_channels, venus_reference_spectrum_set,type="D65")
    Image.fromarray(as_rgb).save(f"venus_messenger_{venus_reference_spectrum_key}_D65.png")

# Saturn Reflectance Spectrum

# RED 650
# BL1 451
# GRN 568
titan_saturn_three_channels = np.load("pglopus3_three_channels.npy")[::1, ::1].astype(
    float
)
titan_three_channels = np.maximum(
    0,
    np.minimum(
        titan_saturn_three_channels,
        np.percentile(titan_saturn_three_channels, 99) * 1.1,
    ),
)
titan_three_channels = np.maximum(
    0, np.minimum(titan_three_channels, np.percentile(titan_three_channels, 99) * 1.1)
)
titan_three_channels = (titan_three_channels * 256).astype(int) / 256
titan_three_channels = np.minimum(
    1, titan_three_channels / (np.percentile(titan_three_channels, 99) * 1.1)
)
titan_three_channels *= 255 / np.max(titan_three_channels)
# these are aligned for Titan rather than Saturn

cassini_channels = [
    Channel(
        titan_three_channels[:, :, 2], [450.851 - 102.996 / 2, 450.851 + 102.996 / 2]
    ),
    Channel(
        titan_three_channels[:, :, 1], [568.134 - 113.019 / 2, 568.134 + 113.019 / 2]
    ),
    Channel(
        titan_three_channels[:, :, 0], [650.086 - 149.998 / 2, 650.086 + 149.998 / 2]
    ),
]

# Saturn Spectrum I had lying around that I admittedly don't have the source for but matches https://atmos.nmsu.edu/planetary_datasets/saturn_infrared.html
saturn_reference_spectrum = np.load("saturn_reference_spectrum.npy")

as_rgb = true_color(cassini_channels, saturn_reference_spectrum)
Image.fromarray(as_rgb).save("saturn.png")
