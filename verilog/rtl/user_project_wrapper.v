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

`include "defines.v"
`include "config_reg_mux.v"
`include "audiodac.v"
`include "tempsense.v"
`include "../../macro/adc_top.v"
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

    // ----------------------
    // connect inputs to core
    // ----------------------
    wire        reset_n_w =         io_in[5];
    wire        clk_w =             io_in[6];
    wire [15:0] data_in_w =         io_in[22:7];
    wire [2:0]  data_out_sel_w =    io_in[25:23];
    wire        config_wr_w =       io_in[26];
    wire [1:0]  config_adr_w =      io_in[28:27];
    wire        trigger_in_w =      io_in[29];

    // ----------------------------
    // connect analog inputs to ADC
    // ----------------------------
    wire        adc_analog_in_p =   analog_io[30-7];
    wire        adc_analog_in_n =   analog_io[31-7];

    // -----------------------
    // connect outputs to core
    // -----------------------
    assign      io_out[37:32] =     mux_out_w;

    // ---------------------------------
    // define wires for interconnections
    // ---------------------------------
    wire [5:0]  mux_out_w;
    wire [5:0]  temp_dac_w, temp0_dac_w, temp1_dac_w, temp2_dac_w, temp3_dac_w;
    wire [11:0] temp_tick_w, temp0_tick_w, temp1_tick_w, temp2_tick_w, temp3_tick_w;
    wire        temp0_done_w, temp1_done_w, temp2_done_w, temp3_done_w;
    wire [5:0]  adac_out_w;
    wire [15:0] reg0_w;
    wire [15:0] reg1_w;
    wire [15:0] reg2_w;
    wire [15:0] reg3_w;
    wire        dummy1_w;
    wire [1:0]  dummy2_w;
    wire [15:0] adc_result_w;
    wire        adc_done_w;

    // -----------------------------------------------------------
    // connect LA signals just in case to monitor internal signals
    // -----------------------------------------------------------
    assign la_data_out[63:0] = {reg3_w, reg2_w, reg1_w, reg0_w};
    assign la_data_out[75:64] = {temp0_dac_w, temp_dac_w};
    assign la_data_out[99:76] = {temp0_tick_w, temp_tick_w};
    assign la_data_out[103:100] = {temp3_done_w, temp2_done_w, temp1_done_w, temp0_done_w};
    assign la_data_out[109:104] = {adac_out_w};
    assign la_data_out[125:110] = {adc_result_w};
    assign la_data_out[126] = {adc_done_w};

    // ------------------------------------------------------
    // register file and output mux (since we are IO limited)
    // ------------------------------------------------------

    config_reg_mux cfg_reg0 (
    `ifdef USE_POWER_PINS
        .vccd1(vccd1),	// User area 1 1.8V power
        .vssd1(vssd1),	// User area 1 digital ground
    `endif

        .rst_n_i(reset_n_w),
        .reg_wr_i(config_wr_w),
        .reg_adr_i(config_adr_w),
        .reg_dat_i(data_in_w),
        .reg0_o(reg0_w), .reg1_o(reg1_w), .reg2_o(reg2_w), .reg3_o(reg3_w),
        .mux_adr_i(data_out_sel_w),
        .mux_o(mux_out_w),
        .mux0_i({reg0_w[15], adc_done_w, temp3_done_w, temp2_done_w, temp1_done_w, temp0_done_w}),
        .mux1_i(temp_dac_w),
        .mux2_i(temp_tick_w[5:0]),
        .mux3_i(temp_tick_w[11:6]),
        .mux4_i(adac_out_w),
        .mux5_i(adc_result_w[5:0]),
        .mux6_i(adc_result_w[11:6]),
        .mux7_i({reg0_w[14:13], adc_result_w[15:12]}),
        .temp_sel_i(reg0_w[8:7]),
        .temp0_dac_i(temp0_dac_w), .temp1_dac_i(temp1_dac_w), .temp2_dac_i(temp2_dac_w), .temp3_dac_i(temp3_dac_w),
        .temp_dac_o(temp_dac_w),
        .temp0_ticks_i(temp0_tick_w), .temp1_ticks_i(temp1_tick_w), .temp2_ticks_i(temp2_tick_w), .temp3_ticks_i(temp3_tick_w),
        .temp_ticks_o(temp_tick_w),

        .loopback_i(la_data_in[127]),
        .loopback_o(la_data_out[127])
    );

    // -----------------------------------------------------------------------
    // 4 instances of the temperature sensor (in each corner, because why not)
    // -----------------------------------------------------------------------

    tempsense temp0 (
    `ifdef USE_POWER_PINS
        .vccd1(vccd1),	// User area 1 1.8V power
        .vssd1(vssd1),	// User area 1 digital ground
    `endif

        .clk(clk_w),
        .rst_n(reset_n_w),
        .start_conv_in(trigger_in_w),
        .vdac_result_out(temp0_dac_w),
        .tick_result_out(temp0_tick_w),
        .conversion_finished_out(temp0_done_w)
    );
    tempsense temp1 (
    `ifdef USE_POWER_PINS
        .vccd1(vccd1),	// User area 1 1.8V power
        .vssd1(vssd1),	// User area 1 digital ground
    `endif

        .clk(clk_w),
        .rst_n(reset_n_w),
        .start_conv_in(trigger_in_w),
        .vdac_result_out(temp1_dac_w),
        .tick_result_out(temp1_tick_w),
        .conversion_finished_out(temp1_done_w)
    );
    tempsense temp2 (
    `ifdef USE_POWER_PINS
        .vccd1(vccd1),	// User area 1 1.8V power
        .vssd1(vssd1),	// User area 1 digital ground
    `endif

        .clk(clk_w),
        .rst_n(reset_n_w),
        .start_conv_in(trigger_in_w),
        .vdac_result_out(temp2_dac_w),
        .tick_result_out(temp2_tick_w),
        .conversion_finished_out(temp2_done_w)
    );
    tempsense temp3 (
    `ifdef USE_POWER_PINS
        .vccd1(vccd1),	// User area 1 1.8V power
        .vssd1(vssd1),	// User area 1 digital ground
    `endif

        .clk(clk_w),
        .rst_n(reset_n_w),
        .start_conv_in(trigger_in_w),
        .vdac_result_out(temp3_dac_w),
        .tick_result_out(temp3_tick_w),
        .conversion_finished_out(temp3_done_w)
    );

    // -----------------------------------------
    // the digital audio dac from an earlier mpw
    // -----------------------------------------

    audiodac adac0 (
    `ifdef USE_POWER_PINS
        .vccd1(vccd1),	// User area 1 1.8V power
        .vssd1(vssd1),	// User area 1 digital ground
    `endif

        .fifo_i(data_in_w),
        .fifo_rdy_i(trigger_in_w),
        .fifo_ack_o(adac_out_w[2]),
        .fifo_full_o(adac_out_w[3]),
        .fifo_empty_o(adac_out_w[4]),
        .rst_n_i(reset_n_w),
        .clk_i(clk_w),
        .mode_i(reg0_w[0]),
        .volume_i(reg0_w[4:1]),
        .osr_i(reg0_w[6:5]),
        .ds_o(adac_out_w[0]),
        .ds_n_o(adac_out_w[1]),
        .tst_fifo_loop_i(reg1_w[0]),
        .tst_sinegen_en_i(reg1_w[1]),
        .tst_sinegen_step_i(reg1_w[7:2])
    );

    // ---------------------------------------------------------
    // the new sar adc for testing functionality and performance
    // ---------------------------------------------------------

    adc_top adc0 (
    `ifdef USE_POWER_PINS
        .VDD(vccd2),    // User area 2 1.8v supply
        .VSS(vssd2),	// User area 2 digital ground
    `endif

        .clk_vcm(clk_w),
        .rst_n(reset_n_w),
        .inp_analog(adc_analog_in_p),
        .inn_analog(adc_analog_in_n),
        .start_conversion_in(trigger_in_w),
        .config_1_in(reg2_w),
        .config_2_in(reg3_w),
        .result_out(adc_result_w),
        .conversion_finished_out(adc_done_w)
    );

endmodule	// user_project_wrapper

`default_nettype wire
