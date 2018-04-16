#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "table_asm.h"
#include "../logger/logger.h"
#define TAILLE 1024

int index_tab_asm;
asm_instruction tab_asm[TAILLE];

void tab_asm_init() {
	index_tab_asm = 0;
	memset(tab_asm, 0, TAILLE * sizeof(asm_instruction));
}

void tab_asm_add(char *id, int r0, int r1) {
	if(index_tab_asm < TAILLE) {
		tab_asm[index_tab_asm].id = strdup(id);
		tab_asm[index_tab_asm].registers[0] = r0;
		tab_asm[index_tab_asm].registers[1] = r1;
		index_tab_asm++;
	} else {
		log_error("La table des instructions assembleur est pleine");
	}
}

void tab_asm_write_file() {
	FILE *f = fopen("output/asm.s", "w+");
	if (f == NULL)
	{
		log_error("Impossible d'ouvrir le fichier pour écrire l'assembleur");
		exit(1);
	}
	
	log_info("Ecriture de l'assembleur dans un fichier (output/asm.s)");
	for(int i = 0; i < index_tab_asm; i++) {
		fprintf(f, "%s %d %d\n", tab_asm[i].id, tab_asm[i].registers[0], tab_asm[i].registers[1]);
	}
	log_info("Fin de l'écriture");
}
