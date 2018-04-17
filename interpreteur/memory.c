#include <string.h>
#include "../logger/logger.h"
#include "memory.h"

#define NOMBRE_REGISTRES 2
#define TAILLE 10

int tab_registres[NOMBRE_REGISTRES];
int tab_memory[TAILLE];

void memory_init() {
    memset(tab_memory, 0, TAILLE * sizeof(int));
    memset(tab_registres, 0, NOMBRE_REGISTRES * sizeof(int));
}

void set_memory(int index, int value) {
    if(index > TAILLE) {
        log_error("L'index %d dépasse la taille de la zone mémoire (%d)", index, TAILLE);
    }
    tab_memory[index] = value;
}

int access_memory(int index) {
    if(index > TAILLE) {
        log_error("L'index %d dépasse la taille de la zone mémoire (%d)", index, TAILLE);
    }
    return tab_memory[index];
}

void set_register(int index, int value) {
    if(index > NOMBRE_REGISTRES) {
        log_error("L'index %d dépasse la taille de le nombre de registres (%d)", index, NOMBRE_REGISTRES);
    }
    tab_registres[index] = value;
}

int access_register(int index) {
    if(index > NOMBRE_REGISTRES) {
        log_error("L'index %d dépasse la taille de le nombre de registres (%d)", index, NOMBRE_REGISTRES);
    }
    return tab_registres[index];
}

void dump_memory() {
    for(int i = 0; i < TAILLE; i++) {
        log_info("Addresse n°%d : %d", i, tab_memory[i]);
    }
}