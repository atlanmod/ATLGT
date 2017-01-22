(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
{
open Parse
open ParseUnCAL
open Lexing
}
let space = [ ' ' '\t' ]*
let new_line = '\r' '\n' | [ '\r' '\n' ]

let bool = "true" | "false"
let digits = ['0'-'9']+
let float_literal = digits '.' digits
let escaped = ([^'"' '\\']|"\\\\"|"\\\"")*
let letters = ['a'-'z' 'A'-'Z' '_' '0'-'9' '\'']*
let single_marker_string = ['&']['a'-'z' 'A'-'Z' '_' '0'-'9' '\'']*
let marker_string = single_marker_string+
let variable_string = ['$']['a'-'z' 'A'-'Z' '_' '0'-'9' '\'']*

rule token = parse
  space			{ token lexbuf }
| new_line		{ token (new_line_is_read lexbuf) }
| eof			{ EOF }
| "(*"			{ comment lexbuf }
| "//"			{ line_comment lexbuf }
| '"' escaped '"'	{ QUOTED(lexeme lexbuf) }
| "$db"			{ DB }
| "doc"                 { DOC }
| bool			{ BOOL(bool_of_string(lexeme lexbuf)) }
| "cycle"		{ CYCLE }
| "rec"			{ REC }
| "if"			{ IF }
| "then"		{ THEN }
| "else"		{ ELSE }
| "llet"		{ LLET }
| "let"			{ LET }
| "in"			{ IN }
| "isempty"		{ ISEMPTY }
| "bisimilar"		{ BISIMILAR }
| "isInt"               { ISINT }
| "isBool"              { ISBOOL }
| "isString"            { ISSTRING }
| "isLabel"             { ISLABEL }
| "isFloat"             { ISFLOAT }
| "not"			{ NOT }
| "and"			{ AND }
| "or"			{ OR }
| "U"			{ U }
| "++"			{ DU }
| marker_string         { MARKERSTR(lexeme lexbuf) }
| variable_string	{ VARSTR(lexeme lexbuf) }
| digits '.' digits	{ FLOAT(float_of_string(lexeme lexbuf)) }
| digits		{ INT(int_of_string(lexeme lexbuf)) }
| letters		{ LETTERS(lexeme lexbuf) }
| '.'			{ DOT }
| ','			{ COMMA }
| ":="			{ COLON_EQ }
| "@@"			{ ATAT }
| "@"			{ ATMARK }
| ':'			{ COLON }
| '{'			{ LBRACE }
| '}'			{ RBRACE }
| '('			{ LPAREN }
| ')'			{ RPAREN }
| '\\'			{ BACKSLASH }
| '='			{ EQ }
| '<'			{ LT }
| '>'			{ GT }
| '+'			{ PLUS }
| '-'			{ MINUS }
| '*'			{ STAR }
| '/'			{ SLASH }
| '%'			{ PERCENT }
| '^'			{ HAT }
| '!'			{ BAN }
| "?"			{ UKN }
| _			{ raise Lexing_error }

and comment = parse
| "*)"			{ token lexbuf }
| new_line		{ comment (new_line_is_read lexbuf) }
| _			{ comment lexbuf }

and line_comment = parse
| new_line		{ token (new_line_is_read lexbuf) }
| _			{ line_comment lexbuf }
