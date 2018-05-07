#include <stdio.h>
#include <stdlib.h>

#include "stack.h"
#include "../logger/logger.h"

#define TAILLE 1024

stack _stack;

void stack_init() {
	_stack.data = malloc(sizeof(int) * TAILLE);
	for (int i = 0; i < TAILLE; i++) {
		_stack.data[i] = 0;
	}
	_stack.index = 0;
}

int stack_push(int value) {
	if (_stack.index == TAILLE - 1) {
		log_error("La pile est déjà à sa capacité maximale");
		return -1;
	}
	log_info("La valeur %d a été poussée", value);
	_stack.data[_stack.index++] = value;
	return 0;
}

int stack_pop() {
	if (_stack.index == 0) {
		log_error("La pile est vide");
		return -1;
	}
	log_info("La valeur %d a été dépilée", _stack.data[_stack.index-1]);
	return _stack.data[--_stack.index];
}

void stack_destroy() {
	free(_stack.data);
	_stack.index = 0;
}

void dump_stack() {
	for (int i = 0; i < _stack.index; i++) {
		log_info("STACK Addresse n°%d : %d", i, _stack.data[i]);
	}
}

