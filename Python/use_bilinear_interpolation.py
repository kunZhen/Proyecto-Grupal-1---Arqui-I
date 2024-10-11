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

    return image[y_start:y_end, x_start:x_end]

# Bilinear interpolation function
def bilinear_interpolation(I):
    I = np.array(I, dtype=int)
    old_height, old_width = I.shape
    new_height = old_height * 2
    new_width  = old_width * 2

    new_image = np.zeros((new_height, new_width), dtype=int)

    x_ratio = (old_width - 1) / (new_width - 1) if new_width > 1 else 0
    y_ratio = (old_height - 1) / (new_height - 1) if new_height > 1 else 0

    for i in range(new_height):
        for j in range(new_width):
            x = x_ratio * j
            y = y_ratio * i

            x1, y1 = int(x), int(y)
            x2, y2 = min(x1 + 1, old_width - 1), min(y1 + 1, old_height - 1)

            dx = x - x1
            dy = y - y1

            I_top = (1 - dx) * I[y1, x1] + dx * I[y1, x2]
            I_bottom = (1 - dx) * I[y2, x1] + dx * I[y2, x2]

            new_image[i, j] = round((1 - dy) * I_top + dy * I_bottom)

    new_image = np.clip(new_image, 0, 255)
    return new_image

def main():
    # Load grayscale image
    image_path = "cameraman1.jpg"
    image = load_grayscale_image(image_path)

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
    print(f"Tamaño del cuadrante: {height}x{width}")

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
