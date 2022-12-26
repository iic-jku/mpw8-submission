/*
 * Configuration register (4x 16b) and output mux
 *
 * SPDX-FileCopyrightText: 2022 Harald Pretl (harald.pretl@jku.at)
 * Johannes Kepler University Linz, Institute for Integrated Circuits
 *
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none
`timescale 10ns / 1ns
`ifndef __CONFIG_REG_MUX__
`define __CONFIG_REG_MUX__

module config_reg_mux (
`ifdef USE_POWER_PINS
    inout 				vccd1,	// User area 1 1.8V supply
    inout 				vssd1,	// User area 1 digital ground
`endif
	input				rst_n_i,

	input				reg_wr_i,
	input [1:0]			reg_adr_i,
	input [15:0]		reg_dat_i,
	output reg [15:0]	reg0_o,
	output reg [15:0]	reg1_o,
	output reg [15:0]	reg2_o,
	output reg [15:0]	reg3_o,
	
	input [2:0]			mux_adr_i,
	input [5:0]			mux0_i,
	input [5:0]			mux1_i,
	input [5:0]			mux2_i,
	input [5:0]			mux3_i,
	input [5:0]			mux4_i,
	input [5:0]			mux5_i,
	input [5:0]			mux6_i,
	input [5:0]			mux7_i,
	output wire [5:0]	mux_o,
	
	input [1:0]			temp_sel_i,
	input [5:0]			temp0_dac_i,
	input [5:0]			temp1_dac_i,
	input [5:0]			temp2_dac_i,
	input [5:0]			temp3_dac_i,
	output wire [5:0]	temp_dac_o,
	input [11:0]		temp0_ticks_i,
	input [11:0]		temp1_ticks_i,
	input [11:0]		temp2_ticks_i,
	input [11:0]		temp3_ticks_i,
	output wire [11:0]	temp_ticks_o,

	input				loopback_i,
	output wire			loopback_o
);

	assign loopback_o = loopback_i;

	always @(posedge reg_wr_i or negedge rst_n_i) begin
		if (rst_n_i == 1'b0) begin
			reg0_o <= 16'b0;
			reg1_o <= 16'b0;
			reg2_o <= 16'b0;
			reg3_o <= 16'b0;
		end else begin
			case (reg_adr_i)
				2'd0: reg0_o <= reg_dat_i;
				2'd1: reg1_o <= reg_dat_i;
				2'd2: reg2_o <= reg_dat_i;
				2'd3: reg3_o <= reg_dat_i;
			endcase
		end
	end

	assign mux_o =	(mux_adr_i==3'd0) ? mux0_i :
					(mux_adr_i==3'd1) ? mux1_i :
					(mux_adr_i==3'd2) ? mux2_i :
					(mux_adr_i==3'd3) ? mux3_i :
					(mux_adr_i==3'd4) ? mux4_i :
					(mux_adr_i==3'd5) ? mux5_i :
					(mux_adr_i==3'd6) ? mux6_i :
					(mux_adr_i==3'd7) ? mux7_i :
					6'b0;

	assign temp_dac_o =	(temp_sel_i==2'd0) ? temp0_dac_i :
						(temp_sel_i==2'd1) ? temp1_dac_i :
						(temp_sel_i==2'd2) ? temp2_dac_i :
						(temp_sel_i==2'd3) ? temp3_dac_i :
						6'b0;

	assign temp_ticks_o =	(temp_sel_i==2'd0) ? temp0_ticks_i :
							(temp_sel_i==2'd1) ? temp1_ticks_i :
							(temp_sel_i==2'd2) ? temp2_ticks_i :
							(temp_sel_i==2'd3) ? temp3_ticks_i :
							12'b0;

endmodule // config_reg_mux

`endif
`default_nettype wire
