{
(* lexer for ATL *)
open Parse
open Parseatl
open Lexing
}

let bool = "true" | "false"
let digits = ['0'-'9']+
let space = [ ' ' '\t' ]*
let new_line = '\r' '\n' | [ '\r' '\n' ]
let letters = ['a'-'z' 'A'-'Z' '_' '0'-'9' '\'']*
let descaped = ([^'"'  '\\']| "\\\\" | "\\\"")*
let sescaped = ([^'\'' '\\']| "\\\\" | "\\\'")*

rule token = parse
  space             { token lexbuf }
| new_line          { token (new_line_is_read lexbuf) }
| eof               { EOF }
| "module"          { MODULE }
| "create"          { CREATE }
| "from"            { FROM }
| "rule"            { RULE }
| "to"              { TO }
| "in"              { IN }
| "OclAny"          { OCLANY }
| "TupleType"       { TUPLETYPE }
| "Map"             { MAP }
| "Integer"         { INTEGER }
| "Real"            { REAL }
| "Boolean"         { BOOLEAN }
| "String"          { STRING }
| "Bag"             { BAG }
| "Set"             { SET }
| "OrderedSet"      { ORDEREDSET }
| "Sequence"        { SEQUENCE }
| "Tuple"           { TUPLE }
| "Collection"      { COLLECTION }
| "OclType"         { OCLTYPE }
| "OclUndefined"    { OCLUNDEF }   
| "and"             { AND }
| "or"              { OR }
| "xor"             { XOR }
| "implies"         { IMPLIES }
| "if"              { IF }
| "then"            { THEN }
| "else"            { ELSE }
| "endif"           { ENDIF }
| "let"             { LET }
| "super"           { SUPER }
| "iterate"         { ITERATE }
| "div"             { DIV }
| "mod"             { MOD }
| "not"             { NOT }
| '#'               { SHARP }
| '|'               { MID }
| "--"		    { line_comment lexbuf }
| bool		    { BOOL(bool_of_string(lexeme lexbuf)) }
| digits '.' digits { FLOAT(float_of_string(lexeme lexbuf)) }
| digits	    { INT(int_of_string(lexeme lexbuf)) }
| '"'  descaped '"' { DQUOTED(lexeme lexbuf) }
| '\'' sescaped '\''{ SQUOTED(lexeme lexbuf) }
| letters	    { LETTERS(lexeme lexbuf) }
| ':'		    { COLON }
| ';'               { SEMICOLON }
| ','		    { COMMA }
| "<-"              { LARROW }
| "->"              { RARROW }
| '.' 		    { DOT }
| '*'               { MUL }
| '/'               { QUOT }
| '+'		    { PLUS }
| '-'               { MINUS }
| '='               { EQ }
| '>'               { GT }
| '<'               { LT }
| ">="              { GE }
| "<="              { LE }
| "<>"              { NE }
| '!'	            { BANG }
| '{'		    { LBRACE }
| '}'		    { RBRACE }
| '('	 	    { LPAREN }
| ')'		    { RPAREN }



and line_comment = parse
| new_line		{ token (new_line_is_read lexbuf) }
| _			{ line_comment lexbuf }
