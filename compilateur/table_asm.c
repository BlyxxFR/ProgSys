#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "table_asm.h"
#include "table_blocs_conditionnels.h"
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

int tab_asm_get_last_line() {
	if(index_tab_asm == 0) {
		log_error("Aucun élément dans la table des instructions assembleur");
	} else {
		return index_tab_asm;
	}
}

void tab_asm_set_correct_addresses_blocs_conditionnels() {
	log_info("Remplacement des adresses incorrects des blocs conditionnels");

	for(int i = 0; i < index_tab_asm; i++) {
		if(strcmp(tab_asm[i].id, "JMP") == 0) {
			if(tab_asm[i].registers[0] == -1) {
				log_info("Instruction JMP à modifier trouvée à la ligne %d", i+1);
				tab_asm[i].registers[0] = tab_blocs_conditionnels_get_destination_address(i);
			}
		}
		else if(strcmp(tab_asm[i].id, "JMPC") == 0) {
			if(tab_asm[i].registers[1] == -1) {
				log_info("Instruction JMPC à modifier trouvée à la ligne %d", i+1);
				tab_asm[i].registers[1] = tab_blocs_conditionnels_get_destination_address(i+1);
			}
		}
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
		if(strcmp(tab_asm[i].id, "JMP") ==  0 || strcmp(tab_asm[i].id, "NEG") == 0) {
			fprintf(f, "%s %d\n", tab_asm[i].id, tab_asm[i].registers[0]);
		} else {
			fprintf(f, "%s %d %d\n", tab_asm[i].id, tab_asm[i].registers[0], tab_asm[i].registers[1]);
		}
	}
	log_info("Fin de l'écriture");
}
