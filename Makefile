include app/sources.mk

FWSRC += tools/format/src/format.c tools/format/lib/printf.c tools/format/lib/snprintf.c tools/format/lib/sprintf.c
FWINC += tools/format/src tools/format/lib
PRJ_ROOT = 

ifeq ($(MAKECMDGOALS),)
$(error Please specify make goals!. More info -> make help)
endif

ifeq ($(target),)
    target = posix
    include targets/posix.mk
endif

BUILDDIR = build_$(target)
ifeq ($(target),posix)
    include targets/posix.mk
else
ifeq ($(target),stm32f4Discovery)
    FWINC += targets/STM32F4Discovery
    include targets/STM32F4Discovery.mk
    UDEFS += -DCHIBIOS_PRINTF
else
ifeq ($(target),stm32l053_nucleo)
    FWINC += targets/STM32L053_nucleo
    include targets/STM32L053_nucleo.mk
    UDEFS += -DCHIBIOS_PRINTF
else
$(error Please specify properly target. More info -> make help)
endif
endif
endif




help:
	@echo "***********  ARM SDK MAKEFILE HELP  **********"
	@echo ""
	@echo ""
	@echo "USAGE:"
	@echo "make help                                        Show this help"
	@echo "make configure                                   Configure environement for fixture generators"
	@echo "make distclean                                   Deconfigure environement, remove additional and builds files"
	@echo "make [target=...] all                            Simply compile test for target using available files"

target-list:
	@echo "┌──────────────────────────────  TARGETS  ────────────────────────────┐"
	@echo "│    Availatble targets : target=...                                  │"
	@echo "├──────────────────────────────────────────────────┬──────────────────┤"
	@echo "│         TARGET                                   │      STRING      │"
	@echo "├──────────────────────────────────────────────────┼──────────────────┤"
	@echo "│ Linux posix (default)                            │ posix            │"
	@echo "│ STM32L053 nucleo dev board                       │ stm32l053_nucleo │"
	@echo "│ STM32F4 Discovery board with USB CDC driver      │ stm32f4Discovery │"
	@echo "└──────────────────────────────────────────────────┴──────────────────┘"
	
configure:
	@echo "Configure environement..."
	@if test -d tools; then echo "toold directory abort"; else mkdir tools; fi
	@echo "Downloading the newest GCC toolchain..."
	@./scripts/install_new_gcc.sh 
	@echo "Downloading the newest openocd debugger..."
	@./scripts/install_new_openocd.sh 
	@echo "Cloning ChibiOS..."
	@if test -d tools/ChibiOS; then echo "ChibiOS exists - pull" && cd tools/ChibiOS && git pull; else git clone git@github.com:cruz91/ChibiOS.git tools/ChibiOS; fi
	@cd tools/ChibiOS && git checkout feature-stm32l053-support
	@echo "Cloning format library..."
	@if test -d tools/format; then echo "format exists"; else git clone git@github.com:nejohnson/format.git tools/format; fi
	@echo "Done!"

distclean: clean
	@echo "Deconfigure environement..."
	@./scripts/clean_all.sh
	@rm -r -f build_*
	@rm -r -f app/.dep
	@echo "Done!"

