/*
 * IIC_FIFO -- Configurable FIFO based on ring-buffer
 *
 * (c) 2021-2022 Harald Pretl (harald.pretl@jku.at)
 * Johannes Kepler University Linz, Institute for Integrated Circuits
 *
 * Parameters:
 *		WIDTH 				... input data bitwidth (default 16b)
 *		FIFO_SIZE			... depth of FIFO (in power of 2; default 5 = 32 entries)
 *		FIFO_ASYNC			... if set to 1, FIFO input is treated asynchronous;
 *								if set to 0, FIFO input is treated as synchronous
 *
 * Ports:
 *		fifo_indata_i		... input data
 *		fifo_indata_rdy_i	... indicates that data is ready from source
 *		fifo_indata_ack_o	... signales to source that datum has been taken into FIFO
 *
 *		fifo_full_o			... indicates a full FIFO, no further datum will be
 *								acknowledged into FIFO
 *		fifo_empty_o		... indicates an empty FIFO, if datum is read from an empty
 *								FIFO then the last datum will be output
 *
 *		fifo_outdata_o		... output data
 *		fifo_outdata_rd_o	... the next output datum is selected (if FIFO is not empty)
 *
 *		rst_n_i				... reset (low active)
 *		clk_i				... clock of FIFO
 *
 *		tst_fifo_loop_i		... enables a test mode where the data in the FIFO is looped
 *								at the output
 */

`default_nettype none
`ifndef __IIC_FIFO__
`define __IIC_FIFO__

module iic_fifo
#(
	parameter WIDTH=16, FIFO_SIZE=5, FIFO_ASYNC=1
) (
	// 0=sync, 1=async write I/F

	input		[WIDTH-1:0]	fifo_indata_i,
	input					fifo_indata_rdy_i,
	// note that fifo_indata_i and fifo_indata_rdy_i could originate from 
	// an asynchronous clk domain, so potentially needs to be synchronized
	// use FIFO_ASYNC=1 to select the proper behaviour
	output reg				fifo_indata_ack_o,
	output wire				fifo_full_o,
	output wire				fifo_empty_o,
	output wire	[WIDTH-1:0]	fifo_outdata_o,
	input					fifo_outdata_rd_i,
	input					rst_n_i,
	input					clk_i,
	input					tst_fifo_loop_i
);

	reg		[FIFO_SIZE-1:0]	read_ptr, write_ptr;
	wire	[FIFO_SIZE-1:0]	next_write;
	reg		[WIDTH-1:0]		fifo_store[0:(1<<FIFO_SIZE)-1];
	// needed for asynch. I/F synchronization (2 stages)
	reg						fifo_rdy_del1, fifo_rdy_del2;
	reg		[WIDTH-1:0]		fifo_data_del1, fifo_data_del2;
	wire					fifo_rdy;
	wire	[WIDTH-1:0]		fifo_data;

	assign fifo_full_o = (next_write == read_ptr);
	assign fifo_empty_o = (write_ptr == read_ptr);

	assign fifo_outdata_o = fifo_store[read_ptr];
	assign next_write = write_ptr + 1'b1;

	assign fifo_rdy = FIFO_ASYNC ? fifo_rdy_del2 : fifo_indata_rdy_i;
	assign fifo_data = FIFO_ASYNC ? fifo_data_del2 : fifo_indata_i;

	always @(posedge clk_i) begin
		if (!rst_n_i) begin
			// reset all registers
			fifo_indata_ack_o <= 1'b0;
			read_ptr <= {FIFO_SIZE{1'b0}};
			write_ptr <= {FIFO_SIZE{1'b0}};

			// only first FIFO input needs to be reset, we put in a midscale UINT
			fifo_store[0] <= {1'b1,{(WIDTH-1){1'b0}}};

			fifo_rdy_del1 <= 1'b0;
			fifo_rdy_del2 <= 1'b0;
			fifo_data_del1 <= {WIDTH{1'b0}};
			fifo_data_del2 <= {WIDTH{1'b0}};
		end else begin
			// use two stages to sync-in fifo_indata_rdy_i
			fifo_rdy_del2 <= fifo_rdy_del1;
			fifo_rdy_del1 <= fifo_indata_rdy_i;
			// use two stages to sync-in fifo_indata_i
			fifo_data_del2 <= fifo_data_del1;
			fifo_data_del1 <= fifo_indata_i;

			// manage the FIFO read process, if fifo_outdata_rd_i is asserted
			// the read pointer location is increased, as long as
			// the FIFO is not empty. note that there is an inherent
			// wrap-around due to truncation.
			
			if (fifo_outdata_rd_i && (!fifo_empty_o || tst_fifo_loop_i))
				read_ptr <= read_ptr + 1'b1;
		
			// manage the FIFO write process. if fifo_rdy is
			// asserted, and the FIFO is not full, the write
			// pointer is increased and the datum is written into
			// the FIFO. further the transfer is acknowledged
			
			if (fifo_rdy && !fifo_indata_ack_o && !fifo_full_o) begin
				write_ptr <= next_write;
				fifo_store[next_write] <= fifo_data;
				fifo_indata_ack_o <= 1'b1;
			end

			if (!fifo_rdy)
				fifo_indata_ack_o <= 1'b0;
		end
	end

endmodule // iic_fifo

`endif
`default_nettype wire
