//  Copyright 2022 Manuel Moser and Harald Pretl
//  Institute for Integrated Circuits, Johannes Kepler University, Linz
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.
`default_nettype none
`timescale 1ns / 1ns

//***************************************
// Note: use RSZ_DONT_TOUCH_RX
// Reason -> no buffers on analog input nets
//***************************************

`ifndef __ADC_TOP__
`define __ADC_TOP__

//Top module ADC Control
module adc_top(
   `ifdef USE_POWER_PINS
      inout VDD,	// User area 1.8V supply
      inout VSS,	// User area ground
   `endif
   input wire clk_vcm, // 32.768Hz VCM generation clock
   input wire rst_n,   // reset
   input wire inp_analog,     // P differential input
   input wire inn_analog,     // N differential input
   input wire start_conversion_in,   
   input wire [15:0] config_1_in,    
   input wire [15:0] config_2_in,    
   output reg [15:0] result_out,    
   output reg conversion_finished_out ,
   output reg [15:0] dummypin
   );

   wire [1:0] adc_in = {inp_analog, inn_analog};
   wire [15:0] adc_result =   (adc_in == 2'b00) ? 16'h1122 :
                              (adc_in == 2'b01) ? 16'h3344 :
                              (adc_in == 2'b10) ? 16'h5566 :
                              (adc_in == 2'b11) ? 16'h7788 :
                              16'bx;

   wire [2:0] osr = config_1_in[5:3];
   wire [4:0] delay_edge = config_1_in[15:10];
   wire [4:0] delay1 = config_2_in[4:0];
   wire [4:0] delay2 = config_2_in[9:5];
   wire [4:0] delay3 = config_2_in[14:10];
   wire delay_en = config_2_in[15];

   integer osr_val = 1;

   integer osr_ctr = 0;

   initial begin
      result_out <= 16'bx;
      conversion_finished_out <= 1'bx;
      dummypin <= 16'b0;
   end

   always @(*) begin
      case (osr)
         3'b000: osr_val =   1;
         3'b001: osr_val =   4;
         3'b010: osr_val =  16;
         3'b011: osr_val =  64;
         3'b100: osr_val = 256;
         default: $error("[ADC] illegal OSR setting");
      endcase
   end

   always @(*) begin
      if (delay1 != delay2) $error("[ADC] unequal delay setting");
      if (delay1 != delay3) $error("[ADC] unequal delay setting");
      if (delay2 != delay3) $error("[ADC] unequal delay setting");
      if (delay_en != 1'b1) $error("[ADC] wrong delay_enable setting");
   end

   always @(negedge rst_n) begin
      result_out <= 16'b0;
      conversion_finished_out <= 1'b0;
   end

   always @(posedge start_conversion_in) begin
      #1 conversion_finished_out <= 1'b0;
     
      osr_ctr = osr_ctr + 1;

      if (osr_ctr == osr_val) begin
         osr_ctr = 0;

         case (delay1)
            5'd01: result_out <= #030 adc_result;
            5'd02: result_out <= #060 adc_result;
            5'd04: result_out <= #120 adc_result;
            5'd08: result_out <= #240 adc_result;
            5'd16: result_out <= #480 adc_result;
            default: $error("[ADC] delay setting not supported in model");
         endcase 
      
         case (delay1)
            5'd01: conversion_finished_out <= #030 1'b1;
            5'd02: conversion_finished_out <= #060 1'b1;
            5'd04: conversion_finished_out <= #120 1'b1;
            5'd08: conversion_finished_out <= #240 1'b1;
            5'd16: conversion_finished_out <= #480 1'b1;
            default: $error("[ADC] delay setting not supported in model");
         endcase  
      end
   end

endmodule // adc_top

`endif

`default_nettype wire
