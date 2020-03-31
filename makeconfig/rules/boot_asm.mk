$(BOOT_OBJ_DIR)%.bin: $(BOOT_SRC_DIR)%.asm
	$(ASM) $(BOOT_ASM_FLAGS) $< -o $@

$(BOOT_OBJ_DIR)vbr_%.bin: $(BOOT_SRC_DIR)vbr/%.asm
	$(ASM) $(BOOT_ASM_FLAGS) $< -o $@