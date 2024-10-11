import numpy as np
import matplotlib.pyplot as plt
from PIL import Image

# Function to load the grayscale image
def load_grayscale_image(image_path):
    image = Image.open(image_path).convert('L')  # Convert to grayscale
    return np.array(image)

# Function to draw dividing lines
def draw_grid(image, num_rows, num_cols):
    height, width = image.shape
    fig, ax = plt.subplots(figsize=(6, 6))

    # Show image
    ax.imshow(image, cmap='gray')
    
    # Draw horizontal lines
    for i in range(1, num_rows):
        y = i * (height // num_rows)
        ax.axhline(y=y, color='red', linestyle='--', lw=1)

    # Draw vertical lines
    for j in range(1, num_cols):
        x = j * (width // num_cols)
        ax.axvline(x=x, color='red', linestyle='--', lw=1)

    ax.set_title("Image divided into 4x4 quadrants")
    ax.axis('off')
    plt.show()

# Function to get the selected quadrant
def get_quadrant(image, quadrant_index, num_rows, num_cols):
    height, width = image.shape
    quadrant_height = height // num_rows
    quadrant_width = width // num_cols

    row = quadrant_index // num_cols
    col = quadrant_index % num_cols

    y_start = row * quadrant_height
    y_end = (row + 1) * quadrant_height
    x_start = col * quadrant_width
    x_end = (col + 1) * quadrant_width

    print("y_start and x_start")
    print(y_start)
    print(x_start)
    print()

    return image[y_start:y_end, x_start:x_end]

def bilinear_interpolation(I):
    # Convert the original image matrix to a numpy array
    I = np.array(I, dtype=int)
    print("Original matrix:")
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
    print("Interpolated matrix in decimal:")
    print(new_image)
    print()

    # Convertir la nueva matriz a hexadecimal
    hex_image = np.vectorize(lambda x: hex(x))(new_image)
    print("Interpolated matrix in hexadecimal:")
    print(hex_image)

    return new_image

def main():
    image_created1 = [[213, 161, 27, 2, 132, 98, 25, 116],
                     [49, 44, 157, 77, 145, 68, 215, 175],
                     [45, 69, 200, 101, 218, 46, 207, 80],
                     [255, 171, 52, 25, 177, 159, 54, 195],
                     [135, 0, 34, 218, 197, 59, 119, 191],
                     [169, 176, 103, 71, 84, 120, 85, 243],
                     [175, 146, 157, 226, 215, 205, 199, 137],
                     [28, 24, 67, 10, 64, 143, 253, 11]]
    
    image_created2 = [[116, 192, 58, 149, 193, 122, 211, 35, 184, 48, 253, 4],
                      [139, 29, 255, 42, 70, 226, 16, 208, 194, 6, 223, 197],
                      [217, 173, 46, 31, 128, 204, 122, 148, 154, 225, 189, 190],
                      [156, 121, 202, 120, 126, 68, 211, 211, 105, 62, 46, 220],
                      [131, 163, 68, 29, 183, 23, 0, 231, 118, 2, 69, 209],
                      [13, 247, 46, 170, 72, 26, 116, 31, 223, 113, 38, 14],
                      [83, 143, 10, 236, 2, 132, 113, 101, 214, 108, 74, 209],
                      [167, 237, 177, 216, 87, 76, 201, 7, 11, 64, 62, 56],
                      [208, 157, 145, 133, 198, 217, 161, 16, 112, 96, 161, 167],
                      [209, 42, 40, 58, 173, 240, 243, 68, 167, 48, 171, 238],
                      [145, 166, 207, 231, 73, 243, 144, 86, 38, 14, 17, 29],
                      [201, 146, 84, 54, 195, 110, 139, 169, 246, 141, 152, 177]]

    image = np.array(image_created2)

    # Draw dividing lines on the image
    draw_grid(image, 4, 4)

    # Select a quadrant to apply the interpolation
    quadrant_index = int(input("Select a quadrant (0-15) to apply bilinear interpolation: "))
    if quadrant_index < 0 or quadrant_index > 15:
        print("Invalid quadrant index. Please select a number between 0 and 15.")
        return

    # Get the selected quadrant
    selected_quadrant = get_quadrant(image, quadrant_index, 4, 4)
    height, width = selected_quadrant.shape
    print(f"Quadrant size: {height}x{width}")

    # Apply bilinear interpolation to the selected quadrant
    interpolated_quadrant = bilinear_interpolation(selected_quadrant)

    # Show the original image and the interpolated quadrant side by side
    plt.figure(figsize=(12, 6))
    
    plt.subplot(1, 2, 1)
    plt.title("Original Image")
    plt.imshow(image, cmap='gray')
    plt.axis('off')

    plt.subplot(1, 2, 2)
    plt.title(f"Interpolated Quadrant {quadrant_index}")
    plt.imshow(interpolated_quadrant, cmap='gray')
    plt.axis('off')

    plt.show()

if __name__ == "__main__":
    main()
