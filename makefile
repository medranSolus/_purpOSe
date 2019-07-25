###################### Info ######################

KER_VER := 0.0.1_a
BOOT_VER := 0.0.1_a
TARGET := i686-elf

############################################ TOOLS ############################################

###################### Main tools ######################

MSG := @echo
CC =
ASM =
LD = 

###################### Architecture dependend rools ######################

LD_X86 := @../Tools/bin/$(TARGET)-ld
ASM_X86 := @nasm
CC_X86 := ../Tools/bin/$(TARGET)-gcc

############################################ FLAGS ############################################

###################### Main flags ######################

SYSROOT = ./$(ARCH)/bin/

LD_FLAGS = -T ./$(ARCH)/kernelScript.ld
ASM_FLAGS =
C_FLAGS = -I $(ARCH_INC_DIR) $(C_CROSS_FLAGS)
BOOT_FLAGS =

###################### Cross platform flags ######################

C_CROSS_FLAGS ?= -fstack-protector -ffreestanding -c -std=gnu99 -O2 -Wall -Wextra -I $(CROSS_INC_DIR)

###################### Architecture flags ######################

ARCH = nan

######### x86 #########

LD_X86_FLAGS := 
ASM_X86_FLAGS := -f elf32
C_X86_FLAGS := -m32
BOOT_X86_FLAGS := -f bin

############################################ VARIABLES ############################################

###################### Main variables ###################### 

KER_OBJ = $(CRT_0_OBJ) $(CRT_I_OBJ) $(shell $(CC) -print-file-name=crtbegin.o) $(KER_CROSS_OBJ) $(KER_ARCH_OBJ) $(LIBK_OBJ) $(LIBC_OBJ) $(TER_OBJ) $(shell $(CC) -print-file-name=crtend.o) $(CRT_N_OBJ)
LIBK_OBJ = $(LIBK_CROSS_OBJ) $(LIBK_ARCH_OBJ)
LIBC_OBJ = $(LIBC_CROSS_OBJ) $(LIBC_ARCH_OBJ)
TER_OBJ = $(TER_CROSS_OBJ) $(TER_ARCH_OBJ)

CRT_OBJ = $(CRT_0_OBJ) $(CRT_I_OBJ) $(CRT_N_OBJ)
CRT_0_OBJ = ./$(ARCH)/obj/kernel/crt0.obj
CRT_I_OBJ = ./$(ARCH)/obj/kernel/crti.obj
CRT_N_OBJ = ./$(ARCH)/obj/kernel/crtn.obj

###################### Cross platform variables ######################

CROSS_INC_DIR := ./cross/inc/
KER_CROSS_INC_DIR := ./cross/inc/kernel/
LIBK_CROSS_INC_DIR := ./cross/inc/libk/
LIBC_CROSS_INC_DIR := ./cross/inc/libc/
TER_CROSS_INC_DIR := ./cross/inc/terminal/

KER_CROSS_SRC_DIR := ./cross/src/kernel/
LIBK_CROSS_SRC_DIR := ./cross/src/libk/
LIBC_CROSS_SRC_DIR := ./cross/src/libc/
TER_CROSS_SRC_DIR := ./cross/src/terminal/

KER_CROSS_OBJ_DIR := ./cross/obj/kernel/
LIBK_CROSS_OBJ_DIR := ./cross/obj/libk/
LIBC_CROSS_OBJ_DIR := ./cross/obj/libc/
TER_CROSS_OBJ_DIR := ./cross/obj/terminal/

KER_CROSS_OBJ := $(patsubst %.c, $(KER_CROSS_OBJ_DIR)%.obj, $(shell find $(KER_CROSS_SRC_DIR) -type f -name "*.c" -exec basename {} \;))
LIBK_CROSS_OBJ := $(patsubst %.c, $(LIBK_CROSS_OBJ_DIR)%.obj, $(shell find $(LIBK_CROSS_SRC_DIR) -type f -name "*.c" -exec basename {} \;))
LIBC_CROSS_OBJ := $(patsubst %.c, $(LIBC_CROSS_OBJ_DIR)%.obj, $(shell find $(LIBC_CROSS_SRC_DIR) -type f -name "*.c" -exec basename {} \;))
TER_CROSS_OBJ := $(patsubst %.c, $(TER_CROSS_OBJ_DIR)%.obj, $(shell find $(TER_CROSS_SRC_DIR) -type f -name "*.c" -exec basename {} \;))

###################### Architecture dependend variables ######################

ARCH_INC_DIR = ./$(ARCH)/inc/
KER_ARCH_INC_DIR = ./$(ARCH)/inc/kernel/
LIBK_ARCH_INC_DIR = ./$(ARCH)/inc/libk/
LIBC_ARCH_INC_DIR = ./$(ARCH)/inc/libc/
TER_ARCH_INC_DIR = ./$(ARCH)/inc/terminal/

