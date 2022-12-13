#!/bin/sh
# SPDX-FileCopyrightText: 2022 Harald Pretl, Institute for Integrated Circuits, Johannes Kepler University
# SPDX-License-Identifier: Apache-2.0

# https://caravel-user-project.readthedocs.io/en/latest/#

OPENLANE_ROOT=$(pwd)/dependencies/openlane_src
export OPENLANE_ROOT
PDK_ROOT=$(pwd)/dependencies/pdks
export PDK_ROOT
PDK=sky130A
export PDK
STD_CELL_LIBRARY=sky130_fd_sc_hd
export STD_CELL_LIBRARY

