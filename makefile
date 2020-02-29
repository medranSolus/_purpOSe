###################### Info ######################

KER_VER := 0.0.1_a
BOOT_VER := 0.0.1_a
TARGET := i386-elf
FS = fat16

############################################ TOOLS ############################################

###################### Main tools ######################

MSG := @echo
CC =
ASM =
LD = 

###################### Architecture dependend tools ######################

LD_X86 := @./x86/tools/bin/$(TARGET)-ld
ASM_X86 := @nasm
CC_X86 := ./x86/tools/bin/$(TARGET)-gcc

############################################ FLAGS ############################################

###################### Main flags ######################

SYSROOT = ./$(ARCH)/bin/
C_OS_DEFINES := -D_purpose -D_purpOSe -D_PURPOSE -D__purpose__ -D__purpOSe__ -D__PURPOSE__ 
ASM_OS_DEFINES := -d_purpose -d_purpOSe -d_PURPOSE -d__purpose__ -d__purpOSe__ -d__PURPOSE__ 

LD_FLAGS = -T ./$(ARCH)/kernel_script.ld
ASM_FLAGS = -i $(ARCH_INC_DIR) $(ASM_OS_DEFINES)
C_FLAGS = -I $(ARCH_INC_DIR) $(C_CROSS_FLAGS) $(C_OS_DEFINES)
BOOT_FLAGS =

KER_INC = -I $(KER_ARCH_INC_DIR) $(KER_CROSS_INC) $(LIBK_INC)
LIBK_INC = -I $(LIBK_ARCH_INC_DIR) $(LIBC_INC) $(LIBK_CROSS_INC)
LIBC_INC = -I $(LIBC_ARCH_INC_DIR) $(LIBC_CROSS_INC)
ACPICA_INC = $(ACPICA_CROSS_INC)

###################### Cross platform flags ######################

C_CROSS_FLAGS ?= -ffreestanding -c -std=gnu99 -O2 -Wall -Wextra -I $(CROSS_INC_DIR) #-fstack-protector 

KER_CROSS_INC = -I $(KER_CROSS_INC_DIR) $(LIBK_CROSS_INC)
LIBK_CROSS_INC = -I $(LIBK_CROSS_INC_DIR) $(LIBC_CROSS_INC)
LIBC_CROSS_INC = -I $(LIBC_CROSS_INC_DIR)
ACPICA_CROSS_INC = -I $(ACPICA_CROSS_INC_DIR) -I $(ACPICA_ARCH_INC_DIR)

###################### Architecture flags ######################

ARCH = nan

######### x86 #########

LD_X86_FLAGS := 
ASM_X86_FLAGS := -f elf32 -g
C_X86_FLAGS := -g -m32
BOOT_X86_FLAGS := -f bin

############################################ VARIABLES ############################################

###################### Main variables ###################### 

OS_OBJ = $(CRT_0_OBJ) $(CRT_I_OBJ) $(shell $(CC) -print-file-name=crtbegin.o) $(KER_OBJ) $(LIBK_OBJ) $(LIBC_OBJ) $(ACPICA_OBJ) $(shell $(CC) -print-file-name=crtend.o) $(CRT_N_OBJ)

CRT_OBJ = $(CRT_0_OBJ) $(CRT_I_OBJ) $(CRT_N_OBJ)
CRT_0_OBJ = ./$(ARCH)/obj/kernel/crt0.obj
CRT_I_OBJ = ./$(ARCH)/obj/kernel/crti.obj
CRT_N_OBJ = ./$(ARCH)/obj/kernel/crtn.obj

###################### Cross platform variables ######################

CROSS_INC_DIR := ./cross/inc/
KER_CROSS_INC_DIR := ./cross/inc/kernel/
LIBK_CROSS_INC_DIR := ./cross/inc/libk/
LIBC_CROSS_INC_DIR := ./cross/inc/libc/
ACPICA_CROSS_INC_DIR := ./cross/inc/acpica/

KER_CROSS_SRC_DIR := ./cross/src/kernel/
LIBK_CROSS_SRC_DIR := ./cross/src/libk/
LIBC_CROSS_SRC_DIR := ./cross/src/libc/
ACPICA_CROSS_SRC_DIR := ./cross/src/acpica/

###################### Architecture dependend variables ######################

ARCH_INC_DIR = ./$(ARCH)/inc/
KER_ARCH_INC_DIR = ./$(ARCH)/inc/kernel/
LIBK_ARCH_INC_DIR = ./$(ARCH)/inc/libk/
LIBC_ARCH_INC_DIR = ./$(ARCH)/inc/libc/
ACPICA_ARCH_INC_DIR = ./$(ARCH)/inc/acpica/

