import numpy as np
from scipy.ndimage import zoom

# Crear matriz de ejemplo          
matriz1 = np.array([[10, 20], 
                    [30, 40]])
                   
matriz2 = np.array([[10, 20, 30], 
                    [40, 50, 60],
                    [70, 80, 90]])

# Aplicar interpolación bilineal (factor de escala 2)
matriz_interpolada = zoom(matriz1, 2, order=1)  # order=1 para interpolación bilineal

print(matriz_interpolada)
