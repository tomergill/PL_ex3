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
STRING			\"[^\"]*\"
SEARCH			"=~"
%%

{STRING}	{	
				string temp = string(yytext);
				yylval.str = new string(temp.substr(1, temp.length() - 2)); /*return "str" without "*/ 
				return T_STR; 
			}

{NUMBER}	{	yylval.int_val = atoi(yytext); return T_INT;	}

{SEARCH}	{	return SEARCH;	}

{OR}		{	return OR;	}
{AND}		{	return AND;	}
{EQ}		{	return EQ;	}
{NEQ}		{	return NEQ;	}
" "			{	/*nothing*/	}
.|\n		{	return *yytext;	}

%%

int yywrap() { return 1; }
