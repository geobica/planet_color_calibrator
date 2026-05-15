import numpy as np
from matplotlib import pyplot as plt
plt.plot([0,0],[0,0])
plt.show()
import cv2
import scipy
import os
import math
from PIL import Image

def load_img(file_name):
    # TODO make this for IMG
    blue_raw = np.load(file_name)
    return blue_raw
def make_bright(calib_list):
    bright_field = np.percentile(calib_list,90,axis=0)
    return bright_field
def make_dark(dark_list):
    dark_field = np.percentile(dark_list,10,axis=0)
    return dark_field
def calibrate(blue_holeless,bright_field,dark_field):
    blue_calibrated = np.nan_to_num((blue_holeless-dark_field)/np.maximum(0.1,bright_field-dark_field),nan=0)

    return blue_calibrated
def remove_lines(blue_raw):
    return blue_raw
    problematic_rows = np.where(np.sum(np.logical_and(blue_raw<np.roll(blue_raw,1,axis=0),blue_raw<np.roll(blue_raw,-1,axis=0)),axis=1)>5)[0]
    # TODO
    # maybe I'll just do this step manually

    # bad solution:
    blue_lineless = np.array(blue_raw)
    for row_i in problematic_rows:
        blue_lineless[row_i] = (np.roll(blue_raw,1,axis=0)+np.roll(blue_raw,-1,axis=0))[row_i]/2

    return blue_lineless
def remove_holes(blue_lineless,bright_field):
    blue_holeless = np.array(blue_lineless)
    where_needs_filling = (bright_field<0.5)

    for k in range(3):
        k_where_needs_filling = np.array(where_needs_filling)
        for axis in [0,1]:
            for direction in [-1,1]:
                where_needs_filling = np.logical_or(where_needs_filling,np.roll(k_where_needs_filling,direction,axis=axis))
    blue_holeless[where_needs_filling] = 0

    for attempt_i in range(20):
        candidate_sum = np.zeros_like(blue_lineless)
        candidate_n = np.zeros_like(blue_lineless)
        for axis in [0,1]:
            for direction in [-1,1]:
                candidate_sum[np.logical_and(where_needs_filling,1-np.roll(where_needs_filling,direction,axis=axis))] += np.roll(blue_holeless,direction,axis=axis)[np.logical_and(where_needs_filling,1-np.roll(where_needs_filling,direction,axis=axis))]
                candidate_n[np.logical_and(where_needs_filling,1-np.roll(where_needs_filling,direction,axis=axis))] += 1
        blue_holeless[candidate_n>0] += (candidate_sum/candidate_n)[candidate_n>0]
        where_needs_filling = np.logical_and(candidate_sum==0,where_needs_filling)
    return blue_holeless
def find_center(blue_calibrated):
    y, x = np.indices(blue_calibrated.shape)
    s = blue_calibrated.sum()
    centroid = (y*blue_calibrated).sum()/s, (x*blue_calibrated).sum()/s

    # cx, cy, r, sun_dir_x, sun_dir_y, k # phase_angle is derived from sun_dir_x and sun_dir_y
    x_0 = np.array([centroid[1], centroid[0], 150, -0.1, 0, 0.7])
    return x_0
def minnaert_function(arr_shape,minnaert_params):
    xx,yy = np.meshgrid(np.arange(arr_shape[1]),np.arange(arr_shape[0]))
    x_prime = (xx-minnaert_params[0])/minnaert_params[2]
    y_prime = (yy-minnaert_params[1])/minnaert_params[2]
    k = minnaert_params[5]
    sun_dir = minnaert_params[3:5]
    phase_angle = np.linalg.norm(sun_dir)
    sun_dir_3D = np.array([sun_dir[0]/phase_angle*np.tan(phase_angle),sun_dir[1]/phase_angle*np.tan(phase_angle),1.])
    sun_dir_3D /= np.linalg.norm(sun_dir_3D)
    view_angle = np.array([0.,0.,1.])
    surface_normal = np.zeros((arr_shape[0],arr_shape[1],3))
    surface_normal[:,:,0] = x_prime
    surface_normal[:,:,1] = y_prime
    surface_normal[:,:,2] = np.sqrt(1-x_prime**2-y_prime**2)

    mu_0 = np.clip(np.sum(surface_normal * sun_dir_3D[None,None,:], axis=-1), 0, 1)
    mu = np.clip(np.sum(surface_normal * view_angle[None,None,:], axis=-1), 0, 1)
    minnaert_arr = mu_0**k*mu**(k-1)#math.pi*
    minnaert_arr[x_prime**2+y_prime**2>=1] = 0
    return np.nan_to_num(minnaert_arr,nan=0)
