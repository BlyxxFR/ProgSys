#include "table_blocs_conditionnels.h"
#define TAILLE 1024

int index_tab_bc;
bloc_conditionnel tab_blocs_conditionnels[TAILLE];

void table_blocs_conditionnels_init() {
	index_tab_bc = 0;
	memset(tab_blocs_conditionnels, -1, TAILLE * sizeof(symbole));
}

void table_blocs_conditionnels_add_source_address(int source_address) {
	if(index_tab_bc < TAILLE) {
		tab_blocs_conditionnels[index_tab_bc].source_address = source_address;
		index_tab_bc++;
	} else {
		// Renvoie une erreur
	}	
}

void table_blocs_conditionnels_add_destination_address(int destination_address) {
	if(index_tab_bc < TAILLE) {
		tab_blocs_conditionnels[index_tab_bc].destination_address = destination_address;
		index_tab_bc++;
	} else {
		// Renvoie une erreur
	}	
}

/*
 * GETTERS
 */

void table_blocs_conditionnels_get_destination_address(int source_address);
bloc_conditionnel table_blocs_conditionnels_unstack();
/* 
 * SETTERS
 */

void table_blocs_conditionnels_set_destination_address(int source_address);
