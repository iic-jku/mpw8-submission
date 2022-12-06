#!/bin/sh

export PDK=sky130A
export PDKPATH="$PDK_ROOT/$PDK"

rm -rf openlane/*/runs/*
