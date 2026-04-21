import matplotlib.pyplot as plt
import pvlib
import numpy as np
from scipy.constants import h, c, k
from scipy.io import readsav
import pandas as pd
from datetime import datetime, timedelta
import matplotlib.dates as mdates
import copy
from utils import *
from spectra.extract_spectra import find_red_pixel_averages, Spectrum
from astropy.io import fits



all_spectra = {}

# Sun spectrum TCT uses

hdul = fits.open("sun_reference_stis_002.fits")
hdul.info()
data = hdul[1].data
header = hdul[1].header
wavelength = data['wavelength']/10
flux = data['flux']

all_spectra["sun_reference_stis_002"] = Spectrum(data['wavelength']/10,data['flux'],"Intensity","Sun")





# ASTM G173-03

am15 = pvlib.spectrum.get_reference_spectra(standard="ASTM G173-03")

lamm = np.linspace(200,1200,400)
all_spectra["Sunlight in Space"] = Spectrum(lamm,averaged_interp(am15.index, am15["extraterrestrial"],lamm),"Intensity","Sun")
all_spectra["Global ASTM G173-03"] = Spectrum(am15.index, am15["global"],"Intensity","Sun*")
all_spectra["Direct ASTM G173-03"] = Spectrum(am15.index, am15["direct"],"Intensity","Sun*")

from colour_system import cs_hdtv
import colour
def create_ciexyz_data_by_lam_i(lam):
    cs = cs_hdtv
    with open("CIEXYZ.txt") as f:
        ciexyz_data = np.array([[float(el) for el in line.split(" ")] for line in "".join(f.readlines()).split("\n")])
    ciexyz_data_by_lam_i = np.zeros((lam.shape[0],3))
    for lam_el_i,lam_el in enumerate(lam):
        if len(np.where(ciexyz_data[:,0]<lam_el)[0]):
            ciexyz_data_by_lam_i[lam_el_i] = ciexyz_data[np.where(ciexyz_data[:,0]<lam_el)[0][-1]][1:]
        else:
            ciexyz_data_by_lam_i[lam_el_i] = 0
    return ciexyz_data_by_lam_i

# for i in range(100):
#     as_xyz = spectrum_to_xyz(100*i*all_spectra["Sunlight in Space"][1],create_ciexyz_data_by_lam_i(all_spectra["Sunlight in Space"][0]))
#     as_xyz = spectrum_to_xyz(100*i*np.ones_like(all_spectra["Sunlight in Space"][1]),create_ciexyz_data_by_lam_i(all_spectra["Sunlight in Space"][0]))
#     as_rgb = colour.XYZ_to_sRGB(as_xyz)
#     print(as_rgb)
# ardsr
# D65 and E

spd_d65 = colour.SDS_ILLUMINANTS["D65"]

wavelengths = spd_d65.wavelengths
values_E = np.ones_like(wavelengths)

spd_E = colour.SpectralDistribution(
    name="Equal Energy E",
    data=dict(zip(wavelengths, values_E))
)

all_spectra["D65 Standard Illuminant"] = Spectrum(spd_d65.wavelengths, spd_d65.values,"Intensity","D65")
all_spectra["E Standard Illuminant"] = Spectrum(spd_E.wavelengths, spd_E.values,"Intensity","E")


# BLACKBODY at 5770 K

T = 5770
sun_wavelength_nm = np.linspace(200, 1000, 1000)
wavelength_m = sun_wavelength_nm * 1e-9
def planck(wavelength, T):
    return (2 * h * c**2 / wavelength**5) / (np.exp(h * c / (wavelength * k * T)) - 1)
bb_5770 = planck(wavelength_m, T)
all_spectra[f"blackbody {T}"] = Spectrum(sun_wavelength_nm, bb_5770,"Intensity","Blackbody")
# all_spectra["Sunlight in Space"] = all_spectra[f"blackbody {T}"]

# VPL SOLAR FLUX

vpl_data = np.loadtxt("VPL__dayside_venus_toa.flx", skiprows=9)

vpl_wavelength = vpl_data[:, 0]*1000 # convert from μm to nm
vpl_wavenumber = vpl_data[:, 1]
vpl_solar_flux = vpl_data[:, 2]
vpl_planetary_flux = vpl_data[:, 3]
vpl_albedo = vpl_data[:, 4]

# all_spectra[f"VPL Solar Flux"] = [vpl_wavelength, vpl_solar_flux]
all_spectra[f"VPL Venus Flux"] = Spectrum(vpl_wavelength, vpl_planetary_flux, "Intensity", "Venus")
# all_spectra[f"VPL Venus Flux"].plot(normalize=True,show=False)

# PEREZHOYOS

with open("Venus_PerezHoyos2018.txtU","r") as f:
    perezhoyos_spectrum = np.array([np.array([float(line.split(" ")[0]),float(line.split(" ")[2])]) for line in f.readlines()])
