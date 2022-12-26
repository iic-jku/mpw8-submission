// SPDX-FileCopyrightText: 2022 Harald Pretl
// Johannes Kepler University Linz, Institute for Integrated Circuits
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
`timescale 1 ns / 1 ps
`define SIM
`include "user_project_wrapper.v"
`include "/foss/pdks/sky130A/libs.ref/sky130_fd_sc_hd/verilog/sky130_fd_sc_hd.v"
`include "/foss/pdks/sky130A/libs.ref/sky130_fd_sc_hd/verilog/primitives.v"

module wrapper_tb;

	wire [37:0] IN;
	wire [37:0] OUT;
	wire [28:0] ANA_IO;

	reg RESET_N;
	reg CLK;
	reg [15:0] DATA_IN;
	reg [2:0] SEL;
	reg CFG_WRITE;
	reg [1:0] CFG_ADR;
	reg TRIG;
	reg [1:0] ADC_IN;

	assign IN[5] = RESET_N;
	assign IN[6] = CLK;
	assign IN[22:7] = DATA_IN;
	assign IN[25:23] = SEL;
	assign IN[26] = CFG_WRITE;
	assign IN[28:27] = CFG_ADR;
	assign IN[29] = TRIG;
	assign ANA_IO[24:23] = ADC_IN;
	wire [5:0] MUX_OUT = OUT[37:32];

	integer i;

	user_project_wrapper dut (
		.io_in(IN),
		.io_out(OUT),
		.analog_io(ANA_IO)
	);

	initial begin
		$dumpfile("wrapper_tb.vcd");
		$dumpvars;

			i = 0;
			RESET_N = 0;
			CLK = 0;
			CFG_WRITE = 0;
		#1 	CLK = 1;
		#1 	CLK = 0;
			RESET_N = 1;

		#1 	DATA_IN = 16'h1234;
			CFG_ADR = 0;
		#1	CFG_WRITE = 1;
		#1	CFG_WRITE = 0;

		#1 	DATA_IN = 16'h5678;
			CFG_ADR = 1;
		#1	CFG_WRITE = 1;
		#1	CFG_WRITE = 0;

		#1 	DATA_IN = 16'b0000110000000000;
			CFG_ADR = 2;
		#1	CFG_WRITE = 1;
		#1	CFG_WRITE = 0;
		
		#1 	DATA_IN = 16'b1000010000100001;
			CFG_ADR = 3;
		#1	CFG_WRITE = 1;
		#1	CFG_WRITE = 0;

			ADC_IN = 1;

		#1	TRIG = 1;
		#1	TRIG = 0;

		#50	SEL = 5;
		#1	SEL = 6;
		#2	SEL = 7;

		// set MUX=4 to monitor DAC status
		#1	SEL = 4;

		repeat (200)  begin
				i = i + 1;
				DATA_IN = i;
			#1	TRIG = 1;
			repeat (3) begin
				#1	CLK = 1;
				#1	CLK = 0;
			end
			#1	TRIG = 0;
			#1	CLK = 1;
			#1	CLK = 0;

		end

		#10	$finish;

	end

endmodule
`default_nettype wire
