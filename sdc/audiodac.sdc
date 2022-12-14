###############################################################################
# Created by write_sdc
# Fri Dec  9 20:51:24 2022
###############################################################################
current_design audiodac
###############################################################################
# Timing Constraints
###############################################################################
create_clock -name clk_i -period 50.0000 [get_ports {clk_i}]
set_clock_transition 0.1500 [get_clocks {clk_i}]
set_clock_uncertainty 0.2500 clk_i
set_propagated_clock [get_clocks {clk_i}]
set_input_delay 10.0000 -clock [get_clocks {clk_i}] -add_delay [get_ports {fifo_i[0]}]
set_input_delay 10.0000 -clock [get_clocks {clk_i}] -add_delay [get_ports {fifo_i[10]}]
set_input_delay 10.0000 -clock [get_clocks {clk_i}] -add_delay [get_ports {fifo_i[11]}]
set_input_delay 10.0000 -clock [get_clocks {clk_i}] -add_delay [get_ports {fifo_i[12]}]
set_input_delay 10.0000 -clock [get_clocks {clk_i}] -add_delay [get_ports {fifo_i[13]}]
set_input_delay 10.0000 -clock [get_clocks {clk_i}] -add_delay [get_ports {fifo_i[14]}]
set_input_delay 10.0000 -clock [get_clocks {clk_i}] -add_delay [get_ports {fifo_i[15]}]
set_input_delay 10.0000 -clock [get_clocks {clk_i}] -add_delay [get_ports {fifo_i[1]}]
set_input_delay 10.0000 -clock [get_clocks {clk_i}] -add_delay [get_ports {fifo_i[2]}]
set_input_delay 10.0000 -clock [get_clocks {clk_i}] -add_delay [get_ports {fifo_i[3]}]
set_input_delay 10.0000 -clock [get_clocks {clk_i}] -add_delay [get_ports {fifo_i[4]}]
set_input_delay 10.0000 -clock [get_clocks {clk_i}] -add_delay [get_ports {fifo_i[5]}]
set_input_delay 10.0000 -clock [get_clocks {clk_i}] -add_delay [get_ports {fifo_i[6]}]
set_input_delay 10.0000 -clock [get_clocks {clk_i}] -add_delay [get_ports {fifo_i[7]}]
set_input_delay 10.0000 -clock [get_clocks {clk_i}] -add_delay [get_ports {fifo_i[8]}]
set_input_delay 10.0000 -clock [get_clocks {clk_i}] -add_delay [get_ports {fifo_i[9]}]
set_input_delay 10.0000 -clock [get_clocks {clk_i}] -add_delay [get_ports {fifo_rdy_i}]
set_input_delay 10.0000 -clock [get_clocks {clk_i}] -add_delay [get_ports {mode_i}]
set_input_delay 10.0000 -clock [get_clocks {clk_i}] -add_delay [get_ports {osr_i[0]}]
set_input_delay 10.0000 -clock [get_clocks {clk_i}] -add_delay [get_ports {osr_i[1]}]
set_input_delay 10.0000 -clock [get_clocks {clk_i}] -add_delay [get_ports {rst_n_i}]
set_input_delay 10.0000 -clock [get_clocks {clk_i}] -add_delay [get_ports {tst_fifo_loop_i}]
set_input_delay 10.0000 -clock [get_clocks {clk_i}] -add_delay [get_ports {tst_sinegen_en_i}]
set_input_delay 10.0000 -clock [get_clocks {clk_i}] -add_delay [get_ports {tst_sinegen_step_i[0]}]
set_input_delay 10.0000 -clock [get_clocks {clk_i}] -add_delay [get_ports {tst_sinegen_step_i[1]}]
set_input_delay 10.0000 -clock [get_clocks {clk_i}] -add_delay [get_ports {tst_sinegen_step_i[2]}]
set_input_delay 10.0000 -clock [get_clocks {clk_i}] -add_delay [get_ports {tst_sinegen_step_i[3]}]
set_input_delay 10.0000 -clock [get_clocks {clk_i}] -add_delay [get_ports {tst_sinegen_step_i[4]}]
set_input_delay 10.0000 -clock [get_clocks {clk_i}] -add_delay [get_ports {tst_sinegen_step_i[5]}]
set_input_delay 10.0000 -clock [get_clocks {clk_i}] -add_delay [get_ports {volume_i[0]}]
set_input_delay 10.0000 -clock [get_clocks {clk_i}] -add_delay [get_ports {volume_i[1]}]
set_input_delay 10.0000 -clock [get_clocks {clk_i}] -add_delay [get_ports {volume_i[2]}]
set_input_delay 10.0000 -clock [get_clocks {clk_i}] -add_delay [get_ports {volume_i[3]}]
set_output_delay 10.0000 -clock [get_clocks {clk_i}] -add_delay [get_ports {ds_n_o}]
set_output_delay 10.0000 -clock [get_clocks {clk_i}] -add_delay [get_ports {ds_o}]
set_output_delay 10.0000 -clock [get_clocks {clk_i}] -add_delay [get_ports {fifo_ack_o}]
set_output_delay 10.0000 -clock [get_clocks {clk_i}] -add_delay [get_ports {fifo_empty_o}]
set_output_delay 10.0000 -clock [get_clocks {clk_i}] -add_delay [get_ports {fifo_full_o}]
###############################################################################
# Environment
###############################################################################
set_load -pin_load 0.0334 [get_ports {ds_n_o}]
set_load -pin_load 0.0334 [get_ports {ds_o}]
set_load -pin_load 0.0334 [get_ports {fifo_ack_o}]
set_load -pin_load 0.0334 [get_ports {fifo_empty_o}]
set_load -pin_load 0.0334 [get_ports {fifo_full_o}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {clk_i}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {fifo_rdy_i}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {mode_i}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {rst_n_i}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {tst_fifo_loop_i}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {tst_sinegen_en_i}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {fifo_i[15]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {fifo_i[14]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {fifo_i[13]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {fifo_i[12]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {fifo_i[11]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {fifo_i[10]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {fifo_i[9]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {fifo_i[8]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {fifo_i[7]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {fifo_i[6]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {fifo_i[5]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {fifo_i[4]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {fifo_i[3]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {fifo_i[2]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {fifo_i[1]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {fifo_i[0]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {osr_i[1]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {osr_i[0]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {tst_sinegen_step_i[5]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {tst_sinegen_step_i[4]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {tst_sinegen_step_i[3]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {tst_sinegen_step_i[2]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {tst_sinegen_step_i[1]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {tst_sinegen_step_i[0]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {volume_i[3]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {volume_i[2]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {volume_i[1]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {volume_i[0]}]
set_timing_derate -early 0.9500
set_timing_derate -late 1.0500
###############################################################################
# Design Rules
###############################################################################
set_max_fanout 10.0000 [current_design]
