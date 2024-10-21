set_global_assignment -entity "pllkeyboard" -library "lib_pllkeyboard" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "pllkeyboard" -library "lib_pllkeyboard" -name IP_TOOL_VERSION "18.1"
set_global_assignment -entity "pllkeyboard" -library "lib_pllkeyboard" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_pllkeyboard" -name SPD_FILE [file join $::quartus(sip_path) "pllkeyboard.spd"]

set_global_assignment -library "lib_pllkeyboard" -name MISC_FILE [file join $::quartus(sip_path) "pllkeyboard_sim/pllkeyboard.vo"]
