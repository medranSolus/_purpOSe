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