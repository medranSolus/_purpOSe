################################# INFO #################################

KER_VER := 0.0.1_a
BOOT_VER := 0.0.1_a
TARGET := i386-elf
FS := fat16

###################### Tools ######################

MSG := @echo
CC =
ASM =
LD = 

########### x86 ###########

LD_X86 := @./x86/tools/bin/$(TARGET)-ld
ASM_X86 := @nasm
CC_X86 := ./x86/tools/bin/$(TARGET)-gcc

################################# CONFIG #################################

ARCH = nan
CONFIG := ./makeconfig/
CONFIG_RULES := $(CONFIG)rules/

include $(CONFIG)flags.mk
include $(CONFIG)files.mk
include $(CONFIG)directories.mk
include $(CONFIG)rules.mk

################################# RULES #################################

.PHONY: all
all: x86
	$(MSG) "_purpOSe assembled."

.PHONY: acpica
acpica: $(ACPICA_OBJ)

.PHONY: libk
libk: $(LIBK_OBJ)

.PHONY: libc
libc: $(LIBC_OBJ)

.PHONY: dir_tree
dir_tree:
	@mkdir -p $(SYSROOT_DIR)Purpose/Boot/

.PHONY: clean
clean:
	$(eval ARCH := x86)
	@$(RM) -rf $(SYSROOT_DIR)*
	@$(RM) $(KER_OBJ_DIR)* $(LIBK_OBJ_DIR)* $(LIBC_OBJ_DIR)* $(ACPICA_OBJ_DIR)* $(BOOT_OBJ_DIR)*

###################### Architecture specyfic ######################

$(SYSROOT_DIR)Purpose/purpose.ker: $(KER_OBJ) $(CRT_OBJ)
	$(LD) $(LD_FLAGS) $(OS_OBJ) -o $@

$(SYSROOT_DIR)Purpose/Boot/bootpos.bio: $(BOOT_OBJ)
	@cat $(BOOT_OBJ) > $@

########### x86 ###########

.PHONY: x86
ifeq ($(ARCH), x86)
x86: dir_tree boot_x86 kernel_x86
	@sudo ./utils/mkdisk_$(FS).sh x86

.PHONY: kernel_x86
kernel_x86: acpica libk libc $(SYSROOT_DIR)Purpose/purpose.ker

.PHONY: boot_x86
boot_x86: $(SYSROOT_DIR)Purpose/Boot/bootpos.bio
else
x86:
	$(eval ARCH := x86)
	@$(MAKE) $@ --no-print-directory ARCH=$(ARCH) LD="$(LD_X86)" CC="$(CC_X86)" ASM="$(ASM_X86)" LD_FLAGS="$(LD_FLAGS) $(LD_X86_FLAGS)" ASM_FLAGS="$(ASM_FLAGS) $(ASM_X86_FLAGS)" C_FLAGS="$(C_FLAGS) $(C_X86_FLAGS)" BOOT_ASM_FLAGS="$(BOOT_ASM_X86_FLAGS)"
endif