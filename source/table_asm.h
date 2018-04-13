struct asm_instruction {
	char * id;
	int registers[3];
} typedef asm_instruction;

void table_asm_init();

void table_asm_add(char * id, int r0, int r1, int r2);

void table_asm_write_file();
