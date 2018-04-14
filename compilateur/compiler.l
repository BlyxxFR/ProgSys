%{
	#include "compiler.tab.h"
	#include <stdio.h>
	#include <stdlib.h>
%}

lettre									[a-zA-Z]
chiffre									[0-9]
entier    								{chiffre}+
exposant  								[eE][+-]?{entier}
reel   									{entier}("."{entier})?{exposant}?
string 									\".*\"

%%
  
"+"         					       	return (PLUS); 
"-"										return (SUB);
"*"         					       	return (MULT);   
"/"										return (DIV);
"=="					        		return (EQUALS); 
"<="					        		return (LESS_EQUALS); 
">="        					        return (GREATER_EQUALS); 
"="         					        return (ASSIGN); 
">"        					       		return (GREATER); 
"<"        					        	return (LESS); 

";"           					        return (SEMICOLON); 
"("										return (PARENTHESE_OUVRANTE);
")"										return (PARENTHESE_FERMANTE);
"^"   									return (POW);
"?"										return (QUESTION_MARK);		
":"										return (COLON);

int					  					return (INT);
float									return (FLOAT);
string									return (STRING);
"{"										return (ACCOLADE_OUVRANTE);
"}"										return (ACCOLADE_FERMANTE);
const									return (CONST);
"if"									return (IF);
"elseif"								return (ELSEIF);
"else"									return (ELSE);
"while"									return (WHILE);
"for"									return (FOR);

[\ \t\n]+ 
","										return (SEPARATEUR);

{entier}								{
											yylval.intValue = atoi(yytext);
											return(NOMBRE);
										}
{reel}									{
										  	yylval.floatValue = atof(yytext);
										  	return(FLOTTANT);
										}
{lettre}({lettre}|{chiffre}|_)*  		{
											yylval.stringValue = strdup(yytext);			
											return (VAR);    
										}
{string}								{
											yylval.stringValue = strdup(yytext);
											return(TEXT);											
										}
\/\/.*
"/*"([^*]|\*+[^*/])*\*+"/"
