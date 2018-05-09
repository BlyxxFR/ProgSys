%{
	#include "compiler.tab.h"
	#include <stdio.h>
	#include <stdlib.h>
%}

%option yylineno

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
"!="        					        return (NOTEQUALS);
"="         					        return (ASSIGN);
">"        					       		return (GREATER); 
"<"        					        	return (LESS); 

";"           					        return (SEMICOLON); 
"("										return (PARENTHESE_OUVRANTE);
")"										return (PARENTHESE_FERMANTE);
"?"										return (QUESTION_MARK);		
":"										return (COLON);

"int"					  				return (INT);
"string"								return (STRING);
"function"								return (FUNCTION);
"{"										return (ACCOLADE_OUVRANTE);
"}"										return (ACCOLADE_FERMANTE);
"const"									return (CONST);
"if"									return (IF);
"else"									return (ELSE);
"while"									return (WHILE);

"print"									return (PRINT);

[\ \t\n]+ 
","										return (SEPARATEUR);

{entier}								{
											yylval.intValue = atoi(yytext);
											return(NOMBRE);
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
