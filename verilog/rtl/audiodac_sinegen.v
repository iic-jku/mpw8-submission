/*
 * AUDIOAC_SINEGEN -- Simple Sine Generator based on a harcoded 16b LUT
 *
 * (c) 2021-2022 Harald Pretl and Jakob Ratschenberger (harald.pretl@jku.at)
 * Johannes Kepler University Linz, Institute for Integrated Circuits
 *
 * Parameters:
 *		BW 					...	bitwith of the output data
 *		LUT_SIZE			... defines the size of the look-up-table.
 *								The actual size is 2**LUT_SIZE
 *		SINE_AMPL 			... percentage of the maximum amplitude. The actual 
 *								maximum amplitude is about 2**(BW-1)*SINE_AMPL.
 * Ports:
 *		data_o				... output data of sine generator (BW)
 *		data_rd_i			... advances the generator to the next output value,
 *								controlled by the step size
 *
 *		rst_n_i				... reset (low active)
 *		clk_i				... clock of sine generator (pos. edge)
 *
 *		tst_sinegen_en_i	... enables the sine generator; when disabled then 0 is
 *								output, and the generator is turned off
 *		tst_sinegen_step_i	... controls the step size per read (1 = use every ROM
 *								value, 2 = use every 2nd ROM entry, etc); the higher the
 *								step value, the faster the output sine
 */

`default_nettype none
`ifndef __AUDIODAC_SINEGEN__
`define __AUDIODAC_SINEGEN__

module audiodac_sinegen 
# (
	parameter BW = 16,
	parameter LUT_SIZE = 6,
	parameter SINE_AMPL = 0.9
) (
	output wire	signed [BW-1:0]			data_o,
	input								data_rd_i,
	input								rst_n_i,
	input								clk_i,

	input								tst_sinegen_en_i,
	input				[LUT_SIZE-2:0]	tst_sinegen_step_i
);
	
	/*
	 *	Function to calculate a single sine-value.
	 *		Input: 	Sine-angle in degrees (integer value)
	 *		Output: Sine value (signed bitvector)
	 */
	
	function signed [BW-1:0] calc_sine_value;
		input integer angle; //in degrees
		/* verilator lint_off UNUSED */	
		integer temp;
		/* verilator lint_on UNUSED */
		begin
			temp = $rtoi(SINE_AMPL*$itor(2**(BW-1)-1)*$sin($itor(angle)*3.1415926/180.0));
			calc_sine_value = temp[BW-1:0];
		end
	endfunction
	
	/*
	 *	Function to generate the LUT
	 */
	
	/* verilator lint_off LITENDIAN */
	function [0:(BW*(2**LUT_SIZE)-1)] calc_sine_values;
		/* verilator lint_off UNUSED */
		input dummy; //dummy input, since a function needs at least one input
		/* verilator lint_on UNUSED */
		integer i;
		begin
			for( i=0; i<2**LUT_SIZE; i=i+1)
				calc_sine_values[i*BW+:BW] = calc_sine_value($rtoi(360.0/$itor(2**LUT_SIZE)*$itor(i)));
		end
	endfunction
	/* verilator lint_on LITENDIAN */
	
	reg	[LUT_SIZE-1:0] read_ptr, next_read_ptr; //pointer for the LUT
	
	// Generate the LUT table as an flattend array
	/* verilator lint_off LITENDIAN */
	wire [0:(BW*(2**LUT_SIZE)-1)] SINE_CONST = calc_sine_values(0);
	/* verilator lint_on LITENDIAN */
	
	//Set the output data
	assign data_o = tst_sinegen_en_i ? SINE_CONST[read_ptr*BW +:BW] : 0;

	// Register process
	always @(posedge clk_i) begin
		if (!rst_n_i) begin
			// reset all registers
			read_ptr <= 0;
		end else begin
			read_ptr <= next_read_ptr;
		end
	end
	
	// Combinatorial process
	always @(*) begin
		next_read_ptr = (tst_sinegen_en_i && data_rd_i) ?
							(read_ptr + {1'b0,tst_sinegen_step_i}) : 	
							read_ptr;
	end

endmodule // audiodac_sinegen

`endif
`default_nettype wire
