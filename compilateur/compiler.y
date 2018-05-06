%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <errno.h>
#include <unistd.h>
#include "compilateur/table_symboles.h"
#include "compilateur/table_asm.h"
#include "compilateur/table_blocs_conditionnels.h"
#include "logger/logger.h"

#define YYDEBUG 1
int yylex();
void yyerror(char *s) {
	log_error(s);
}
extern int yylineno;

int initialisee = 0; // Entier pour indiquer la variable considérée par le parseur est inistialisée ou non
int constante = 0; // Entier pour indiquer la variable considérée par le parseur est une constante ou non
enum enumType decl_type; // Type de la variable considérée par le parseur

%}

%union {
	int intValue;
	float floatValue;
	char *stringValue;
}

%token <intValue> NOMBRE
%token <floatValue> FLOTTANT
%token <stringValue> TEXT
%token PLUS SUB MULT DIV POW
%token PARENTHESE_OUVRANTE PARENTHESE_FERMANTE
%token ACCOLADE_OUVRANTE ACCOLADE_FERMANTE
%token EQUALS LESS_EQUALS GREATER_EQUALS GREATER LESS
%token SEMICOLON
%token INT
%token FLOAT
%token STRING
%token CONST
%token <stringValue> VAR
%token SEPARATEUR
%token ASSIGN
%token WHILE
%token FOR
%token IF
%token ELSE
%token QUESTION_MARK
%token COLON

%left PLUS SUB
%left MULT DIV

%right POW 
%right ASSIGN
%right EQUALS LESS_EQUALS GREATER_EQUALS GREATER LESS

%type <expr> Expr
%union {int expr;}

%start Input

%%

Input:
	  /* empty */
	| Input Line
	;

Line:
	  SEMICOLON
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
	| FLOAT
		{
			decl_type = FLOAT_TYPE;
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
	}
	| VAR Assignation
	{
		log_info("Déclaration d'une variable nommée %s (initialisé : %d, constante : %d)", $1, initialisee, constante);
		tab_symboles_add($1, decl_type, initialisee, constante);
	}
	;

Affectation:
	  VAR Assignation SEMICOLON
	{
		log_info("Variable modifiée : %s", $1);
		int is_constant = tab_symboles_is_constant($1);

		if(is_constant == 1) {
			log_error_with_line_number(yylineno, "La variable %s est une constante et ne peut être modifiée", $1);
		} else if(is_constant != -1 && initialisee) {
			symbole tmp = tab_symboles_unstack();
			tab_asm_add("LOAD", 0, tmp.address);
			tab_asm_add("STORE", tab_symboles_get_address($1), 0);
		}
	}
	;

Assignation:
	  /* empty */
		{
			initialisee = 0;
		}
	| ASSIGN Expr
		{
			initialisee = 1;
		}
	| ASSIGN BlocIfTernaire
		{
			initialisee = 1;
		}
	;

BlocFonction:
	  Type VAR PARENTHESE_OUVRANTE Liste_params PARENTHESE_FERMANTE ACCOLADE_OUVRANTE { tab_symboles_increase_depth(); } Input ACCOLADE_FERMANTE { tab_symboles_decrease_depth(); }
	;

AppelFonction:
	   VAR PARENTHESE_OUVRANTE Liste_params PARENTHESE_FERMANTE SEMICOLON
	;

Liste_params:
	  /* empty */
	| Params
	| Liste_params SEPARATEUR Params
	;

Params:
	  VAR
	| TEXT
	| NOMBRE
	;

Operation:
	  Expr
	| AppelFonction
	;

BlocIf:
	  IF PARENTHESE_OUVRANTE Expr
	   	{
			tab_symboles_add(strdup("###"), INT_TYPE, 1, 1);
			tab_asm_add("JMPC", tab_symboles_get_last_index(), -1);
			symbole tmp = tab_symboles_unstack();
			tab_blocs_conditionnels_add_source_address(tab_asm_get_last_line());
	   	}
	  PARENTHESE_FERMANTE ACCOLADE_OUVRANTE { tab_symboles_increase_depth(); } Input ACCOLADE_FERMANTE
	  	{
	  		tab_symboles_decrease_depth();
			tab_blocs_conditionnels_set_destination_address(tab_asm_get_last_line() + 1);
			tab_blocs_conditionnels_add_source_address(tab_asm_get_last_line());
			tab_asm_add("JMP", -1, -1);
	  	} BlocElse
	;

