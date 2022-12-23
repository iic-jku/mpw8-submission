/*
 * IIC_DSMOD TESTBENCH
 *
 * (c) 2021-2022 Harald Pretl (harald.pretl@jku.at)
 * Johannes Kepler University Linz, Institute for Integrated Circuits
 *
 * This is the testbench for iic_dsmod.v
 */

`timescale 1ns / 1ns

`include "adc_top.v"

module adc_top_tb;

	// inputs
	reg 			RESET_N = 1'bx;
	reg [1:0]		INPUT = 1'bx;
	reg				START = 1'bx;
	reg [15:0]		CONFIG1 = 16'b0000010000000000;
	reg [15:0]		CONFIG2 = 16'b1000010000100001;

	// outputs
	wire [15:0]		DATA;
	wire			DONE;

	wire [15:0]		DUMMY;

	// instantiate DUT
	adc_top adc(
		.clk_vcm(1'b0),
		.rst_n(RESET_N),
		.inp_analog(INPUT[1]),
		.inn_analog(INPUT[0]),
		.start_conversion_in(START),
		.config_1_in(CONFIG1),
		.config_2_in(CONFIG2),
		.result_out(DATA),
		.conversion_finished_out(DONE),
		.dummypin(DUMMY)
	);
	
	// here is all the initilization work for the simulation
	initial begin
		// dump signals into VCD for debug
		$dumpfile("adc_top_tb.vcd");
		$dumpvars;

		// de-assert reset
		#5 		RESET_N = 1'b0;
		#5 		RESET_N = 1'b1;

		// state1
		#100	INPUT = 2'b00;
		#1 		START = 1'b1;
		#2 		START = 1'b0;
		// state2
		#100	INPUT = 2'b01;
		#1 		START = 1'b1;
		#2 		START = 1'b0;	
		// state3
		#100	INPUT = 2'b10;
		#1 		START = 1'b1;
		#2 		START = 1'b0;	
		// state4
		#100	INPUT = 2'b11;
		#1 		START = 1'b1;
		#2 		START = 1'b0;	

		// stop simulation
		#100 	$finish;
	end

endmodule // adc_top_tb
