addip t0, zero, 5      # t0 = 5
addip t1, zero, 10     # t1 = a
cmpp t0, t1
bgep Major
addip t2, zero, 12     # t2 = c
addp t3, t0, t2        # t3 = 11
cmp zero, zero
bgep End
Major:
lwp t0, 0(zero)        # t0 = c
lwp t1, 4(zero)        # t1 = c
End:
subp t4, t1, t0        # t4 = 5/0