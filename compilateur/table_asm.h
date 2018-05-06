
#ifndef PROGSYS_TAB_ASM_H
#define PROGSYS_TAB_ASM_H

struct asm_instruction {
	char * id;
	int registers[2];
} typedef asm_instruction;

void tab_asm_init();

void tab_asm_add(char * id, int r0, int r1);
int tab_asm_get_last_line();
void tab_asm_set_correct_addresses_blocs_conditionnels();

void tab_asm_write_file();

#endif