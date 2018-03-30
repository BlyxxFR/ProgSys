%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "source/table_symboles.h"

#define YYDEBUG 1
int yylex();
void yyerror(char *s) {
  printf("%s\n",s);
}

int constante; // Entier pour indiquer la variable considérée par le parseur est une constante ou non
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
	| Type Assignation
	| CONST Type { constante = 1; } Assignation { constante = 0; }
	| Assignation	
	| BlocIf
	| BlocWhile
	;

Type:
	  INT																											{ decl_type = INT_TYPE; }
	| FLOAT 																										{ decl_type = FLOAT_TYPE; }
	| STRING																										{ decl_type = STRING_TYPE; }
	;

Assignation:
	  VAR SEMICOLON																									{ tab_symboles_add($1, decl_type, 0, constante); }
	| VAR ASSIGN Expr SEMICOLON																						{ tab_symboles_add($1, decl_type, 1, constante); }
	| VAR ASSIGN BlocIfTernaire SEMICOLON																			{ tab_symboles_add($1, decl_type, 1, constante); }
	| VAR SEPARATEUR Assignation																					{ tab_symboles_add($1, decl_type, 0, constante); }
	| VAR ASSIGN Expr SEPARATEUR Assignation																		{ tab_symboles_add($1, decl_type, 1, constante); }			
	| VAR ASSIGN BlocIfTernaire SEPARATEUR Assignation																{ tab_symboles_add($1, decl_type, 1, constante); }	
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
	| FLOTTANT
	| TEXT
	| VAR	
	| SUB Expr							
	| Expr PLUS Expr							
	| Expr SUB Expr																		
	| Expr MULT Expr								
	| Expr DIV Expr								
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
    yyparse();
}

