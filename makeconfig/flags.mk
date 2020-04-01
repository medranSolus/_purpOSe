###################### Main flags ######################

C_OS_DEFINES := -D_purpose -D_purpOSe -D_PURPOSE -D__purpose__ -D__purpOSe__ -D__PURPOSE__ 
ASM_OS_DEFINES := -d_purpose -d_purpOSe -d_PURPOSE -d__purpose__ -d__purpOSe__ -d__PURPOSE__ 

LD_FLAGS = -s -T ./$(ARCH)/kernel_script.ld
ASM_FLAGS = -i $(ARCH_INC_DIR) $(ASM_OS_DEFINES)
C_FLAGS = -I $(ARCH_INC_DIR) $(C_CROSS_FLAGS) $(C_OS_DEFINES)
BOOT_ASM_FLAGS = -i $(BOOT_SRC_DIR)

KER_C_FLAGS = $(KER_CROSS_INC)
LIBK_C_FLAGS = $(LIBK_CROSS_INC)
LIBC_C_FLAGS = $(LIBC_CROSS_INC)
ACPICA_C_FLAGS = $(ACPICA_CROSS_INC)

KER_INC = -I $(KER_ARCH_INC_DIR) $(LIBK_INC)
LIBK_INC = -I $(LIBK_ARCH_INC_DIR) $(LIBC_INC)
LIBC_INC = -I $(LIBC_ARCH_INC_DIR)
ACPICA_INC = -I $(ACPICA_ARCH_INC_DIR)

###################### Cross platform ######################

C_CROSS_FLAGS = -ffreestanding -c -std=gnu17 -pedantic -O2 -Wall -Wextra -I $(CROSS_INC_DIR) #-fstack-protector 

KER_CROSS_INC = -I $(KER_CROSS_INC_DIR) $(LIBK_CROSS_INC)
LIBK_CROSS_INC = -I $(LIBK_CROSS_INC_DIR) $(LIBC_CROSS_INC)
LIBC_CROSS_INC = -I $(LIBC_CROSS_INC_DIR)
ACPICA_CROSS_INC = -I $(ACPICA_CROSS_INC_DIR) -I $(ACPICA_ARCH_INC_DIR)

###################### Architecture specyfic ######################

########### x86 ###########

LD_X86_FLAGS := 
ASM_X86_FLAGS := -f elf32 -g
C_X86_FLAGS := -g -m32
BOOT_ASM_X86_FLAGS := -f bin