def optimize_minnaert(blue_calibrated,x_0,lock_position=False,k_use=None,set_radius=None,set_phase=None):
    position_store = None
    if lock_position:
        position_store = x_0[:3]
    blue_calibrated_smooth = scipy.signal.medfilt2d(blue_calibrated, kernel_size=13)
    blue_calibrated_smooth /= np.max(blue_calibrated_smooth)
    def loss(x,plot=False):
        if lock_position:
            x[:3] = position_store
        if k_use is not None:
            x[5] = k_use
        x[2] = 1.35397598e+02
        if set_radius is not None:
            x[2] = set_radius
        if set_phase is not None:
            x[3:5] = set_phase
        minnaert_arr = minnaert_function(blue_calibrated.shape,x)
        lossval = np.sum((blue_calibrated_smooth-minnaert_arr)**2)
        if plot:
            plt.imshow(minnaert_arr)
            plt.title("minnaert_arr")
            plt.show()
            plt.imshow(blue_calibrated_smooth)
            plt.title("blue_calibrated_smooth")
            plt.show()
            plt.imshow(np.clip(blue_calibrated_smooth/minnaert_arr,0,1))
            plt.title("blue_calibrated_smooth")
            plt.show()
        return lossval
    res = scipy.optimize.minimize(loss,x_0,method='L-BFGS-B')
    # loss(res.x,plot=True)
    minnaert_params = res.x
    if lock_position:
        minnaert_params[:3] = position_store
    if k_use is not None:
        minnaert_params[5] = k_use
    minnaert_params[2] = 1.35397598e+02
    if set_radius is not None:
        minnaert_params[2] = set_radius
    if set_phase is not None:
        minnaert_params[3:5] = set_phase
    print(set_phase,minnaert_params)
    return minnaert_params
def apply_sensitivity_curve(arr,sensitivity_coeffs):
    return np.sum([arr**(i+1)*sensitivity_coeffs[i] for i in range(len(sensitivity_coeffs))],axis=0)
def optimize_sensitivity(blue_calibrated,minnaert_params):
    blue_calibrated_smooth = scipy.signal.medfilt2d(blue_calibrated, kernel_size=13)
    blue_calibrated_smooth /= np.max(blue_calibrated_smooth)
    coeffs_0 = [1,0,0,0]
    minnaert_arr = minnaert_function(blue_calibrated.shape,minnaert_params)
    def loss(coeffs,plot=False):
        lossval = np.sum((apply_sensitivity_curve(blue_calibrated_smooth,coeffs)-minnaert_arr)**2)
        if plot:
            plt.imshow(minnaert_arr)
            plt.title("minnaert_arr")
            plt.show()
            plt.imshow(blue_calibrated_smooth)
            plt.title("blue_calibrated_smooth")
            plt.show()
            plt.imshow(apply_sensitivity_curve(blue_calibrated_smooth,coeffs))
            plt.title("apply_sensitivity_curve(blue_calibrated_smooth,coeffs)")
            plt.show()
        return lossval
    res = scipy.optimize.minimize(loss,coeffs_0)
    # loss(res.x,plot=True)
    sensitivity_coeffs = res.x
    return sensitivity_coeffs
def curve_correction(blue_calibrated,sensitivity_coeffs):
    blue_corrected = apply_sensitivity_curve(blue_calibrated,sensitivity_coeffs)
    return blue_corrected
def resize_to(arr, target_size):
    resized_image = cv2.resize(arr, target_size, interpolation=cv2.INTER_AREA)
    return resized_image
def align(minnaert_params,blue_corrected):
    # should this be like, 1000x1000 with the radius being 450 or something like that?
    RADIUS_FULLNESS = 0.9
    x_shifted = np.roll(blue_corrected,int(blue_corrected.shape[0]/2)-minnaert_params[1],axis=0)
    y_shifted = np.roll(x_shifted,int(blue_corrected.shape[1]/2)-minnaert_params[0],axis=1)
    cropped_to_radius = y_shifted[int(blue_corrected.shape[0]/2)-int(1/RADIUS_FULLNESS*minnaert_params[2]):int(blue_corrected.shape[0]/2)+int(1/RADIUS_FULLNESS*minnaert_params[2]),int(blue_corrected.shape[1]/2)-int(1/RADIUS_FULLNESS*minnaert_params[2]):int(blue_corrected.shape[1]/2)+int(1/RADIUS_FULLNESS*minnaert_params[2])]
    cropped_to_radius = scipy.signal.medfilt2d(cropped_to_radius,kernel_size=3)
    ctr_center = find_center(cropped_to_radius)
    x_shifted = np.roll(cropped_to_radius,int(cropped_to_radius.shape[0]/2)-ctr_center[1],axis=0)
    y_shifted = np.roll(x_shifted,int(cropped_to_radius.shape[1]/2)-ctr_center[0],axis=1)
    blue_aligned = resize_to(y_shifted,[1000,1000])
    return blue_aligned
def save_image(save_path,arr):
    arr = np.asarray(arr, dtype=np.float32)
    p99 = np.percentile(arr, 99)
    if p99 <= 0:
        scaled = np.zeros_like(arr, dtype=np.uint8)
    else:
        scaled = np.clip(arr / p99 * 255, 0, 255).astype(np.uint8)
    img = Image.fromarray(scaled, mode="L")  # grayscale
    img.save(save_path)

