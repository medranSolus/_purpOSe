$(BOOT_OBJ_DIR)%.bin: $(BOOT_SRC_DIR)stage_1/%.asm
	$(ASM) $(BOOT_ASM_FLAGS) $< -o $@

$(BOOT_OBJ_DIR)vbr_%.bin: $(BOOT_SRC_DIR)stage_1/vbr/%.asm
	$(ASM) $(BOOT_ASM_FLAGS) $< -o $@

$(BOOT_OBJ_DIR)%.bin: $(BOOT_SRC_DIR)stage_2/%.asm
	$(ASM) $(BOOT_ASM_FLAGS) -i $(BOOT_SRC_DIR)stage_2/ $< -o $@