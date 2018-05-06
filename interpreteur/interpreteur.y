%{
#include <stdio.h>
#include <string.h>
#include "interpreteur/table_instructions.h"
#include "interpreteur/memory.h"
#include "logger/logger.h"

#define YYDEBUG 1
int yylex();
void yyerror(char *s) {
	log_error("Erreur de syntaxe");
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
%token NEG
%token MUL
%token DIV

%token JMP
%token JMPC

%token AFC

%token CMP

%start Input

%%

Input:
	  /* empty */
	| Input Line
	;

Line:
      Addition
    | Soustraction
    | Negation
    | Multiplication
    | Division
    | Affectation
    | Chargement
    | Memorisation
    | Jump
    | JumpC
    | Compraison
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

Jump:
	  JMP NOMBRE
	  {
	  	   	log_info("Instruction JMP détectée à l'adresse %d", $2);
	  	   	tab_asm_add("JMP", $2, -1);
	  }
	;

JumpC:
	  JMPC NOMBRE NOMBRE
	  {
	  	   	log_info("Instruction JMPC détectée aux adresses %d et %d", $2, $3);
	  	   	tab_asm_add("JMPC", $2, $3);
	  }
	;

Negation:
	  NEG NOMBRE
	  {
	  		log_info("Négation de l'adresse %d", $2);
	  		tab_asm_add("NEG", $2, -1);
	  }
	;

Compraison:
	  CMP NOMBRE NOMBRE
	  {
	  		log_info("Comparaison de l'adresse %d selon la méthode %d", $2, $3);
	  		tab_asm_add("CMP", $2, $3);
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
	log_info("On considère que le fichier assembleur commence à la ligne 0");

	int current_index = 0;
	int max_index = tab_asm_get_last_index();
	asm_instruction current_instruction;

	while(current_index <= max_index) {
		current_instruction = tab_asm_get_instruction(current_index);

		if(strcmp(current_instruction.id, "JMP") ==  0 || strcmp(current_instruction.id, "NEG") == 0)
			log_info("Instruction évaluée : %s %d", current_instruction.id, current_instruction.registers[0]);
		else
			log_info("Instruction évaluée : %s %d %d", current_instruction.id, current_instruction.registers[0], current_instruction.registers[1]);

		if(strcmp(current_instruction.id, "ADD") == 0) {
			set_memory(current_instruction.registers[0], access_memory(current_instruction.registers[0]) + access_memory(current_instruction.registers[1]));
		}

		else if(strcmp(current_instruction.id, "SUB") == 0) {
			set_memory(current_instruction.registers[0], access_memory(current_instruction.registers[0]) - access_memory(current_instruction.registers[1]));
		}

		else if(strcmp(current_instruction.id, "MUL") == 0) {
            set_memory(current_instruction.registers[0], access_memory(current_instruction.registers[0]) * access_memory(current_instruction.registers[1]));
        }

        else if(strcmp(current_instruction.id, "DIV") == 0) {
           	if(access_memory(current_instruction.registers[1]) == 0)
           		log_error("Division par zéro");
           	else
           		set_memory(current_instruction.registers[0] , access_memory(current_instruction.registers[0]) / access_memory(current_instruction.registers[1]));
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

		else if(strcmp(current_instruction.id, "NEG") == 0) {
        	set_memory(current_instruction.registers[0], - access_memory(current_instruction.registers[0]));
       	}

       	else if(strcmp(current_instruction.id, "JMP") == 0) {
       	    log_info("Saut à la ligne %d du fichier assembleur", current_instruction.registers[0]);
           	current_index = current_instruction.registers[0];
           	continue;
       	}

       	else if(strcmp(current_instruction.id, "JMPC") == 0) {
			if(access_memory(current_instruction.registers[0]) == 0) {
				log_info("Saut à la ligne %d du fichier assembleur", current_instruction.registers[1]);
				current_index = current_instruction.registers[1];
				continue;
			}
        }

        else if(strcmp(current_instruction.id, "CMP") == 0) {
			switch(current_instruction.registers[1]) {
				case -2: 	// LESS
					if(access_memory(current_instruction.registers[0]) < 0) {
						set_memory(current_instruction.registers[0], 1);
					} else {
						set_memory(current_instruction.registers[0], 0);
					}
					break;
				case -1: 	// LESS OR EQUAL
					if(access_memory(current_instruction.registers[0]) <= 0) {
                    	set_memory(current_instruction.registers[0], 1);
                    } else {
                    	set_memory(current_instruction.registers[0], 0);
                    }
					break;
				case 0: 	// EQUAL
					if(access_memory(current_instruction.registers[0]) == 0) {
                    	set_memory(current_instruction.registers[0], 1);
                    } else {
                    	set_memory(current_instruction.registers[0], 0);
                    }
					break;
				case 1:		// GREATER OR EQUAL
					if(access_memory(current_instruction.registers[0]) >= 0) {
						set_memory(current_instruction.registers[0], 1);
					} else {
						set_memory(current_instruction.registers[0], 0);
					}
					break;
				case 2:		// GREATER
					if(access_memory(current_instruction.registers[0]) > 0) {
						set_memory(current_instruction.registers[0], 1);
					} else {
						set_memory(current_instruction.registers[0], 0);
					}
					break;
				default:
					log_error("Méthode de comparaison inconnue");
					break;
			}
        }

		else {
			log_error("Instruction %s non supportée", current_instruction.id);
		}

		current_index++;
	}

	log_info("Dump de la mémoire");
	dump_memory();

	if(logger_get_nb_errors())
		log_info("Echec de la traduction assembleur : %d erreur(s) rencontrée(s)\n", logger_get_nb_errors());
	else
		log_info("L'interprétation du fichier assembleur s'est déroulée correctement.\n");
}
