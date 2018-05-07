
#ifndef PROGSYS_STACK_H
#define PROGSYS_STACK_H

typedef struct stack {
	int *data;
	int index;
} stack;

void stack_init();

int stack_push(int value);

int stack_pop();

void stack_destroy();

void dump_stack();


#endif //PROGSYS_STACK_H
