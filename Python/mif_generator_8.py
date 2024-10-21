def generar_mif(nombre_archivo_pixeles, nombre_archivo_mif, width, depth, direccion_inicio):
    # Leer los píxeles desde el archivo
    with open(nombre_archivo_pixeles, 'r') as f:
        pixels = [int(line.strip()) for line in f]

    # Verificar si la cantidad de píxeles más la dirección de inicio no excede la profundidad
    if direccion_inicio + len(pixels) > depth:
        print("Error: La cantidad de píxeles y la dirección de inicio exceden la profundidad especificada.")
        return

    # Generar el contenido del archivo .mif
    with open(nombre_archivo_mif, 'w') as mif_file:
        mif_file.write(f"WIDTH={width};\n")
        mif_file.write(f"DEPTH={depth};\n\n")
        mif_file.write("ADDRESS_RADIX=HEX;\n")
        mif_file.write("DATA_RADIX=HEX;\n\n")
        mif_file.write("CONTENT BEGIN\n")

        # Rellenar las direcciones hasta la dirección de inicio con ceros
        for address in range(direccion_inicio):
            mif_file.write(f"    {address:X} : 0;\n")  # Escribir la dirección en hexadecimal

        # Escribir cada píxel en una dirección diferente
        for offset, pixel in enumerate(pixels):
            address = direccion_inicio + offset
            mif_file.write(f"    {address:X} : {pixel:02X};\n")  # Dirección y valor en hexadecimal

        # Rellenar las direcciones restantes con ceros si es necesario
        for address in range(direccion_inicio + len(pixels), depth):
            mif_file.write(f"    {address:X} : 0;\n")  # Escribir la dirección en hexadecimal

        mif_file.write("END;\n")

# Configuración de los parámetros
nombre_archivo_pixeles = 'VGA/64x64/pix_PISA_100_bn.txt'
nombre_archivo_mif = 'VGA/64x64/pix_PISA_100.mif'
width = 8  # Cada dirección almacena 8 bits (un píxel por dirección)
depth = 10100  # La cantidad máxima de direcciones de memoria
direccion_inicio = 4  # Dirección donde iniciarán los píxeles

# Generar el archivo .mif
generar_mif(nombre_archivo_pixeles, nombre_archivo_mif, width, depth, direccion_inicio)
