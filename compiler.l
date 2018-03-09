%{
	#include "y.tab.h"
%}

lettre									[a-zA-Z]
chiffre									[0-9]
entier    								{chiffre}+
exposant  								[eE][+-]?{entier}
reel   									{entier}("."{entier})?{exposant}?

%%
  
"+"         					       	return (PLUS); 
"-"										return (SUB);
"*"         					       	return (MULT);   
"/"										return (DIV);
"="         					        return (ASIGN); 
";"           					        return (SEMICOLON); 
"("										return (PARENTHESE_OUVRANTE);
")"										return (PARENTHESE_FERMANTE);
"^"   									return (POW);

int					  					return (INT);
"{"										return (ACCOLADE_OUVRANTE);
"}"										return (ACCOLADE_FERMANTE);
const									return (CONST);

\n 										return (END_LINE);

[\ \t]									return (EMPTY);
","										return (SEPARATEUR);

entier              					{
										  yylval=atoi(yytext);
										  return(NOMBRE);
										}
reel									{
										  yylval=atof(yytext);
										  return(NOMBRE);
										}
{lettre}({lettre}|{chiffre}|_)*  		return (VAR);    

