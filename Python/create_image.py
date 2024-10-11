import numpy as np

def generate_image_data_text(image_width, image_height):
    # Generate random integers between 0 and 255 for the image data
    image_data = np.random.randint(0, 256, (image_height, image_width), dtype=np.uint8)
    
    # Convert the image data into the desired text format
    image_data_lines = []
    for row in image_data:
        line = ', '.join(str(value) for value in row)
        image_data_lines.append(f"                      {line}")
    
    # Combine lines into a single string
    image_data_text = "image_data:   .byte   " + image_data_lines[0] + ",\n" + ',\n'.join(image_data_lines[1:])
    return image_data_text

# Example usage with the given width and height
image_width = 12
image_height = 12
image_data_text = generate_image_data_text(image_width, image_height)
print(image_data_text)
