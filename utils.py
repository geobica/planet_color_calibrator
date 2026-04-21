from colour_system import cs_hdtv
import numpy as np
import colour
from matplotlib import pyplot as plt
import xml.etree.ElementTree as ET

def averaged_interp(x, y, new_x, samples_per_interval=50):
    x = np.array(x)
    y = np.array(y)
    new_x = np.array(new_x)

    idx = np.argsort(x)
    x = x[idx]
    y = y[idx]

    new_y = np.zeros_like(new_x, dtype=float)

    for i in range(len(new_x)):
        if i == 0:
            left = new_x[i]
        else:
            left = 0.5 * (new_x[i-1] + new_x[i])

        if i == len(new_x) - 1:
            right = new_x[i]
        else:
            right = 0.5 * (new_x[i] + new_x[i+1])
        xs = np.linspace(left, right, samples_per_interval)
        ys = np.interp(xs, x, y)
        new_y[i] = ys.mean()

    return new_y

def rgb_to_hex(rgb):
    r, g, b = [max(0, min(255, int(round(x)))) for x in rgb]
    return f"#{r:02X}{g:02X}{b:02X}"

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

def spectrum_to_xyz(wavelengths,spectrum_in):
    lam_usable = np.linspace(200,1000,num=2000)
    ciexyz_data_by_lam_i = create_ciexyz_data_by_lam_i(lam_usable)
    spectrum = averaged_interp(wavelengths,spectrum_in,lam_usable)
    sums = np.sum(ciexyz_data_by_lam_i[:,:]*np.array(spectrum)[:,None],axis=0)
    # print("xyz",sums)
    # plt.plot(wavelengths,np.cumsum(ciexyz_data_by_lam_i[:,:]*np.array(spectrum)[:,None],axis=0))
    # plt.title(f"spectrum_to_xyz {sums}")
    # plt.show()
    return np.sum(ciexyz_data_by_lam_i[:,:]*np.array(spectrum)[:,None],axis=0)

def spectrum_arr_to_xyz(spectrum,ciexyz_data_by_lam_i):
    return np.sum(ciexyz_data_by_lam_i[None,:,:]*spectrum[:,:,None],axis=1)

def spectrum_to_sRGB(spectrum,illuminant=None):
    spd_d65 = colour.SDS_ILLUMINANTS["D65"]
    if illuminant is None:
        illuminant = [spd_d65.wavelengths,spd_d65.values]
    if np.min(illuminant[1])<=0:
        return rgb_to_hex([0,0,0])
    illuminant_interp = averaged_interp(illuminant[0],illuminant[1],spectrum[0])
    d65_interp = averaged_interp(spd_d65.wavelengths,spd_d65.values,spectrum[0])
    multiplier = 1
    as_xyz = spectrum_to_xyz(spectrum[0],d65_interp)
    # print("XYZ",as_xyz)
    # print("RGB",colour.XYZ_to_sRGB(as_xyz))
    #[  5352.21543561   5311.48766456  10301.27069862]
    # plt.plot(spectrum[0],spectrum[1]/np.max(spectrum[1]))
    # plt.plot(illuminant[0],illuminant[1]/np.max(illuminant[1]))
    # plt.plot(spectrum[0],d65_interp/np.max(d65_interp))
    # plt.show()
    # plt.plot(spectrum[0],spectrum[1]/illuminant_interp*d65_interp/np.max(spectrum[1]/illuminant_interp*d65_interp),label="spectrum")
    # plt.plot(illuminant[0],illuminant[1]/np.max(illuminant[1]),label="illuminant")
    # plt.plot(spectrum[0],d65_interp/np.max(d65_interp),label="D65")
    # plt.legend
    # plt.show()
    for i in range(50):
        # print(multiplier)
        # print(spectrum[1])
        # print(multiplier*spectrum[1]*d65_interp/illuminant_interp)
        # print(create_ciexyz_data_by_lam_i(spectrum[0]))
        as_xyz = spectrum_to_xyz(spectrum[0],multiplier*spectrum[1]/illuminant_interp*d65_interp)
        # print(as_xyz)
        as_rgb = colour.XYZ_to_sRGB(as_xyz)
        # print(as_rgb)
        if str(as_rgb[0])=="nan":
            # plt.plot(spectrum[0],spectrum[1]/np.max(spectrum[1]))
            # print(spectrum[1]*d65_interp/illuminant_interp)
            # print(np.max(spectrum[1]*d65_interp/illuminant_interp))
            # print(spectrum[1]*d65_interp/illuminant_interp/np.max(spectrum[1]*d65_interp/illuminant_interp))
            # plt.plot(spectrum[0],spectrum[1]*d65_interp/illuminant_interp/np.max(spectrum[1]*d65_interp/illuminant_interp))
            # plt.show()
            # plt.plot(spectrum[0],spectrum[1])
            # plt.plot(illuminant[0],illuminant[1])
            # plt.show()
            multiplier /= 1000
        else:
            multiplier /= np.max(as_rgb)/255
    return rgb_to_hex(as_rgb)

def parse_tag(filepath, tag_name):
    tree = ET.parse(filepath)
    root = tree.getroot()

    target = None
    for elem in root.iter():
        local_tag = elem.tag.split('}')[-1] if '}' in elem.tag else elem.tag
        if local_tag == tag_name:
            target = elem
            break

    if target is None:
        print(f"<{tag_name}> not found.")
        return None

    def elem_to_dict(el):
        tag = el.tag.split('}')[-1] if '}' in el.tag else el.tag
        children = list(el)
        if not children:
            return {tag: el.text.strip() if el.text and el.text.strip() else None}
        child_dict = {}
        for child in children:
            child_data = elem_to_dict(child)
            for k, v in child_data.items():
                if k in child_dict:
                    if not isinstance(child_dict[k], list):
                        child_dict[k] = [child_dict[k]]
                    child_dict[k].append(v)
                else:
                    child_dict[k] = v
        return {tag: child_dict}

    return elem_to_dict(target)

def IMG_to_npy(filename:str):
    pixel_count = 1024 * 1024
    data = np.fromfile(filename, dtype=">f4")
    data = data[-pixel_count:]
    raw_image = data.reshape((1024, 1024))
    raw_image[raw_image<-10**10] = 0
    with open(filename) as f:
        f.seek(12288)
        img = np.fromfile(f, dtype=">f4", count=1024*1024)
        img = img.reshape((1024,1024))
        img = np.maximum(img,0)
    return img

spd_d65 = colour.SDS_ILLUMINANTS["D65"]
as_xyz = spectrum_to_xyz(spd_d65.wavelengths,spd_d65.values)

if __name__=="__main__":
    import pvlib
    am15 = pvlib.spectrum.get_reference_spectra(standard="ASTM G173-03")
    print(am15["extraterrestrial"])
    # all_spectra["Extraterrestrial ASTM G173-03"] = [am15.index, am15["extraterrestrial"]]
    print(spectrum_to_sRGB([am15.index, am15["extraterrestrial"]]))
    # for i in range(100):
    #     as_xyz = spectrum_to_xyz(100*i*all_spectra["Extraterrestrial ASTM G173-03"][1],create_ciexyz_data_by_lam_i(all_spectra["Extraterrestrial ASTM G173-03"][0]))
    #     as_xyz = spectrum_to_xyz(100*i*np.ones_like(all_spectra["Extraterrestrial ASTM G173-03"][1]),create_ciexyz_data_by_lam_i(all_spectra["Extraterrestrial ASTM G173-03"][0]))
    #     as_rgb = colour.XYZ_to_sRGB(as_xyz)