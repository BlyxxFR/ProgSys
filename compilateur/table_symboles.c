#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include "table_symboles.h"
#include "../logger/logger.h"
#define TAILLE 1024

// Variables
int index_tab_symboles;
int index_mem_symboles;
int current_depth;
symbole tab_symboles[TAILLE];
extern int yylineno;


// Initialisation du tableau des symboles et des indexes à 0
void tab_symboles_init() {
	index_tab_symboles = 0;
	index_mem_symboles = 0;
	current_depth = 0;
	memset(tab_symboles, 0, TAILLE * sizeof(symbole));
}

// Ajoute un symbole à la table des symboles
void tab_symboles_add(char * name, enum enumType type, int isInitialized, int isConstant) {
	if(index_tab_symboles < TAILLE) {
		tab_symboles[index_tab_symboles].name = name;
		tab_symboles[index_tab_symboles].type = type;
		tab_symboles[index_tab_symboles].depth = current_depth;
		tab_symboles[index_tab_symboles].address = index_mem_symboles;
		tab_symboles[index_tab_symboles].isInitialized = isInitialized;
		tab_symboles[index_tab_symboles].isConstant = isConstant;
		index_tab_symboles++;
		index_mem_symboles++;
	} else {
		log_error("La table des symboles est pleine");
	}
}

void tab_symboles_increase_depth() {
	current_depth++;
}

/*
 * GETTERS
 */

// Récupère la dernière variable associé au nom demandé (en cas de plusieurs variables ayant le même nom)
int tab_symboles_get_index(char * name) {
	int index = -1;
	for(int i = 0; i < index_tab_symboles; i++) {
		if(strcmp(name, tab_symboles[i].name) == 0) {
			index = i;
		}
	}

	if(index == -1) {
		log_error("Aucun symbole ne porte le nom %s dans la table des symboles", name);
	}

	return index; 
}

int tab_symboles_get_address(char * name) {
	int index = tab_symboles_get_index(name);

	if(index == -1)
		return -1;
	else
		return tab_symboles[index].address;
}

// Récupère la dernière entrée de la table des symboles
int tab_symboles_get_last_index() {
	if(index_tab_symboles == 0)
		log_error("Aucun symbole n'est présent dans la table des symboles");
	return index_tab_symboles - 1;
}

// Dépile le dernier symbole
symbole tab_symboles_unstack() {
	if(index_tab_symboles > 0) {
		symbole tmp = tab_symboles[--index_tab_symboles];
		free(tab_symboles[index_tab_symboles].name);
		index_mem_symboles = tab_symboles[index_tab_symboles-1].address + 1;
		return tmp;
	} else {
		log_error("Aucun symbole n'est présent dans la table des symboles");
	}
}

// Retourne si une variable est initialisée
int tab_symboles_is_initialized(char * name) {
	int index = tab_symboles_get_index(name);

	if(index == -1)
		return -1;
	else
		return tab_symboles[index].isInitialized;
}

// Retourne si une variable est constante
int tab_symboles_is_constant(char * name) {
	int index = tab_symboles_get_index(name);

	if(index == -1)
		return -1;
	else
		return tab_symboles[index].isConstant;
}

int tab_symboles_get_last_address() {
	if(index_mem_symboles == 0)
		log_error("Aucun symbole n'est présent dans la table des symboles");
	return index_mem_symboles - 1;
}

int tab_sumboles_is_last_temp() {
	return strcmp(tab_symboles[index_tab_symboles-1].name, "###") == 0;
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
	int i = index_tab_symboles - 1;
	while(tab_symboles[i].depth == current_depth) {
		if(strcmp(tab_symboles[i].name, "###") != 0)
			log_info("Suppresion de la variable %s en raison d'un changement de profondeur", tab_symboles[i].name);
		free(tab_symboles[i].name);
		i--;
	}
	index_tab_symboles = i + 1;
	index_mem_symboles = tab_symboles[i].address;
	current_depth--;
}


/*
 * TEST
 */

void tab_symboles_print() {
	int i;
	for(i = 0; i < index_tab_symboles; i++) {
		log_info("Symbole rencontré %s de type %u à l'addresse %d (profondeur %d)", tab_symboles[i].name, tab_symboles[i].type, tab_symboles[i].address, tab_symboles[i].depth);
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
