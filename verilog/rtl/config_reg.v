/*
 * Configuration register (2x 16b)
 *
 * (c) 2022 Harald Pretl (harald.pretl@jku.at)
 * Johannes Kepler University Linz, Institute for Integrated Circuits
 *
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none
`ifndef __CONFIG_REG__
`define __CONFIG_REG__

module config_reg (
`ifdef USE_POWER_PINS
    inout 				vccd1,	// User area 1 1.8V supply
    inout 				vssd1,	// User area 1 digital ground
`endif
	input				rst_n_i,
	input				clk_i,
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
	output wire [5:0]	mux_o
);

	always @(posedge clk_i) begin
		if (!rst_n_i) begin
			reg0_o <= 16'b0;
			reg1_o <= 16'b0;
			reg2_o <= 16'b0;
			reg3_o <= 16'b0;
		end else begin
			if (reg_wr_i) begin
				case (reg_adr_i)
					2'd0: reg0_o <= reg_dat_i;
					2'd1: reg1_o <= reg_dat_i;
					2'd2: reg2_o <= reg_dat_i;
					2'd3: reg3_o <= reg_dat_i;
				endcase
			end
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

endmodule // config_reg

`endif
`default_nettype wire
