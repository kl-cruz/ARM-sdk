include app/sources.mk

FWSRC += tools/format/src/format.c tools/format/lib/printf.c tools/format/lib/snprintf.c tools/format/lib/sprintf.c
FWINC += tools/format/src tools/format/lib
PRJ_ROOT = 

ifeq ($(MAKECMDGOALS),)
$(error Please specify make goals!. More info -> make help)
endif 

# All configuration

ifeq ($(MAKECMDGOALS), all)

ifeq ($(target),)
    $(error Please specify target! make target=... all)
endif

BUILDDIR = build_$(target)
include targets/$(target)/target.mk
FWINC += targets/$(target)

endif

# Clean configuration

ifeq ($(MAKECMDGOALS), clean_build)

ifeq ($(target),)
    $(error Please specify target! make target=... clean_build)
endif

include targets/$(target)/target.mk

endif

help:
	@echo "***********  ARM SDK MAKEFILE HELP  **********"
	@echo ""
	@echo ""
	@echo "USAGE:"
	@echo "make help                                        Show this help"
	@echo "make configure                                   Configure environement for fixture generators"
	@echo "make distclean                                   Deconfigure environement, remove additional and builds files"
	@echo "make target=... clean_build                      Clean all compile files with target build directory"
	@echo "make target=... all                              Simply compile test for target using available files"

clean_build: clean
	@echo "Cleaning build $(target)"
	@rm -r -f build_$(target)
	@rm -r -f app/.dep
	@rm -r -f .dep

configure:
	@echo "Configure environement..."
	@if test -d tools; then echo "tools directory exist!"; else mkdir tools; fi
	@echo "Downloading the newest GCC toolchain..."
	@./scripts/install_new_gcc.sh 
	@echo "Downloading the newest openocd debugger..."
	@./scripts/install_new_openocd.sh 
	@echo "Cloning ChibiOS..."
	@if test -d tools/ChibiOS; then echo "ChibiOS exists - pull" && cd tools/ChibiOS && git pull; else git clone https://github.com/ChibiOS/ChibiOS.git tools/ChibiOS; fi
	@echo "Cloning format library..."
	@if test -d tools/format; then echo "format exists"; else git clone git@github.com:nejohnson/format.git tools/format; fi
	@echo "Done!"

distclean:
	@echo "Deconfigure environement..."
	@./scripts/clean_all.sh
	@rm -r -f build_*
	@rm -r -f app/.dep
	@rm -r -f .dep
	@echo "Done!"

install:
	@echo "Downloading application to MCU..."
	@./targets/$(target)/download_to_MCU.sh build_$(target)/arm_sdk.hex
	@echo "Done!"

