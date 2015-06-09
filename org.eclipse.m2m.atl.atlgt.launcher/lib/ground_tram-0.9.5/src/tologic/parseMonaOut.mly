/* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 */
%{
open Parse
open MonaOut
let real_var_name var =
  let len = String.length var in
  if len > 0 then var (* String.sub var 1 (len-1) *) (* do this at MonaOut.var2alpat *)
  else failwith ("real_var_name: unknown variable name '"^var^"'")
%}

%token EOF COLON COMMA LPAREN RPAREN
%token FormulaIs Valid Unsatisfiable FreeVarIs 
%token SatExample CntExample Booleans Universe 
%token <string> STRING

%start entry
%type <MonaOut.message> entry
%%
entry:
| summary free_vars cnt_example_decl sat_example_decl EOF
{ return ~ntsym:"EntryPoint" { is_valid = $1; free_vars = $2;
                               cnt_example = $3; sat_example = $4 } }

summary:
| 
{ return ~ntsym:"summary" false }
| FormulaIs result
{ return ~ntsym:"summary" $2 }

result:
| Valid
{ return ~ntsym:"result" true }
| Unsatisfiable
{ return ~ntsym:"result" false }

free_vars:
| FreeVarIs COLON var_list
{ return ~ntsym:"free_vars" (Array.of_list $3) } 

var_list:
| var_name
{ return ~ntsym:"var_list" [real_var_name $1] } 
| var_name COMMA var_list
{ return ~ntsym:"var_list" (real_var_name $1::$3) } 

var_name:
| STRING
{ return ~ntsym:"var_list" $1 } 

cnt_example_decl:
|
{ return ~ntsym:"cnt_example_decl" None }
| CntExample COLON example
{ return ~ntsym:"cnt_example_decl" (Some $3) }

sat_example_decl:
|
{ return ~ntsym:"sat_example_decl" None }
| SatExample COLON example
{ return ~ntsym:"sat_example_decl" (Some $3) }

example:
| Booleans COLON bool_decl universe_list
{ return ~ntsym:"example" { booleans = $3; univ = $4 } }

bool_decl:
| STRING /* not implemented */
{ return ~ntsym:"bool_decl (not implemented)" [] }

universe_list:
| 
{ return ~ntsym:"universe_list" [] }
| universe universe_list
{ return ~ntsym:"universe_list" ($1::$2) }

universe:
| Universe STRING COLON bin_tree
{ return ~ntsym:"universe" ($2,$4) }

bin_tree:
| LPAREN RPAREN
{ return ~ntsym:"bin_tree" Leaf }
| LPAREN STRING COMMA bin_tree COMMA bin_tree RPAREN
{ return ~ntsym:"bin_tree" (Node($2,$4,$6)) }
