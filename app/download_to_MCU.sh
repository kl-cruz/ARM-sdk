#!/bin/bash
FILE=../build_stm32l053_nucleo/arm_sdk.hex

./../tools/openocd/src/openocd -f ../tools/openocd/tcl/interface/stlink-v2-1.cfg -f ../tools/openocd/tcl/target/stm32l0.cfg \
        -c "adapter_khz 1000;" \
        -c init -c targets -c "reset halt" \
        -c "flash write_image erase ${FILE}" \
        -c "verify_image ${FILE}" \
        -c "reset run" -c shutdown
