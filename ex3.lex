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
LETTERSAND_		[a-zA-Z_]
VARNAME			{LETTERSAND_}({LETTERSAND_}|[0-9])*
WS				" "\t\n
%%

"var"		{	return VAR_ASSIGN;	}

{VARNAME}	{	yylval.str = new string(yytext); return Var;	}

{STRING}	{	
				string temp = string(yytext);
				yylval.str = new string(temp.substr(1, temp.length() - 2)); /*return "str" without "-s */ 
				return T_STR; 
			}

{NUMBER}	{	yylval.int_val = atoi(yytext); return T_INT;	}

{SEARCH}	{	return SEARCH;	}

{OR}		{	return OR;	}
{AND}		{	return AND;	}
{EQ}		{	return EQ;	}
{NEQ}		{	return NEQ;	}
" "|\t		{	/*nothing*/	}
.|\n		{	return *yytext;	}

%%

int yywrap() { return 1; }
