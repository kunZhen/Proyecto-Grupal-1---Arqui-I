transcript on
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vlog -sv -work work +incdir+. {MAIN.svo}

vlog -sv -work work +incdir+C:/Users/Usuario/Documents/ArquidecomputadoresI/Proyecto-Grupal-1---Arqui-I/PISA/Keyboard {C:/Users/Usuario/Documents/ArquidecomputadoresI/Proyecto-Grupal-1---Arqui-I/PISA/Keyboard/PS2_DRIVER_tb.sv}

vsim -t 1ps +transport_int_delays +transport_path_delays -L altera_ver -L altera_lnsim_ver -L cyclonev_ver -L lpm_ver -L sgate_ver -L cyclonev_hssi_ver -L altera_mf_ver -L cyclonev_pcie_hip_ver -L gate_work -L work -voptargs="+acc"  PS2_DRIVER_tb

add wave *
view structure
view signals
run -all
