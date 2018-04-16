%{
#include <stdio.h>
#include <string.h>
#include "interpreteur/table_instructions.h"
#include "interpreteur/memory.h"
#include "logger/logger.h"

#define YYDEBUG 1
int yylex();
void yyerror(char *s) {
	printf("%s\n",s);
}
extern int yylineno;

%}

%union {
	int intValue;
}

%token <intValue> NOMBRE

%token LOAD
%token STORE

%token ADD
%token SUB
%token MUL
%token DIV

%token AFC

%start Input

%%

Input:
	  /* empty */
	| Input Line
	;

Line:
      Addition
    | Soustraction
    | Multiplication
    | Division
    | Affectation
    | Chargement
    | Memorisation
    ;

Addition:
      ADD NOMBRE NOMBRE
      {
      		log_info("Instruction ADD détectée entre les registres %d et %d", $2, $3);
			tab_asm_add("ADD", $2, $3);
      }
    ;

Soustraction:
      SUB NOMBRE NOMBRE
      {
      		log_info("Instruction SUB détectée entre les registres %d et %d", $2, $3);
			tab_asm_add("SUB", $2, $3);
      }
    ;

Multiplication:
      MUL NOMBRE NOMBRE
      {
      		log_info("Instruction MUL détectée entre les registres %d et %d", $2, $3);
			tab_asm_add("MUL", $2, $3);
      }
    ;

Division:
      DIV NOMBRE NOMBRE
      {
      		log_info("Instruction DIV détectée entre les registres %d et %d", $2, $3);
			tab_asm_add("DIV", $2, $3);
      }
    ;

Affectation:
      AFC NOMBRE NOMBRE
      {
      		log_info("Instruction AFC détectée entre les registres %d et %d", $2, $3);
			tab_asm_add("AFC", $2, $3);
      }
    ;

Chargement:
      LOAD NOMBRE NOMBRE
      {
      		log_info("Instruction LOAD détectée entre les registres %d et %d", $2, $3);
			tab_asm_add("LOAD", $2, $3);
      }
    ;

Memorisation:
      STORE NOMBRE NOMBRE
      {
      		log_info("Instruction STORE détectée entre les registres %d et %d", $2, $3);
			tab_asm_add("STORE", $2, $3);
      }
    ;

%%

int main(void) {
	#if YYDEBUG
	yydebug = 0;
	#endif

	tab_asm_init();
	memory_init();

	log_info("Début du parsing de l'assembleur");
	yyparse();
	log_info("Fin du parsing de l'assembleur");

	log_info("Evaluation de l'assembleur");

	int current_index = 0;
	int max_index = tab_asm_get_last_index();
	asm_instruction current_instruction;

	while(current_index <= max_index) {
		current_instruction = tab_asm_get_instruction(current_index);

		log_info("Instruction évaluée : %s %d %d", current_instruction.id, current_instruction.registers[0], current_instruction.registers[1]);

		if(strcmp(current_instruction.id, "ADD") == 0) {
			set_register(current_instruction.registers[0] , access_register(current_instruction.registers[0]) + access_register(current_instruction.registers[1]));
		}

		else if(strcmp(current_instruction.id, "SUB") == 0) {
				set_register(current_instruction.registers[0] , access_register(current_instruction.registers[0]) - access_register(current_instruction.registers[1]));
		}

		else if(strcmp(current_instruction.id, "MUL") == 0) {
            set_register(current_instruction.registers[0] , access_register(current_instruction.registers[0]) * access_register(current_instruction.registers[1]));
        }

        else if(strcmp(current_instruction.id, "DIV") == 0) {
           	if(access_register(current_instruction.registers[1]) == 0)
           		log_error("Division par zéro");
           	else
           		set_register(current_instruction.registers[0] , access_register(current_instruction.registers[0]) / access_register(current_instruction.registers[1]));
		}

		else if(strcmp(current_instruction.id, "AFC") == 0) {
        	set_register(current_instruction.registers[0], current_instruction.registers[1]);
        }

        else if(strcmp(current_instruction.id, "LOAD") == 0) {
			set_register(current_instruction.registers[0], access_memory(current_instruction.registers[1]));
        }

		else if(strcmp(current_instruction.id, "STORE") == 0) {
			set_memory(current_instruction.registers[0], access_register(current_instruction.registers[1]));
		}

		else {
			log_error("Instruction %s non supportée", current_instruction.id);
		}

		current_index++;
	}

	log_info("Dump de la mémoire");
	dump_memory();

	if(logger_get_nb_errors())
		printf("Echec de la traduction assembleur : %d erreur(s) rencontrée(s)\n", logger_get_nb_errors());
	else
		printf("Ok\n");
}
