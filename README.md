# IIC Mixed-Signal Circuits (MPW-8)

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) [![CI](https://github.com/efabless/caravel_user_project_analog/actions/workflows/user_project_ci.yml/badge.svg)](https://github.com/efabless/caravel_user_project_analog/actions/workflows/user_project_ci.yml) [![Caravan Build](https://github.com/efabless/caravel_user_project_analog/actions/workflows/caravan_build.yml/badge.svg)](https://github.com/efabless/caravel_user_project_analog/actions/workflows/caravan_build.yml)

(c) 2022 **Harald Pretl, Manuel Moser, and Michael Herber**, Institute for Integrated Circuits, Johannes Kepler University, Linz

## TODO

* [x] Add more temperature sensors (one in each corner)
* [x] Connect digital signals to LA
* [x] Include SAR-ADC
* [ ] Fix pdn shorts in ADC
* [ ] Maybe include PLL from Christof
* [x] Make clock and reset of config reg async
* [x] Use `define.v` in user_proj_wrapper
* [x] Check settings is `user_defines.v`, mgmt vs user
* [ ] In `tempsense`, add power pins to the directly instantiated standard cells?
* [ ] Add stand-alone VDAC (and delay-cell?) from `tempsense` for testing.

## 12b SAR-ADC

This design is a nonbinary, asynchronous (= self-clocked) 12b SAR ADC, using a segmented 9+3b capacitive DAC with a thermometer-coded 9b capacitor array with 3b binary capacitor cells.

The ADC allows oversampling and includes a programmable boxcar FIR decimation filter. OSR=1/4/16/64/256 is supported.

The internal timing can be adapted by programmable delay cells. Further, the ADC uses result averaging (configurable 1/3/7/15/31) on the LSB steps to reduce the impact of comparator thermal noise.

## Synthesizable digital temperature sensor

This design is a fully-synthesizable temperature sensor using a fully-synthesizable voltage-mode DAC. This design has been submitted to the ISSCC2023 Code-a-Chip contest.

Four instances of the temperature sensor are included so that the die corner temperatures can be individually measured.

## 16b Delta-Sigma Audio DAC

This design is a purely digital implementation of a 1b-output delta-sigma DAC supporting a 16b data input (signed INT). It includes an asynchronous FIFO for easy interfacing with a host system.

The 1b digital output (`out_p` plus inverted `out_n`) allows the easy connection of a power H-bridge to implement a class-D audio DAC plus amplifier.

Several test modes (FIFO loop-back replay, sinusoidal tone generator) are included for testing.
