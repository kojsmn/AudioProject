set_global_assignment -entity "SRAM" -library "lib_SRAM" -name IP_TOOL_NAME "altera_up_avalon_sram"
set_global_assignment -entity "SRAM" -library "lib_SRAM" -name IP_TOOL_VERSION "13.0sp1"
set_global_assignment -entity "SRAM" -library "lib_SRAM" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_SRAM" -name SPD_FILE [file join $::quartus(sip_path) "SRAM.spd"]

set_global_assignment -library "lib_SRAM" -name MISC_FILE [file join $::quartus(sip_path) "SRAM_sim/SRAM.v"]
