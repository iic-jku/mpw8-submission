#!/bin/sh
# SPDX-FileCopyrightText: 2022-2023 Harald Pretl, Institute for Integrated Circuits, Johannes Kepler University
# SPDX-License-Identifier: Apache-2.0

export PDK=sky130B
export PDKPATH="$PDK_ROOT/$PDK"

call_flow () {
	echo "---------------------------------------------------"
	echo "Hardening $1..."
	echo "---------------------------------------------------"
	rm -rf openlane/"$1"/runs/*
	openlane "openlane/$1/config.json" --run-tag foo
}

clean_result () {
	echo "---------------------------------------------------"
	echo "Deleting old results..."
	echo "---------------------------------------------------"
	[ "$(ls -A def)" ] 			&& rm def/*
	[ "$(ls -A lef)" ] 			&& rm lef/*
	[ "$(ls -A gds)" ] 			&& rm gds/*
	[ "$(ls -A mag)" ] 			&& rm mag/*
	[ "$(ls -A maglef)" ] 		&& rm maglef/*
	[ "$(ls -A verilog/gl)" ] 	&& rm verilog/gl/*
}

stage_result () {
	echo "---------------------------------------------------"
	echo "Staging results of $1..."
	echo "---------------------------------------------------"
	cp "openlane/$1/runs/foo/final/def/$1.def" def
	cp "openlane/$1/runs/foo/final/gds/$1.magic.gds" "gds/$1.gds"
	cp "openlane/$1/runs/foo/final/lef/$1.lef" lef
	##cp "openlane/$1/runs/foo/final/mag/$1.mag" mag
	##cp "openlane/$1/runs/foo/final/maglef/$1.mag" maglef
	cp "openlane/$1/runs/foo/final/nl/$1.nl.v" "verilog/gl/$1.v"
}

fix_lef () {
	head -n -4 "lef/$1.lef" > temp.txt ; mv temp.txt "lef/$1.lef"
	cat "$1"_obs.lef >> "lef/$1.lef"
}

# Get rid of old results
##clean_result

# Harden macros
##call_flow audiodac
##call_flow tempsense
##call_flow config_reg_mux
##call_flow const_gen

# Stage results of hardening
stage_result audiodac
stage_result tempsense
stage_result config_reg_mux
stage_result const_gen

# Abs OBS to LEFs as a WA for the pddgen fail
##fix_lef tempsense
##fix_lef config_reg_mux
##fix_lef const_gen

# Assemble top-level
call_flow user_project_wrapper
stage_result user_project_wrapper
