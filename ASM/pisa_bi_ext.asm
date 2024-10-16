# Algorithm that takes an image, divides it into 16 quadrants and applies bilinear interpolation to one of them.
# It uses 20-bit registers, 14 bits for the integer part and 6 bits for the decimal part.

.global _start

_start:
    # Load original image dimensions     
    lwp s0, 0(zero)         	# s0 = width
    lwp s1, 4(zero)        		# s1 = height
	
	# Store base address of original image
	addip s2, zero, 16			# s2 = original_image
	
	# Define the base address to store the quadrant to be interpolated
	mulp t0, s0, s1				
	addp t0, s2, t0
	addip t0, t0, 16
	addp s3, t0, zero			# s3 = saved_quadrant
	
	# Calculate the size of the quadrants and their scaled size
	addip t1, zero, 4			# Split the image into 4x4 quadrants
    divp t0, s0, t1         	# t0 = width / 4
	addp s4, t0, zero			# s4 = quadrant_width
	
	sllip t0, t0, 1				# t0 = quadrant_width x 2
	addp s5, t0, zero           # s5 = scaled_quadrant_width
	
    divp t0, s1, t1         	# t0 = height / 4
    addp s6, t0, zero         	# s6 = quadrant_height
	
	sllip t0, t0, 1				# t0 = quadrant_height x 2
	addp s7, t0, zero           # s7 = scaled_quadrant_height
	
	# Define the base address to store the interpolated quadrant
	mulp t0, s4, s6				
	addp t0, s3, t0
	addip t0, t0, 16
	addp s8, t0, zero			# s8 = scaled_quadrant
	
	# Set 0x3F
	addip s9, zero, 3
	sllip s9, s9, 4				# s9 = 0x30
	addip t2, zero, 15
	orp s9, s9, t2				# s9 = 0x3F
	
	# Load selected_quadrant
    lwp t1, 8(zero)				# t1 = selected_quadrant
	
	# To calculate the row, shift right is used (division by 4)
    srlip t3, t1, 2       		# t3 = t1 / 4
    mulp t3, t3, s6          	# Multiply the row by the height of the quadrant
    
    # To calculate the column, AND is used to obtain the remainder of the division by 4
	addip t2, zero, 3
    andp t4, t1, t2      		# t4 = t1 % 4 
    mulp t4, t4, s4          	# Multiply the column by the width of the quadrant

    mulp t3, t3, s0     		# Row * image width
    addp t6, t3, t4     		# Initial index in t6 (row + column)
	
    # Load the base address of the image and the address where the selected quadrant will be stored  
	addp a0, s2, zero
    addp a0, a0, t6          	# Quadrant initial pixel position
	addp a1, s3, zero

    # Initialize registers to traverse the quadrant
    addip t8, zero, 0         	# t8 will be the index of the rows
    addip t9, zero, 0           # t9 will be the index of the columns
	
load_row: 
	cmpp t8, s6
	bgep start_scaling

	addip t9, zero, 0	

load_column:	
	cmpp t9, s4
	bgep next_row
    
    lbp t0, 0(a0)            	# Load byte
	sbp t0, 0(a1)				# Store byte 
	
	addip a0, a0, 1			
	addip a1, a1, 1 
    
    addip t9, t9, 1           
    jump load_column

next_row:
	subp a0, a0, s4		   		# Subtract quadrant width
    addp a0, a0, s0          	# Move to next row (jump image width)
    addip t8, t8, 1           	
    jump load_row
	
start_scaling:							
    addip t10, zero, 0          # t10 = y iterator for rows
    addip t12, zero, 0          # t12 = offset to point to the next pixel in the scaled image

row_loop:
    addip t11, zero, 0          # t11 = x iterator for columns

column_loop:
    # Calculate position with fixed point
	addip t0, zero, 1
    subp t3, s4, t0         	# t3 = quadrant_width - 1
    mulp t3, t11, t3          	# t3 = x * (quadrant_width - 1)
    sllip t3, t3, 6            	# << 6 (setting for 6 fractional bits)
    subp t4, s5, t0         	# t4 = scaled_quadrant_width - 1
    divp t3, t3, t4          	# t3 = fx

    subp t4, s6, t0         	# t4 = quadrant_height - 1
    mulp t4, t10, t4          	# t4 = y * (quadrant_height - 1) 
    sllip t4, t4, 6            	# << 6 (setting for 6 fractional bits)
    subp t5, s7, t0         	# t5 = scaled_quadrant_height - 1
    divp t4, t4, t5          	# t4 = fy

    # Get ox, oy, fx_frac, fy_frac
    srlip t5, t3, 6            	# ox = fx >> 6
    srlip t6, t4, 6            	# oy = fy >> 6
    andp t7, t3, s9        		# fx_frac = fx & 0x3F (6 bits)
    andp t8, t4, s9        		# fy_frac = fy & 0x3F (6 bits)

    # Load the values ​​of P11, P12, P21, P22
    addp t0, s3, zero			# t0 = saved_quadrant
    mulp t1, s4, t6          	# t1 = quadrant_width * oy
    addp t1, t1, t5          	# t1 = (quadrant_width * oy) + ox

    addp t0, t0, t1          	# Pixel address in (ox, oy)
    lbp a0, 0(t0)             	# P11 (top left)
    lbp a1, 1(t0)            	# P12 (top right)

    addp t0, t0, s4          	# Pixel address at (ox, oy + 1)
    lbp a2, 0(t0)             	# P21 (bottom left)
    lbp a3, 1(t0)            	# P22 (bottom right)

    # Bilinear interpolation
    # 1 - fx_frac and 1 - fy_frac
    addip t0, zero, 16			
	sllip t0, t0, 2				# 64 represents 1.0 in 6-bit fixed point
    subp t3, t0, t7         	# 1 - fx_frac
    subp t4, t0, t8         	# 1 - fy_frac

    # Top and bottom
    mulp t0, a0, t3          	# t0 = P11 * (1 - fx_frac)
    mulp t0, t0, t4          	# t0 = P11 * (1 - fx_frac) * (1 - fy_frac)

    mulp t1, a1, t7          	# t1 = P12 * fx_frac
    mulp t1, t1, t4          	# t1 = P12 * fx_frac * (1 - fy_frac)

    mulp t2, a2, t3          	# t2 = P21 * (1 - fx_frac)
    mulp t2, t2, t8          	# t2 = P21 * (1 - fx_frac) * fy_frac

    mulp t3, a3, t7          	# t3 = P22 * fx_frac
    mulp t3, t3, t8          	# t3 = P22 * fx_frac * fy_frac

    # Sum the contributions
    addp t0, t0, t1         	# Top
    addp t2, t2, t3         	# Bottom
    addp t0, t0, t2         	# Total sum

    # Convert from fixed point
    srlip t0, t0, 12			# Shift 12 bits to fit the result to an integer

    # Save the interpolated pixel
    addp t1, s8, zero			# t1 = scaled_quadrant
    addp t1, t1, t12
    sbp t0, 0(t1)
    addip t12, t12, 1

    # Increment indexes and loops
    addip t11, t11, 1
	cmpp t11, s5
	bltp column_loop

    addip t10, t10, 1
	cmpp t10, s7
	bltp row_loop

    # End of program
    addip v0, zero, 10
    syscall
