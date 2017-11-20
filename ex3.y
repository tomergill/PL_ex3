/*
 * Name:	 Tomer Gill
 * ID:		 318459450
 * Group:	 05
 * Username: gilltom
 */
 
%{
	#include <stdio.h>
	#include <math.h>
	int yylex();
	void yyerror(const char*);
%}
%token T_INT
%%
S:
	Expr	{$$=$1}
;
Expr: Expr '+' Expr		{	$$ = $1 + $3;	}
	| Expr '-' Expr		{	$$ = $1 - $3;	}		
	| Expr '*' Expr		{	$$ = $1 * $3;	}
	| Expr '/' Expr		{	$3 != 0 ? $$ = $1 / $3; : printf("Error – Zero Division\n");	}
	| Expr '^' Expr		{	$$ = (int) pow($1, $3);	}
	| T_INT				{	$$ = $1;	}
;


%%
