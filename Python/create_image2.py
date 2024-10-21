import numpy as np
from PIL import Image

def generate_and_save_image(image_width, image_height, file_name):
    # Generate random integers between 0 and 255 for the image data
    image_data = np.random.randint(0, 256, (image_height, image_width), dtype=np.uint8)
    
    # Convert the numpy array to a PIL Image object
    image = Image.fromarray(image_data, 'L')
    
    # Save the image
    image.save(file_name)

# Example usage
image_width = 100
image_height = 100
file_name = "Python/random_image.jpg"
generate_and_save_image(image_width, image_height, file_name)
