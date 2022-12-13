#!/bin/sh
# SPDX-FileCopyrightText: 2022 Harald Pretl, Institute for Integrated Circuits, Johannes Kepler University
# SPDX-License-Identifier: Apache-2.0

# Abs OBS to LEFs as a WA for the pddgen fail
head -n -4 lef/tempsense.lef > temp.txt ; mv temp.txt lef/tempsense.lef
cat tempsense_obs.lef >> lef/tempsense.lef
head -n -4 lef/config_reg_mux.lef > temp.txt ; mv temp.txt lef/config_reg_mux.lef
cat config_reg_mux_obs.lef >> lef/config_reg_mux.lef
