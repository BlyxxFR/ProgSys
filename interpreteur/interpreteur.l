%{
	#include "interpreteur.tab.h"
	#include <stdio.h>
	#include <stdlib.h>
%}

%option yylineno

chiffre									[0-9]
entier    								{chiffre}+

%%

[\ \t\n]+

LOAD									return (LOAD);
STORE                                  return (STORE);

AFC                                    return (AFC);

ADD                                    return (ADD);
SUB									    return (SUB);
NEG										return (NEG);
MUL									    return (MUL);
DIV								    	return (DIV);
JMP										return (JMP);
JMPC									return (JMPC);
PRINT									return (PRINT);
POP										return (POP);
PUSH									return (PUSH);
RETURN									return (RETURN);

GE										return (GE);
GT										return (GT);
LE										return (LE);
LT										return (LT);
EQ										return (EQ);

{entier}								{
											yylval.intValue = atoi(yytext);
											return(NOMBRE);
										}
