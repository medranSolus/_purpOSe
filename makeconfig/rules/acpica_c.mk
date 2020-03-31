$(ACPICA_OBJ_DIR)%.obj: $(ACPICA_ARCH_SRC_DIR)%.c
	@$(CC) $(C_FLAGS) $(ACPICA_C_FLAGS) $(ACPICA_INC) $< -o $@


$(ACPICA_OBJ_DIR)%.obj: $(ACPICA_CROSS_SRC_DIR)dispatcher/%.c
	@$(CC) $(C_FLAGS) $(ACPICA_C_FLAGS) $< -o $@

$(ACPICA_OBJ_DIR)%.obj: $(ACPICA_CROSS_SRC_DIR)events/%.c
	@$(CC) $(C_FLAGS) $(ACPICA_C_FLAGS) $< -o $@

$(ACPICA_OBJ_DIR)%.obj: $(ACPICA_CROSS_SRC_DIR)executer/%.c
	@$(CC) $(C_FLAGS) $(ACPICA_C_FLAGS) $< -o $@

$(ACPICA_OBJ_DIR)%.obj: $(ACPICA_CROSS_SRC_DIR)hardware/%.c
	@$(CC) $(C_FLAGS) $(ACPICA_C_FLAGS) $< -o $@

$(ACPICA_OBJ_DIR)%.obj: $(ACPICA_CROSS_SRC_DIR)namespace/%.c
	@$(CC) $(C_FLAGS) $(ACPICA_C_FLAGS) $< -o $@

$(ACPICA_OBJ_DIR)%.obj: $(ACPICA_CROSS_SRC_DIR)parser/%.c
	@$(CC) $(C_FLAGS) $(ACPICA_C_FLAGS) $< -o $@

$(ACPICA_OBJ_DIR)%.obj: $(ACPICA_CROSS_SRC_DIR)resources/%.c
	@$(CC) $(C_FLAGS) $(ACPICA_C_FLAGS) $< -o $@

$(ACPICA_OBJ_DIR)%.obj: $(ACPICA_CROSS_SRC_DIR)tables/%.c
	@$(CC) $(C_FLAGS) $(ACPICA_C_FLAGS) $< -o $@

$(ACPICA_OBJ_DIR)%.obj: $(ACPICA_CROSS_SRC_DIR)utilities/%.c
	@$(CC) $(C_FLAGS) $(ACPICA_C_FLAGS) $< -o $@