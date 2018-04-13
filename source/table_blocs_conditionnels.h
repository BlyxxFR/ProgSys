struct bloc_conditionnel {
	int source_address;
	int dest_address;
} typedef bloc_conditionnel;

void table_blocs_conditionnels_init();
void table_blocs_conditionnels_add_source_address(int source_address);
void table_blocs_conditionnels_add_destination_address(int destination_address);

/*
 * GETTERS
 */

void table_blocs_conditionnels_get_destination_address(int source_address);
bloc_conditionnel table_blocs_conditionnels_unstack();

/* 
 * SETTERS
 */

void table_blocs_conditionnels_set_destination_address(int source_address);
