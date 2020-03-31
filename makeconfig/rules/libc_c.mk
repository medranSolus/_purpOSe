$(LIBC_OBJ_DIR)%.obj: $(LIBC_ARCH_SRC_DIR)%.c
	@$(CC) $(C_FLAGS) $(LIBC_C_FLAGS) $(LIBC_INC) $< -o $@


$(LIBC_OBJ_DIR)%.obj: $(LIBC_CROSS_SRC_DIR)stdio/%.c
	@$(CC) $(C_FLAGS) $(LIBC_C_FLAGS) $< -o $@

$(LIBC_OBJ_DIR)%.obj: $(LIBC_CROSS_SRC_DIR)string/%.c
	@$(CC) $(C_FLAGS) $(LIBC_C_FLAGS) $< -o $@

$(LIBC_OBJ_DIR)%.obj: $(LIBC_CROSS_SRC_DIR)%.c
	@$(CC) $(C_FLAGS) $(LIBC_C_FLAGS) $< -o $@