#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include "table_symboles.h"
#define TAILLE 1024

// Variables
int index_tab;
int index_mem;
int current_depth;
symbole tab_symboles[TAILLE];


// Initialisation du tableau des symboles et des indexes à 0
void tab_symboles_init() {
	index_tab = 0;
	index_mem = 0;
	current_depth = 0;
	memset(tab_symboles, 0, TAILLE * sizeof(symbole));
}

// Ajoute un symbole à la table des symboles
void tab_symboles_add(char * name, enum enumType type, int isInitialized, int isConstant) {
	tab_symboles[index_tab].name = name;
	tab_symboles[index_tab].type = type;
	tab_symboles[index_tab].depth = current_depth;
	tab_symboles[index_tab].address = index_mem;
	tab_symboles[index_tab].isInitialized = isInitialized;
	tab_symboles[index_tab].isConstant = isConstant;
	index_tab++;
	index_mem++;
}

void tab_symboles_increase_depth() {
	current_depth++;
}

/*
 * GETTERS
 */

// Récupère la dernière variable associé au nom demandé (en cas de plusieurs variables ayant le même nom)
int tab_symboles_get_index(char * name) {
	int i;
	int index = -1;
	for(i = 0; i < index_tab; i++) {
		if(strcmp(name, tab_symboles[i].name) == 0) {
			index = i;
		}
	}
	return index; 
}

int tab_symboles_get_address(char * name) {
	int index = tab_symboles_get_index(name);
	return tab_symboles[index].address; 
}

// Récupère la dernière entrée de la table des symboles
int tab_symboles_get_last_index() {
	return index_tab - 1;
}

// Dépile le dernier symbole
symbole tab_symboles_unstack() {
	symbole tmp = tab_symboles[--index_tab];
	free(tab_symboles[index_tab].name);
	index_mem = tab_symboles[index_tab-1].address + 1;
	return tmp;
}

// Retourne si une variable est initialisée
int tab_symboles_is_initialized(char * name) {
	int index = tab_symboles_get_index(name);
	return tab_symboles[index].isInitialized;
}

// Retourne si une variable est constante
int tab_symboles_is_constant(char * name) {
	int index = tab_symboles_get_index(name);
	return tab_symboles[index].isConstant;
}

/* 
 * SETTERS
 */

// Indique qu'un symbole est initialisé car a subit une affectation
void tab_symboles_affectation(char * name) {
	int index = tab_symboles_get_index(name);
	tab_symboles[index].isInitialized = 1;
}

// Libère la mémoire de la profondeur courante (quand on quitte une fonction par exemple)
void tab_symboles_decrease_depth() {
	int i = index_tab - 1;
	while(tab_symboles[i].depth == current_depth) {
		free(tab_symboles[i].name);
		i--;
	}
	index_tab = i + 1;
	index_mem = tab_symboles[i].address + 1;
	current_depth--;
}


/*
 * TEST
 */

void tab_symboles_print() {
	int i;
	for(i = 0; i < index_tab; i++) {
		printf("Symbole rencontré %s de type %u à l'addresse %d (profondeur %d)\n", tab_symboles[i].name, tab_symboles[i].type, tab_symboles[i].address, tab_symboles[i].depth);
	}
}

/*
int main() {
	tab_symboles_init();
	tab_symboles_add(strdup("i"), INT_TYPE, 0, 0);
	tab_symboles_add(strdup("j"), INT_TYPE, 0, 0);
	tab_symboles_add(strdup("k"), INT_TYPE, 0, 0);
	tab_symboles_increase_depth();
	tab_symboles_add(strdup("l"), INT_TYPE, 0, 0);
	tab_symboles_add(strdup("m"), INT_TYPE, 0, 0);
	tab_symboles_add(strdup("n"), INT_TYPE, 0, 0);
	tab_symboles_unstack();
	tab_symboles_print();
	tab_symboles_decrease_depth();
	tab_symboles_print();
}
*/
