# Algorithm that takes an image, divides it into 16 quadrants and applies bilinear interpolation to one of them.

.data
# Define the input image (grayscale) and its dimensions
image_width:  .word 12
image_height: .word 12
image_data:   .byte 116, 192, 58, 149, 193, 122, 211, 35, 184, 48, 253, 4,
					139, 29, 255, 42, 70, 226, 16, 208, 194, 6, 223, 197,
					217, 173, 46, 31, 128, 204, 122, 148, 154, 225, 189, 190,
					156, 121, 202, 120, 126, 68, 211, 211, 105, 62, 46, 220,
					131, 163, 68, 29, 183, 23, 0, 231, 118, 2, 69, 209,
					13, 247, 46, 170, 72, 26, 116, 31, 223, 113, 38, 14,
					83, 143, 10, 236, 2, 132, 113, 101, 214, 108, 74, 209,
		            167, 237, 177, 216, 87, 76, 201, 7, 11, 64, 62, 56,
		            208, 157, 145, 133, 198, 217, 161, 16, 112, 96, 161, 167,
		            209, 42, 40, 58, 173, 240, 243, 68, 167, 48, 171, 238,
		            145, 166, 207, 231, 73, 243, 144, 86, 38, 14, 17, 29,
		            201, 146, 84, 54, 195, 110, 139, 169, 246, 141, 152, 177

# Space for the quadrant of the image you want to interpolate      
saved_quadrant:  .space 12

# Space for the scaled image quadrant
scaled_quadrant: .space 36

selected_quadrant: .word 0

.text
.globl main

main:	
	# Load original image dimensions
    la $t0, image_width       
    lw $s0, ($t0)              	# $s0 = width 
    la $t0, image_height      
    lw $s1, ($t0)              	# $s1 = height 
	
	# Calculate the size of the quadrants and their scaled size
    li $t2, 4                   # Split the image into 4x4 quadrants
    div $t0, $s0, $t2         	# $t0 = width / 4
    move $s2, $t0			  	# $s2 = quadrant_width
	mul $t0, $t0, 2
	move $s4, $t0             	# $s4 = scaled_quadrant_width
	
    div $t0, $s1, $t2         	# $t0 = height / 4
    move $s3, $t0         	  	# $s3 = quadrant_height
	mul $t0, $t0, 2
	move $s5, $t0             	# $s5 = scaled_quadrant_height
	
	# Load selected_quadrant
    la $t0, selected_quadrant
    lw $t1, 0($t0)        	  	# $t1 = selected_quadrant
	
	# To calculate the row, shift right is used (division by 4)
    srl $t3, $t1, 2       		# $t3 = $t1 / 4
    mul $t3, $t3, $s3          	# Multiply the row by the height of the quadrant
    
    # To calculate the column, AND is used to obtain the remainder of the division by 4
    andi $t4, $t1, 3      		# $t4 = $t1 % 4 
    mul $t4, $t4, $s2          	# Multiply the column by the width of the quadrant

    mul $t3, $t3, $s0     		# Row * image width
    add $t6, $t3, $t4     		# Initial index in $t6 (row + column)
	
    # Load the base address of the image and the address where the selected quadrant will be stored
    la $a0, image_data         
    add $a0, $a0, $t6          	# Quadrant initial pixel position
	la $a1, saved_quadrant

    # Initialize registers to traverse the quadrant
    li $t8, 0                  	# $t8 will be the index of the rows
    li $t9, 0                  	# $t9 will be the index of the columns
	
load_row:
    bge $t8, $s3, start_scaling 
    
    li $t9, 0              

load_column:
    bge $t9, $s2, next_row 		
    
    lb $k0, 0($a0)            	# Load byte
	sb $k0, 0($a1)				# Store byte 
	
	addi $a0, $a0, 1			
	addi $a1, $a1, 1 
    
    addi $t9, $t9, 1           
    j load_column

next_row:
	sub $a0, $a0, $s2		   	# Subtract quadrant width
    add $a0, $a0, $s0          	# Move to next row (jump image width)
    addi $t8, $t8, 1           	
    j load_row              	

start_scaling:
    # Initialize scaled image position indices and counter
    li $t8, 0                  	# $t8 = Y iterator for rows
    li $s6, 0                  	# Scaled image position counter

row_loop:
    li $t9, 0                  	# $t9 = iterator X for columns

column_loop:
    # Calculate position with fixed point
    addiu $t3, $s2, -1         	# t3 = quadrant_width - 1
    mul $t3, $t9, $t3          	# t3 = (quadrant_width - 1) * x
    sll $t3, $t3, 6            	# << 6 (setting for 6 fractional bits)
    addiu $t4, $s4, -1         	# t4 = scaled_quadrant_width - 1
    div $t3, $t3, $t4          	# t3 = fx

    addiu $t4, $s3, -1         	# t4 = quadrant_height - 1
    mul $t4, $t8, $t4          	# t4 = (quadrant_height - 1) * y
    sll $t4, $t4, 6            	# << 6 (setting for 6 fractional bits)
    addiu $t5, $s5, -1         	# t5 = scaled_quadrant_height - 1
    div $t4, $t4, $t5          	# t4 = fy

    # Get ox, oy, fx_frac, fy_frac
    srl $t5, $t3, 6            	# ox = fx >> 6
    srl $t6, $t4, 6            	# oy = fy >> 6
    andi $t7, $t3, 0x3F        	# fx_frac = fx & 0x3F (6 bits)
    andi $k1, $t4, 0x3F        	# fy_frac = fy & 0x3F (6 bits)

    # Load the values ​​of P11, P12, P21, P22
    la $t0, saved_quadrant
    mul $t1, $s2, $t6          	# t1 = oy * quadrant_width
    add $t1, $t1, $t5          	# (oy * quadrant_width) + ox

    add $t0, $t0, $t1          	# Pixel address in (ox, oy)
    lbu $a0, ($t0)             	# P11 (top left)
    lbu $a1, 1($t0)            	# P12 (top right)

    add $t0, $t0, $s2          	# Pixel address at (ox, oy + 1)
    lbu $a2, ($t0)             	# P21 (bottom left)
    lbu $a3, 1($t0)            	# P22 (bottom right)

    # Bilinear interpolation
    # 1 - fx_frac y 1 - fy_frac
    li $t0, 64
    subu $t3, $t0, $t7         	# 1 - fx_frac
    subu $t4, $t0, $k1         	# 1 - fy_frac

    # Top and bottom
    mul $t0, $a0, $t3          	# P11 * (1 - fx_frac)
    mul $t0, $t0, $t4          	# * (1 - fy_frac)

    mul $t1, $a1, $t7          	# P12 * fx_frac
    mul $t1, $t1, $t4          	# * (1 - fy_frac)

    mul $t2, $a2, $t3          	# P21 * (1 - fx_frac)
    mul $t2, $t2, $k1          	# * fy_frac

    mul $t3, $a3, $t7          	# P22 * fx_frac
    mul $t3, $t3, $k1          	# * fy_frac

    # Add the contributions
    addu $t0, $t0, $t1         	# Top
    addu $t2, $t2, $t3         	# Bottom
    addu $t0, $t0, $t2         	# Total sum

    # Convert from fixed point
    srl $t0, $t0, 12           	# >> 6 + 6 

    # Save the interpolated pixel
    la $t1, scaled_quadrant
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
