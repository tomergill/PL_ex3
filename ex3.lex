/*
 * Name:	 Tomer Gill
 * ID:		 318459450
 * Group:	 05
 * Username: gilltom
 */
 
%{
	#include <iostream>	
	#include "ex3.tab.h"
	
	using namespace std;
%}
 
NUMBER			0|[1-9][0-9]*
OR				"||"
AND				"&&"
EQ				"=="
NEQ				"!="
%%

{NUMBER}	{	yylval = atoi(yytext); return T_INT;	}
{OR}		{	return OR;	}
{AND}		{	return AND;	}
{EQ}		{	return EQ;	}
{NEQ}		{	return NEQ;	}
" "			{	/*nothing*/	}
.|\n		{	return *yytext;	}

%%

int yywrap() { return 1; }
