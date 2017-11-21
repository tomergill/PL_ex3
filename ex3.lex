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
	int counter = 0;	//counts how many open { brackets there are
%}

%s MAP_STATE
 
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
VAR				"var"
START_BRACKET	"{"
END_BRACKET		"}"
COMMA			","
COLON			":"


%%

<MAP_STATE>{END_BRACKET}	{	
								if (--counter == 0)
								{
									BEGIN(INITIAL);
								}
								return '}';	
							}
<MAP_STATE>{COMMA}			{	return COMMA;	}
<MAP_STATE>{COLON}			{	return COLON;	}
<MAP_STATE>{VAR}			{	yylval.str = new string(yytext); return Var;	}


{START_BRACKET}				{	counter++; BEGIN(MAP_STATE); return '{';	}

{VAR}						{	return VAR_ASSIGN;	}

{VARNAME}					{	yylval.str = new string(yytext); return Var;	}

{STRING}					{	
								string temp = string(yytext);
								yylval.str = new string(temp.substr(1, temp.length() - 2)); /*return "str" without "-s */ 
								return T_STR; 
							}

{NUMBER}					{	yylval.int_val = atoi(yytext); return T_INT;	}

{SEARCH}					{	return SEARCH;	}

{OR}						{	return OR;	}
{AND}						{	return AND;	}
{EQ}						{	return EQ;	}
{NEQ}						{	return NEQ;	}
" "|\t						{	/*nothing*/	}
.|\n						{	return *yytext;	}

%%

int yywrap() { return 1; }
