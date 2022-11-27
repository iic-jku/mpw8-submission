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
`ifndef __TEMPSENSE_VDAC_CELL__
`define __TEMPSENSE_VDAC_CELL__

module tempsense_vdac_cell #(parameter PARALLEL_CELLS = 4)(
  input wire sign,
  input wire data,
  input wire enable,
  output wire vout_analog
  );
  wire en_vref, en_pupd, npu_pd;

  // Control logic
  assign npu_pd  = ~data;
  assign en_pupd = enable & (~(sign^data));
  assign en_vref = enable & (sign^data);

  genvar i;
  generate
    for (i=0; i < PARALLEL_CELLS; i=i+1) begin : einvp_batch
      sky130_fd_sc_hd__einvp_1 pupd (.A(npu_pd), .TE(en_pupd), .Z(vout_analog));
      sky130_fd_sc_hd__einvp_1 vref (.A(vout_analog), .TE(en_vref), .Z(vout_analog));
    end
  endgenerate
endmodule // tempsense_vdac_cell

`endif
`default_nettype wire
