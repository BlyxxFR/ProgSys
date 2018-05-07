
#ifndef PROGSYS_TABLE_FONCTIONS_H
#define PROGSYS_TABLE_FONCTIONS_H

struct fonction {
	char *name;
	int arguments;
	int line_asm_start;

} typedef fonction;

void tab_fonctions_init();

void tab_fonctions_add(char *name, int arguments, int line_asm_start);

// -1 si existe avec un nombre d'arguments différent, 0 si n'existe pas, 1 si existe
int tab_fonctions_exists(char *name, int arguments);

/*
 * GETTER
 */

int tab_fonctions_get_start(char *name, int arguments);


#endif //PROGSYS_TABLE_FONCTIONS_H