BlocIfTernaire:
	  Expr QUESTION_MARK Operation COLON Operation
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
	  Expr
	  	{
	  		tab_blocs_conditionnels_add_source_address(tab_asm_get_last_line());
	  		tab_symboles_add(strdup("###"), INT_TYPE, 1, 1);
			tab_asm_add("JMPC", tab_symboles_get_last_index(), -1);
			symbole tmp = tab_symboles_unstack();
	  	}
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
	  NOMBRE
	{
		tab_symboles_add(strdup("###"),	INT_TYPE, 1, 1);
		tab_asm_add("AFC", 0, $1);
		tab_asm_add("STORE", tab_symboles_get_last_address(), 0);
		$$=tab_symboles_get_last_address();
	}	
	| FLOTTANT
	{
		tab_symboles_add(strdup("###"), FLOAT_TYPE, 1, 1);
		tab_asm_add("AFC", 0, $1);
		tab_asm_add("STORE", tab_symboles_get_last_address(), 0);
		$$=tab_symboles_get_last_address();
	}
	| TEXT
	{
		$$=tab_symboles_get_last_address();
	}
	| VAR	
	{
		tab_symboles_add(strdup("###"), INT_TYPE, 1, 1);
		tab_asm_add("LOAD", 0, tab_symboles_get_address($1));
		tab_asm_add("STORE", tab_symboles_get_last_address(), 0);
		$$=tab_symboles_get_last_address();
	}	
	| SUB Expr
	{
		tab_asm_add("NEG", $2, -1);
		$$ = $2;
	} %prec MULT
	| Expr PLUS Expr	
	{
		tab_asm_add("ADD", $1, $3);
		tab_symboles_unstack();
		$$=$1;
	}			
	| Expr SUB Expr	
	{
		tab_asm_add("SUB", $1, $3);
		tab_symboles_unstack();
		$$=$1;
	}									
	| Expr MULT Expr	
	{
		tab_asm_add("MUL", $1, $3);
		tab_symboles_unstack();
		$$=$1;
	}				
	| Expr DIV Expr	
	{
		tab_asm_add("DIV", $1, $3);
		tab_symboles_unstack();
		$$=$1;
	}				
	| Expr POW Expr				
	| Expr GREATER_EQUALS Expr
	{
        tab_asm_add("LOAD", 0, $1);
        tab_asm_add("STORE", tab_symboles_get_last_address()+1, 0);
        tab_asm_add("SUB", tab_symboles_get_last_address()+1, $3);
        tab_asm_add("CMP", tab_symboles_get_last_address()+1, 1);
    	$$=tab_symboles_get_last_address()+1;
    }
	| Expr LESS_EQUALS Expr
	{
        tab_asm_add("LOAD", 0, $1);
        tab_asm_add("STORE", tab_symboles_get_last_address()+1, 0);
      	tab_asm_add("SUB", tab_symboles_get_last_address()+1, $3);
       	tab_asm_add("CMP", tab_symboles_get_last_address()+1, -1);
       	$$=tab_symboles_get_last_address()+1;
    }
	| Expr LESS Expr
	{
       	tab_asm_add("LOAD", 0, $1);
    	tab_asm_add("STORE", tab_symboles_get_last_address()+1, 0);
       	tab_asm_add("SUB", tab_symboles_get_last_address()+1, $3);
       	tab_asm_add("CMP", tab_symboles_get_last_address()+1, -2);
       	$$=tab_symboles_get_last_address()+1;
    }
	| Expr GREATER Expr
	{
    	tab_asm_add("LOAD", 0, $1);
    	tab_asm_add("STORE", tab_symboles_get_last_address()+1, 0);
    	tab_asm_add("SUB", tab_symboles_get_last_address()+1, $3);
    	tab_asm_add("CMP", tab_symboles_get_last_address()+1, 2);
    	$$=tab_symboles_get_last_address()+1;
    }
	| Expr EQUALS Expr
	{
		tab_asm_add("LOAD", 0, $1);
    	tab_asm_add("STORE", tab_symboles_get_last_address()+1, 0);
		tab_asm_add("SUB", tab_symboles_get_last_address()+1, $3);
		tab_asm_add("CMP", tab_symboles_get_last_address()+1, 0);
		$$=tab_symboles_get_last_address()+1;
	}
	| PARENTHESE_OUVRANTE Expr PARENTHESE_FERMANTE
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
	yyparse();

	tab_asm_set_correct_addresses_blocs_conditionnels();

	if(logger_get_nb_errors())
		log_info("Echec de la compilation : %d erreur(s) rencontrée(s)\n", logger_get_nb_errors());
	else
		tab_asm_write_file();
}

