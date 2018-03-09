lettre									[a-zA-Z]
chiffre									[0-9]

%%
  
"+"         					       	return ("PLUS"); 
"-"										return ("SUB");
"*"         					       	return ("MULT");   
"/"										return ("DIV");
"="         					        return ("ASGN"); 
";"           					        return ("SEMI"); 
"("										return ("(");
")"										return (")");

int					  					return ("int trouvé");
"{"										return ("accolade ouvrante");
"}"										return ("accolade fermante");
main									return ("le main");
const									return ("constante");

\n 										return (" fin de ligne ");

[\ \t,]									return ("un séparateur");

return									return ("un return");

{chiffre}+              				return ("nombre");
{lettre}({lettre}|{chiffre}|_)*  		return ("variable");    