all_spectra[f"Venus_PerezHoyos2018"] = Spectrum(perezhoyos_spectrum[:,0]*1000, perezhoyos_spectrum[:,1],"Reflectance","Venus")
# all_spectra[f"Venus_PerezHoyos2018"].plot(normalize=True,show=False)

# KUIPER

kuiper_df = pd.read_excel("Kuiper_1969_Venus_spectrum.xlsx")
all_spectra[f"Venus_Kuiper_1969b"] = Spectrum(kuiper_df["microns"]*1000,kuiper_df["Venus Spectrum Kuiper (1969)"],"Reflectance","Venus")
# all_spectra[f"Venus_Kuiper_1969b"].plot(normalize=True,show=True)

# https://www.planetary-astronomy-and-imaging.com/en/venus-spectrum/

all_spectra["christophe_pellier"] = find_red_pixel_averages("spectra/christophe_pellier.png", "Intensity", "Venus")
# all_spectra["christophe_pellier"] = [all_spectra["christophe_pellier"][0],all_spectra["christophe_pellier"][1]*
#     averaged_interp(all_spectra["Sunlight in Space"][0],all_spectra["Sunlight in Space"][1],all_spectra["christophe_pellier"][0])/
#     averaged_interp(all_spectra["D65 Standard Illuminant"][0],all_spectra["D65 Standard Illuminant"][1],all_spectra["christophe_pellier"][0])]
np.save("christophe_pellier_raw.npy",find_red_pixel_averages("spectra/christophe_pellier.png", "Intensity", "Venus"))
np.save("christophe_pellier_reflectance.npy",find_red_pixel_averages("spectra/christophe_pellier_reflectance.png", "Reflectance", "Venus"))
all_spectra["christophe_pellier_reflectance"] = find_red_pixel_averages("spectra/christophe_pellier_reflectance.png", "Reflectance", "Venus")
#all_spectra["christophe_pellier_reflectance"] = [all_spectra["christophe_pellier_reflectance"][0],all_spectra["christophe_pellier_reflectance"][1]*
#    averaged_interp(all_spectra["Sunlight in Space"][0],all_spectra["Sunlight in Space"][1],all_spectra["christophe_pellier_reflectance"][0])]

all_spectra["Selsis et al., 2008"] = find_red_pixel_averages("spectra/selsis.png", "Intensity", "Venus")
#all_spectra["Selsis et al., 2008"] = [all_spectra["Selsis et al., 2008"][0],all_spectra["Selsis et al., 2008"][1]*
#    averaged_interp(all_spectra["Sunlight in Space"][0],all_spectra["Sunlight in Space"][1],all_spectra["Selsis et al., 2008"][0])]


messenger_spectrum_x = [433.2, 479.9, 558.9, 628.8, 698.8, 748.7, 828.4, 898.8, 947.0, 996.2, 1012.6000000000001]
messenger_spectrum_y = [np.float32(368.08212), np.float32(555.22296), np.float32(521.6083), np.float32(462.25385), np.float32(386.05475), np.float32(350.84842), np.float32(291.30246), np.float32(243.68433), np.float32(216.5664), np.float32(197.61197), np.float32(190.74495)]
all_spectra["messenger_filters"] = Spectrum(messenger_spectrum_x,messenger_spectrum_y,"Intensity","Venus")
messenger_spectrumb_x = [433.2, 415.09999999999997, 451.3, 479.9, 469.79999999999995, 490.0, 558.9, 553.1, 564.6999999999999, 628.8, 623.3, 634.3, 698.8, 693.5, 704.0999999999999, 748.7, 743.6, 753.8000000000001, 828.4, 823.1999999999999, 833.6, 898.8, 893.6999999999999, 903.9, 947.0, 940.8, 953.2, 996.2, 981.9000000000001, 1010.5, 1012.6000000000001, 979.3000000000001, 1045.9]
messenger_spectrumb_y = [np.float32(368.08212), np.float32(368.08212), np.float32(368.08212), np.float32(555.22296), np.float32(555.22296), np.float32(555.22296), np.float32(521.6083), np.float32(521.6083), np.float32(521.6083), np.float32(462.25385), np.float32(462.25385), np.float32(462.25385), np.float32(386.05475), np.float32(386.05475), np.float32(386.05475), np.float32(350.84842), np.float32(350.84842), np.float32(350.84842), np.float32(291.30246), np.float32(291.30246), np.float32(291.30246), np.float32(243.68433), np.float32(243.68433), np.float32(243.68433), np.float32(216.5664), np.float32(216.5664), np.float32(216.5664), np.float32(197.61197), np.float32(197.61197), np.float32(197.61197), np.float32(190.74495), np.float32(190.74495), np.float32(190.74495)]
all_spectra["messenger_spectrum_b"] = Spectrum(np.array(messenger_spectrumb_x)[np.argsort(messenger_spectrumb_x)],np.array(messenger_spectrumb_y)[np.argsort(messenger_spectrumb_x)],"Intensity","Venus")
messenger_spectrumc_x = [400,433.2, 415.09999999999997, 451.3, 479.9, 469.79999999999995, 490.0, 558.9, 553.1, 564.6999999999999, 628.8, 623.3, 634.3, 698.8, 693.5, 704.0999999999999, 748.7, 743.6, 753.8000000000001, 828.4, 823.1999999999999, 833.6, 898.8, 893.6999999999999, 903.9, 947.0, 940.8, 953.2, 996.2, 981.9000000000001, 1010.5, 1012.6000000000001, 979.3000000000001, 1045.9]
messenger_spectrumc_y = [np.float32(368.08212)/4, np.float32(368.08212), np.float32(368.08212)*0.7, 1.3*np.float32(368.08212), np.float32(555.22296), np.float32(555.22296), np.float32(555.22296), np.float32(521.6083), np.float32(521.6083), np.float32(521.6083), np.float32(462.25385), np.float32(462.25385), np.float32(462.25385), np.float32(386.05475), np.float32(386.05475), np.float32(386.05475), np.float32(350.84842), np.float32(350.84842), np.float32(350.84842), np.float32(291.30246), np.float32(291.30246), np.float32(291.30246), np.float32(243.68433), np.float32(243.68433), np.float32(243.68433), np.float32(216.5664), np.float32(216.5664), np.float32(216.5664), np.float32(197.61197), np.float32(197.61197), np.float32(197.61197), np.float32(190.74495), np.float32(190.74495), np.float32(190.74495)]
all_spectra["messenger_spectrum_c"] = Spectrum(np.array(messenger_spectrumc_x)[np.argsort(messenger_spectrumc_x)],np.array(messenger_spectrumc_y)[np.argsort(messenger_spectrumc_x)],"Intensity","Venus")



