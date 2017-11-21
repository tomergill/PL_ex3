/*
 * Name:	 Tomer Gill
 * ID:		 318459450
 * Group:	 05
 * Username: gilltom
 */
 
%{
	#include <math.h>
	#include <iostream>
	#include <algorithm>
	#include <sstream>
	#include <stdexcept>
	using namespace std;
	
	void 	yyerror(const char*);
	int 	yylex();
%}

%union 
{
	int 		int_val;
	std::string	*str;
}

%nonassoc	SEARCH	//strings
%left		OR		//nums
%left		AND		//nums
%nonassoc	EQ NEQ	//nums
%left		'+' '-'	//nums, + is also strings
%left		'*' '/'	//nums
%nonassoc	UNARY	//nums
%nonassoc	'[' ']'	//strings
%right		'^'		//strings & nums
%nonassoc	'<' '>' //strings
%nonassoc	'(' ')'	//strings & nums

%token	<int_val>	T_INT
%token	<str>		T_STR

%type	<int_val>	Expr
%type	<str>		Str

%%
lines: /*epsilon*/ |
     line lines;

line: Expr '\n'							{	cout << "Expr=" << $1 << endl;	}
	| Str '\n'							{	cout << "Str=" << *$1 << endl; delete($1);	}
;

Expr: Expr '+' Expr						{	$$ = $1 + $3;	}
	| Expr '-' Expr						{	$$ = $1 - $3;	}		
	| Expr '*' Expr						{	$$ = $1 * $3;	}
	| Expr '/' Expr						{
											if ($3 != 0)
											{
												$$ = $1 / $3;
											}
											else 
											{
												cout << "Error - Zero Division" << endl;
												return 0;
											}	
										}
	| Expr '^' Expr						{	$$ = (int) pow($1, $3);	}
	| '+' Expr	%prec UNARY				{	$$ = $2;	}
	| '-' Expr	%prec UNARY				{	$$ = -1 * $2;	}
	| Expr OR Expr						{	$$ = $1  || $3;	}
	| Expr AND Expr						{	$$ = $1  && $3;	}
	| Expr EQ Expr						{	$$ = ($1 == $3);	}
	| Expr NEQ Expr						{	$$ = ($1 != $3);	}
	| '(' Expr ')'						{	$$ = $2;	}
	| Str SEARCH Str					{	$$ = $1->find(*$3); delete($1); delete($3);	}
	| T_INT								{	$$ = (int) $1;	}
;

Str: Str '+' Str						{	$$ = new string(*$1 + *$3); delete($1); delete($3);	}
   | '^' Str							{	std::reverse($2->begin(), $2->end()); $$ = $2;	}
   | '<' Expr '>'						{	
			   								stringstream ss;
			   								ss << $2;
			   								$$ = new string(ss.str());
			   							}
   | Str '[' Expr ']'					{	
			   								try
			   								{
			   									stringstream ss;
			   									ss << $1->at($3);
			   									$$ = new string(ss.str());
			   									delete($1);
			   								}
			   								catch(const std::out_of_range& oor) 
			   								{
			   									cout << "Error - Index out of range!" << endl;
			   									delete($1);
			   									return 0;
											}
			   							}
   | Str '[' T_INT '.' '.' T_INT ']'	{	
   											try
   											{
   												stringstream ss;
   												int i;
   												for (i = $3; i <= $6; ++i)
   													ss << $1->at(i);
   												$$ = new string(ss.str());
   												delete($1);
   											}
   											catch (const std::out_of_range& oor)
   											{
   												cout << "Error - Index out of range!" << endl;
   												delete($1);
   												return 0;
   											}
   										}
   | T_STR								{	$$ = $1;	}
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
