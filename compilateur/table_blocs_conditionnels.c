#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "table_blocs_conditionnels.h"
#include "../logger/logger.h"

#define TAILLE 1024

int index_tab_bc;
bloc_conditionnel tab_blocs_conditionnels[TAILLE];

void tab_blocs_conditionnels_init() {
	index_tab_bc = 0;
	memset(tab_blocs_conditionnels, -1, TAILLE * sizeof(bloc_conditionnel));
}

void tab_blocs_conditionnels_add_source_address(int source_address) {
	if (index_tab_bc < TAILLE) {
		tab_blocs_conditionnels[index_tab_bc].source_address = source_address;
		tab_blocs_conditionnels[index_tab_bc].destination_address = -1;
		index_tab_bc++;
	} else {
		log_error("La table des blocs conditionneles est pleine");
	}
}

void tab_blocs_conditionnels_add_destination_address(int destination_address) {
	if (index_tab_bc < TAILLE) {
		tab_blocs_conditionnels[index_tab_bc].source_address = -1;
		tab_blocs_conditionnels[index_tab_bc].destination_address = destination_address;
		index_tab_bc++;
	} else {
		log_error("La table des blocs conditionneles est pleine");
	}
}

int tab_blocs_conditionnels_get_index(int source_address) {
	int index = -1;
	for (int i = 0; i < index_tab_bc && index == -1; i++) {
		if (tab_blocs_conditionnels[i].source_address == source_address) {
			index = i;
		}
	}
	if (index == -1) {
		for (int i = 0; i < index_tab_bc; i++) {
			log_info("source %d dest %d", tab_blocs_conditionnels[i].source_address, tab_blocs_conditionnels[i].destination_address);
		}
		log_error("Aucun élément ne correspond à l'adresse %d dans la table des blocs conditionnels", source_address);
	}
	return index;
}

/*
 * GETTERS
 */

int tab_blocs_conditionnels_get_destination_address(int source_address) {
	int index = tab_blocs_conditionnels_get_index(source_address);
	if (index >= 0)
		return tab_blocs_conditionnels[index].destination_address;
	else
		return -1;
}

bloc_conditionnel tab_blocs_conditionnels_unstack() {
	if (index_tab_bc > 0) {
		return tab_blocs_conditionnels[--index_tab_bc];
	} else {
		log_error("La table des blocs conditionneles est vide");
	}
}

/* 
 * SETTERS
 */

void tab_blocs_conditionnels_set_source_address(int source_address) {
	if (index_tab_bc == 0) {
		log_error("Aucun élément pour affecter l'adresse source");
	} else {
		int index = index_tab_bc - 1;
		while (tab_blocs_conditionnels[index].source_address != -1) {
			index--;
		}
		tab_blocs_conditionnels[index].source_address = source_address;
	}
}


void tab_blocs_conditionnels_set_destination_address(int destination_address) {
	if (index_tab_bc == 0) {
		log_error("Aucun élément pour affecter l'adresse de destination");
	} else {
		int index = index_tab_bc - 1;
		while (tab_blocs_conditionnels[index].destination_address != -1) {
			index--;
		}
		tab_blocs_conditionnels[index].destination_address = destination_address;
	}
}
