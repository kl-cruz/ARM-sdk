#!/bin/bash
declare -a ARRAY
for arg; do
   ARRAY+=("$arg")
done

./tools/openocd/src/openocd -f tools/openocd/tcl/interface/stlink-v2-1.cfg -f tools/openocd/tcl/target/stm32l0.cfg \
        -c "adapter_khz 1000;" \
        -c "program ${ARRAY[0]} exit ${ARRAY[1]}" \
        -c "reset run" \
        -c "shutdown"