BOOT_SRC_DIR = ./$(ARCH)/src/bootloader/
KER_ARCH_SRC_DIR = ./$(ARCH)/src/kernel/
LIBK_ARCH_SRC_DIR = ./$(ARCH)/src/libk/
LIBC_ARCH_SRC_DIR = ./$(ARCH)/src/libc/
TER_ARCH_SRC_DIR = ./$(ARCH)/src/terminal/

KER_ARCH_OBJ_DIR = ./$(ARCH)/obj/kernel/
LIBK_ARCH_OBJ_DIR = ./$(ARCH)/obj/libk/
LIBC_ARCH_OBJ_DIR = ./$(ARCH)/obj/libc/
TER_ARCH_OBJ_DIR = ./$(ARCH)/obj/terminal/

ifneq ($(ARCH), nan)
KER_ARCH_OBJ = $(patsubst %.c, $(KER_ARCH_OBJ_DIR)%.obj, $(shell find $(KER_ARCH_SRC_DIR) -type f -name "*.c" -exec basename {} \;)) $(patsubst %.asm, $(KER_ARCH_OBJ_DIR)%.obj, $(shell find $(KER_ARCH_SRC_DIR) -path $(KER_ARCH_SRC_DIR)crt -prune -o -type f -name "*.asm" -exec basename {} \;))
LIBK_ARCH_OBJ = $(patsubst %.c, $(LIBK_ARCH_OBJ_DIR)%.obj, $(shell find $(LIBK_ARCH_SRC_DIR) -type f -name "*.c" -exec basename {} \;)) $(patsubst %.asm, $(LIBK_ARCH_OBJ_DIR)%.obj, $(shell find $(LIBK_ARCH_SRC_DIR) -type f -name "*.asm" -exec basename {} \;))
LIBC_ARCH_OBJ = $(patsubst %.c, $(LIBC_ARCH_OBJ_DIR)%.obj, $(shell find $(LIBC_ARCH_SRC_DIR) -type f -name "*.c" -exec basename {} \;)) $(patsubst %.asm, $(LIBC_ARCH_OBJ_DIR)%.obj, $(shell find $(LIBC_ARCH_SRC_DIR) -type f -name "*.asm" -exec basename {} \;))
TER_ARCH_OBJ = $(patsubst %.c, $(TER_ARCH_OBJ_DIR)%.obj, $(shell find $(TER_ARCH_SRC_DIR) -type f -name "*.c" -exec basename {} \;)) $(patsubst %.asm, $(TER_ARCH_OBJ_DIR)%.obj, $(shell find $(TER_ARCH_SRC_DIR) -type f -name "*.asm" -exec basename {} \;))
endif

############################################ RULES ############################################

###################### Main rules ######################

.PHONY: all
all: x86
	$(MSG) "_purpOSe assembled"

.PHONY: cross
cross: $(LIBK_CROSS_OBJ) $(LIBC_CROSS_OBJ) $(TER_CROSS_OBJ_DIR) $(KER_CROSS_OBJ)

.PHONY: clean
clean:
	@$(RM) -f $(KER_CROSS_OBJ_DIR)*.obj $(LIBK_CROSS_OBJ_DIR)*.obj $(LIBC_CROSS_OBJ_DIR)*.obj $(TER_CROSS_OBJ_DIR)*.obj
	@$(RM) -f $(SYSROOT)kernel_$(KER_VER) $(SYSROOT)bootloader_$(BOOT_VER)
	$(eval ARCH := x86)
	@$(RM) -f $(KER_ARCH_OBJ_DIR)*.obj $(LIBK_ARCH_OBJ_DIR)*.obj $(LIBC_ARCH_OBJ_DIR)*.obj $(TER_ARCH_OBJ_DIR)*.obj 

###################### Architecture dependend rules ######################

.PHONY: libk_$(ARCH)
libk_$(ARCH): $(LIBK_ARCH_OBJ)

.PHONY: libc_$(ARCH)
libc_$(ARCH): $(LIBC_ARCH_OBJ)

.PHONY: $(SYSROOT)terminal
$(SYSROOT)terminal: $(TER_ARCH_OBJ)

$(SYSROOT)kernel_$(KER_VER): $(KER_ARCH_OBJ) $(CRT_OBJ)
	$(LD) $(LD_FLAGS) $(KER_OBJ) -o $(SYSROOT)kernel_$(KER_VER)

$(SYSROOT)bootloader_$(BOOT_VER):
	$(ASM) $(BOOT_FLAGS) $(BOOT_SRC_DIR)MBR.asm -o $(SYSROOT)bootloader_$(BOOT_VER)

######### x86 #########

.PHONY: x86
ifeq ($(ARCH), x86)
x86: libk_$(ARCH) libc_$(ARCH) $(SYSROOT)terminal cross $(SYSROOT)kernel_$(KER_VER) $(SYSROOT)bootloader_$(BOOT_VER)
else
x86:
	$(eval ARCH := x86)
	@$(MAKE) x86 --no-print-directory ARCH=$(ARCH) LD="$(LD_X86)" CC="$(CC_X86)" ASM="$(ASM_X86)" LD_FLAGS="$(LD_FLAGS) $(LD_X86_FLAGS)" ASM_FLAGS="$(ASM_FLAGS) $(ASM_X86_FLAGS)" C_FLAGS="$(C_FLAGS) $(C_X86_FLAGS)" BOOT_FLAGS="$(BOOT_FLAGS) $(BOOT_X86_FLAGS)"
