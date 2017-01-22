(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
{
open Parse
open ParseKm3
open Lexing
}
let space = [ ' ' '\t' ]*
let new_line = '\r' '\n' | [ '\r' '\n' ]

let digits = ['0'-'9']+
let string = ['a'-'z' 'A'-'Z' '_']['a'-'z' 'A'-'Z' '_' '0'-'9']*
let quoted = '"' ['a'-'z' 'A'-'Z' '_' '0'-'9']* '"'

rule token = parse
  space		{ token lexbuf }
| new_line	{ token (new_line_is_read lexbuf) }
| eof		{ EOF }
| quoted	{ QUOTED(lexeme lexbuf) }
| "--"		{ line_comment lexbuf }
| "package"	{ PACKAGE }
| "abstract"	{ ABSTRACT }
| "class"	{ CLASS }
| "extends"	{ EXTENDS }
| ','		{ COMMA }
| '{'		{ LBRACE }
| '}'		{ RBRACE }
| "attribute"	{ ATTRIBUTE }
| "reference"	{ REFERENCE }
| "ordered"	{ ORDERED }
| ':'		{ COLON } 
| "oppositeOf"	{ OPPOSITE_OF }
| ';'		{ SEMICOLON }
| '['		{ LBRACKET }
| ']'		{ RBRACKET }
| '-'		{ MINUS }
| '*'		{ STAR}
| "container"	{ CONTAINER }
| "datatype"	{ DATATYPE }
| "enumeration"	{ ENUMERATION }
| "literal"	{ LITERAL }
| digits	{ INT(int_of_string(lexeme lexbuf)) }
| string	{ STRING(lexeme lexbuf) }
| _		{ raise Lexing_error }

and line_comment = parse
| new_line		{ token (new_line_is_read lexbuf) }
| _			{ line_comment lexbuf }
