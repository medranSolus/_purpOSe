$(LIBC_OBJ_DIR)%.obj: $(LIBC_ARCH_SRC_DIR)%.asm
	$(ASM) $(ASM_FLAGS) -i $(LIBC_ARCH_INC_DIR) $< -o $@