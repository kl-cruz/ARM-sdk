#!/bin/bash

./tools/openocd/src/openocd -f tools/openocd/tcl/interface/stlink-v2-1.cfg -f tools/openocd/tcl/target/stm32lx_stlink.cfg
