/*
 * AUDIODAC -- 16b Delta-Sigma Modulator with Single-Bit Output
 *
 * (c) 2021-2022 Harald Pretl (harald.pretl@jku.at)
 * Johannes Kepler University Linz, Institute for Integrated Circuits
 *
 * This delta-sigma modulator includes an input-side FIFO for easy connection
 * to a host system, volume control in 6dB steps, and configurable OSR
 * (32/64/128/256). The modulator can be configured to first or second order.
 *
 * The clock for the modulator is required to be clk = audio_sample_rate * OSR
 * e.g. for 44.1kHz and OSR=128 then clk=5.6448MHz
 *
 * The audio input data (fifo_i) must be 16b signed INT!
 *
 * In order to write into the FIFO:
 *   (1) assert the data at fifo_i[15:0] (with fifo_rdy_i=0)
 * 	 (2) signal that data is ready with a transition of fifo_rdy_i=0->1
 * 	 (3) wait that data is accepted by waiting for the transition fifo_ack_o=0->1
 * 	 (4) de-assert fifo_rdy_i=1->0 (this is followed by fifo_ack_o=1->0)
 *
 * Data is only accepted if the FIFO is not full (fifo_full_o=0). Using fifo_full_o
 * and fifo_empty_o an interrupt service routine (ISR) can be constructed:
 * 	 (1) fifo_empty_o=0->1 triggers the ISR
 * 	 (2) the ISR writes data into the FIFO until it is full (fifo_full_o=0->1)
 * 	 (3) exit the ISR
 * 
 * Ideas for future extension:
 * 	 (1) Implement a higher-order (e.g. 5th order) modulator.
 *	 (2) Potentially substitute register-based FIFO by a dual-port RAM.
 */

`default_nettype none
`ifndef __AUDIODAC__
`define __AUDIODAC__

`ifdef SIM_PYTHON
	`include "../dig/rtl/audiodac_dsmod.v"
	`include "../dig/rtl/audiodac_fifo.v"
	`include "../dig/rtl/audiodac_sinegen.v"
 `else 
	`include "audiodac_dsmod.v"
	`include "audiodac_fifo.v"
	`include "audiodac_sinegen.v"
`endif

module audiodac (
`ifdef USE_POWER_PINS
    inout 				vccd1,	// User area 1 1.8V supply
    inout 				vssd1,	// User area 1 digital ground
`endif

	// FIFO interface
	input		[15:0]	fifo_i,		// data is signed INT
	input				fifo_rdy_i,
	output wire			fifo_ack_o,
	output wire			fifo_full_o,
	output wire			fifo_empty_o,
	// housekeeping
	input				rst_n_i,
	input				clk_i,
	// configuration bits
	input				mode_i, 	// 0 = 1st, 1 = 2nd order SD-mod
	input 		[3:0]	volume_i,	// 0 = off, 1 = min volume, 15 = max volume
	input		[1:0]	osr_i, 		// 0 = 32; 1 = 64, 2 = 128, 3 = 256
	// DS-modulator outputs
	output wire			ds_o,		// single-bit SD-modulator output
	output wire			ds_n_o,		//  plus the complementary output
	// test modes
	input				tst_fifo_loop_i,
	input				tst_sinegen_en_i,
	input		[5:0]	tst_sinegen_step_i
);
	
	// parameters for sine generator and FIFO
	parameter SINE_GENERATOR_AMPL = 0.5;
	parameter SINE_GENERATOR_LUT_SIZE = 7;
	parameter FIFO_SIZE = 7;
	
	wire		[15:0]	dsmod_data_i, audio, audio_fifo, audio_sinegen;
	wire				audio_rd;
	assign				audio = tst_sinegen_en_i ? audio_sinegen : audio_fifo; 
	// change 16-bit signed audio data to unsigned data
	assign				dsmod_data_i = audio + {1'b1,{15{1'b0}}};
	
	audiodac_fifo
		#(16, FIFO_SIZE, 1)
		fifo0 (
			.fifo_indata_i(fifo_i),
			.fifo_indata_rdy_i(fifo_rdy_i),
			.fifo_indata_ack_o(fifo_ack_o),
			.fifo_full_o(fifo_full_o),
			.fifo_empty_o(fifo_empty_o),
			.fifo_outdata_o(audio_fifo),
			.fifo_outdata_rd_i(audio_rd),
			.rst_n_i(rst_n_i),
			.clk_i(clk_i),
			.tst_fifo_loop_i(tst_fifo_loop_i)
		);

	audiodac_dsmod
		dsmod0 (	
			.data_i(dsmod_data_i),
			.data_rd_o(audio_rd),
			.ds_o(ds_o),
			.ds_n_o(ds_n_o),
			.rst_n_i(rst_n_i),
			.clk_i(clk_i),
			.mode_i(mode_i),
			.scale_i(volume_i),
			.osr_i(osr_i)
		);

	audiodac_sinegen
		// this module uses parameters, if your implementation does not use params
		// then delete the following line:
		#(16, SINE_GENERATOR_LUT_SIZE, SINE_GENERATOR_AMPL)
		sinegen0 (
			.data_o(audio_sinegen),
			.data_rd_i(audio_rd),
			.rst_n_i(rst_n_i),
			.clk_i(clk_i),
			.tst_sinegen_en_i(tst_sinegen_en_i),
			.tst_sinegen_step_i(tst_sinegen_step_i)
		);

endmodule // audiodac

`endif
`default_nettype wire
