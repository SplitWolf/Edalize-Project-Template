log_wave -recursive *
create_wave_config
add_wave SSCS
add_wave DUT/SSCS_debounce/o_clean
add_wave clock
add_wave MSC
add_wave SSC
set mstl_wave [add_wave mstl]
set_property radix bin $mstl_wave
set sstl_wave [add_wave sstl]
set_property radix bin $sstl_wave
add_wave BCD1
add_wave BCD2
add_wave reset
add_wave sim_end
save_wave_config traffic_light_system_tb.wcfg
run all
exit