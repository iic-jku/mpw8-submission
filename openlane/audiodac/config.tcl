# OpenLane configuration file for audiodac.v
#
# SPDX-FileCopyrightText: 2022 Manuel Moser, Michael Herber, Harald Pretl
# Johannes Kepler University, Institute for Integrated Circuits
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# SPDX-License-Identifier: Apache-2.0

set script_dir [file dirname [file normalize [info script]]]

set ::env(DESIGN_NAME) audiodac

# Set clock details
set ::env(CLOCK_PORT) {clk_i}
set ::env(CLOCK_NET) {clk_i}
set ::env(CLOCK_PERIOD) 50

set ::env(VERILOG_FILES) "\
	$::env(DESIGNS)/verilog/rtl/audiodac.v \
	$::env(DESIGNS)/verilog/rtl/iic_dsmod.v \
	$::env(DESIGNS)/verilog/rtl/iic_fifo.v \
	$::env(DESIGNS)/verilog/rtl/iic_sinegen.v"

# PDN on Macro Level
set ::env(DESIGN_IS_CORE) 0

# Design has hold violations, trying this to fix it
#set ::env(PL_RESIZER_HOLD_SLACK_MARGIN) "0.7"
#set ::env(GLB_RESIZER_HOLD_SLACK_MARGIN) "0.7"

# Setup placing and routing
set ::env(FP_SIZING) "relative"
set ::env(FP_CORE_UTIL) 25
set ::env(PL_TARGET_DENSITY) [ expr ($::env(FP_CORE_UTIL)+5) / 100.0 ]
set ::env(ROUTING_CORES) 4
set ::env(RT_MAX_LAYER) {met4}
set ::env(VDD_NETS) [list {VPWR}]
set ::env(GND_NETS) [list {VGND}]

# Pin config
set ::env(FP_PIN_ORDER_CFG) $::env(DESIGNS)/openlane/audiodac/pin_order.cfg

set ::env(DIODE_INSERTION_STRATEGY) 4 
# If you're going to use multiple power domains, then disable cvc run.
set ::env(RUN_CVC) 1
