#!/bin/sh
# SPDX-FileCopyrightText: 2022 Harald Pretl, Institute for Integrated Circuits, Johannes Kepler University
# SPDX-License-Identifier: Apache-2.0

export PDK=sky130A
export PDKPATH="$PDK_ROOT/$PDK"

rm -rf openlane/*/runs/*
