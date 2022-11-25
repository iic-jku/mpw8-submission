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
`ifndef __VDAC__
`define __VDAC__
`include "vdac_cell.v"

module vdac #(parameter BITWIDTH = 6)(
  input wire [BITWIDTH-1:0] data,
  input wire enable,
  output wire vout_ana_
  );
  genvar i;
  generate 
    for (i = 0; i<BITWIDTH-1; i=i+1) begin : parallel_cells
      vdac_cell #(.PARALLEL_CELLS(2**i)) vdac_batch (
        .sign(data[BITWIDTH-1]),
        .data(data[i]),
        .enable(enable),
        .vout_ana_(vout_ana_)
      );
    end
  endgenerate
  
  // Single cell for transition from 011..11 to 100..00
  vdac_cell #(.PARALLEL_CELLS(1)) vdac_single (
    .sign(1'b0),
    .data(1'b0),
    .enable(enable & (~data[BITWIDTH-1])),
    .vout_ana_(vout_ana_)
  );
endmodule

`endif
`default_nettype wire
