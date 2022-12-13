/*
 * AUDIOAC_DSMOD -- Delta-Sigma Modulator (1st/2nd Order) with Single-Bit Output
 *
 * SPDX-FileCopyrightText: 2021-2022 Harald Pretl (harald.pretl@jku.at)
 * Johannes Kepler University Linz, Institute for Integrated Circuits
 *
 * Parameters:
 *		BW 				... input data bitwidth
 *
 * Ports:
 *		data_i			... input data (must be UINT, default 16b)
 *		data_rd_o		... fetch next input data word (data feed-in driven 
 *							by DS-modulator)
 *		ds_o, ds_n_o	... output bitstream (complimentary outputs)
 *
 *		rst_n_i			... reset (low active)
 *		clk_i			... clock of ds-modulator (must be OSR * input_data_rate),
 *							output bitstream rate = OSR * input_data_rate
 *
 *		mode_i			... select order of modulator (0 = 1st, 1 = 2nd)
 *		scale_i			... scaling (attenuation) of input data in -6dB steps
 *							(0 = 0dB, 1 = -6dB, 2 = -12dB, ..., 15 = off)
 *		osr_i			... oversampling ratio (OSR), 0=32/1=64/2=128/3=256 is supported
 *
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none
`ifndef __AUDIODAC_DSMOD__
`define __AUDIODAC_DSMOD__

module audiodac_dsmod
#(
	parameter BW = 16
) (
	input 		[BW-1:0]	data_i,
	output wire				data_rd_o,
	output reg				ds_o,
	output wire				ds_n_o,
	
	input					rst_n_i,
	input					clk_i,
	
	input					mode_i,
	input 		[3:0]		scale_i,		// 0 = off, 15 = max scale
	input		[1:0]		osr_i			// 0 = 32; 1 = 64, 2 = 128, 3 = 256
);

	reg 		[BW-1:0]	accu1;
	reg			[BW-1:0]	accu2;
	reg			[1:0]		accu3;
	wire 		[BW-1:0]	data_scaled;	// input data treated with scaling
	wire signed [BW-1:0]	data_calc;		// 1b more is needed here
	reg			[7:0]		fetch_ctr;		// clock divideid by osr

	reg			[1:0]		mod2_ctr;		// clk divide by 4 for 1st stage of 2nd order mod
	reg			[1:0]		mod2_out;		// output 1st stage

	localparam	[7:0]		CTR_OSR_32  	=  8'd31;
	localparam	[7:0]		CTR_OSR_64  	=  8'd63;
	localparam	[7:0]		CTR_OSR_128 	=  8'd127;
	localparam	[7:0]		CTR_OSR_256 	=  8'd255;
	localparam	[1:0]		OSR_32  		= 2'd0;
	localparam	[1:0]		OSR_64  		= 2'd1;
	localparam	[1:0]		OSR_128 		= 2'd2;
	localparam	[1:0]		OSR_256 		= 2'd3;
	localparam				MODE_ORD1 		= 1'd0;
	localparam				MODE_ORD2 		= 1'd1;
	localparam	[3:0]		SCALE_OFF		= 4'd15;
	localparam	[3:0]		SCALE_MAX		= 4'd0;
	localparam	[BW-1:0]	DATA_MID		= {1'b1,{(BW-1){1'b0}}};

	// provide out and out_n
  	assign ds_n_o = ~ds_o;

	// we provide scaling in 6dB steps, 0=min (off), 15=max (unchanged)
	// scaling is a bit tricky as we have UINT coming in, so we do the scaling in signed INT
	// so that we stay around the midscale at 0x8000 when the amplitude is reduced
	assign data_calc = (($signed(data_i) - $signed(DATA_MID)) >>> scale_i)
						+ $signed(DATA_MID);

	assign data_scaled = (scale_i == SCALE_OFF) ? DATA_MID : 
							(scale_i == SCALE_MAX) ? data_i : 
								$unsigned(data_calc[BW-1:0]);

	// the fetch counter controls the read of the next sample from the FIFO
	// the counter runs down so decoding is easier for different counter
	// cycles (reloads at 0)
	assign data_rd_o = (fetch_ctr == 8'd0);

  	always @(posedge clk_i) begin
		if (!rst_n_i) begin
			// reset all registers
			accu1 <= {BW{1'b0}};
			accu2 <= {BW{1'b0}};
			accu3 <=  2'b0;
			ds_o <= 1'b0;
			fetch_ctr <= 8'b0;
			mod2_ctr <= 2'b0;
			mod2_out <= 2'b0;
		end else begin
			// sd-modulator is running

			if (fetch_ctr == 8'd0) begin
			// fetch_ctr finished, restart with proper cycle count
			// depending on osr
				case (osr_i)
					OSR_32:		fetch_ctr <= CTR_OSR_32;
					OSR_64:		fetch_ctr <= CTR_OSR_64;
					OSR_128:	fetch_ctr <= CTR_OSR_128;
					OSR_256:	fetch_ctr <= CTR_OSR_256;
					default:	fetch_ctr <= 8'bx;
				endcase
			end else
				//just keep counting down
				fetch_ctr <= fetch_ctr - 1'b1;
		
			if (mode_i == MODE_ORD1) begin
				// delta-sigma modulator 1st order
				// this simple structure works if everything
				// is UINT
				{ds_o,accu1} <= data_scaled + accu1;
			
			end else if (mode_i == MODE_ORD2) begin
				// delta-sigma modulator 2nd order
				// the first stage runs on clk/4, the second
				// stage runs on clk

				if (mod2_ctr == 2'b0) begin
					// this only happens every 4th clk
					// cycle
					{mod2_out,accu1} <= {2'b00,data_scaled} 
								+ {1'b0,accu1,1'b0} 
								+ {2'b01,{BW{1'b0}}}
								- {2'b0,accu2};
					accu2 <= accu1;
				end

				// this is the clk divider for the 1st stage
				mod2_ctr <= mod2_ctr + 1'b1;
				
				// this simple structure is the 2nd stage
				// running on clk
				{ds_o,accu3} <= mod2_out + accu3;
			end
		end
	end
endmodule // audiodac_dsmod

`endif
`default_nettype wire
