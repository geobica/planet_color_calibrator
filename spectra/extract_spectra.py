import numpy as np
from PIL import Image
from matplotlib import pyplot as plt


point_pairs_dict = {"christophe_pellier.png":np.array([[[509,767],[400,0]],
                        [[1305,230],[800,6]]]),
				"christophe_pellier_reflectance.png":np.array([[[68,477],[400,0]],
				                        [[730,93],[700,0.9]]]),
				"selsis.png":np.array([[[173,461],[400,0]],
				                        [[701,122],[1400,6000]]])}

def find_red_pixel_averages(image_path: str) -> tuple[np.ndarray, np.ndarray]:
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

    return [x, y]

if __name__=="__main__":
    [x, y] = find_red_pixel_averages("christophe_pellier.png")

    print(f"Columns with red pixels: {len(x)}")
    print(f"x: {x}")
    print(f"y: {y}")

    plt.plot(x,y)
    plt.show()