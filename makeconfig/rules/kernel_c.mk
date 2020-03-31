$(KER_OBJ_DIR)%.obj: $(KER_ARCH_SRC_DIR)utils/%.c
	@$(CC) $(C_FLAGS) $(KER_C_FLAGS) $(KER_INC) $< -o $@

$(KER_OBJ_DIR)%.obj: $(KER_ARCH_SRC_DIR)terminal/%.c
	@$(CC) $(C_FLAGS) $(KER_C_FLAGS) $(KER_INC) $< -o $@

$(KER_OBJ_DIR)%.obj: $(KER_ARCH_SRC_DIR)%.c
	@$(CC) $(C_FLAGS) $(KER_C_FLAGS) $(KER_INC) $< -o $@


$(KER_OBJ_DIR)%.obj: $(KER_CROSS_SRC_DIR)%.c
	@$(CC) $(C_FLAGS) $(KER_C_FLAGS) $< -o $@