BOOT_SRC_DIR = ./$(ARCH)/src/bootloader/
KER_ARCH_SRC_DIR = ./$(ARCH)/src/kernel/
LIBK_ARCH_SRC_DIR = ./$(ARCH)/src/libk/
LIBC_ARCH_SRC_DIR = ./$(ARCH)/src/libc/
ACPICA_ARCH_SRC_DIR = ./$(ARCH)/src/acpica/

BOOT_OBJ_DIR = ./$(ARCH)/obj/bootloader/
KER_OBJ_DIR = ./$(ARCH)/obj/kernel/
LIBK_OBJ_DIR = ./$(ARCH)/obj/libk/
LIBC_OBJ_DIR = ./$(ARCH)/obj/libc/
ACPICA_OBJ_DIR = ./$(ARCH)/obj/acpica/

ifneq ($(ARCH), nan)
BOOT_OBJ = $(patsubst %.asm, $(BOOT_OBJ_DIR)%.bin, mbr.asm vbr_fat16.asm)
KER_OBJ = $(patsubst %.c, $(KER_OBJ_DIR)%.obj, $(shell find $(KER_CROSS_SRC_DIR) -type f -name "*.c" -exec basename {} \;)) $(patsubst %.c, $(KER_OBJ_DIR)%.obj, $(shell find $(KER_ARCH_SRC_DIR) -type f -name "*.c" -exec basename {} \;)) $(patsubst %.asm, $(KER_OBJ_DIR)%.obj, $(shell find $(KER_ARCH_SRC_DIR) -path $(KER_ARCH_SRC_DIR)crt -prune -o -type f -name "*.asm" -exec basename {} \;))
LIBK_OBJ = $(patsubst %.c, $(LIBK_OBJ_DIR)%.obj, $(shell find $(LIBK_CROSS_SRC_DIR) -type f -name "*.c" -exec basename {} \;)) $(patsubst %.c, $(LIBK_OBJ_DIR)%.obj, $(shell find $(LIBK_ARCH_SRC_DIR) -type f -name "*.c" -exec basename {} \;)) $(patsubst %.asm, $(LIBK_OBJ_DIR)%.obj, $(shell find $(LIBK_ARCH_SRC_DIR) -type f -name "*.asm" -exec basename {} \;))
LIBC_OBJ = $(patsubst %.c, $(LIBC_OBJ_DIR)%.obj, $(shell find $(LIBC_CROSS_SRC_DIR) -type f -name "*.c" -exec basename {} \;)) $(patsubst %.c, $(LIBC_OBJ_DIR)%.obj, $(shell find $(LIBC_ARCH_SRC_DIR) -type f -name "*.c" -exec basename {} \;)) $(patsubst %.asm, $(LIBC_OBJ_DIR)%.obj, $(shell find $(LIBC_ARCH_SRC_DIR) -type f -name "*.asm" -exec basename {} \;))
#ACPICA_OBJ = $(patsubst %.c, $(ACPICA_OBJ_DIR)%.obj, $(shell find $(ACPICA_CROSS_SRC_DIR) -type f -name "*.c" -exec basename {} \;)) $(patsubst %.c, $(ACPICA_OBJ_DIR)%.obj, $(shell find $(ACPICA_ARCH_SRC_DIR) -type f -name "*.c" -exec basename {} \;))
endif

############################################ RULES ############################################

###################### Main rules ######################

.PHONY: all
all: x86
	$(MSG) "_purpOSe assembled."

.PHONY: kernel
kernel: kernel_x86
	$(MSG) "Kernel assembled."

.PHONY: boot
boot: boot_x86
	$(MSG) "Bootloader assembled."

.PHONY: acpica
acpica: $(ACPICA_OBJ)

.PHONY: libk
libk: $(LIBK_OBJ)

.PHONY: libc
libc: $(LIBC_OBJ)

.PHONY: dir_tree
dir_tree:
	@mkdir -p $(SYSROOT)Purpose/Boot

.PHONY: clean
clean:
	$(eval ARCH := x86)
	@$(RM) -rf $(SYSROOT)*
	@$(RM) $(KER_OBJ_DIR)*.obj $(LIBK_OBJ_DIR)*.obj $(LIBC_OBJ_DIR)*.obj $(ACPICA_OBJ_DIR)*.obj $(BOOT_OBJ_DIR)*.bin

###################### Architecture dependend rules ######################

$(SYSROOT)Purpose/purpose.ker: $(KER_OBJ) $(CRT_OBJ)
	$(LD) $(LD_FLAGS) $(OS_OBJ) -o $@

$(SYSROOT)Purpose/Boot/bootpos.bin: $(BOOT_OBJ)
	@cat $(BOOT_OBJ) > $@

