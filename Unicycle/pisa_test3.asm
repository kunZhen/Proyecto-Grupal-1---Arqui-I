# Set 0x3F
nop
addip s9, zero, 3
sllip s9, s9, 4				# s9 = 0x30
addip t2, zero, 15
orp s9, s9, t2				# s9 = 0x3F