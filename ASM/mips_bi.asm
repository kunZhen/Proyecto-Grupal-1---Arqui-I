# Algorithm that applies bilinear interpolation to an N x N matrix. 

.data
# Define the input image (grayscale) and its dimensions
image_width:  .word 3
image_height: .word 3
image_data:   .byte   116, 192, 58, 
		              139, 29, 255,
		              217, 173, 46
		       
# Space for the new scaled image
fill: .byte 10, 10, 10
scaled_image: .space 36

.text
.globl main

main:
    # Load original image dimensions
    la $t0, image_width       
    lw $s2, ($t0)              # $s2 = width
    la $t0, image_height      
    lw $s3, ($t0)              # $s3 = height

    # Calculate dimensions of the new scaled image
    mul $s4, $s2, 2            # $s4 = new_width
    mul $s5, $s3, 2            # $s5 = new_height
             
    # Initialize scaled image position indices and counter
    li $t8, 0                  # $t8 = Y iterator for rows
    li $s6, 0                  # Scaled image position counter

row_loop:
    li $t9, 0                  # $t9 = iterator X for columns

column_loop:
    # Calculate position in original image with fixed point
    addiu $t3, $s2, -1         # t3 = width - 1
    mul $t3, $t9, $t3          # t3 = (width - 1) * x
    sll $t3, $t3, 6            # << 6 (setting for 6 fractional bits)
    addiu $t4, $s4, -1         # t4 = new_width - 1
    div $t3, $t3, $t4          # t3 = fx

    addiu $t4, $s3, -1         # t4 = height - 1
    mul $t4, $t8, $t4          # t4 = (height - 1) * y
    sll $t4, $t4, 6            # << 6 (setting for 6 fractional bits)
    addiu $t5, $s5, -1         # t5 = new_height - 1
    div $t4, $t4, $t5          # t4 = fy

    # Get ox, oy, fx_frac, fy_frac
    srl $t5, $t3, 6            # ox = fx >> 6
    srl $t6, $t4, 6            # oy = fy >> 6
    andi $t7, $t3, 0x3F        # fx_frac = fx & 0x3F (6 bits)
    andi $k1, $t4, 0x3F        # fy_frac = fy & 0x3F (6 bits)

    # Load the values ​​of P11, P12, P21, P22
    la $t0, image_data
    mul $t1, $s2, $t6          # t1 = oy * width
    add $t1, $t1, $t5          # (oy * width) + ox

    add $t0, $t0, $t1          # Pixel address in (ox, oy)
    lbu $a0, ($t0)             # P11 (top left)
    lbu $a1, 1($t0)            # P12 (top right)

    add $t0, $t0, $s2          # Pixel address at (ox, oy + 1)
    lbu $a2, ($t0)             # P21 (bottom left)
    lbu $a3, 1($t0)            # P22 (bottom right)

    # Bilinear interpolation
    # 1 - fx_frac y 1 - fy_frac
    li $t0, 64
    subu $t3, $t0, $t7         # 1 - fx_frac
    subu $t4, $t0, $k1         # 1 - fy_frac

    # Top and bottom
    mul $t0, $a0, $t3          # P11 * (1 - fx_frac)
    mul $t0, $t0, $t4          # * (1 - fy_frac)

    mul $t1, $a1, $t7          # P12 * fx_frac
    mul $t1, $t1, $t4          # * (1 - fy_frac)

    mul $t2, $a2, $t3          # P21 * (1 - fx_frac)
    mul $t2, $t2, $k1          # * fy_frac

    mul $t3, $a3, $t7          # P22 * fx_frac
    mul $t3, $t3, $k1          # * fy_frac

    # Add the contributions
    addu $t0, $t0, $t1         # Top
    addu $t2, $t2, $t3         # Bottom
    addu $t0, $t0, $t2         # Total sum

    # Convert from fixed point
    srl $t0, $t0, 12           # >> 6 + 6 

    # Save the interpolated pixel
    la $t1, scaled_image
    add $t1, $t1, $s6
    sb $t0, ($t1)
    addiu $s6, $s6, 1

    # Increment indexes and loops
    addiu $t9, $t9, 1
    blt $t9, $s4, column_loop

    addiu $t8, $t8, 1
    blt $t8, $s5, row_loop

    # End of program
    li $v0, 10
    syscall
