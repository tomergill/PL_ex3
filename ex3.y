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
	#include <map>
	using namespace std;
	
	void 	yyerror(const char*);
	int 	yylex();
	
	map<string, int> variables, the_map; //variable map, and the map to the Map part
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
%token				VAR_ASSIGN
%token	<str>		Var
%token				MAP_START
%token				MAP_END
%token				COLON
%token				COMMA

%type	<int_val>	Expr
%type	<str>		Str

%%
lines: /*epsilon*/ |
     line lines;

line: Expr '\n'							{	cout << "Expr = " << $1 << endl;	}
	| Str '\n'							{	cout << "Str = " << *$1 << endl; delete($1);	}
	| VAR_ASSIGN Var '=' Expr '\n'		{	variables[*$2] = $4;	delete($2);}
	| MAP '\n'							{
											map<string, int>::iterator it;
											for (it = the_map.begin(); it != the_map.end(); ++it)
											{
												cout << it->first << " : " << it->second << endl;
											}
											the_map.clear(); //finished with map, emptying it
										}
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
	| Var								{	
											if (variables.find(*$1) != variables.end())
												$$ = variables[*$1];
											else 
											{
												cout << "The variable " << *$1 << " doesn't exist!" << endl;
												delete($1);
												return 0;
											}	
											delete($1);
										}
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
   | '(' Str ')'						{	$$ = $2;	}
   | T_STR								{	$$ = $1;	}
;

MAP: MAP_START MAP_PAIRS MAP_END 		// map with one or more pairs of Key (string) and Value (number)
   | MAP_START /*epsilon*/ MAP_END 		// {} - empty map
;

MAP_PAIRS: MAP_PAIR 
		 | MAP_PAIR COMMA MAP_PAIRS
;

MAP_PAIR: Var COLON Expr			{
											if (the_map.find(*$1) == the_map.end()) // key doesn't exist already
											{
												the_map[*$1] = $3;
												delete($1);
											}
											else // key exists in map
											{
												cout << "The key " << *$1 << " already exist!" << endl;
												delete($1);
												return 0;
											}
										}
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
