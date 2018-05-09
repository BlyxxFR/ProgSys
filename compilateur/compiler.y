%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <errno.h>
#include <unistd.h>
#include "compilateur/table_symboles.h"
#include "compilateur/table_asm.h"
#include "compilateur/table_blocs_conditionnels.h"
#include "compilateur/table_fonctions.h"
#include "logger/logger.h"

#define YYDEBUG 1
int yylex();
extern int yylineno;

void yyerror(char *s) {
	log_error_with_line_number(yylineno, s);
}

int arguments = 0; 			// Entier permettant de mémoriser le nombre d'arguments quand on appelle une fonction
int initialisee = 0; 		// Entier pour indiquer la variable considérée par le parseur est inistialisée ou non
int constante = 0; 			// Entier pour indiquer la variable considérée par le parseur est une constante ou non
enum enumType decl_type; 	// Type de la variable considérée par le parseur
int line_start_function; 	// Ligne à laquelle commence une fonction

%}

%union {
	int intValue;
	char *stringValue;
}

%token <intValue> NOMBRE
%token <stringValue> TEXT
%token PLUS SUB MULT DIV
%token PARENTHESE_OUVRANTE PARENTHESE_FERMANTE
%token ACCOLADE_OUVRANTE ACCOLADE_FERMANTE
%token EQUALS LESS_EQUALS GREATER_EQUALS GREATER LESS NOTEQUALS
%token SEMICOLON
%token INT
%token STRING
%token FUNCTION
%token CONST
%token <stringValue> VAR
%token SEPARATEUR
%token ASSIGN
%token WHILE
%token PRINT
%token IF
%token ELSE
%token QUESTION_MARK
%token COLON

%left PLUS SUB
%left MULT DIV

%right ASSIGN
%right EQUALS LESS_EQUALS GREATER_EQUALS GREATER LESS

%type<intValue> Assignation
%type<intValue> Expr
%type<intValue> ExpressionArithmetique
%type<intValue> ExpressionLogique

%start Input

%%

Input:
	  /* empty */
	| Input Line
	;

Line:
	  SEMICOLON
	| Print
	| BlocFonction 	
	| AppelFonction
	| Declaration
	| CONST { constante = 1; } Declaration { constante = 0; }
	| Affectation
	| BlocIf
	| BlocWhile
	;

Type:
	  INT
		{
			decl_type = INT_TYPE;
		}
	| STRING
		{
			decl_type = STRING_TYPE;
		}
	;

Declaration:
	  Type Declaration_liste_vars SEMICOLON
	;

Declaration_liste_vars:
	  VAR Assignation SEPARATEUR Declaration_liste_vars
	{
		log_info("Déclaration d'une variable nommée %s (initialisé : %d, constante : %d)", $1, initialisee, constante);
		tab_symboles_add($1, decl_type, initialisee, constante);
		int address = tab_symboles_get_last_address();
		if(initialisee) {
        	tab_asm_add("LOAD", 0, $2);
        	tab_asm_add("STORE", address, 0);
        }
	}
	| VAR Assignation
	{
		log_info("Déclaration d'une variable nommée %s (initialisé : %d, constante : %d)", $1, initialisee, constante);
		tab_symboles_add($1, decl_type, initialisee, constante);
		int address = tab_symboles_get_last_address();
		if(initialisee) {
			tab_asm_add("LOAD", 0, $2);
			tab_asm_add("STORE", address, 0);
		}
	}
	;

Affectation:
	  VAR Assignation SEMICOLON
	{
		log_info_with_line_number(yylineno, "Variable modifiée : %s", $1);
		int is_constant = tab_symboles_is_constant($1);

		if(is_constant == 1) {
			log_error_with_line_number(yylineno, "La variable %s est une constante et ne peut être modifiée", $1);
		} else if(is_constant != -1 && initialisee) {
			tab_asm_add("LOAD", 0, $2);
			tab_asm_add("STORE", tab_symboles_get_address($1), 0);
		}
	}
	;

