#!/bin/bash

MAC=const_gen
rm -rf $MAC/runs/*
openlane --run-tag foo $MAC/config.json

MAC=config_reg_mux
rm -rf $MAC/runs/*
openlane --run-tag foo $MAC/config.json

MAC=audiodac
rm -rf $MAC/runs/*
openlane --run-tag foo $MAC/config.json

MAC=tempsense
rm -rf $MAC/runs/*
openlane --run-tag foo $MAC/config.json