endif

###################### Kernel pattern rules ######################

######### C #########

$(KER_ARCH_OBJ_DIR)%.obj: $(KER_ARCH_SRC_DIR)%.c
	@$(CC) $(C_FLAGS) -I $(KER_CROSS_INC_DIR) -I $(KER_ARCH_INC_DIR) $< -o $@

$(KER_CROSS_OBJ_DIR)%.obj: $(KER_CROSS_SRC_DIR)%.c
	@$(CC) $(C_FLAGS) -I $(KER_CROSS_INC_DIR) $< -o $@

######## ASM ########

$(KER_ARCH_OBJ_DIR)%.obj: $(KER_ARCH_SRC_DIR)memoryManagment/segmentation/%.asm
	$(ASM) $(ASM_FLAGS) $< -o $@

$(KER_ARCH_OBJ_DIR)%.obj: $(KER_ARCH_SRC_DIR)portIO/out/%.asm
	$(ASM) $(ASM_FLAGS) $< -o $@

$(KER_ARCH_OBJ_DIR)%.obj: $(KER_ARCH_SRC_DIR)portIO/in/%.asm
	$(ASM) $(ASM_FLAGS) $< -o $@

$(KER_ARCH_OBJ_DIR)%.obj: $(KER_ARCH_SRC_DIR)crt/%.asm
	$(ASM) $(ASM_FLAGS) $< -o $@

$(KER_ARCH_OBJ_DIR)%.obj: $(KER_ARCH_SRC_DIR)%.asm
	$(ASM) $(ASM_FLAGS) $< -o $@

###################### Libk pattern rules ######################

######### C #########

$(LIBK_ARCH_OBJ_DIR)%.obj: $(LIBK_ARCH_SRC_DIR)%.c
	@$(CC) $(C_FLAGS) -I $(LIBK_CROSS_INC_DIR) -I $(LIBK_ARCH_INC_DIR) $< -o $@

$(LIBK_CROSS_OBJ_DIR)%.obj: $(LIBK_CROSS_SRC_DIR)%.c
	@$(CC) $(C_FLAGS) -I $(LIBK_CROSS_INC_DIR) $< -o $@

######## ASM ########

$(LIBK_ARCH_OBJ_DIR)%.obj: $(LIBK_ARCH_SRC_DIR)%.asm
	$(ASM) $(ASM_FLAGS) $< -o $@

###################### Libc pattern rules ######################

######### C #########

$(LIBC_ARCH_OBJ_DIR)%.obj: $(LIBC_ARCH_SRC_DIR)%.c
	@$(CC) $(C_FLAGS) -I $(LIBC_CROSS_INC_DIR) -I $(LIBC_ARCH_INC_DIR) $< -o $@

$(LIBC_CROSS_OBJ_DIR)%.obj: $(LIBC_CROSS_SRC_DIR)stdio/%.c
	@$(CC) $(C_FLAGS) -I $(LIBC_CROSS_INC_DIR) $< -o $@

$(LIBC_CROSS_OBJ_DIR)%.obj: $(LIBC_CROSS_SRC_DIR)string/%.c
	@$(CC) $(C_FLAGS) -I $(LIBC_CROSS_INC_DIR) $< -o $@

$(LIBC_CROSS_OBJ_DIR)%.obj: $(LIBC_CROSS_SRC_DIR)%.c
	@$(CC) $(C_FLAGS) -I $(LIBC_CROSS_INC_DIR) $< -o $@

######## ASM ########

$(LIBC_ARCH_OBJ_DIR)%.obj: $(LIBC_ARCH_SRC_DIR)%.asm
	$(ASM) $(ASM_FLAGS) $< -o $@

###################### Terminal pattern rules ######################

######### C #########

$(TER_ARCH_OBJ_DIR)%.obj: $(TER_ARCH_SRC_DIR)%.c
	@$(CC) $(C_FLAGS) -I $(TER_CROSS_INC_DIR) -I $(TER_ARCH_INC_DIR) $< -o $@

$(TER_CROSS_OBJ_DIR)%.obj: $(TER_CROSS_SRC_DIR)%.c
	@$(CC) $(C_FLAGS) -I $(TER_CROSS_INC_DIR) $< -o $@

######## ASM ########

$(TER_ARCH_OBJ_DIR)%.obj: $(TER_ARCH_SRC_DIR)cursor/%.asm
	$(ASM) $(ASM_FLAGS) $< -o $@

$(TER_ARCH_OBJ_DIR)%.obj: $(TER_ARCH_SRC_DIR)output/%.asm
	$(ASM) $(ASM_FLAGS) $< -o $@

$(TER_ARCH_OBJ_DIR)%.obj: $(TER_ARCH_SRC_DIR)%.asm
	$(ASM) $(ASM_FLAGS) $< -o $@