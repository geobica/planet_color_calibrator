import numpy as np
from PIL import Image
from matplotlib import pyplot as plt
from utils import averaged_interp
from astropy.io import fits

# Sun spectrum TCT uses

hdul = fits.open("sun_reference_stis_002.fits")
hdul.info()
data = hdul[1].data
header = hdul[1].header
wavelength = data['wavelength']/10
flux = data['flux']
SunSpectrum = None


class Spectrum:
    def __init__(self,lam:np.ndarray,arr:np.ndarray,type:str,body:str):
        self.lam = lam
        self.arr = arr
        self.type = type # "Intensity" or "Reflectance"
        self.body = body

    def get_reflectance(self):
        global SunSpectrum
        if self.type == "Intensity":
            return Spectrum(self.lam,self.arr/averaged_interp(SunSpectrum.lam,SunSpectrum.arr,self.lam),"Reflectance",self.body)
        elif self.type == "Photon":
            return Spectrum(self.lam,self.arr/self.lam/averaged_interp(SunSpectrum.lam,SunSpectrum.arr,self.lam),"Reflectance",self.body)
        else:
            return self

    def get_intensity(self):
        global SunSpectrum
        if self.type == "Reflectance":
            return Spectrum(self.lam,self.arr*averaged_interp(SunSpectrum.lam,SunSpectrum.arr,self.lam),"Intensity",self.body)
        elif self.type == "Photon":
            # photons have energy inversely proportional to wavelength
            # intensity is measured in W/μm/m^2/sr, photon count is photons/μm/m^2/sr
            return Spectrum(self.lam,self.arr/self.lam,"Intensity",self.body)
        else:
            return self

    def interp(self,lam):
        return averaged_interp(self.lam,self.arr,lam)

    def plot(self,show=True,normalize=False):
        plt.title(f"{self.body} ({self.type})")
        if normalize:
            plt.plot(self.lam,self.arr/np.max(self.arr),label=f"{self.body} ({self.type})")
        else:
            plt.plot(self.lam,self.arr,label=f"{self.body} ({self.type})")
        plt.xlabel("Wavelength [nm]")
        plt.ylabel(f"{self.type}")
        if show:
            plt.legend()
            plt.show()

    def save_txtU(self,filename:str):
        with open(filename,"w") as f:
            f.write("\n".join([f"{self.lam[i]/1000}  {self.arr[i]}" for i in range(len(self.lam))]))


SunSpectrum = Spectrum(data['wavelength']/10,data['flux'],"Intensity","Sun")


point_pairs_dict = {"christophe_pellier.png":np.array([[[509,767],[400,0]],
                        [[1305,230],[800,6]]]),
				"christophe_pellier_reflectance.png":np.array([[[68,477],[400,0]],
				                        [[730,93],[700,0.9]]]),
				"selsis.png":np.array([[[173,461],[400,0]],
				                        [[701,122],[1400,6000]]])}

def find_red_pixel_averages(image_path: str, type:str, body:str) -> Spectrum:
    img = np.array(Image.open(image_path).convert("RGB"))

    r, g, b = img[:, :, 0], img[:, :, 1], img[:, :, 2]

    red_mask = (r > 100) & (r > g * 1.4) & (r > b * 1.4)

    x_coords = []
    y_coords = []

    for col_x in range(img.shape[1]):
        col_mask = red_mask[:, col_x]
        if not col_mask.any():
            continue

        avg_y = np.mean(np.where(col_mask)[0])
        x_coords.append(col_x)
        y_coords.append(avg_y)

    x = np.array(x_coords)
    y = np.array(y_coords)

    point_pairs = point_pairs_dict[image_path.split("/")[-1]]
    x = (x-point_pairs[0,0,0])/(point_pairs[1,0,0]-point_pairs[0,0,0])*(point_pairs[1,1,0]-point_pairs[0,1,0])+point_pairs[0,1,0]
    y = (y-point_pairs[0,0,1])/(point_pairs[1,0,1]-point_pairs[0,0,1])*(point_pairs[1,1,1]-point_pairs[0,1,1])+point_pairs[0,1,1]

    return Spectrum(x, y, type, body)

if __name__=="__main__":
    [x, y] = find_red_pixel_averages("christophe_pellier.png")

    print(f"Columns with red pixels: {len(x)}")
    print(f"x: {x}")
    print(f"y: {y}")

    plt.plot(x,y)
    plt.show()