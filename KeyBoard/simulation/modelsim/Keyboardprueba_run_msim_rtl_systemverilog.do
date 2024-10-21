transcript on
if ![file isdirectory Keyboardprueba_iputf_libs] {
	file mkdir Keyboardprueba_iputf_libs
}

if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

###### Libraries for IPUTF cores 
###### End libraries for IPUTF cores 
###### MIF file copy and HDL compilation commands for IPUTF cores 


vlog "C:/Users/Usuario/Documents/ArquidecomputadoresI/Proyecto-Grupal-1---Arqui-I/Keyboardprueba/pll_sim/pll.vo"

vlog -vlog01compat -work work +incdir+C:/Users/Usuario/Documents/ArquidecomputadoresI/Proyecto-Grupal-1---Arqui-I/Keyboardprueba {C:/Users/Usuario/Documents/ArquidecomputadoresI/Proyecto-Grupal-1---Arqui-I/Keyboardprueba/ramps2.v}
vlog -sv -work work +incdir+C:/Users/Usuario/Documents/ArquidecomputadoresI/Proyecto-Grupal-1---Arqui-I/Keyboardprueba {C:/Users/Usuario/Documents/ArquidecomputadoresI/Proyecto-Grupal-1---Arqui-I/Keyboardprueba/KFPS2KB_Shift_Register.sv}
vlog -sv -work work +incdir+C:/Users/Usuario/Documents/ArquidecomputadoresI/Proyecto-Grupal-1---Arqui-I/Keyboardprueba {C:/Users/Usuario/Documents/ArquidecomputadoresI/Proyecto-Grupal-1---Arqui-I/Keyboardprueba/KFPS2KB.sv}
vlog -sv -work work +incdir+C:/Users/Usuario/Documents/ArquidecomputadoresI/Proyecto-Grupal-1---Arqui-I/Keyboardprueba {C:/Users/Usuario/Documents/ArquidecomputadoresI/Proyecto-Grupal-1---Arqui-I/Keyboardprueba/top.sv}

vlog -sv -work work +incdir+C:/Users/Usuario/Documents/ArquidecomputadoresI/Proyecto-Grupal-1---Arqui-I/Keyboardprueba {C:/Users/Usuario/Documents/ArquidecomputadoresI/Proyecto-Grupal-1---Arqui-I/Keyboardprueba/KFPS2KB_tb.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  KFPS2KB_tb

add wave *
view structure
view signals
run -all
