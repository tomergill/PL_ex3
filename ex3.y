/*
 * Name:	 Tomer Gill
 * ID:		 318459450
 * Group:	 05
 * Username: gilltom
 */
 
%{
	#include <iostream>
	using namespace std;
	
	#include <math.h>
	int yylex();
	void yyerror(const char*);
%}

%left		OR
%left		AND
%nonassoc	EQ NEQ
%left		'+' '-'
%left		'*' '/'
%nonassoc	UNARY
%right		'^'
%nonassoc	'(' ')'

%token	T_INT

%%
lines: /*epsilon*/ |
     line lines;

line: Expr '\n'	{	cout << "Expr=" << $1 << endl;	}
;

Expr: Expr '+' Expr			{	$$ = $1 + $3;	}
	| Expr '-' Expr			{	$$ = $1 - $3;	}		
	| Expr '*' Expr			{	$$ = $1 * $3;	}
	| Expr '/' Expr			{	if ($3 != 0)
									$$ = $1 / $3;
								else 
								{
									cout << "Error – Zero Division" << endl;
									return 0;
								}	
							}
	| Expr '^' Expr			{	$$ = (int) pow($1, $3);	}
	| '+' Expr	%prec UNARY	{	$$ = $2;	}
	| '-' Expr	%prec UNARY	{	$$ = -1 * $2;	}
	| Expr OR Expr			{	$$ = $1  || $3;	}
	| Expr AND Expr			{	$$ = $1  && $3;	}
	| Expr EQ Expr			{	$$ = ($1 == $3);	}
	| Expr NEQ Expr			{	$$ = ($1 != $3);	}
	| '(' Expr ')'			{	$$ = $2;	}
	| T_INT					{	$$ = $1;	}
;


%%

void yyerror(const char *err)
{
	cout << "Error: " << err << endl;
}

int main() 
{
	yyparse();
	return 0;
}
