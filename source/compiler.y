%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#define YYSTYPE double
#define YYDEBUG 1
extern YYSTYPE yylval;

int yylex();
void yyerror(char *s) {
  printf("%s\n",s);
}
%}

%token NOMBRE
%token PLUS SUB MULT DIV POW
%token PARENTHESE_OUVRANTE PARENTHESE_FERMANTE
%token ACCOLADE_OUVRANTE ACCOLADE_FERMANTE
%token SEMICOLON
%token INT
%token CONST
%token VAR
%token SEPARATEUR
%token ASSIGN

%left PLUS SUB
%left MULT DIV

%right POW

%start Input

%%

Input:
	  /* empty */
	| Input Line
	;

Line:
	  SEMICOLON
	| Fonction SEMICOLON	
	| Type Assignation SEMICOLON
	| Assignation SEMICOLON
	| error SEMICOLON					     { yyerrok; }
	;

Type:
	  INT
	| CONST
	;

Assignation:
	  VAR
	| VAR SEPARATEUR Assignation
	| VAR ASSIGN Expr 
	;

Fonction:
	  Type VAR PARENTHESE_OUVRANTE Liste_params PARENTHESE_FERMANTE ACCOLADE_OUVRANTE Line ACCOLADE_FERMANTE
	;

Liste_params:
	  /* empty */
	| Liste_params SEPARATEUR  
	;

Expr:
	  NOMBRE									{ $$ = $1; }
	| Expr PLUS Expr							{ $$ = $1 + $3; }
	| Expr SUB Expr								{ $$ = $1 - $3; }
	| SUB Expr									{ $$ = - $2; }
	| Expr MULT Expr							{ $$ = $1 * $3; }	
	| Expr DIV Expr								{ $$ = $1 / $3; }
	| Expr POW Expr								
	| PARENTHESE_OUVRANTE Expr PARENTHESE_FERMANTE	{ $$ = $2; }							
	;

%%

int main(void) {
  yyparse();
}

