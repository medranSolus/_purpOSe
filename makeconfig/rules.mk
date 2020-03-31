########### Kernel ###########

include $(CONFIG_RULES)kernel_c.mk
include $(CONFIG_RULES)kernel_asm.mk

########### LIBK ###########

include $(CONFIG_RULES)libk_c.mk
include $(CONFIG_RULES)libk_asm.mk

########### LIBC ###########

include $(CONFIG_RULES)libc_c.mk
include $(CONFIG_RULES)libc_asm.mk

########### Bootloader ###########

include $(CONFIG_RULES)boot_asm.mk

########### ACPICA ###########

include $(CONFIG_RULES)acpica_c.mk