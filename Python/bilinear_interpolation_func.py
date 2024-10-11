import numpy as np

def bilinear_interpolation(I):
    # Convert the original image matrix to a numpy array
    I = np.array(I, dtype=int)
    print(I)
    print()

    # Get the original size of the image
    old_height, old_width = I.shape
    
    # Get the new image size
    new_height = old_height * 2
    new_width  = old_width * 2

    # Create a new matrix for the scaled image
    new_image = np.zeros((new_height, new_width), dtype=int)

    # Scaling ratios on both axes
    x_ratio = (old_width - 1) / (new_width - 1) if new_width > 1 else 0
    y_ratio = (old_height - 1) / (new_height - 1) if new_height > 1 else 0

    # Apply bilinear interpolation
    for i in range(new_height):
        for j in range(new_width):
            # Coordinates in the original image
            x = x_ratio * j
            y = y_ratio * i

            # Coordinates of the 4 nearest neighbors
            x1, y1 = int(x), int(y)
            x2, y2 = min(x1 + 1, old_width - 1), min(y1 + 1, old_height - 1)

            # Distances from point (x, y) to neighbors
            dx = x - x1
            dy = y - y1

            # Interpolation on the X axis
            I_top = (1 - dx) * I[y1, x1] + dx * I[y1, x2]
            I_bottom = (1 - dx) * I[y2, x1] + dx * I[y2, x2]

            # Interpolation on the Y axis and rounding the result
            new_image[i, j] = round((1 - dy) * I_top + dy * I_bottom)

    # Validate that the values ​​are between 0 and 255
    new_image = np.clip(new_image, 0, 255)
    print(new_image)

# Usage examples
I2 = [[10, 20],
      [30, 40]]

I3 = [[10, 20, 30], 
      [40, 50, 60],
      [70, 80, 90]]

I4 = [[10, 20, 30, 40], 
      [50, 60, 70, 80],
      [90, 100, 110, 120],
      [130, 140, 150, 160]]

bilinear_interpolation(I4)
