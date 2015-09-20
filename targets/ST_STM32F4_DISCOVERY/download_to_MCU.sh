#!/bin/bash
declare -a ARRAY
for arg; do
   ARRAY+=("$arg")
done

./tools/openocd/src/openocd -f tools/openocd/tcl/interface/stlink-v2.cfg -f tools/openocd/tcl/target/stm32f4x.cfg \
	-c "reset_config trst_and_srst; adapter_khz 1000;" \
        -c init -c targets -c "reset halt" \
        -c "flash write_image erase ${ARRAY[0]}" \
        -c "verify_image ${ARRAY[0]}" \
        -c "reset run" -c shutdown