def median_pngs(file_names, output_file="median.png"):
    arrays = []
    base_size = None

    for fname in file_names:
        img = Image.open(fname).convert("L")

        if base_size is None:
            base_size = img.size

        arrays.append(np.asarray(img, dtype=np.uint8))
        arrays[-1] = scipy.signal.medfilt2d(arrays[-1],kernel_size=13)

    stack = np.stack(arrays, axis=0)
    median_array = np.median(stack, axis=0)
    median_array = median_array.astype(np.uint8)

    median_img = Image.fromarray(median_array, mode="L")
    median_img.save(output_file)

    return output_file
if __name__=="__main__":
    by_color = {"blue":[129922382,129922298,129922214],
                "orange":[129922550,129922718,129922802,129923054],
                "UV":[129923474,129923642,129923558]}#129923726,129923642,129923558,130009577

    phase_angle_set = [[-0.63460752, -0.01525785],
                        [-0.66239819, -0.01009852],
                        [-0.64348818, -0.05024259],
                        [-0.65958519, -0.02024361],
                        [-0.70138437, -0.01287166],
                        [-0.6779431,  -0.01508676],
                        [-0.68173235, -0.05522172],]
                        # [-0.74342641, -0.03712082],
                        # [-0.82297506,  0.02411257],]

    for color in by_color:
        for file_npy in by_color[color]:
            file_name = f"A_npy/{color}/{file_npy}.npy"
            radii = {"orange":(396-134.5)/2,
                    "blue":(350.5-89)/2,
                    "UV":(460.5-198.5)/2,}
            blue_raw = load_img(file_name)
            blue_lineless = remove_lines(blue_raw)
            calib_dir = "A_npy/calib"
            dark_dir = f"A_npy/{color}"
            calib_list = [load_img(os.path.join(calib_dir,calib_file)) for calib_file in os.listdir(calib_dir)]
            typical_calib_median = np.percentile([np.percentile(el,50) for el in calib_list],50)
            calib_list = [el/np.percentile(el,50) for el in calib_list]
            dark_list = [load_img(os.path.join(dark_dir,dark_file))/typical_calib_median for dark_file in os.listdir(dark_dir)]
            bright_field = make_bright(calib_list)
            dark_field = make_dark(dark_list)
            blue_calibrated = calibrate(blue_lineless,bright_field,dark_field)
            blue_holeless = remove_holes(blue_calibrated,bright_field)
            x_0 = find_center(blue_holeless)
            if color=="UV":
                x_0 = [ 6.36858421e+02,  3.29411290e+02,  1.36009614e+02, -5.51927000e-01, -2.43900000e-02,  1.13433832e+00]
            minnaert_params = optimize_minnaert(blue_holeless,x_0)
            sensitivity_coeffs = optimize_sensitivity(blue_holeless,minnaert_params)
            blue_corrected = curve_correction(blue_holeless/np.max(scipy.signal.medfilt2d(blue_holeless,kernel_size=13)),sensitivity_coeffs)
            minnaert_params = optimize_minnaert(blue_corrected,minnaert_params)
            sensitivity_coeffs = optimize_sensitivity(blue_corrected,minnaert_params)
            blue_corrected = curve_correction(blue_corrected/np.max(scipy.signal.medfilt2d(blue_corrected,kernel_size=13)),sensitivity_coeffs)
            minnaert_params = optimize_minnaert(blue_corrected,minnaert_params)
            sensitivity_coeffs = optimize_sensitivity(blue_corrected,minnaert_params)
            blue_corrected = curve_correction(blue_corrected/np.max(scipy.signal.medfilt2d(blue_corrected,kernel_size=13)),sensitivity_coeffs)
            minnaert_params = optimize_minnaert(blue_corrected,minnaert_params,set_radius=radii[color])
            sensitivity_coeffs = optimize_sensitivity(blue_corrected,minnaert_params)
            blue_corrected = curve_correction(blue_corrected/np.max(scipy.signal.medfilt2d(blue_corrected,kernel_size=13)),sensitivity_coeffs)
            minnaert_params = optimize_minnaert(blue_corrected,minnaert_params,lock_position=True,k_use=0.7,set_radius=radii[color],set_phase=np.mean(np.array(phase_angle_set),axis=0))
            sensitivity_coeffs = optimize_sensitivity(blue_corrected,minnaert_params)
            blue_corrected = curve_correction(blue_corrected/np.max(scipy.signal.medfilt2d(blue_corrected,kernel_size=13)),sensitivity_coeffs)
            blue_aligned = align(minnaert_params,blue_corrected)
            save_path = f"{color}_aligned_{file_npy}.png"
            print("minnaert_params",minnaert_params)
            print(minnaert_params[3:5])
            save_image(save_path,blue_aligned)
    for color in by_color:
        median_pngs([f"{color}_aligned_{file_npy}.png" for file_npy in by_color[color]],f"{color}_aligned_median.png")