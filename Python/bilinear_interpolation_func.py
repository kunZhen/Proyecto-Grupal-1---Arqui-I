import numpy as np

def bilinear_interpolation(I):
    # Convertir la matriz de la imagen original a un array de numpy
    I = np.array(I, dtype=int)
    print(I)
    print()

    # Obtener el tamaño original de la imagen
    old_height, old_width = I.shape
    
    # Obtener el nuevo tamaño de la imagen
    new_height = old_height * 2
    new_width  = old_width * 2

    # Crear una nueva matriz para la imagen escalada
    new_image = np.zeros((new_height, new_width), dtype=int)

    # Proporciones de escalado en ambos ejes
    x_ratio = (old_width - 1) / (new_width - 1) if new_width > 1 else 0
    y_ratio = (old_height - 1) / (new_height - 1) if new_height > 1 else 0

    # Aplicar interpolación bilineal
    for i in range(new_height):
        for j in range(new_width):
            # Coordenadas en la imagen original
            x = x_ratio * j
            y = y_ratio * i

            # Coordenadas de los 4 vecinos más cercanos
            x1, y1 = int(x), int(y)
            x2, y2 = min(x1 + 1, old_width - 1), min(y1 + 1, old_height - 1)

            # Distancias desde el punto (x, y) hasta los vecinos
            dx = x - x1
            dy = y - y1

            # Interpolación en el eje X
            I_top = (1 - dx) * I[y1, x1] + dx * I[y1, x2]
            I_bottom = (1 - dx) * I[y2, x1] + dx * I[y2, x2]

            # Interpolación en el eje Y y redondeo del resultado
            new_image[i, j] = round((1 - dy) * I_top + dy * I_bottom)

    # Validar que los valores estén entre 0 y 255
    new_image = np.clip(new_image, 0, 255)

    return new_image

# Ejemplos de uso
I1 = [[10, 20],
      [30, 40]]

I2 = [[10, 20, 30], 
      [40, 50, 60],
      [70, 80, 90]]

result = bilinear_interpolation(I1)
print(result)