Assignation:
	  /* empty */
		{
			initialisee = 0;
			$$ = -1;
		}
	| ASSIGN Expr
		{
			initialisee = 1;
			symbole tmp = tab_symboles_unstack();
			$$ = tmp.address;
		}
	;

Print:
	  PRINT PARENTHESE_OUVRANTE Expr
	  	{
	  		log_info_with_line_number(yylineno, "Affichage à l'écran demandé");
	  		tab_asm_add("PRINT", $3, -1);
	  		tab_symboles_unstack();
	  	}
	  PARENTHESE_FERMANTE SEMICOLON
	;

BlocFonction:
	  FUNCTION VAR
	  	{
	  		arguments = 0;
	  		line_start_function = tab_asm_get_last_line();
	  		// Si la fonction que l'on déclare correspond au main, on met à jour l'instruction de saut au tout début du fichier
	  		if(strcmp($2, "main") == 0) {
				tab_asm_set_main_line(line_start_function);
	  		}
	  	}
	  PARENTHESE_OUVRANTE Liste_params_declaration
	  	{
	  		tab_fonctions_add($2, arguments, line_start_function);
	  	}
	  PARENTHESE_FERMANTE ACCOLADE_OUVRANTE { tab_symboles_increase_depth(); } Input ACCOLADE_FERMANTE
	  	{
	  		tab_symboles_decrease_depth();
	  		if(strcmp($2, "main") != 0) {
		  		tab_asm_add("POP", 0, -1);
	  			tab_asm_add("RETURN", 0, -1);
	  		} else {
	  			tab_asm_add("LEAVE", -1, -1);
	  		}
	  	}
	;

Liste_params_declaration:
	  /* empty */
	| Liste_params_declaration_suite
	;

Liste_params_declaration_suite:
	  Params_declaration
    | Liste_params_declaration_suite SEPARATEUR Params_declaration
	;

Params_declaration:
	  Type VAR
	  	{
	  		arguments++;
	  		log_info("Récupération du paramètre %s dans la pile", $2);
	  		tab_symboles_add($2, decl_type, 1, 0);
	  		tab_asm_add("POP", 0, -1);
            tab_asm_add("STORE", tab_symboles_get_last_address(), 0);
	  	}
	  | CONST Type VAR
      	{
      		arguments++;
      		log_info("Récupération du paramètre %s dans la pile", $3);
      	  	tab_symboles_add($3, decl_type, 1, 1);
            tab_asm_add("POP", 0, -1);
            tab_asm_add("STORE", tab_symboles_get_last_address(), 0);
      	}
	;

AppelFonction:
	    VAR PARENTHESE_OUVRANTE
	   	{
	   		arguments = 0 ;
	   		for(int i = 0; i <= tab_symboles_get_last_address(); i++) {
            	tab_asm_add("PUSH", i, -1);
            }
            tab_symboles_add(strdup("###"),	INT_TYPE, 1, 1);
            tab_asm_add("AFC", 0, tab_asm_get_last_line() + 7);
            tab_asm_add("STORE", tab_symboles_get_last_address(), 0);
            tab_asm_add("PUSH", tab_symboles_get_last_address(), -1);
            tab_symboles_unstack();
	   	}
	   	Liste_params PARENTHESE_FERMANTE SEMICOLON
	   	{
	   		int status_appel = tab_fonctions_exists($1, arguments);
			if(status_appel == 1) {
				log_info_with_line_number(yylineno, "Appel de %s avec %d arguments et sauvegrde de la mémoire", $1, arguments);
				tab_asm_add("JMP", tab_fonctions_get_start($1, arguments), -1);
				for(int i = tab_symboles_get_last_address(); i >= 0; i--) {
                	tab_asm_add("POP", 0, -1);
                	tab_asm_add("STORE", i, 0);
                }
			} else if(status_appel == -1) {
				log_error_with_line_number(yylineno, "La fonction %s a été appelée avec un nombre d'argument incorrect", $1);
			} else {
				log_error_with_line_number(yylineno, "La fonction %s n'existe pas", $1);
			}
	   	}
	;

Liste_params:
	  /* empty */
	| Liste_params_suite
	;

