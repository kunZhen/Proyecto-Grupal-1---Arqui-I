transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/Usuario/Desktop/Proyecto-Grupal-1---Arqui-I/Unicycle {C:/Users/Usuario/Desktop/Proyecto-Grupal-1---Arqui-I/Unicycle/register_file.sv}
vlog -sv -work work +incdir+C:/Users/Usuario/Desktop/Proyecto-Grupal-1---Arqui-I/Unicycle {C:/Users/Usuario/Desktop/Proyecto-Grupal-1---Arqui-I/Unicycle/mux2.sv}
vlog -sv -work work +incdir+C:/Users/Usuario/Desktop/Proyecto-Grupal-1---Arqui-I/Unicycle {C:/Users/Usuario/Desktop/Proyecto-Grupal-1---Arqui-I/Unicycle/imm_gen.sv}
vlog -sv -work work +incdir+C:/Users/Usuario/Desktop/Proyecto-Grupal-1---Arqui-I/Unicycle {C:/Users/Usuario/Desktop/Proyecto-Grupal-1---Arqui-I/Unicycle/alu.sv}
vlog -sv -work work +incdir+C:/Users/Usuario/Desktop/Proyecto-Grupal-1---Arqui-I/Unicycle {C:/Users/Usuario/Desktop/Proyecto-Grupal-1---Arqui-I/Unicycle/alu_control.sv}
vlog -sv -work work +incdir+C:/Users/Usuario/Desktop/Proyecto-Grupal-1---Arqui-I/Unicycle {C:/Users/Usuario/Desktop/Proyecto-Grupal-1---Arqui-I/Unicycle/control_unit.sv}
vlog -sv -work work +incdir+C:/Users/Usuario/Desktop/Proyecto-Grupal-1---Arqui-I/Unicycle {C:/Users/Usuario/Desktop/Proyecto-Grupal-1---Arqui-I/Unicycle/datapath_unit.sv}
vlog -sv -work work +incdir+C:/Users/Usuario/Desktop/Proyecto-Grupal-1---Arqui-I/Unicycle {C:/Users/Usuario/Desktop/Proyecto-Grupal-1---Arqui-I/Unicycle/compare.sv}
vlog -sv -work work +incdir+C:/Users/Usuario/Desktop/Proyecto-Grupal-1---Arqui-I/Unicycle {C:/Users/Usuario/Desktop/Proyecto-Grupal-1---Arqui-I/Unicycle/mux4.sv}
vlog -sv -work work +incdir+C:/Users/Usuario/Desktop/Proyecto-Grupal-1---Arqui-I/Unicycle {C:/Users/Usuario/Desktop/Proyecto-Grupal-1---Arqui-I/Unicycle/unicycle.sv}
vlog -sv -work work +incdir+C:/Users/Usuario/Desktop/Proyecto-Grupal-1---Arqui-I/Unicycle {C:/Users/Usuario/Desktop/Proyecto-Grupal-1---Arqui-I/Unicycle/instruction_memory.sv}
vlog -sv -work work +incdir+C:/Users/Usuario/Desktop/Proyecto-Grupal-1---Arqui-I/Unicycle {C:/Users/Usuario/Desktop/Proyecto-Grupal-1---Arqui-I/Unicycle/data_memory.sv}

vlog -sv -work work +incdir+C:/Users/Usuario/Desktop/Proyecto-Grupal-1---Arqui-I/Unicycle {C:/Users/Usuario/Desktop/Proyecto-Grupal-1---Arqui-I/Unicycle/unicycle_tb.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  unicycle_tb

add wave *
view structure
view signals
run -all
