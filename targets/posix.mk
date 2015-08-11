PROJECT = test_main

ifeq ($(BUILDDIR),)
  BUILDDIR = build
endif

ifeq ($(BUILDDIR),.)
  BUILDDIR = build
endif

TRGT = 
CC   = $(TRGT)gcc
AS   = $(TRGT)gcc -x assembler-with-cpp

# List all default ASM defines here, like -D_DEBUG=1
DADEFS =

# List all default directories to look for include files here
DINCDIR =

# List the default directory to look for the libraries here
DLIBDIR =

# List all default libraries here
DLIBS = -lm

# List C source files here
SRC  = targets/posix/platform_utils.c $(FWSRC)


# List ASM source files here
ASRC =

# List all user directories here
INCDIR = targets $(FWINC)

# List the user directory to look for the libraries here
ULIBDIR =

# List all user libraries here
ULIBS =

# Output directories
OBJDIR = $(BUILDDIR)/obj
LSTDIR = $(BUILDDIR)/lst

# Define optimisation level here
OPT = -O2 -fomit-frame-pointer -std=gnu99

LLIBDIR  = $(patsubst %,-L%,$(DLIBDIR) $(ULIBDIR))
IINCDIR  = $(patsubst %,-I%,$(INCDIR) $(DINCDIR) $(UINCDIR))
DEFS    = $(DDEFS) $(UDEFS) $(CUSTOM_DEFINES)
ADEFS   = $(DADEFS) $(UADEFS)
AOBJS   = $(addprefix $(OBJDIR)/, $(notdir $(ASRC:.s=.o))) 
COBJS   = $(addprefix $(OBJDIR)/, $(notdir $(SRC:.c=.o)))
OBJS    = $(AOBJS) $(COBJS)
LIBS    = $(DLIBS) $(ULIBS)
OUT     = $(BUILDDIR)/$(PROJECT)

# Paths
ASFLAGS = -m32 -Wa,-amhls=$(<:.s=.lst) $(ADEFS)
CPFLAGS = $(OPT) -m32 -Wall -Wextra -Wstrict-prototypes -fverbose-asm $(DEFS)

ifeq ($(HOST_OSX),yes)
  ifeq ($(OSX_SDK),)
    OSX_SDK = /Developer/SDKs/MacOSX10.7.sdk
  endif
  ifeq ($(OSX_ARCH),)
    OSX_ARCH = -mmacosx-version-min=10.3 -arch i386
  endif

  CPFLAGS += -isysroot $(OSX_SDK) $(OSX_ARCH)
  LDFLAGS = -Wl -Map=$(PROJECT).map,-syslibroot,$(OSX_SDK),$(LLIBDIR)
  LIBS += $(OSX_ARCH)
else
  # Linux, or other
  CPFLAGS += -Wno-missing-field-initializers
  LDFLAGS += -m32 -Wl,-Map=$(BUILDDIR)/$(PROJECT).map,--cref,--no-warn-mismatch $(LLIBDIR)
endif

# Generate dependency information
CPFLAGS += -MD -MP -MF .dep/$(@F).d

# Paths where to search for sources
VPATH = $(sort $(dir $(SRC)))

#
# makefile rules
#

.packages_check_ok:
	@./targets/posix/posix_libs_check.sh

all: .packages_check_ok $(OBJS) $(OUT) MAKE_ALL_RULE_HOOK

MAKE_ALL_RULE_HOOK:

$(OBJS): | $(BUILDDIR)

$(BUILDDIR) $(OBJDIR) $(LSTDIR):
ifneq ($(USE_VERBOSE_COMPILE),yes)
	@echo Compiler Options
	@echo $(CC) -c $(CFLAGS) -I. $(IINCDIR) main.c -o main.o
	@echo
endif
	@mkdir -p $(OBJDIR)
	@mkdir -p $(LSTDIR)

$(COBJS) : $(OBJDIR)/%.o : %.c
ifeq ($(USE_VERBOSE_COMPILE),yes)
	@echo
	$(CC) -c $(CPFLAGS) -I . $(IINCDIR) $< -o $@
else
	@echo Compiling $<
	@$(CC) -c $(CPFLAGS) -I . $(IINCDIR) $< -o $@
endif

$(AOBJS) : $(OBJDIR)/%.o : %.s
ifeq ($(USE_VERBOSE_COMPILE),yes)
	$(AS) -c $(ASFLAGS) $< -o $@
else
	@echo Compiling $<
	@$(AS) -c $(ASFLAGS) $< -o $@
endif

$(OUT): $(OBJS)
ifeq ($(USE_VERBOSE_COMPILE),yes)
	$(CC) $(OBJS) $(LDFLAGS) $(LIBS) $(DEFS) -o $@
else
	@echo Linking $<
	@$(CC) $(OBJS) $(LDFLAGS) $(LIBS) $(DEFS) -o $@
endif

clean:
	@echo Cleaning
	-rm -fR .dep $(BUILDDIR)
	@echo Done                                  
#
# Include the dependency files, should be the last of the makefile
#
-include $(shell mkdir .dep 2>/dev/null) $(wildcard .dep/*)

# *** EOF ***
