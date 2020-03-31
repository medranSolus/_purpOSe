###################### Cross platform ######################

CROSS_INC_DIR := ./cross/inc/
KER_CROSS_INC_DIR := ./cross/inc/kernel/
LIBK_CROSS_INC_DIR := ./cross/inc/libk/
LIBC_CROSS_INC_DIR := ./cross/inc/libc/
ACPICA_CROSS_INC_DIR := ./cross/inc/acpica/

KER_CROSS_SRC_DIR := ./cross/src/kernel/
LIBK_CROSS_SRC_DIR := ./cross/src/libk/
LIBC_CROSS_SRC_DIR := ./cross/src/libc/
ACPICA_CROSS_SRC_DIR := ./cross/src/acpica/

###################### Architecture dependend ######################

SYSROOT_DIR = ./$(ARCH)/bin/

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