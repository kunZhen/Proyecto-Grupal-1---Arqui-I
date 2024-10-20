transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/emari/Desktop/Proyecto-Grupal-1---Arqui-I/Pipeline {C:/Users/emari/Desktop/Proyecto-Grupal-1---Arqui-I/Pipeline/alu.sv}
vlog -sv -work work +incdir+C:/Users/emari/Desktop/Proyecto-Grupal-1---Arqui-I/Pipeline {C:/Users/emari/Desktop/Proyecto-Grupal-1---Arqui-I/Pipeline/alu_control.sv}
vlog -sv -work work +incdir+C:/Users/emari/Desktop/Proyecto-Grupal-1---Arqui-I/Pipeline {C:/Users/emari/Desktop/Proyecto-Grupal-1---Arqui-I/Pipeline/compare.sv}
vlog -sv -work work +incdir+C:/Users/emari/Desktop/Proyecto-Grupal-1---Arqui-I/Pipeline {C:/Users/emari/Desktop/Proyecto-Grupal-1---Arqui-I/Pipeline/control_unit.sv}
vlog -sv -work work +incdir+C:/Users/emari/Desktop/Proyecto-Grupal-1---Arqui-I/Pipeline {C:/Users/emari/Desktop/Proyecto-Grupal-1---Arqui-I/Pipeline/imm_gen.sv}
vlog -sv -work work +incdir+C:/Users/emari/Desktop/Proyecto-Grupal-1---Arqui-I/Pipeline {C:/Users/emari/Desktop/Proyecto-Grupal-1---Arqui-I/Pipeline/mux2.sv}
vlog -sv -work work +incdir+C:/Users/emari/Desktop/Proyecto-Grupal-1---Arqui-I/Pipeline {C:/Users/emari/Desktop/Proyecto-Grupal-1---Arqui-I/Pipeline/mux4.sv}
vlog -sv -work work +incdir+C:/Users/emari/Desktop/Proyecto-Grupal-1---Arqui-I/Pipeline {C:/Users/emari/Desktop/Proyecto-Grupal-1---Arqui-I/Pipeline/register_file.sv}
vlog -sv -work work +incdir+C:/Users/emari/Desktop/Proyecto-Grupal-1---Arqui-I/Pipeline {C:/Users/emari/Desktop/Proyecto-Grupal-1---Arqui-I/Pipeline/datapath_unit.sv}
vlog -sv -work work +incdir+C:/Users/emari/Desktop/Proyecto-Grupal-1---Arqui-I/Pipeline {C:/Users/emari/Desktop/Proyecto-Grupal-1---Arqui-I/Pipeline/data_memory.sv}
vlog -sv -work work +incdir+C:/Users/emari/Desktop/Proyecto-Grupal-1---Arqui-I/Pipeline {C:/Users/emari/Desktop/Proyecto-Grupal-1---Arqui-I/Pipeline/instruction_memory.sv}

vlog -sv -work work +incdir+C:/Users/emari/Desktop/Proyecto-Grupal-1---Arqui-I/Pipeline {C:/Users/emari/Desktop/Proyecto-Grupal-1---Arqui-I/Pipeline/datapath_unit_tb.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  datapath_unit_tb

add wave *
view structure
view signals
run -all
