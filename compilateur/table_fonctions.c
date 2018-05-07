#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "table_fonctions.h"
#include "../logger/logger.h"

#define TAILLE 1024

int index_tab_fonctions;
fonction tab_fonctions[TAILLE];

void tab_fonctions_init() {
	index_tab_fonctions = 0;
	memset(tab_fonctions, 0, TAILLE * sizeof(fonction));
}

int tab_fonctions_exists(char *name, int arguments) {
	for (int i = 0; i < index_tab_fonctions; i++) {
		if (strcmp(name, tab_fonctions[i].name) == 0) {
			if (tab_fonctions[i].arguments == arguments) {
				return 1;
			} else {
				return -1;
			}
		}
	}
	return 0;
}

void tab_fonctions_add(char *name, int arguments, int line_asm_start) {
	if (tab_fonctions_exists(name, arguments) == 1) {
		log_error("La fonction %s (%d arguments) a déjà été déclarée", name, arguments);
	} else if (tab_fonctions_exists(name, arguments) == -1) {
		log_error("La fonction %s a déjà été déclarée avec un nombre différent d'arguments", name, arguments);
	} else {
		log_info("Déclaration de la fonction %s avec %d argument(s) effectuée", name, arguments);
		tab_fonctions[index_tab_fonctions].name = name;
		tab_fonctions[index_tab_fonctions].arguments = arguments;
		tab_fonctions[index_tab_fonctions].line_asm_start = line_asm_start;
		index_tab_fonctions++;

	}
}

/*
 * GETTER
 */

int tab_fonctions_get_start(char *name, int arguments) {
	for (int i = 0; i < index_tab_fonctions; i++) {
		if (strcmp(name, tab_fonctions[i].name) == 0 && tab_fonctions[i].arguments == arguments) {
			return tab_fonctions[i].line_asm_start;
		}
	}
	log_error("La fonction %s n'existe pas", name);
	return -1;
}
