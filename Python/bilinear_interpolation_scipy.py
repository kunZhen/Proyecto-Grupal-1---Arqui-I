import numpy as np
from scipy.ndimage import zoom

# Create example matrix        
matrix2 = np.array([[10, 20], 
                    [30, 40]])
                   
matrix3 = np.array([[10, 20, 30], 
                    [40, 50, 60],
                    [70, 80, 90]])

# Apply bilinear interpolation (scale factor 2)
matriz_interpolada = zoom(matrix3, 2, order=1)  # order=1 for bilinear interpolation

print(matriz_interpolada)