######### x86 #########

.PHONY: x86
x86: boot_x86 kernel_x86
	@sudo ./utils/mkdisk_$(FS).sh x86

.PHONY: kernel_x86
ifeq ($(ARCH), x86)
kernel_x86: dir_tree acpica libk libc $(SYSROOT)Purpose/purpose.ker
else
kernel_x86:
	$(eval ARCH := x86)
	@$(MAKE) $@ --no-print-directory ARCH=$(ARCH) LD="$(LD_X86)" CC="$(CC_X86)" ASM="$(ASM_X86)" LD_FLAGS="$(LD_FLAGS) $(LD_X86_FLAGS)" ASM_FLAGS="$(ASM_FLAGS) $(ASM_X86_FLAGS)" C_FLAGS="$(C_FLAGS) $(C_X86_FLAGS)"
endif

.PHONY: boot_x86
ifeq ($(ARCH), x86)
boot_x86: dir_tree $(SYSROOT)Purpose/Boot/bootpos.bin
else
boot_x86:
	$(eval ARCH := x86)
	@$(MAKE) $@ --no-print-directory ARCH=$(ARCH) CC="$(CC_X86)" ASM="$(ASM_X86)" ASM_FLAGS="$(ASM_FLAGS) $(ASM_X86_FLAGS)" BOOT_FLAGS="$(BOOT_FLAGS) $(BOOT_X86_FLAGS)"
endif

###################### Kernel pattern rules ######################

######### C #########

$(KER_OBJ_DIR)%.obj: $(KER_ARCH_SRC_DIR)utils/%.c
	@$(CC) $(C_FLAGS) $(KER_INC) $< -o $@

$(KER_OBJ_DIR)%.obj: $(KER_ARCH_SRC_DIR)terminal/%.c
	@$(CC) $(C_FLAGS) $(KER_INC) $< -o $@

$(KER_OBJ_DIR)%.obj: $(KER_ARCH_SRC_DIR)%.c
	@$(CC) $(C_FLAGS) $(KER_INC) $< -o $@

$(KER_OBJ_DIR)%.obj: $(KER_CROSS_SRC_DIR)%.c
	@$(CC) $(C_FLAGS) $(KER_CROSS_INC) $< -o $@

######## ASM ########

$(KER_OBJ_DIR)%.obj: $(KER_ARCH_SRC_DIR)utils/%.asm
	$(ASM) $(ASM_FLAGS) -i $(KER_ARCH_INC_DIR) $< -o $@

$(KER_OBJ_DIR)%.obj: $(KER_ARCH_SRC_DIR)terminal/cursor/%.asm
	$(ASM) $(ASM_FLAGS) -i $(KER_ARCH_INC_DIR) $< -o $@

$(KER_OBJ_DIR)%.obj: $(KER_ARCH_SRC_DIR)terminal/output/%.asm
	$(ASM) $(ASM_FLAGS) -i $(KER_ARCH_INC_DIR) $< -o $@

$(KER_OBJ_DIR)%.obj: $(KER_ARCH_SRC_DIR)terminal/%.asm
	$(ASM) $(ASM_FLAGS) -i $(KER_ARCH_INC_DIR) $< -o $@

$(KER_OBJ_DIR)%.obj: $(KER_ARCH_SRC_DIR)interrupts/handlers/%.asm
	$(ASM) $(ASM_FLAGS) -i $(KER_ARCH_INC_DIR) $< -o $@

$(KER_OBJ_DIR)%.obj: $(KER_ARCH_SRC_DIR)interrupts/%.asm
	$(ASM) $(ASM_FLAGS) -i $(KER_ARCH_INC_DIR) $< -o $@

$(KER_OBJ_DIR)%.obj: $(KER_ARCH_SRC_DIR)memory_managment/%.asm
	$(ASM) $(ASM_FLAGS) -i $(KER_ARCH_INC_DIR) $< -o $@

$(KER_OBJ_DIR)%.obj: $(KER_ARCH_SRC_DIR)portIO/out/%.asm
	$(ASM) $(ASM_FLAGS) -i $(KER_ARCH_INC_DIR) $< -o $@

$(KER_OBJ_DIR)%.obj: $(KER_ARCH_SRC_DIR)portIO/in/%.asm
	$(ASM) $(ASM_FLAGS) -i $(KER_ARCH_INC_DIR) $< -o $@

$(KER_OBJ_DIR)%.obj: $(KER_ARCH_SRC_DIR)crt/%.asm
	$(ASM) $(ASM_FLAGS) -i $(KER_ARCH_INC_DIR) $< -o $@

$(KER_OBJ_DIR)%.obj: $(KER_ARCH_SRC_DIR)%.asm
	$(ASM) $(ASM_FLAGS) -i $(KER_ARCH_INC_DIR) $< -o $@

