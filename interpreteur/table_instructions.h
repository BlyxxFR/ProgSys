#ifndef PROGSYS_TABLE_INSTRUCTIONS_H
#define PROGSYS_TABLE_INSTRUCTIONS_H

struct asm_instruction {
	char *id;
	int registers[2];
} typedef asm_instruction;

void tab_asm_init();

void tab_asm_add(char *id, int r0, int r1);

asm_instruction tab_asm_get_instruction(int index);

int tab_asm_get_last_index();

#endif
