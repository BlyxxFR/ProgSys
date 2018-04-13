#include <stdio.h>
#include <string.h>
#include "table_asm.h"
#define TAILLE 1024

int index_tab_asm;
asm_instruction tab_asm[TAILLE];

void table_asm_init() {
	index_tab_asm = 0;
	memset(tab_asm, 0, TAILLE * sizeof(asm_instruction));
}

void table_asm_add(char * id, int r0, int r1, int r2) {
	tab_asm[index_tab_asm].id = strdup(id);
	tab_asm[index_tab_asm].registers[0] = r0;
	tab_asm[index_tab_asm].registers[1] = r1;
	tab_asm[index_tab_asm].registers[2] = r2;
	index_tab_asm++;
}

void table_asm_write_file() {
	// Export dans un fichier à faire
	for(int i = 0; i < index_tab_asm; i++) {
		if(tab_asm[i].registers[2] == -1) {
			printf("%s %d %d\n", tab_asm[i].id, tab_asm[i].registers[0], tab_asm[i].registers[1]);
		} else {
			printf("%s %d %d %d\n", tab_asm[i].id, tab_asm[i].registers[0], tab_asm[i].registers[1], tab_asm[i].registers[2]);
		}
	}
}
