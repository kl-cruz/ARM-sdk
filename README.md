# ARM-sdk
When developers change 8-bit MCUs into powerful 32-bit ARMs, They must prepare environement properly:<br>
- Download toolchain<br>
- Download and maybe compile software for hardware debugger<br>
- Download libraries for 32-bit MCUs and connect everything<br>
Sometimes everything works out of the box, sometimes It is big battle between developer and PC.
<br><br>
This repository helps developers to quick start with ARMs. It contains:<br>
- base ChibiOS (http://www.chibios.org) to provide simply OS functions and control hardware using HAL<br>
- simple, small and powerful log system using format (https://github.com/nejohnson/format)<br>
- example app<br>
- the newest toolchain from https://launchpad.net/gcc-arm-embedded<br>
- the newest openocd compiled during configuration
<br><br>
To arm this repository with whole stuff:<br>
- clone it: git clone https://github.com/kl-cruz/ARM-sdk.git<br>
- configure it: make configure<br>
- connect target board to PC eg. STM32F4 Discovery<br>
- compile and install example app: make target=ST_STM32F4_DISCOVERY all && make target=ST_STM32F4_DISCOVERY install<br>
