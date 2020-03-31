$(LIBK_OBJ_DIR)%.obj: $(LIBK_ARCH_SRC_DIR)%.asm
	$(ASM) $(ASM_FLAGS) -i $(LIBK_ARCH_INC_DIR) $< -o $@