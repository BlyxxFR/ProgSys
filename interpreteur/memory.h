#ifndef PROGSYS_MEMOIRE_H
#define PROGSYS_MEMOIRE_H

void memory_init();

void set_memory(int index, int value);

int access_memory(int index);

void set_register(int index, int value);

int access_register(int index);

void dump_memory(int entries_memory_to_dump);

#endif
