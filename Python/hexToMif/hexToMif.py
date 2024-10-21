# Abrir y leer el archivo .hex
file_path = 'data_out.hex'

with open(file_path, 'r') as file:
    hex_content = file.read()

# Separar el contenido en líneas
hex_lines = hex_content.strip().splitlines()

# Crear la estructura para el archivo .mif
mif_data = []
mif_data.append("WIDTH=8;")
mif_data.append(f"DEPTH={len(hex_lines) * 4};")  # Cada línea hex son 4 bytes (32 bits), y cada byte se almacena en direcciones separadas
mif_data.append("ADDRESS_RADIX=HEX;")
mif_data.append("DATA_RADIX=HEX;")
mif_data.append("CONTENT BEGIN")

# Procesar cada línea del archivo .hex
address = 0
for line in hex_lines:
    # Separar la línea en bytes (pares de dos caracteres hexadecimales) y revertir el orden
    reversed_bytes = [line[i:i+2] for i in range(0, len(line), 2)][::-1]  # Invertir el orden de los bytes
    for byte in reversed_bytes:
        # Agregar cada byte a la estructura mif_data con la dirección adecuada
        mif_data.append(f"    {hex(address)[2:].upper()} : {byte};")
        address += 1

# Finalizar el archivo .mif
mif_data.append("END;")

# Guardar el archivo .mif
mif_output_path = 'output_data.mif'
with open(mif_output_path, 'w') as mif_file:
    mif_file.write("\n".join(mif_data))

print(f"Archivo .mif generado en: {mif_output_path}")
