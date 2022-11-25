/*
* SPDX-FileCopyrightText: 2022 Manuel Moser, Michael Herber, Harald Pretl
* Johannes Kepler University, Institute for Integrated Circuits
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*      http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
* SPDX-License-Identifier: Apache-2.0
*
* clk=10MHz SAR-Algorithm for Digitally Controlled Delay Cell (DCDC) temperature sensor.
* Computes the Digital-Analog-Converter (DAC) code where the Delay-cell creates a delay of 
* 1024 clk-cycles, which is a vague information about temperature.
* The detailed temperature-information is confined in the residual time-difference of
* the trigger-signal to 1024 clk-cycles, which is determined in a timespan of 2048 clk-cycles.
*  
* State machine:
*   State 1: Wait for start-trigger
*   State 2: Charge DCDC cell to max. output
*   State 3: Starve DCDC cell (set the lower DAC voltage).
*            Go to state 4 if the DAC code is not determined yet, or go to state 5.
*   State 4: Check if the current delay is less or greater 512 cycles, update DAC code depending on the result.
*            Return to state 2.
*   State 5: Measure the residual delay-time of the DCDC cell for additional temperature information. 
*/

`default_nettype none
`ifndef __TEMPSENSE_SAR_CTRL__
`define __TEMPSENSE_SAR_CTRL__

module tempsense_sar_ctrl #(parameter DAC_RESOLUTION = 6,
                            parameter COUNTER_BITWIDTH = 12) (
   // control
   input wire clk, 
   input wire rst_n,
   input wire start_conv_in,
   // results
   output reg [DAC_RESOLUTION-1:0]  dac_result_out,
   output reg [COUNTER_BITWIDTH-1:0] ticks_out,
   output reg conv_finished_out,
   //vdac interface
   output wire [DAC_RESOLUTION-1:0] vdac_data_out,
   output wire vdac_enable_out,
   // dcdc interface
   output wire dcdc_dat_out,
   input wire time_trigd_n_in
   );

   // to output
   wire [5:0] next_dac_result_w;
   wire       next_conv_finished_w;
   
   // DAC code handling
   reg  [DAC_RESOLUTION-1:0] dac_value_r;
   wire [DAC_RESOLUTION-1:0] next_dac_value_w;
   reg  [COUNTER_BITWIDTH-1:0] counter_r;
   wire [COUNTER_BITWIDTH-1:0] next_counter_w;
   reg  [COUNTER_BITWIDTH-1:0] ticks_r;
   wire [COUNTER_BITWIDTH-1:0] next_ticks_w;
   wire [COUNTER_BITWIDTH-1:0] next_ticks_out_w;
   reg  [DAC_RESOLUTION-1:0] current_dac_bit_r;
   wire [DAC_RESOLUTION-1:0] next_dac_bit_w;

   wire time_trigd_w = ~time_trigd_n_in;

   // State machine
   reg  [2:0] state_r;
   wire [2:0] next_state_w;
   localparam [2:0] 
    waitstate    = 3'b000,  // everything disabled
    charge_dcdc  = 3'b001,  // DCDC gets precharged (VDAC set to VDD, tri-inverter input set to 0, output thus to VDD)
    starve_dcdc  = 3'b010,  // transition into starved discharge mode (VDAC set to lower voltage, tri-inverter input unchanged)
    compare  = 3'b011,      // current-starved discharge, find SAR code (VDAC kept at lower voltage, tri-inverter input set to 1, thus output pulling to VSS)
    count_delay  = 3'b100;  // current-starved discharge, measure residual delay (VDAC kept at lower voltage, tri-inverter input set to 1, thus output pulling to VSS)

   //******************************************
   //   Synchronous process and Reset Handling
   //******************************************
   always @(posedge clk, negedge rst_n) begin
      if (rst_n == 1'b0) begin  
         dac_result_out        <= {DAC_RESOLUTION{1'b0}};
         dac_value_r           <= {DAC_RESOLUTION{1'b0}};
         conv_finished_out     <= 1'b0;
         counter_r             <= {{(COUNTER_BITWIDTH-1){1'b0}},1'b1};
         state_r               <= waitstate;
         current_dac_bit_r     <= {1'b1,{(DAC_RESOLUTION-1){1'b0}}};
         ticks_r               <= {COUNTER_BITWIDTH{1'b0}};
         ticks_out             <= {COUNTER_BITWIDTH{1'b0}};
      end 
      else begin	
         dac_result_out        <= next_dac_result_w;
         dac_value_r           <= next_dac_value_w;
         conv_finished_out     <= next_conv_finished_w;
         counter_r             <= next_counter_w;
         state_r               <= next_state_w;
         current_dac_bit_r     <= next_dac_bit_w;
         ticks_r               <= next_ticks_w;
         ticks_out             <= next_ticks_out_w;
      end
   end 

   //******************************************
   //   Combinatoric process handling
   //******************************************
   wire is_conversion_starting_w = (state_r == waitstate) & start_conv_in;
   wire compare_end_w = counter_r[COUNTER_BITWIDTH-4] == 1; // count-goal is 256
   wire count_ticks_end_w = (~counter_r) == {COUNTER_BITWIDTH{1'b0}};  // count residual until 4095
   wire is_last_bit_w    = current_dac_bit_r == {{(DAC_RESOLUTION-1){1'b0}},1'b1};
   wire is_returning_to_waitstate_w = count_ticks_end_w;
   wire comparison_done = current_dac_bit_r == {(DAC_RESOLUTION){1'b0}};

   /***************************
    State machine combinatorics
    **************************/
   // Count up when in count-state, otherwise reset counter
   wire [COUNTER_BITWIDTH-1:0] counter_reset = {{(COUNTER_BITWIDTH-1){1'b0}},1'b1};
   wire [COUNTER_BITWIDTH-1:0] one_vector = {{(COUNTER_BITWIDTH-1){1'b0}},1'b1};
   assign next_counter_w = (state_r == compare) & compare_end_w  ? counter_reset : 
                           (state_r == count_delay) & count_ticks_end_w ? counter_reset : 
                           state_r == compare     ? counter_r + one_vector : 
                           state_r == count_delay ? counter_r + one_vector :
                           counter_reset;

   // DAC-Value handling with binary SAR algorithm
   assign next_dac_bit_w = is_returning_to_waitstate_w ? {1'b1,{(DAC_RESOLUTION-1){1'b0}}} :
                           compare_end_w ? current_dac_bit_r >> 1 : 
                           current_dac_bit_r ;

   assign next_dac_value_w = state_r == waitstate    ? {DAC_RESOLUTION{1'b0}} :
                             state_r == compare & compare_end_w & ~time_trigd_w ? (dac_value_r | current_dac_bit_r) : 
                                                                                  dac_value_r;  

   assign next_dac_result_w = (is_last_bit_w  & compare_end_w ) ?  dac_value_r | {{(DAC_RESOLUTION-1){1'b0}},(~time_trigd_w)} : 
                                                                   dac_result_out ;
   
   // handle conv_finished output
   assign next_conv_finished_w = is_conversion_starting_w ? 1'b0 :
                                 is_returning_to_waitstate_w ? 1'b1 : 
                                 conv_finished_out; 
   
   // Counting clock-cylces of the last state 
   // until the delay cell triggers for additional temperature reading
   assign next_ticks_w = (state_r == count_delay) & (time_trigd_w == 0) ? counter_r : ticks_r;
   assign next_ticks_out_w = is_returning_to_waitstate_w ? next_ticks_w : ticks_out;
   
   /***************************
    VDAC output control signals
    **************************/
   assign vdac_data_out   = state_r == charge_dcdc ? {DAC_RESOLUTION{1'b1}} : (dac_value_r | current_dac_bit_r);
   assign vdac_enable_out = state_r == waitstate   ? 1'b0 : 1'b1; 

   /***************************
    DCDC output control signals
    **************************/
   assign dcdc_dat_out = state_r == charge_dcdc ? 1'b0 : 
                         state_r == starve_dcdc ? 1'b0 : 
                         1'b1;
                         
   /***************************
    State machine control
    **************************/
   assign next_state_w = state_r==waitstate   ? (start_conv_in ? charge_dcdc : state_r) : 
                         state_r==charge_dcdc ? starve_dcdc :
                         state_r==starve_dcdc ? (comparison_done ? count_delay : compare) :
                         state_r==compare     ? (compare_end_w ? charge_dcdc : state_r) :
                         state_r==count_delay ? (is_returning_to_waitstate_w ? waitstate : count_delay) :
                         waitstate;
endmodule

`endif
`default_nettype wire