# Saturn Spectrum I had lying around that I admittedly don't have the source for but matches https://atmos.nmsu.edu/planetary_datasets/saturn_infrared.html

saturn_reference_spectrum = np.load("saturn_reference_spectrum.npy")
all_spectra[f"Saturn"] = Spectrum(saturn_reference_spectrum[0],saturn_reference_spectrum[1],"Intensity","Saturn")

# .sav file created with gdl run_virs_ddr.pro

# doesn't work because it's EDR rather than CDR?
# data = readsav('../MASCS/virsne_vf2_07156_225458.sav')

data = readsav('MASCS/virsvc_vf2_07156_225458.sav')
# print(data)
# Access the VIS CDR structure
vis_cdr = data['result']  # replace 'result' if you saved under a different name
# print(vis_cdr)
# Extract wavelengths and calibrated radiance
wavelengths = vis_cdr['CHANNEL_WAVELENGTHS']  # shape: (512,)
intensity = vis_cdr['CALIBRATED_RADIANCE_SPECTRUM_DATA']  # shape: (512,)
timeutcs = vis_cdr['SPECTRUM_UTC_TIME']  # shape: (512,)

relevant_attributes = ["TARGET_LATITUDE_SET",
                    "TARGET_LONGITUDE_SET",
                    "ALONG_TRACK_FOOTPRINT_SIZE",
                    "ACROSS_TRACK_FOOTPRINT_SIZE",
                    "FOOTPRINT_AZIMUTH",
                    "INCIDENCE_ANGLE",
                    "EMISSION_ANGLE",
                    "PHASE_ANGLE",
                    "SLANT_RANGE_TO_CENTER",
                    "SUBSPACECRAFT_LATITUDE",
                    "SUBSPACECRAFT_LONGITUDE",
                    "NADIR_ALTITUDE",
                    "SUBSOLAR_LATITUDE",
                    "SUBSOLAR_LONGITUDE",
                    "SOLAR_DISTANCE",
                    "PLANET_TRUE_ANOMALY",
                    "SPARE_1",
                    "RIGHT_ASCENSION",
                    "DECLINATION"]
relevant_values = {}
for key in relevant_attributes:
    relevant_values[key] = vis_cdr[key]

def parse_doy_timestamp(s):
    yy = int(s[:2])
    doy = int(s[2:5])
    time_part = s.split("T")[1]
    dt = datetime(2000+yy, 1, 1) + timedelta(days=doy - 1)
    t = datetime.strptime(time_part.strip(), "%H:%M:%S").time()
    dt = datetime.combine(dt.date(), t)
    return dt
unix_timestamps = []
for timeutc in timeutcs:
	unix_timestamps.append(parse_doy_timestamp(''.join(map(chr, timeutc))))

use_vals_lat = []
use_vals = []
for i in range(len(relevant_values["TARGET_LONGITUDE_SET"])):
    vals = np.array(relevant_values["TARGET_LATITUDE_SET"][i])
    vals[vals>10000000] = 0
    use_vals_lat.append(np.mean(vals))
    vals = np.array(relevant_values["TARGET_LONGITUDE_SET"][i])
    vals[vals>10000000] = 0
    use_vals.append(np.mean(vals))
    # print(relevant_values["SUBSPACECRAFT_LATITUDE"])

#for key in all_spectra:
#    all_spectra[key] = Spectrum(np.array(all_spectra[key][0]),np.array(all_spectra[key][1]),"Intensity","Venus")
