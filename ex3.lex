/*
 * Name:	 Tomer Gill
 * ID:		 318459450
 * Group:	 05
 * Username: gilltom
 */
 
%{
	#include <stdlib.h>
	#include "ex3.tab.h"
%}
 
NUMBER			0|[1-9][0-9]*
%%

{NUMBER}	{yylval = atoi(yytext); return T_INT;}
.|\n		{return *yytext; }

%%

int yywrap() { return 1; }
