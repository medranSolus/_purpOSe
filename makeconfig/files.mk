###################### Main files ######################

OS_OBJ = $(CRT_0_OBJ) $(CRT_I_OBJ) $(shell $(CC) -print-file-name=crtbegin.o) $(KER_OBJ) $(LIBK_OBJ) $(LIBC_OBJ) $(ACPICA_OBJ) $(shell $(CC) -print-file-name=crtend.o) $(CRT_N_OBJ)

CRT_OBJ = $(CRT_0_OBJ) $(CRT_I_OBJ) $(CRT_N_OBJ)
CRT_0_OBJ = ./$(ARCH)/obj/kernel/crt0.obj
CRT_I_OBJ = ./$(ARCH)/obj/kernel/crti.obj
CRT_N_OBJ = ./$(ARCH)/obj/kernel/crtn.obj

###################### Module specyfic files ######################

########### Object ###########

BOOT_OBJ = $(patsubst %.asm, $(BOOT_OBJ_DIR)%.bin, mbr.asm vbr_fat16.asm)
KER_OBJ = $(patsubst %.c, $(KER_OBJ_DIR)%.obj, $(KER_C_SRC)) $(patsubst %.asm, $(KER_OBJ_DIR)%.obj, $(KER_ASM_SRC))
LIBK_OBJ = $(patsubst %.c, $(LIBK_OBJ_DIR)%.obj, $(LIBK_C_SRC)) $(patsubst %.asm, $(LIBK_OBJ_DIR)%.obj, $(LIBK_ASM_SRC))
LIBC_OBJ = $(patsubst %.c, $(LIBC_OBJ_DIR)%.obj, $(LIBC_C_SRC)) $(patsubst %.asm, $(LIBC_OBJ_DIR)%.obj, $(LIBC_ASM_SRC))
ACPICA_OBJ = $(patsubst %.c, $(ACPICA_OBJ_DIR)%.obj, $(ACPICA_C_SRC))

########### Source ###########

ifneq ($(ARCH), nan)
KER_C_SRC = $(shell find $(KER_CROSS_SRC_DIR) -type f -name "*.c" -exec basename {} \;) \
	$(shell find $(KER_ARCH_SRC_DIR) -type f -name "*.c" -exec basename {} \;)
KER_ASM_SRC = $(shell find $(KER_ARCH_SRC_DIR) -path $(KER_ARCH_SRC_DIR)crt -prune -o -type f -name "*.asm" -exec basename {} \;)
LIBK_C_SRC = $(shell find $(LIBK_CROSS_SRC_DIR) -type f -name "*.c" -exec basename {} \;) \
	$(shell find $(LIBK_ARCH_SRC_DIR) -type f -name "*.c" -exec basename {} \;)
LIBK_ASM_SRC = $(shell find $(LIBK_ARCH_SRC_DIR) -type f -name "*.asm" -exec basename {} \;)
LIBC_C_SRC = $(shell find $(LIBC_CROSS_SRC_DIR) -type f -name "*.c" -exec basename {} \;) \
	$(shell find $(LIBC_ARCH_SRC_DIR) -type f -name "*.c" -exec basename {} \;)
LIBC_ASM_SRC = $(shell find $(LIBC_ARCH_SRC_DIR) -type f -name "*.asm" -exec basename {} \;)
#ACPICA_C_SRC = $(shell find $(ACPICA_CROSS_SRC_DIR) -type f -name "*.c" -exec basename {} \;) \
	$(shell find $(ACPICA_ARCH_SRC_DIR) -type f -name "*.c" -exec basename {} \;)
endif