Liste_params_suite:
	  Params
    | Liste_params_suite SEPARATEUR Params
	;

Params:
	  Expr
	  	{
	  		arguments++;
	  		tab_asm_add("PUSH", $1, -1);
	  		tab_symboles_unstack();
	  	}
	;

BlocIf:
	  IF PARENTHESE_OUVRANTE SuiteBlocIf
	  ;

SuiteBlocIf:
	  ExpressionArithmetique
		{
			tab_symboles_add(strdup("###"),	INT_TYPE, 1, 1);
           	tab_asm_add("AFC", 0, 0);
           	tab_asm_add("STORE", tab_symboles_get_last_address(), 0);
           	int address_zero = tab_symboles_get_last_address();
           	tab_asm_add("NEQ", $1, address_zero);
			tab_symboles_add(strdup("###"),	INT_TYPE, 1, 1);
    		tab_asm_add("JMPC", -1, -1);
    		tab_symboles_unstack();
    		tab_blocs_conditionnels_add_source_address(tab_asm_get_last_line());
    	}
      FinBlocIf
	| ExpressionLogique
	   	{
			tab_asm_add("JMPC", -1, -1);
			tab_symboles_unstack();
			tab_blocs_conditionnels_add_source_address(tab_asm_get_last_line());
	   	}
	  FinBlocIf
	;

FinBlocIf:
	  PARENTHESE_FERMANTE ACCOLADE_OUVRANTE { tab_symboles_increase_depth(); } Input ACCOLADE_FERMANTE
	  	{
	  		tab_symboles_decrease_depth();
			tab_blocs_conditionnels_set_destination_address(tab_asm_get_last_line() + 1);
			tab_blocs_conditionnels_add_source_address(tab_asm_get_last_line());
			tab_asm_add("JMP", -1, -1);
	  	} BlocElse
	;

BlocElse:
	  /* empty */
	  	{
	  		tab_blocs_conditionnels_set_destination_address(tab_asm_get_last_line());
	  	}
	| ELSE ACCOLADE_OUVRANTE { tab_symboles_increase_depth(); } Input ACCOLADE_FERMANTE
		{
			tab_symboles_decrease_depth();
			tab_blocs_conditionnels_set_destination_address(tab_asm_get_last_line());
		}
	;


BlocWhile:
	  WHILE PARENTHESE_OUVRANTE
	  	{
	  		tab_blocs_conditionnels_add_destination_address(tab_asm_get_last_line());
	  	}
	  SuiteWhile
	;

SuiteWhile:
	  ExpressionArithmetique
	  	{
	  		tab_symboles_add(strdup("###"),	INT_TYPE, 1, 1);
            tab_asm_add("AFC", 0, 0);
            tab_asm_add("STORE", tab_symboles_get_last_address(), 0);
            symbole tmp = tab_symboles_unstack();
            tab_asm_add("NEQ", $1, tmp.address);
	  		tab_blocs_conditionnels_add_source_address(tab_asm_get_last_line() + 1);
	  		tab_symboles_unstack();

			tab_asm_add("JMPC", -1, -1);
	  	} FinWhile
	| ExpressionLogique
	  	{
	  		tab_blocs_conditionnels_add_source_address(tab_asm_get_last_line() + 1);
	  		tab_symboles_unstack();
			tab_asm_add("JMPC", -1, -1);
	  	} FinWhile
	;

FinWhile:
	  PARENTHESE_FERMANTE ACCOLADE_OUVRANTE
	  	{
      		tab_symboles_increase_depth();
      	}
	  Input ACCOLADE_FERMANTE
	  	{
	  		tab_symboles_decrease_depth();
	  		tab_blocs_conditionnels_set_source_address(tab_asm_get_last_line());
	  		tab_asm_add("JMP", -1, -1);
	  		tab_blocs_conditionnels_set_destination_address(tab_asm_get_last_line());
	  	}
	;

Expr:
	  ExpressionArithmetique 	{ $$ = $1; }
	| ExpressionLogique			{ $$ = $1; }
    ;

