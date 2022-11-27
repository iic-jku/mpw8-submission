# OpenLane configuration file for tempsense.v
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

set ::env(DESIGN_NAME) tempsense

# Set clock details
set ::env(CLOCK_PORT) "clk"
set ::env(CLOCK_NET) "clk"
set ::env(CLOCK_TREE_SYNTH) 1
set ::env(CLOCK_PERIOD) 50

# Input files
set ::env(VERILOG_FILES) "\
    $::env(DESIGNS)/verilog/rtl/tempsense.v \
    $::env(DESIGNS)/verilog/rtl/tempsense_vdac.v \
    $::env(DESIGNS)/verilog/rtl/tempsense_vdac_cell.v \
    $::env(DESIGNS)/verilog/rtl/tempsense_sar_ctrl.v"

# Interpret instantiated SKY130-Standardcells as blackbox
set ::env(SYNTH_READ_BLACKBOX_LIB) 1

# Rexeg to flag nets where buffers are not allowed (analog signals)
set ::env(RSZ_DONT_TOUCH_RX) "analog" 

# Floorplanning
set ::env(FP_SIZING) "relative"
set ::env(FP_CORE_UTIL) 25
set ::env(PL_TARGET_DENSITY) [ expr ($::env(FP_CORE_UTIL)+5) / 100.0 ]
set ::env(ROUTING_CORES) 8

# Power distribution network settings
set ::env(FP_PDN_HOFFSET) 12
set ::env(FP_PDN_VOFFSET) 12
set ::env(FP_PDN_HPITCH) 12
set ::env(FP_PDN_VPITCH) 24

# PDN on Macro Level
set ::env(DESIGN_IS_CORE) 0
set ::env(FP_PDN_CORE_RING) 0
set ::env(RT_MAX_LAYER) {met4}
set ::env(VDD_NETS) [list {VPWR}]
set ::env(GND_NETS) [list {VGND}]

# Pin config
set ::env(FP_PIN_ORDER_CFG) $::env(DESIGNS)/openlane/tempsense/pin_order.cfg

# Placement
set ::env(PL_TARGET_DENSITY) [ expr ($::env(FP_CORE_UTIL)+5) / 100.0 ]
#set ::env(PL_TARGET_DENSITY) {0.80}
set ::env(PL_BASIC_PLACEMENT) 0
set ::env(DPL_CELL_PADDING) 2
set ::env(PL_RESIZER_TIMING_OPTIMIZATIONS) {0}
set ::env(PL_RESIZER_DESIGN_OPTIMIZATIONS) {1}
set ::env(DIODE_INSERTION_STRATEGY) 4

# Router
set ::env(GLB_RESIZER_TIMING_OPTIMIZATIONS) {0}

# LVS - workaround because LVS will fail with GDS at OpenLane commit a0b19fa
set ::env(MAGIC_EXT_USE_GDS) 0

set ::env(RUN_CVC) 1
