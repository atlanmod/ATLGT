(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
{
open Parse
open ParseMonaOut
open Lexing
}
let space = [ ' ' '\t' ]*
let new_line = '\r' '\n' | [ '\r' '\n' ]

let digits = ['0'-'9']+
let chars = ['a'-'z' 'A'-'Z' '_' '<' '>']
let string = (digits|chars)+

rule token = parse
  space				{ token lexbuf }
| new_line			{ token (new_line_is_read lexbuf) }
| eof				{ EOF }
| "Formula is"			{ FormulaIs }
| "valid"			{ Valid }
| "unsatisfiable"		{ Unsatisfiable }
| "Free variables are"		{ FreeVarIs }
| "Free variable is"		{ FreeVarIs }
| "Universe"			{ Universe }
| ':'				{ COLON }
| ','				{ COMMA }
| '('				{ LPAREN }
| ')'				{ RPAREN }
| "A satisfying example is"	{ SatExample }
| "A counter-example is"	{ CntExample }
| "Booleans"			{ Booleans }
| "Boolean"			{ Booleans }
| string			{ STRING(lexeme lexbuf) }
| _				{ raise Lexing_error }
