%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "source/table_symboles.h"
#include "source/table_asm.h"

#define YYDEBUG 1
int yylex();
void yyerror(char *s) {
  printf("%s\n",s);
}

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
%token ELSEIF
%token ELSE
%token QUESTION_MARK
%token COLON

%left PLUS SUB
%left MULT DIV

%right POW 
%right ASSIGN
%right EQUALS LESS_EQUALS GREATER_EQUALS GREATER LESS

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
	  INT																											{ decl_type = INT_TYPE; }
	| FLOAT 																										{ decl_type = FLOAT_TYPE; }
	| STRING																										{ decl_type = STRING_TYPE; }
	;

Declaration:
	Type Declaration_liste_vars SEMICOLON
	;

Declaration_liste_vars:
	  VAR Assignation SEPARATEUR Declaration_liste_vars
		{ 		
			if(initialisee) {
				symbole tmp = tab_symboles_unstack();
				tab_symboles_add($1, decl_type, initialisee, constante); tab_symboles_print(); 
			} else {
				tab_symboles_add($1, decl_type, initialisee, constante); tab_symboles_print(); 
			}
		}
	| VAR Assignation
		{ 		
			if(initialisee) {
				symbole tmp = tab_symboles_unstack();
				tab_symboles_add($1, decl_type, initialisee, constante); tab_symboles_print(); 
			} else {
				tab_symboles_add($1, decl_type, initialisee, constante); tab_symboles_print(); 
			}
		}
	;

Affectation:
	  VAR Assignation SEMICOLON
		{
			printf("Var modifiée : %s\n", $1);
			table_asm_add("LOAD", 0, tab_symboles_get_last_address(), -1);
			symbole tmp = tab_symboles_unstack();
			table_asm_add("STORE", tab_symboles_get_address($1), 0, -1);
		}
	;

Assignation:
	  /* empty */ 																								    { initialisee = 0; }
	| ASSIGN Expr																									{ initialisee = 1; }			
	| ASSIGN BlocIfTernaire																							{ initialisee = 1; }
	;

BlocFonction:
	  Type VAR PARENTHESE_OUVRANTE Liste_params PARENTHESE_FERMANTE ACCOLADE_OUVRANTE { tab_symboles_increase_depth(); } Input ACCOLADE_FERMANTE { tab_symboles_decrease_depth(); } 
	;

AppelFonction:
	  VAR PARENTHESE_OUVRANTE Liste_params PARENTHESE_FERMANTE SEMICOLON
	;

Liste_params:
	  /* empty */
	| VAR
	| Liste_params SEPARATEUR VAR
	;

Operation:
	  Expr
	| AppelFonction
	;

BlocIf:
	  IF Expr ACCOLADE_OUVRANTE { tab_symboles_increase_depth(); } Input ACCOLADE_FERMANTE { tab_symboles_decrease_depth(); } BlocElse													
	;

BlocIfTernaire:
	  Expr QUESTION_MARK Operation COLON Operation
	;

BlocElse:
	  /* empty */
	| ELSEIF Expr ACCOLADE_OUVRANTE { tab_symboles_increase_depth(); } Input ACCOLADE_FERMANTE { tab_symboles_decrease_depth(); } BlocElse 
	| ELSE ACCOLADE_OUVRANTE { tab_symboles_increase_depth(); } Input ACCOLADE_FERMANTE { tab_symboles_decrease_depth(); }
	;


BlocWhile:
	  WHILE Expr ACCOLADE_OUVRANTE { tab_symboles_increase_depth(); } Input ACCOLADE_FERMANTE { tab_symboles_decrease_depth(); }
	;

Expr:
	  NOMBRE
		{
			tab_symboles_add(strdup("###"),	INT_TYPE, 1, 1);
			table_asm_add("AFC", 0, $1, -1);
			table_asm_add("STORE", tab_symboles_get_last_address(), 0, -1);
		}	
	| FLOTTANT
		{
			tab_symboles_add(strdup("###"), FLOAT_TYPE, 1, 1);
			table_asm_add("AFC", 0, $1, -1);
			table_asm_add("STORE", tab_symboles_get_last_address(), 0, -1);
		}
	| TEXT
	| VAR	
		{
			tab_symboles_add(strdup("###"), INT_TYPE, 1, 1);
			table_asm_add("LOAD", 0, tab_symboles_get_address($1), -1);
			table_asm_add("STORE", tab_symboles_get_last_address(), 0, -1);
		}	
	| SUB Expr %prec MULT							
	| Expr PLUS Expr	
		{
			symbole tmp = tab_symboles_unstack();
			table_asm_add("LOAD", 0, tmp.address, -1);
			tmp = tab_symboles_unstack();
			table_asm_add("LOAD", 1, tmp.address, -1);
			table_asm_add("ADD", 0, 1, -1);
			table_asm_add("STORE", tab_symboles_get_last_address(), 0, -1);
		}						
	| Expr SUB Expr	
		{
			symbole tmp = tab_symboles_unstack();
			table_asm_add("LOAD", 0, tmp.address, -1);
			tmp = tab_symboles_unstack();
			table_asm_add("LOAD", 1, tmp.address, -1);
			table_asm_add("SUB", 0, 1, -1);
			table_asm_add("STORE", tab_symboles_get_last_address(), 0, -1);
		}																		
	| Expr MULT Expr	
		{
			symbole tmp = tab_symboles_unstack();
			table_asm_add("LOAD", 0, tmp.address, -1);
			tmp = tab_symboles_unstack();
			table_asm_add("LOAD", 1, tmp.address, -1);
			table_asm_add("MUL", 0, 1, -1);
			table_asm_add("STORE", tab_symboles_get_last_address(), 0, -1);
		}								
	| Expr DIV Expr		
		{
			symbole tmp = tab_symboles_unstack();
			table_asm_add("LOAD", 0, tmp.address, -1);
			tmp = tab_symboles_unstack();
			table_asm_add("LOAD", 1, tmp.address, -1);
			table_asm_add("DIV", 0, 1, -1);
			table_asm_add("STORE", tab_symboles_get_last_address(), 0, -1);
		}							
	| Expr POW Expr								
	| Expr GREATER_EQUALS Expr 				
	| Expr LESS_EQUALS Expr 			
	| Expr LESS Expr 			
	| Expr GREATER Expr 			
	| Expr EQUALS Expr		
	| PARENTHESE_OUVRANTE Expr PARENTHESE_FERMANTE	
	;	

%%

int main(void) {
	#if YYDEBUG
		yydebug = 0;
	#endif
	
	tab_symboles_init();
	table_asm_init();
    yyparse();
	table_asm_write_file();
}

