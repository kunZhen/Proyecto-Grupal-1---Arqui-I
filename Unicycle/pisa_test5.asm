nop    
addip t0, zero, 12
lwp s1, 4(zero)    	# s1 = height
lwp s0, 0(zero)  	# s0 = width
lbp t1, 8(zero)		# t1 = selected_quadrant

addip a0, zero, 4
addip a1, zero, 2

mulp t2, t1, a0     # t2 = t1 * 4
divp t3, t2, a1		# t3 = t2 / 2

sbp t2, 0(t0)
sbp t3, 1(t0)
sbp t3, 2(t0)
sbp t2, 3(t0)

lwp s1, 0(t0)