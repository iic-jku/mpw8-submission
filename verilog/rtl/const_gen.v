/*
 * Provide constant ones and zeros as output
 *
 * SPDX-FileCopyrightText: 2022 Harald Pretl (harald.pretl@jku.at)
 * Johannes Kepler University Linz, Institute for Integrated Circuits
 *
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none
`timescale 10ns / 1ns
`ifndef __CONST_GEN__
`define __CONST_GEN__

module const_gen 
#( 
	parameter NO_HI=32, 
	parameter NO_LO=96
)(
`ifdef USE_POWER_PINS
    inout 				vccd1,	// User area 1 1.8V supply
    inout 				vssd1,	// User area 1 digital ground
`endif
	output wire [NO_HI-1:0]	tie_hi,
	output wire [NO_LO-1:0]	tie_lo
);

	assign tie_hi = {NO_HI{1'b1}};
	assign tie_lo = {NO_LO{1'b0}};

endmodule // const_gen

`endif
`default_nettype wire
