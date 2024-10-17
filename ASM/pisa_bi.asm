# Algorithm that applies bilinear interpolation to an N x N matrix. 
# It uses 20-bit registers, 14 bits for the integer part and 6 bits for the decimal part.

.global _start

_start:
	nop
    # Load original image dimensions     
    lwp s0, 0(zero)         	# s0 = width
    lwp s1, 4(zero)        		# s1 = height
	
	# Store base address of original image
	addip s4, zero, 16			# s4 = original_image
	
	# Define the base address of the scaled image
	mulp t0, s0, s1
	addip t0, t0, 8
	addp t0, t0, s4
	addp s5, t0, zero			# s5 = scaled_image

    # Calculate dimensions of the new scaled image
    sllip s6, s0, 1         	# s6 = new_width
    sllip s7, s1, 1             # s7 = new_height
	
	# Set 0x3F
	addip s8, zero, 3
	sllip s8, s8, 4				# s8 = 0x30
	addip t2, zero, 15
	orp s8, s8, t2				# s8 = 0x3F
								
    addip t10, zero, 0          # t10 = y iterator for rows
    addip t12, zero, 0          # t12 = offset to point to the next pixel in the scaled image

row_loop:
    addip t11, zero, 0          # t11 = x iterator for columns

column_loop:
    # Calculate position in original image with fixed point
	addip t0, zero, 1
    subp t3, s0, t0         	# t3 = width - 1
    mulp t3, t11, t3          	# t3 = x * (width - 1)
    sllip t3, t3, 6            	# << 6 (setting for 6 fractional bits)
    subp t4, s6, t0         	# t4 = new_width - 1
    divp t3, t3, t4          	# t3 = fx

    subp t4, s1, t0         	# t4 = height - 1
    mulp t4, t10, t4          	# t4 = y * (height - 1) 
    sllip t4, t4, 6            	# << 6 (setting for 6 fractional bits)
    subp t5, s7, t0         	# t5 = new_height - 1
    divp t4, t4, t5          	# t4 = fy

    # Get ox, oy, fx_frac, fy_frac
    srlip t5, t3, 6            	# ox = fx >> 6
    srlip t6, t4, 6            	# oy = fy >> 6
    andp t7, t3, s8        		# fx_frac = fx & 0x3F (6 bits)
    andp t8, t4, s8        		# fy_frac = fy & 0x3F (6 bits)

    # Load the values ​​of P11, P12, P21, P22
    addp t0, s4, zero			# t0 = original_image
    mulp t1, s0, t6          	# t1 = width * oy
    addp t1, t1, t5          	# t1 = (width * oy) + ox

    addp t0, t0, t1          	# Pixel address in (ox, oy)
    lbp a0, 0(t0)             	# P11 (top left)
    lbp a1, 1(t0)            	# P12 (top right)

    addp t0, t0, s0          	# Pixel address at (ox, oy + 1)
    lbp a2, 0(t0)             	# P21 (bottom left)
    lbp a3, 1(t0)            	# P22 (bottom right)

    # Bilinear interpolation
    # 1 - fx_frac andp 1 - fy_frac
    addip t0, zero, 16			
	sllip t0, t0, 2				# 64 represents 1.0 in 6-bit fixed point
    subp t3, t0, t7         		# 1 - fx_frac
    subp t4, t0, t8         		# 1 - fy_frac

    # Top andp bottom
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
    addp t1, s5, zero
    addp t1, t1, t12
    sbp t0, 0(t1)
    addip t12, t12, 1

    # Increment indexes andp loops
    addip t11, t11, 1
	cmpp t11, s6
	bltp column_loop

    addip t10, t10, 1
	cmpp t10, s7
	bltp row_loop

    # End of program
    addip v0, zero, 10
    syscall
