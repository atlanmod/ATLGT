(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
{
open Parse
open ParseUnQL
open Lexing
}

let space = [ ' ' '\t' ]*
let new_line = '\r' '\n' | [ '\r' '\n' ]

let bool = "true" | "false"
let digits = ['0'-'9']+
let escaped = ([^'"' '\\']|"\\\\"|"\\\"")*
let letters = ['a'-'z' 'A'-'Z' '_' '0'-'9']*
let marker_string = ['&']['a'-'z' 'A'-'Z' '_' '0'-'9']*
let variable_string = ['$']['a'-'z' 'A'-'Z' '_' '0'-'9']['a'-'z' 'A'-'Z' '_' '0'-'9' '\'']*

rule token = parse
  space			{ token lexbuf }
| new_line		{ token (new_line_is_read lexbuf) }
| eof			{ EOF }
| "(*"			{ comment lexbuf }
| "//"			{ line_comment lexbuf }
| "select"		{ SELECT }
| "replace"		{ REPLACE } (* editing primitive *)
| "by"                  { BY }
| "delete"              { DELETE }  (* syntacitc sugar   *)
| "extend"              { EXTEND }  (* syntacitc sugar   *)
| "with"                { WITH }
| "where"		{ WHERE }
| "let"                 { LET }     (* syntactic sugar *)
| "letrec"              { LETREC }  (* syntactic sugar *)
| "sfun"                { SFUN }    (* syntactic sugar *)
| "rec"                 { REC }     (* syntactic sugar *)
| "if"                  { IF }
| "then"                { THEN }
| "else"                { ELSE }
| "in"			{ IN }
| "under"		{ UNDER }
| "and"			{ AND }
| "or"			{ OR }
| "not"			{ NOT }
| "isempty"		{ ISEMPTY }
| 'U'			{ U }
| "$db"			{ DATABASE }
| "doc"                 { DOC }
| bool			{ BOOL(bool_of_string(lexeme lexbuf)) }
| digits '.' digits	{ FLOAT(float_of_string(lexeme lexbuf)) }
| digits		{ INT(int_of_string(lexeme lexbuf)) }
| '"' escaped '"'	{ QUOTED(lexeme lexbuf) }
| ":="			{ ASSIGN }  (* syntactic sugar: graph constructor *)
| "(+)"                 { PPLUS }   (* syntactic sugar: graph constructor *)
| '@'                   { ATMARK }  (* syntactic sugar: graph constructor *)
| "cycle"               { CYCLE }   (* syntactic sugar: graph constructor *)
| "->"			{ ARROW }
| '_'			{ ANY }
| '.'			{ DOT }
| '|'			{ UNION }
| '?'			{ OPTION }
| '*'			{ STAR }
| '+'			{ PLUS }
| ','			{ COMMA }
| ':'			{ COLON }
| '{'			{ LBRACE }
| '}'			{ RBRACE }
| '('			{ LPAREN }
| ')'			{ RPAREN }
| '='			{ EQ }
| '<'			{ LT }
| '>'			{ GT }
| '^'			{ HAT }
| '!'			{ BAN }
| '~'                   { TILDA }
| letters		{ LETTERS(lexeme lexbuf) }
| variable_string       { VARSTR(lexeme lexbuf) } (* variable *)
| marker_string         { MARKERSTR(lexeme lexbuf) } (* syntactic sugar *)
| _			{ raise Lexing_error }

and comment = parse
| "*)"			{ token lexbuf }
| new_line		{ comment (new_line_is_read lexbuf) }
| _			{ comment lexbuf }

and line_comment = parse
| new_line		{ token (new_line_is_read lexbuf) }
| _			{ line_comment lexbuf }
