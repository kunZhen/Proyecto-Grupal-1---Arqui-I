from PIL import Image

# Cargar la imagen
img = Image.open('VGA\PISA_bn.png')

# Convertir a escala de grises si es necesario
img_gray = img.convert('L')

# Obtener los valores de los píxeles como una lista
pixels = list(img_gray.getdata())

# Guardar los píxeles en un archivo
with open('VGA/64x64/pix_PISA_100_bn.txt', 'w') as f:
    for pixel in pixels:
        f.write(f'{pixel}\n')
