set_global_assignment -entity "PS2controller" -library "lib_PS2controller" -name IP_TOOL_NAME "Qsys"
set_global_assignment -entity "PS2controller" -library "lib_PS2controller" -name IP_TOOL_VERSION "18.1"
set_global_assignment -entity "PS2controller" -library "lib_PS2controller" -name IP_TOOL_ENV "Qsys"
set_global_assignment -library "lib_PS2controller" -name SPD_FILE [file join $::quartus(sip_path) "../PS2controller.spd"]
set_global_assignment -library "lib_PS2controller" -name MISC_FILE [file join $::quartus(sip_path) "../../PS2controller.qsys"]

set_global_assignment -library "lib_PS2controller" -name MISC_FILE [file join $::quartus(sip_path) "PS2controller.v"]
set_global_assignment -library "lib_PS2controller" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_up_ps2.v"]
set_global_assignment -library "lib_PS2controller" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_up_ps2_command_out.v"]
set_global_assignment -library "lib_PS2controller" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_up_ps2_data_in.v"]
set_global_assignment -library "lib_PS2controller" -name MISC_FILE [file join $::quartus(sip_path) "submodules/PS2controller_ps2_0.v"]
