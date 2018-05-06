%{
	#include "interpreteur.tab.h"
	#include <stdio.h>
	#include <stdlib.h>
%}

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
CMP										return (CMP);

{entier}								{
											yylval.intValue = atoi(yytext);
											return(NOMBRE);
										}
