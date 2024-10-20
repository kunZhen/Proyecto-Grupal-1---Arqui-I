import numpy as np
import pandas as pd
import os

def bilinear_interpolation_to_excel(I, filename="interpolated_image.xlsx"):
    # Convert the original image matrix to a numpy array
    I = np.array(I, dtype=int)
    
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

    # Convert matrices to hexadecimal format
    hex_original = np.vectorize(lambda x: hex(x))(I)
    hex_interpolated = np.vectorize(lambda x: hex(x))(new_image)

    # Define the save path
    save_path = os.path.join(os.getcwd(), filename)  # Save in current working directory

    # Save all matrices into Excel
    with pd.ExcelWriter(save_path) as writer:
        # Original matrix in decimal
        pd.DataFrame(I).to_excel(writer, sheet_name="Original Matrix Decimal", index=False, header=False)

        # Original matrix in hexadecimal
        pd.DataFrame(hex_original).to_excel(writer, sheet_name="Original Matrix Hexadecimal", index=False, header=False)

        # Interpolated matrix in decimal
        pd.DataFrame(new_image).to_excel(writer, sheet_name="Interpolated Matrix Decimal", index=False, header=False)

        # Interpolated matrix in hexadecimal
        pd.DataFrame(hex_interpolated).to_excel(writer, sheet_name="Interpolated Matrix Hexadecimal", index=False, header=False)
    
    return f'{filename} created with the required matrices in the respective formats.'

# Example usage with 2x2 matrix
I2 = [[10, 20], [30, 40]]
bilinear_interpolation_to_excel(I2)
