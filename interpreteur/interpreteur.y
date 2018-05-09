%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "interpreteur/table_instructions.h"
#include "interpreteur/memory.h"
#include "interpreteur/stack.h"
#include "logger/logger.h"

#define ENTRIES_MEMORY_TO_DUMP 10

#define YYDEBUG 1
int yylex();
extern int yylineno;
void yyerror(char *s) {
	log_error_with_line_number(yylineno, "Erreur de syntaxe");
}

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

%token GE
%token GT
%token LE
%token LT
%token EQ
%token NEQ

%token PRINT

%token PUSH
%token POP
%token RETURN
%token LEAVE

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
    | GreaterEqual
    | GreaterThan
    | LessEqual
    | LessThan
    | Equal
    | NotEqual
    | Print
    | Push
    | Pop
    | Return
    | Leave
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
	  	   	log_info("Instruction JMP à l'adresse %d detectée", $2);
	  	   	tab_asm_add("JMP", $2, -1);
	  }
	;

JumpC:
	  JMPC NOMBRE
	  {
	  	   	log_info("Instruction JMPC à la ligne %d detectée", $2);
	  	   	tab_asm_add("JMPC", $2, -1);
	  }
	;

Negation:
	  NEG NOMBRE
	  {
	  		log_info("Négation de l'adresse %d", $2);
	  		tab_asm_add("NEG", $2, -1);
	  }
	;

GreaterEqual:
	  GE NOMBRE NOMBRE
	  {
	  		log_info("Test si le contenu de l'adresse %d est plus grand ou égal que celui de l'adresse %d", $2, $3);
	  		tab_asm_add("GE", $2, $3);
	  }
	;

GreaterThan:
	  GT NOMBRE NOMBRE
	  {
	  		log_info("Test si le contenu de l'adresse %d est plus grand que celui de l'adresse %d", $2, $3);
	  		tab_asm_add("GT", $2, $3);
	  }
	;

LessEqual:
	  LE NOMBRE NOMBRE
	  {
	  		log_info("Test si le contenu de l'adresse %d est plus petit ou égal que celui de l'adresse %d", $2, $3);
	  		tab_asm_add("LE", $2, $3);
	  }
	;

LessThan:
	  LT NOMBRE NOMBRE
	  {
	  		log_info("Test si le contenu de l'adresse %d est plus petit que celui de l'adresse %d", $2, $3);
	  		tab_asm_add("LT", $2, $3);
	  }
	;

Equal:
	  EQ NOMBRE NOMBRE
	  {
	  		log_info("Test si le contenu de l'adresse %d est égal à celui de l'adresse %d", $2, $3);
	  		tab_asm_add("EQ", $2, $3);
	  }
	;

NotEqual:
	  NEQ NOMBRE NOMBRE
	  {
	  		log_info("Test si le contenu de l'adresse %d est différent de celui de l'adresse %d", $2, $3);
	  		tab_asm_add("NEQ", $2, $3);
	  }
	;

Print:
	  PRINT NOMBRE
	  {
	  		log_info("On affiche le contenu de l'adresse %d", $2);
	  		tab_asm_add("PRINT", $2, -1);
	  }
	;

Push:
	  PUSH NOMBRE
	  {
	  		log_info("On pousse l'adresse %d dans la pile", $2);
	  		tab_asm_add("PUSH", $2, -1);
	  }
	;

Leave:
	  LEAVE
	  {
	  		log_info("Instruction pour quitter le programme principal détecté");
	  		tab_asm_add("LEAVE", -1, -1);
	  }
	;

Pop:
	  POP NOMBRE
	  {
	  		log_info("On dépile dans le registre %d", $2);
	  		tab_asm_add("POP", $2, -1);
	  }
	;

Return:
	  RETURN NOMBRE
	  {
	  		log_info("On saute à la ligne contenu dans le registre %d", $2);
	  		tab_asm_add("RETURN", $2, -1);
	  }
	;

%%

