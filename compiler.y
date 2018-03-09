%token NOMBRE
%token PLUS SUB MULT DIV POW
%token PARENTHESE_OUVRANTE PARENTHESE_FERMANTE
%token ACCOLADE_OUVRANTE ACCOLADE_FERMANTE
%token END_LINE
%token SEMICOLON
%token INT
%token CONST
%token VAR
%token EMPTY
%token SEPARATEUR

%left PLUS SUB
%left MULT DIV

%right POW
%right ASIGN

%start Input

%%

Input:
	| Input Line
	;

Line:						
	| Fonction SEMICOLON	
	| Type Assignation SEMICOLON
	| Assignation SEMICOLON
	;

Type:
	| INT
	| CONST
	;

Assignation:
	| VAR ASIGN Expr 
	;

Fonction:
	| VAR PARENTHESE_OUVRANTE Liste_params PARENTHESE_FERMANTE ACCOLADE_OUVRANTE Line ACCOLADE_FERMANTE
	;

Liste_params:
	| EMPTY
	;

Expr:
	| NOMBRE									{ $$ = $1; }
	| Expr PLUS Expr							{ $$ = $1 + $3; }
	| Expr SUB Expr								{ $$ = $1 - $3; }
	| SUB Expr									{ $$ = - $2; }
	| Expr MULT Expr							{ $$ = $1 * $3; }	
	| Expr DIV Expr								{ $$ = $1 / $3; }
	| Expr POW Expr								{ $$ = $1 ^ $3; }
	| PARENTHESE_OUVRANTE Expr PARENTHESE_FERMANTE	{ $$ = $2; }
	| VAR ASIGN Expr							{ $1 = $3; }
	;

%%

int main(void) {
  yyparse();
}