###################### Libk pattern rules ######################

######### C #########

$(LIBK_OBJ_DIR)%.obj: $(LIBK_ARCH_SRC_DIR)%.c
	@$(CC) $(C_FLAGS) $(LIBK_INC) $< -o $@

$(LIBK_OBJ_DIR)%.obj: $(LIBK_CROSS_SRC_DIR)%.c
	@$(CC) $(C_FLAGS) $(LIBK_CROSS_INC) $< -o $@

######## ASM ########

$(LIBK_OBJ_DIR)%.obj: $(LIBK_ARCH_SRC_DIR)%.asm
	$(ASM) $(ASM_FLAGS) -i $(LIBK_ARCH_INC_DIR) $< -o $@

###################### Libc pattern rules ######################

######### C #########

$(LIBC_OBJ_DIR)%.obj: $(LIBC_ARCH_SRC_DIR)%.c
	@$(CC) $(C_FLAGS) $(LIBC_INC) $< -o $@

$(LIBC_OBJ_DIR)%.obj: $(LIBC_CROSS_SRC_DIR)stdio/%.c
	@$(CC) $(C_FLAGS) $(LIBC_CROSS_INC) $< -o $@

$(LIBC_OBJ_DIR)%.obj: $(LIBC_CROSS_SRC_DIR)string/%.c
	@$(CC) $(C_FLAGS) $(LIBC_CROSS_INC) $< -o $@

$(LIBC_OBJ_DIR)%.obj: $(LIBC_CROSS_SRC_DIR)%.c
	@$(CC) $(C_FLAGS) $(LIBC_CROSS_INC) $< -o $@

######## ASM ########

$(LIBC_OBJ_DIR)%.obj: $(LIBC_ARCH_SRC_DIR)%.asm
	$(ASM) $(ASM_FLAGS) -i $(LIBC_ARCH_INC_DIR) $< -o $@

###################### Bootloader pattern rules ######################

######## ASM ########

$(BOOT_OBJ_DIR)%.bin: $(BOOT_SRC_DIR)%.asm
	$(ASM) $(BOOT_FLAGS) $< -o $@

$(BOOT_OBJ_DIR)vbr_%.bin: $(BOOT_SRC_DIR)vbr/%.asm
	$(ASM) $(BOOT_FLAGS) $< -o $@

###################### ACPICA pattern rules ######################

######### C #########

$(ACPICA_OBJ_DIR)%.obj: $(ACPICA_ARCH_SRC_DIR)%.c
	@$(CC) $(C_FLAGS) $(ACPICA_INC) $< -o $@

$(ACPICA_OBJ_DIR)%.obj: $(ACPICA_CROSS_SRC_DIR)dispatcher/%.c
	@$(CC) $(C_FLAGS) $(ACPICA_CROSS_INC) $< -o $@

$(ACPICA_OBJ_DIR)%.obj: $(ACPICA_CROSS_SRC_DIR)events/%.c
	@$(CC) $(C_FLAGS) $(ACPICA_CROSS_INC) $< -o $@

$(ACPICA_OBJ_DIR)%.obj: $(ACPICA_CROSS_SRC_DIR)executer/%.c
	@$(CC) $(C_FLAGS) $(ACPICA_CROSS_INC) $< -o $@

$(ACPICA_OBJ_DIR)%.obj: $(ACPICA_CROSS_SRC_DIR)hardware/%.c
	@$(CC) $(C_FLAGS) $(ACPICA_CROSS_INC) $< -o $@

$(ACPICA_OBJ_DIR)%.obj: $(ACPICA_CROSS_SRC_DIR)namespace/%.c
	@$(CC) $(C_FLAGS) $(ACPICA_CROSS_INC) $< -o $@

$(ACPICA_OBJ_DIR)%.obj: $(ACPICA_CROSS_SRC_DIR)parser/%.c
	@$(CC) $(C_FLAGS) $(ACPICA_CROSS_INC) $< -o $@

$(ACPICA_OBJ_DIR)%.obj: $(ACPICA_CROSS_SRC_DIR)resources/%.c
	@$(CC) $(C_FLAGS) $(ACPICA_CROSS_INC) $< -o $@

$(ACPICA_OBJ_DIR)%.obj: $(ACPICA_CROSS_SRC_DIR)tables/%.c
	@$(CC) $(C_FLAGS) $(ACPICA_CROSS_INC) $< -o $@

$(ACPICA_OBJ_DIR)%.obj: $(ACPICA_CROSS_SRC_DIR)utilities/%.c
	@$(CC) $(C_FLAGS) $(ACPICA_CROSS_INC) $< -o $@