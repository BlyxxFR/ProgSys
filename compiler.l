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
"="         					        return (ASGN); 
";"           					        return (SEMICOLON); 
"("										return (PARENTHESE_GAUCHE);
")"										return (PARENTHESE_DROITE);
"^"   									return (POW);

int					  					return (INT);
"{"										return (ACCOLADE_OUVRANTE);
"}"										return (ACCOLADE_FERMANTE);
main									return (MAIN);
const									return (CONST);

\n 										return (END_LINE);

[\ \t,]									return (SEPARATEUR);

printf									return (PRINTF);

entier              					{
										  yylval=atoi(yytext);
										  return(NOMBRE);
										}
reel									{
										  yylval=atof(yytext);
										  return(NOMBRE);
										}
{lettre}({lettre}|{chiffre}|_)*  		return (VAR);    

