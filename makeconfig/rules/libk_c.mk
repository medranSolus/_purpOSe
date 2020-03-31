$(LIBK_OBJ_DIR)%.obj: $(LIBK_ARCH_SRC_DIR)%.c
	@$(CC) $(C_FLAGS) $(LIBK_C_FLAGS) $(LIBK_INC) $< -o $@


$(LIBK_OBJ_DIR)%.obj: $(LIBK_CROSS_SRC_DIR)%.c
	@$(CC) $(C_FLAGS) $(LIBK_C_FLAGS) $< -o $@