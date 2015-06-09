(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
{
open Parse
open ParseDot
open Lexing

let strip1 str = String.sub str 1 (String.length str-1)
let lunquote str = String.sub str 2 (String.length str-4)
}

let bool = "true" | "false"
let space = [ ' ' '\t' ]*
let new_line = '\r' '\n' | [ '\r' '\n' ]
(* let escaped = ([^'"' '\\']|"\\\\"|"\\\"")* *)
(* let escaped = ([^'"']|"\\\\"|"\\\"")*   *)
(* let escaped = ['a'-'z' 'A'-'Z' '_' '0'-'9' '\'' '-' '\\' '"' ]* *)
let letters = ['a'-'z' 'A'-'Z' '_' '0'-'9' '\'' '-' ]*
(* let str_lit = ['a'-'z' 'A'-'Z' '_' '0'-'9' '\'' '-' '@' '.' ' ' ]* *)
(* let escaped = ([^'"' '\\']|"\\\\"|"\\\"")* *)
let escaped = ([^'"' '\\']|"\\\\")* 
let str_lit = escaped
(* let escaped = letters* *)
let single_marker_string = ['&']['a'-'z' 'A'-'Z' '_' '0'-'9' '\'']*
let marker_string = single_marker_string+
let digits = ['0'-'9']+
let sn_digits = ("-")?digits
let dotty_node_id = ['n']digits

rule token = parse
  space		        { token lexbuf }
| new_line		{ token (new_line_is_read lexbuf) }
| eof			{ EOF }
| "/*"			{ comment lexbuf }
| "//"			{ line_comment lexbuf }
| "digraph"		{ DIGRAPH }
| "graph"               { GRAPH }
| "node"                { NODE }
| "edge"                { EDGE }
| "->"                  { ARROW }
| "fontsize"            { ATTRNAME(lexeme lexbuf) }
| "fontname"            { ATTRNAME(lexeme lexbuf) }
| "fontcolor"           { ATTRNAME(lexeme lexbuf) }
| "color"               { ATTRNAME(lexeme lexbuf) }
| "label"               { LABEL(lexeme lexbuf) }
| "shape"               { ATTRNAME(lexeme lexbuf) }
| "style"               { ATTRNAME(lexeme lexbuf) }
| "dir"                 { ATTRNAME(lexeme lexbuf) }
| "width"               { ATTRNAME(lexeme lexbuf) }
| "height"              { ATTRNAME(lexeme lexbuf) }
| "minlen"              { ATTRNAME(lexeme lexbuf) }
| "ordering"            { ATTRNAME(lexeme lexbuf) }
| "S1"                  { S1 }
| "S2"                  { S2 }
| "Hub"                 { Hub }
| "FrE"                 { FrE }
| "InT"                 { InT }
| "ImT"                 { ImT }
| "IaT"                 { IaT }
(* | '\\' '"' letters '\\' '"' { ESCAPED(lunquote (lexeme lexbuf)) }  *)
| '\\' '"' str_lit '\\' '"' { ESCAPED(lunquote (lexeme lexbuf)) } 
(* | '"'                   { print_string "token:consumed dquote \n";qstr lexbuf } *)
| '"'                   { DQ }
| marker_string         { let l=(lexeme lexbuf) in MARKERSTR(l)(*; idmks lexbuf*) }
| '&' marker_string     { MARKERSTR(strip1 (lexeme lexbuf)) } (* for Win32 *)
| "\\N"                 { SELF  }
| "\\n"                 { NEWLINE }
| '|'                   { BAR }
| ';'                   { SEMICOLON }
(* |                     { ESCAPED(lexeme lexbuf) } *)
| bool			{ BOOL(bool_of_string(lexeme lexbuf)) }
| digits '.' digits	{ FLOAT(float_of_string(lexeme lexbuf)) }
| digits '.' 	        { FLOAT(float_of_string(lexeme lexbuf)) }
| sn_digits		{ INT(int_of_string(lexeme lexbuf)) }
| dotty_node_id         { DOTTY_NODE_ID(int_of_string(strip1 (lexeme lexbuf))) }
| letters		{ LETTERS(lexeme lexbuf) }
| '{'                   { LBRACE }
| '}'                   { RBRACE }
| '['                   { LBRACKET }
| ']'                   { RBRACKET }
| '('                   { LPAREN }
| ')'                   { RPAREN }
| '='                   { EQ }
| '!'                   { BAN }
| "?"                   { UKN }
| ','                   { COMMA }
| _			{ raise Lexing_error }

(* and qstr = parse *)
(*  | '{'                   { print_string "qstr: entering idmks\n"; idmks lexbuf } *)
(* |  letters '"'          { print_string "qstr: consumed letters&quote\n"; ESCAPED(lexeme lexbuf) } *)
(* | _			{ print_string "error(qstr)\n"; raise Lexing_error } *)

(* and idmks = parse *)
(* | space                 { print_string "idmks: skipping space\n"; idmks lexbuf } *)
(* | '|'                   { print_string "idmks: consumed | \n"; BAR (\* ; idmks lexbuf *\)} *)
(* | ';'                   { SEMICOLON (\* ; idmks lexbuf *\) } *)
(* | "\\N"                 { SELF ; idmks lexbuf  } *)
(* | '}'                   { qstr lexbuf } *)



and comment = parse
| "*/"			{ token lexbuf }
| new_line		{ comment (new_line_is_read lexbuf) }
| _			{ comment lexbuf }

and line_comment = parse
| new_line		{ token (new_line_is_read lexbuf) }
| _			{ line_comment lexbuf }
