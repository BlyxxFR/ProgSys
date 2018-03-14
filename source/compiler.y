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

%union {
	int intValue;
	float floatValue;
    char *string;
}

%token <intValue> NOMBRE
%token <floatValue> FLOTTANT
%token PLUS SUB MULT DIV POW
%token PARENTHESE_OUVRANTE PARENTHESE_FERMANTE
%token ACCOLADE_OUVRANTE ACCOLADE_FERMANTE
%token EQUALS LESS_EQUALS GREATER_EQUALS GREATER LESS
%token SEMICOLON
%token INT
%token CONST
%token VAR
%token SEPARATEUR
%token ASSIGN
%token WHILE
%token IF
%token ELSEIF
%token ELSE
%token QUESTION_MARK
%token COLON

%left PLUS SUB
%left MULT DIV

%right POW 
%right ASSIGN EQUALS LESS_EQUALS GREATER_EQUALS GREATER LESS

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
	| CONST Type Assignation
	| Assignation	
	| BlocIf
	| BlocWhile
	;

Type:
	  INT
	;

Assignation:
	  VAR SEMICOLON
	| VAR SEPARATEUR Assignation
	| VAR ASSIGN Expr SEMICOLON
	| VAR ASSIGN BlocIfTernaire SEMICOLON
	;

BlocFonction:
	  Type VAR PARENTHESE_OUVRANTE Liste_params PARENTHESE_FERMANTE ACCOLADE_OUVRANTE Input ACCOLADE_FERMANTE
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
	  IF Expr ACCOLADE_OUVRANTE Input ACCOLADE_FERMANTE BlocElse
	;

BlocIfTernaire:
	  Expr QUESTION_MARK Operation COLON Operation
	;

BlocElse:
	  /* empty */
	| ELSEIF Expr ACCOLADE_OUVRANTE Input ACCOLADE_FERMANTE BlocElse 
	| ELSE ACCOLADE_OUVRANTE Input ACCOLADE_FERMANTE
	;


BlocWhile:
	  WHILE Expr ACCOLADE_OUVRANTE Input ACCOLADE_FERMANTE
	;

Expr:
	  NOMBRE	
	| FLOTTANT
	| VAR	
	| SUB Expr							
	| Expr PLUS Expr				{ 			
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
	
    yyparse();
}

