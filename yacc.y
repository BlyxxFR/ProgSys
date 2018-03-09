%token NOMBRE
%token PLUS SUB MULT DIV POW
%token PARENTHESE_GAUCHE PARENTHESE_DROITE
%token END_LINE
%token SEMICOLON
%token INT
%token CONST

%left PLUS  SUB
%left MULT  DIV

%right POW

%start Input

%%

Input:
	| Input Line
	;

Line:						
	| Fonction SEMICOLON	
	| INT Assignation SEMICOLON
	| CONST Assignation SEMICOLON
	;

Assignation:
	| VAR ASIGN Expr 
	;

Expr:
	| NOMBRE									{ $$ = $1; }
	| Expr PLUS Expr							{ $$ = $1 + $3; }
	| Expr SUB Expr								{ $$ = $1 - $3; }
	| SUB Expr									{ $$ = - $2; }
	| Expr MULT Expr							{ $$ = $1 * $3 }	
	| Expr DIV Expr								{ $$ = $1 / $3 }
	| Expr POW Expr								{ $$ = $1 ^ $3 }
	| PARENTHESE_GAUCHE Expr PARENTHESE_DROITE	{ $$ = $2 }
	| VAR ASIGN Expr							{ $1 = $3 }
	;

%%

int main(void) {
  yyparse();
}

