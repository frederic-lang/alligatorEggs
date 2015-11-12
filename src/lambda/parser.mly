%{
open Printf
open Lambda
%}

%token <string> STR
%token <string> VAR 
%token APP ABS
%token EOF

%start input
%type <Lambda.lambda> input

%%
input:   exp EOF		{ $1 }
;

str:	STR			{ $1 }
;
exp:    VAR 			{ Var($1) }
        | ABS str exp	{ Abs($2, $3) }
        | APP exp exp	{ App($2, $3) }
;
%%