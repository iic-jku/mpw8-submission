#!/bin/sh

export PDK=sky130A
export PDKPATH="$PDK_ROOT/$PDK"

call_flow () {
	flow.tcl -design "openlane/$1" -tag foo -overwrite
}

clean_result () {
	rm def/*
	rm lef/*
	rm gds/*
	rm mag/*
	rm maglef/*
	rm verilog/gl/*
}

stage_result () {
	cp "openlane/$1/runs/foo/results/final/def/$1.def" def
	cp "openlane/$1/runs/foo/results/final/lef/$1.lef" lef
	cp "openlane/$1/runs/foo/results/final/gds/$1.gds" gds
	cp "openlane/$1/runs/foo/results/final/mag/$1.mag" mag
	cp "openlane/$1/runs/foo/results/final/maglef/$1.mag" maglef
	cp "openlane/$1/runs/foo/results/final/verilog/gl/$1.v" verilog/gl
}

# Get rid of old results
clean_result

# Harden macros
call_flow audiodac
call_flow tempsense
call_flow config_reg

# Stage results of hardening
stage_result audiodac
stage_result tempsense
stage_result config_reg

# Assemble top-level
call_flow user_project_wrapper
stage_result user_project_wrapper
