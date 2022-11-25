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
*/

`default_nettype none
`ifndef __TEMPSENSE__
`define __TEMPSENSE__

`include "tempsense_sar_ctrl.v"
`include "vdac.v"

module tempsense #(parameter DAC_RESOLUTION = 6,
                   parameter COUNTER_BITWIDTH = 12) (
`ifdef USE_POWER_PINS
      inout vccd1,	// User area 1 1.8V supply
      inout vssd1,	// User area 1 digital ground
`endif

  input wire clk,
  input wire rst_n,
  input wire start_conv_in,
  output wire [DAC_RESOLUTION-1:0] vdac_result_out,
  output wire [COUNTER_BITWIDTH-1:0] tick_result_out,
  output wire conversion_finished_out
  );

  // Digital core with SAR-algoritm
  tempsense_sar_ctrl #(.DAC_RESOLUTION(DAC_RESOLUTION),
                       .COUNTER_BITWIDTH(COUNTER_BITWIDTH)) sar 
                       (
                        .clk(clk),
                        .rst_n(rst_n),
                        .start_conv_in(start_conv_in),
                        .dac_result_out(vdac_result_out),
                        .ticks_out(tick_result_out),
                        .conv_finished_out(conversion_finished_out),
                        .vdac_data_out(dac_data_w),
                        .vdac_enable_out(dac_enable_w),
                        .dcdc_dat_out(dcdc_data_w),
                        .time_trigd_n_in(dcdc_trigd_n_w)
   );
  
  // Voltage-mode Digital to Analog Converter (VDAC)
  wire [DAC_RESOLUTION-1:0] dac_data_w;
  wire dac_enable_w;
  wire dcdc_data_w;
  wire dcdc_enable_ana_w;
  vdac #(.BITWIDTH(DAC_RESOLUTION)) dac
        (
         .data(dac_data_w),
         .enable(dac_enable_w),
         .vout_ana_(dcdc_enable_ana_w)
        );

  // Digitally-Controled Delay Cell
  wire dcdc_trig_n_ana_w;
  wire dcdc_trigd_w;
  wire dcdc_trigd_n_w;
  sky130_fd_sc_hd__einvp_1 dcdc (.A(dcdc_data_w), .TE(dcdc_enable_ana_w), .Z(dcdc_trig_n_ana_w));
  sky130_fd_sc_hd__inv_4   inv1 (.A(dcdc_trig_n_ana_w),.Y(dcdc_trigd_w));
  sky130_fd_sc_hd__inv_12  inv2 (.A(dcdc_trigd_w),.Y(dcdc_trigd_n_w));
  
endmodule

`endif
`default_nettype wire
