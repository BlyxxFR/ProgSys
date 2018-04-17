#include <string.h>
#include "table_instructions.h"
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

int tab_asm_get_size() {
    return TAILLE;
}

asm_instruction tab_asm_get_instruction(int index) {
    if(index > TAILLE) {
        log_error("L'index %d dépasse la taille du tableau assembleur (%d)", index, TAILLE);
    }
    return tab_asm[index];
}

int tab_asm_get_last_index() {
    return index_tab_asm - 1;
}