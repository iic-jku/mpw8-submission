###############################################################################
# Created by write_sdc
# Fri Dec  9 20:45:25 2022
###############################################################################
current_design tempsense
###############################################################################
# Timing Constraints
###############################################################################
create_clock -name clk -period 50.0000 [get_ports {clk}]
set_clock_transition 0.1500 [get_clocks {clk}]
set_clock_uncertainty 0.2500 clk
set_propagated_clock [get_clocks {clk}]
set_input_delay 10.0000 -clock [get_clocks {clk}] -add_delay [get_ports {rst_n}]
set_input_delay 10.0000 -clock [get_clocks {clk}] -add_delay [get_ports {start_conv_in}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -add_delay [get_ports {conversion_finished_out}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -add_delay [get_ports {tick_result_out[0]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -add_delay [get_ports {tick_result_out[10]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -add_delay [get_ports {tick_result_out[11]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -add_delay [get_ports {tick_result_out[1]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -add_delay [get_ports {tick_result_out[2]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -add_delay [get_ports {tick_result_out[3]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -add_delay [get_ports {tick_result_out[4]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -add_delay [get_ports {tick_result_out[5]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -add_delay [get_ports {tick_result_out[6]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -add_delay [get_ports {tick_result_out[7]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -add_delay [get_ports {tick_result_out[8]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -add_delay [get_ports {tick_result_out[9]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -add_delay [get_ports {vdac_result_out[0]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -add_delay [get_ports {vdac_result_out[1]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -add_delay [get_ports {vdac_result_out[2]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -add_delay [get_ports {vdac_result_out[3]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -add_delay [get_ports {vdac_result_out[4]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -add_delay [get_ports {vdac_result_out[5]}]
###############################################################################
# Environment
###############################################################################
set_load -pin_load 0.0334 [get_ports {conversion_finished_out}]
set_load -pin_load 0.0334 [get_ports {tick_result_out[11]}]
set_load -pin_load 0.0334 [get_ports {tick_result_out[10]}]
set_load -pin_load 0.0334 [get_ports {tick_result_out[9]}]
set_load -pin_load 0.0334 [get_ports {tick_result_out[8]}]
set_load -pin_load 0.0334 [get_ports {tick_result_out[7]}]
set_load -pin_load 0.0334 [get_ports {tick_result_out[6]}]
set_load -pin_load 0.0334 [get_ports {tick_result_out[5]}]
set_load -pin_load 0.0334 [get_ports {tick_result_out[4]}]
set_load -pin_load 0.0334 [get_ports {tick_result_out[3]}]
set_load -pin_load 0.0334 [get_ports {tick_result_out[2]}]
set_load -pin_load 0.0334 [get_ports {tick_result_out[1]}]
set_load -pin_load 0.0334 [get_ports {tick_result_out[0]}]
set_load -pin_load 0.0334 [get_ports {vdac_result_out[5]}]
set_load -pin_load 0.0334 [get_ports {vdac_result_out[4]}]
set_load -pin_load 0.0334 [get_ports {vdac_result_out[3]}]
set_load -pin_load 0.0334 [get_ports {vdac_result_out[2]}]
set_load -pin_load 0.0334 [get_ports {vdac_result_out[1]}]
set_load -pin_load 0.0334 [get_ports {vdac_result_out[0]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {clk}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {rst_n}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {start_conv_in}]
set_timing_derate -early 0.9500
set_timing_derate -late 1.0500
###############################################################################
# Design Rules
###############################################################################
set_max_fanout 10.0000 [current_design]
