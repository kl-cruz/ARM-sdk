#!/bin/bash

./tools/openocd/src/openocd -f tools/openocd/tcl/interface/stlink-v2.cfg -f tools/openocd/tcl/target/stm32f4.cfg