ExpressionArithmetique:
	  NOMBRE
	{
		tab_symboles_add(strdup("###"),	INT_TYPE, 1, 1);
		tab_asm_add("AFC", 0, $1);
		tab_asm_add("STORE", tab_symboles_get_last_address(), 0);
		$$=tab_symboles_get_last_address();
	}
	| VAR
	{
		tab_symboles_add(strdup("###"), INT_TYPE, 1, 1);
		tab_asm_add("LOAD", 0, tab_symboles_get_address($1));
		tab_asm_add("STORE", tab_symboles_get_last_address(), 0);
		$$=tab_symboles_get_last_address();
	}	
	| SUB ExpressionArithmetique
	{
		tab_asm_add("NEG", $2, -1);
		$$ = $2;
	} %prec MULT
	| ExpressionArithmetique PLUS ExpressionArithmetique
	{
		tab_asm_add("ADD", $1, $3);
		tab_symboles_unstack();
		$$=$1;
	}			
	| ExpressionArithmetique SUB ExpressionArithmetique
	{
		tab_asm_add("SUB", $1, $3);
		tab_symboles_unstack();
		$$=$1;
	}									
	| ExpressionArithmetique MULT ExpressionArithmetique
	{
		tab_asm_add("MUL", $1, $3);
		tab_symboles_unstack();
		$$=$1;
	}				
	| ExpressionArithmetique DIV ExpressionArithmetique
	{
		tab_asm_add("DIV", $1, $3);
		tab_symboles_unstack();
		$$=$1;
	}
	| PARENTHESE_OUVRANTE ExpressionArithmetique PARENTHESE_FERMANTE
	{
		$$=$2;
	}
	;

ExpressionLogique:
	  ExpressionArithmetique GREATER_EQUALS ExpressionArithmetique
	{
		tab_asm_add("GE", $1, $3);
		tab_symboles_add(strdup("###"),	INT_TYPE, 1, 1);
    	$$=tab_symboles_get_last_address();
    }
	| ExpressionArithmetique LESS_EQUALS ExpressionArithmetique
	{
		tab_asm_add("LE", $1, $3);
		tab_symboles_add(strdup("###"),	INT_TYPE, 1, 1);
    	$$=tab_symboles_get_last_address();
    }
	| ExpressionArithmetique LESS ExpressionArithmetique
	{
		tab_asm_add("LT", $1, $3);
		tab_symboles_add(strdup("###"),	INT_TYPE, 1, 1);
    	$$=tab_symboles_get_last_address();
    }
	| ExpressionArithmetique GREATER ExpressionArithmetique
	{
		tab_asm_add("GT", $1, $3);
		tab_symboles_add(strdup("###"),	INT_TYPE, 1, 1);
    	$$=tab_symboles_get_last_address();
    }
	| ExpressionArithmetique EQUALS ExpressionArithmetique
	{
		tab_asm_add("EQ", $1, $3);
		tab_symboles_add(strdup("###"),	INT_TYPE, 1, 1);
    	$$=tab_symboles_get_last_address();
	}
	| ExpressionArithmetique NOTEQUALS ExpressionArithmetique
	{
		tab_asm_add("NEQ", $1, $3);
		tab_symboles_add(strdup("###"),	INT_TYPE, 1, 1);
    	$$=tab_symboles_get_last_address();
	}
	| PARENTHESE_OUVRANTE ExpressionLogique PARENTHESE_FERMANTE
	{
		$$=$2;
	}
	;	

%%

int main(void) {
	#if YYDEBUG
	yydebug = 0;
	#endif
	
	tab_symboles_init();
	tab_asm_init();

	// On ajoute une instruction de saut qui servira à se rendre au main lors du lancement du programme
	tab_asm_add("JMP", -1, -1);

	yyparse();

	tab_asm_set_correct_addresses_blocs_conditionnels();

	if(logger_get_nb_errors())
		log_info("Echec de la compilation : %d erreur(s) rencontrée(s)\n", logger_get_nb_errors());
	else
		tab_asm_write_file();
}

