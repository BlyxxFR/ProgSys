
#ifndef PROGSYS_TABLE_SYMBOLES_H
#define PROGSYS_TABLE_SYMBOLES_H

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

#define TAILLE 1024

enum enumType {
	INT_TYPE, FLOAT_TYPE, STRING_TYPE
};

struct symbole {
	char *name;
	enum enumType type;
	int depth;
	int address;
	int isInitialized;
	int isConstant;
} typedef symbole;

void tab_symboles_init();

void tab_symboles_add(char *name, enum enumType type, int isInitialized, int isConstant);

void tab_symboles_increase_depth();

/*
 * GETTERS
 */


int tab_symboles_get_index(char *name);

int tab_symboles_get_address(char *name);

int tab_symboles_get_last_index();

int tab_symboles_get_last_address();

int tab_symboles_is_initialized(char *name);

int tab_symboles_is_constant(char *name);

symbole tab_symboles_unstack();

/* 
 * SETTERS
 */

void tab_symboles_affectation(char *name);

void tab_symboles_decrease_depth();

/*
 * TEST
 */

void tab_symboles_print();

#endif