int main(void) {
	#if YYDEBUG
	yydebug = 0;
	#endif

	//logger_set_mode(LOGGER_SILENT);

	tab_asm_init();
	memory_init();
	stack_init();

	log_info("Début du parsing de l'assembleur");
	yyparse();
	log_info("Fin du parsing de l'assembleur");

	log_info("Evaluation de l'assembleur");
	log_info("On considère que le fichier assembleur commence à la ligne 0");

	int current_index = 0;
	int last_comparaison = 0;
	int max_index = tab_asm_get_last_index();
	asm_instruction current_instruction;

	while(current_index <= max_index) {
		current_instruction = tab_asm_get_instruction(current_index);

		if(strcmp(current_instruction.id, "JMP") ==  0 || strcmp(current_instruction.id, "NEG") == 0 ||
		   strcmp(current_instruction.id, "PUSH") ==  0 || strcmp(current_instruction.id, "POP") ==  0 ||
		   strcmp(current_instruction.id, "PRINT") ==  0 || strcmp(current_instruction.id, "RETURN") ==  0 ||
		   strcmp(current_instruction.id, "JMPC") ==  0)
			log_info("Instruction évaluée : %s %d", current_instruction.id, current_instruction.registers[0]);
		else if(strcmp(current_instruction.id, "LEAVE") ==  0)
			log_info("Instruction évaluée : %s", current_instruction.id);
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

		else if(strcmp(current_instruction.id, "PUSH") == 0) {
        	stack_push(access_memory(current_instruction.registers[0]));
       	}

		else if(strcmp(current_instruction.id, "POP") == 0) {
        	set_register(current_instruction.registers[0], stack_pop());
       	}

		else if(strcmp(current_instruction.id, "PRINT") == 0) {
        	log_print("Affichage de la valeur %d", access_memory(current_instruction.registers[0]));
       	}

		else if(strcmp(current_instruction.id, "RETURN") == 0) {
        	current_index = access_register(current_instruction.registers[0]);
            continue;
       	}

       	else if(strcmp(current_instruction.id, "JMP") == 0) {
       	    log_info("Saut à la ligne %d du fichier assembleur", current_instruction.registers[0]);
           	current_index = current_instruction.registers[0];
           	continue;
       	}

       	else if(strcmp(current_instruction.id, "JMPC") == 0) {
			if(last_comparaison <= 0) {
				log_info("Saut à la ligne %d du fichier assembleur", current_instruction.registers[0]);
				current_index = current_instruction.registers[0];
				continue;
			}
        }

        else if(strcmp(current_instruction.id, "GE") == 0) {
			last_comparaison = access_memory(current_instruction.registers[0]) >= access_memory(current_instruction.registers[1]);
			log_info("Résultat de la comparaison : %d", last_comparaison);
        }

        else if(strcmp(current_instruction.id, "GT") == 0) {
			last_comparaison = access_memory(current_instruction.registers[0]) > access_memory(current_instruction.registers[1]);
			log_info("Résultat de la comparaison : %d", last_comparaison);
        }

        else if(strcmp(current_instruction.id, "LE") == 0) {
			last_comparaison = access_memory(current_instruction.registers[0]) <= access_memory(current_instruction.registers[1]);
			log_info("Résultat de la comparaison : %d", last_comparaison);
        }

        else if(strcmp(current_instruction.id, "LT") == 0) {
			last_comparaison = access_memory(current_instruction.registers[0]) < access_memory(current_instruction.registers[1]);
			log_info("Résultat de la comparaison : %d", last_comparaison);
        }

        else if(strcmp(current_instruction.id, "EQ") == 0) {
			last_comparaison = access_memory(current_instruction.registers[0]) == access_memory(current_instruction.registers[1]);
			log_info("Résultat de la comparaison : %d", last_comparaison);
        }

        else if(strcmp(current_instruction.id, "NEQ") == 0) {
			last_comparaison = access_memory(current_instruction.registers[0]) != access_memory(current_instruction.registers[1]);
			log_info("Résultat de la comparaison : %d", last_comparaison);
        }

        else if(strcmp(current_instruction.id, "LEAVE") == 0) {
        	log_info("Programme principal terminé");
			break;
        }

		else {
			log_error("Instruction %s non supportée", current_instruction.id);
		}

		current_index++;
	}

	log_info("Fin de l'évaluation");
	log_info("Dump de la mémoire pour %d entrées", ENTRIES_MEMORY_TO_DUMP);
	dump_memory(ENTRIES_MEMORY_TO_DUMP);

	if(logger_get_nb_errors())
		log_info("Echec de la traduction assembleur : %d erreur(s) rencontrée(s)\n", logger_get_nb_errors());
	else
		log_info("L'interprétation du fichier assembleur s'est déroulée correctement.\n");
}
