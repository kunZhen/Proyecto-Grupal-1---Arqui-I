transcript on
if ![file isdirectory MAIN_iputf_libs] {
	file mkdir MAIN_iputf_libs
}

if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

###### Libraries for IPUTF cores 
###### End libraries for IPUTF cores 
###### MIF file copy and HDL compilation commands for IPUTF cores 


vlog "C:/Users/Usuario/Documents/ArquidecomputadoresI/Proyecto-Grupal-1---Arqui-I/PISA/pllkeyboard_sim/pllkeyboard.vo"

vlog -vlog01compat -work work +incdir+C:/Users/Usuario/Documents/ArquidecomputadoresI/Proyecto-Grupal-1---Arqui-I/PISA {C:/Users/Usuario/Documents/ArquidecomputadoresI/Proyecto-Grupal-1---Arqui-I/PISA/RAM_pixels.v}
vlog -sv -work work +incdir+C:/Users/Usuario/Documents/ArquidecomputadoresI/Proyecto-Grupal-1---Arqui-I/PISA {C:/Users/Usuario/Documents/ArquidecomputadoresI/Proyecto-Grupal-1---Arqui-I/PISA/MAIN.sv}
vlog -sv -work work +incdir+C:/Users/Usuario/Documents/ArquidecomputadoresI/Proyecto-Grupal-1---Arqui-I/PISA {C:/Users/Usuario/Documents/ArquidecomputadoresI/Proyecto-Grupal-1---Arqui-I/PISA/PISA.sv}
vlog -sv -work work +incdir+C:/Users/Usuario/Documents/ArquidecomputadoresI/Proyecto-Grupal-1---Arqui-I/PISA/VGA {C:/Users/Usuario/Documents/ArquidecomputadoresI/Proyecto-Grupal-1---Arqui-I/PISA/VGA/pll.sv}
vlog -sv -work work +incdir+C:/Users/Usuario/Documents/ArquidecomputadoresI/Proyecto-Grupal-1---Arqui-I/PISA/VGA {C:/Users/Usuario/Documents/ArquidecomputadoresI/Proyecto-Grupal-1---Arqui-I/PISA/VGA/vga_controller.sv}
vlog -sv -work work +incdir+C:/Users/Usuario/Documents/ArquidecomputadoresI/Proyecto-Grupal-1---Arqui-I/PISA/VGA {C:/Users/Usuario/Documents/ArquidecomputadoresI/Proyecto-Grupal-1---Arqui-I/PISA/VGA/draw_board.sv}
vlog -sv -work work +incdir+C:/Users/Usuario/Documents/ArquidecomputadoresI/Proyecto-Grupal-1---Arqui-I/PISA/VGA {C:/Users/Usuario/Documents/ArquidecomputadoresI/Proyecto-Grupal-1---Arqui-I/PISA/VGA/vga.sv}
vlog -sv -work work +incdir+C:/Users/Usuario/Documents/ArquidecomputadoresI/Proyecto-Grupal-1---Arqui-I/PISA {C:/Users/Usuario/Documents/ArquidecomputadoresI/Proyecto-Grupal-1---Arqui-I/PISA/KFPS2KB.sv}
vlog -sv -work work +incdir+C:/Users/Usuario/Documents/ArquidecomputadoresI/Proyecto-Grupal-1---Arqui-I/PISA {C:/Users/Usuario/Documents/ArquidecomputadoresI/Proyecto-Grupal-1---Arqui-I/PISA/KFPS2KB_Shift_Register.sv}
vlog -sv -work work +incdir+C:/Users/Usuario/Documents/ArquidecomputadoresI/Proyecto-Grupal-1---Arqui-I/PISA {C:/Users/Usuario/Documents/ArquidecomputadoresI/Proyecto-Grupal-1---Arqui-I/PISA/top_keyboard.sv}

vlog -sv -work work +incdir+C:/Users/Usuario/Documents/ArquidecomputadoresI/Proyecto-Grupal-1---Arqui-I/PISA/TestBench {C:/Users/Usuario/Documents/ArquidecomputadoresI/Proyecto-Grupal-1---Arqui-I/PISA/TestBench/RAM_data_tb.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  RAM_data_tb

add wave *
view structure
view signals
run -all
