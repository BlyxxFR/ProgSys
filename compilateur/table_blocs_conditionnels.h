
#ifndef PROGSYS_TAB_BLOCS_CONDITIONNELS_H
#define PROGSYS_TAB_BLOCS_CONDITIONNELS_H

struct bloc_conditionnel {
	int source_address;
	int destination_address;
} typedef bloc_conditionnel;

void tab_blocs_conditionnels_init();
void tab_blocs_conditionnels_add_source_address(int source_address);
void tab_blocs_conditionnels_add_destination_address(int destination_address);

/*
 * GETTERS
 */

int tab_blocs_conditionnels_get_destination_address(int source_address);
bloc_conditionnel tab_blocs_conditionnels_unstack();

/* 
 * SETTERS
 */

void tab_blocs_conditionnels_set_source_address(int source_address);
void tab_blocs_conditionnels_set_destination_address(int destination_address);

#endif