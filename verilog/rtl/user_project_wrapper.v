// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

`default_nettype none
/*
 *-------------------------------------------------------------
 *
 * user_project_wrapper
 *
 * This wrapper enumerates all of the pins available to the
 * user for the user project.
 *
 * An example user project is provided in this wrapper.  The
 * example should be removed and replaced with the actual
 * user project.
 *
 *-------------------------------------------------------------
 */
`ifndef MPRJ_IO_PADS
`define MPRJ_IO_PADS 38
`endif

`include "config_reg.v"
`include "audiodac.v"
`include "tempsense.v"
//`include "/foss/pdks/sky130A/libs.ref/sky130_fd_sc_hd/verilog/sky130_fd_sc_hd.v"
//`include "/foss/pdks/sky130A/libs.ref/sky130_fd_sc_hd/verilog/primitives.v"

module user_project_wrapper #(
    parameter BITS = 32
) (
`ifdef USE_POWER_PINS
    inout vdda1,	// User area 1 3.3V supply
    inout vdda2,	// User area 2 3.3V supply
    inout vssa1,	// User area 1 analog ground
    inout vssa2,	// User area 2 analog ground
    inout vccd1,	// User area 1 1.8V supply
    inout vccd2,	// User area 2 1.8v supply
    inout vssd1,	// User area 1 digital ground
    inout vssd2,	// User area 2 digital ground
`endif

    // Wishbone Slave ports (WB MI A)
    input wb_clk_i,
    input wb_rst_i,
    input wbs_stb_i,
    input wbs_cyc_i,
    input wbs_we_i,
    input [3:0] wbs_sel_i,
    input [31:0] wbs_dat_i,
    input [31:0] wbs_adr_i,
    output wbs_ack_o,
    output [31:0] wbs_dat_o,

    // Logic Analyzer Signals
    input  [127:0] la_data_in,
    output [127:0] la_data_out,
    input  [127:0] la_oenb,

    // IOs
    input  [`MPRJ_IO_PADS-1:0] io_in,
    output [`MPRJ_IO_PADS-1:0] io_out,
    output [`MPRJ_IO_PADS-1:0] io_oeb,

    // Analog (direct connection to GPIO pad---use with caution)
    // Note that analog I/O is not available on the 7 lowest-numbered
    // GPIO pads, and so the analog_io indexing is offset from the
    // GPIO indexing by 7 (also upper 2 GPIOs do not have analog_io).
    inout [`MPRJ_IO_PADS-10:0] analog_io,

    // Independent clock (on independent integer divider)
    input   user_clock2,

    // User maskable interrupt signals
    output [2:0] user_irq
);

/*--------------------------------------*/
/* User project is instantiated  here   */
/*--------------------------------------*/

    wire        reset_n_w =         io_in[5];
    wire        clk_w =             io_in[6];
    wire [15:0] data_in_w =         io_in[22:7];
    wire [2:0]  data_out_sel_w =    io_in[25:23];
    wire        config_wr_w =       io_in[26];
    wire [1:0]  config_adr_w =      io_in[28:27];
    wire        trigger_in_w =      io_in[29];
    wire        adc_analog_in_p =   analog_io[30-7];
    wire        adc_analog_in_n =   analog_io[31-7];
    assign      io_out[37:32] =     mux_out_w;

    wire [5:0]  mux_out_w;
    wire [5:0]  temp_dac_w;
    wire [11:0] temp_tick_w;
    wire        temp_done_w;
    wire [5:0]  dac_out_w;
    wire [15:0] reg0_w;
    wire [15:0] reg1_w;
    wire [15:0] reg2_w;
    wire [15:0] reg3_w;
    wire        dummy_w =           reg0_w[15];

    config_reg cfg_reg0 (
    `ifdef USE_POWER_PINS
        .vccd1(vccd1),	// User area 1 1.8V power
        .vssd1(vssd1),	// User area 1 digital ground
    `endif

        .rst_n_i(reset_n_w),
        .clk_i(clk_w),
        .reg_wr_i(config_wr_w),
        .reg_adr_i(config_adr_w),
        .reg_dat_i(data_in_w),
        .reg0_o(reg0_w),
        .reg1_o(reg1_w),
        .reg2_o(reg2_w),
        .reg3_o(reg3_w),
        .mux_adr_i(data_out_sel_w),
        .mux_o(mux_out_w),
        .mux0_i({{5{dummy_w}},temp_done_w}),
        .mux1_i(temp_dac_w),
        .mux2_i(temp_tick_w[5:0]),
        .mux3_i(temp_tick_w[11:6]),
        .mux4_i(dac_out_w),
        .mux5_i({6{dummy_w}}),
        .mux6_i({6{dummy_w}}),
        .mux7_i({6{dummy_w}})
    );

    tempsense temp0 (
    `ifdef USE_POWER_PINS
        .vccd1(vccd1),	// User area 1 1.8V power
        .vssd1(vssd1),	// User area 1 digital ground
    `endif

        .clk(clk_w),
        .rst_n(reset_n_w),
        .start_conv_in(trigger_in_w),
        .vdac_result_out(temp_dac_w),
        .tick_result_out(temp_tick_w),
        .conversion_finished_out(temp_done_w)
    );

    audiodac adac0 (
    `ifdef USE_POWER_PINS
        .vccd1(vccd1),	// User area 1 1.8V power
        .vssd1(vssd1),	// User area 1 digital ground
    `endif

        .fifo_i(data_in_w),
        .fifo_rdy_i(trigger_in_w),
        .fifo_ack_o(dac_out_w[2]),
        .fifo_full_o(dac_out_w[3]),
        .fifo_empty_o(dac_out_w[4]),
        .rst_n_i(reset_n_w),
        .clk_i(clk_w),
        .mode_i(reg0_w[0]),
        .volume_i(reg0_w[4:1]),
        .osr_i(reg0_w[6:5]),
        .ds_o(dac_out_w[0]),
        .ds_n_o(dac_out_w[1]),
        .tst_fifo_loop_i(reg1_w[0]),
        .tst_sinegen_en_i(reg1_w[1]),
        .tst_sinegen_step_i(reg1_w[7:2])
    );

endmodule	// user_project_wrapper

`default_nettype wire
