/* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 */
%{
open Parse
open UnQL
%}

%token SELECT REPLACE BY DELETE EXTEND WITH WHERE IN UNDER DATABASE DOC
%token IF THEN ELSE LET LETREC SFUN REC
%token COMMA COLON LBRACE RBRACE LPAREN RPAREN U
%token AND OR NOT ISEMPTY EQ LT GT HAT BAN
%token ASSIGN PPLUS ATMARK CYCLE
%token ARROW ANY DOT UNION OPTION STAR PLUS TILDA
%token <bool> BOOL
%token <int> INT
%token <float> FLOAT
%token <string> LETTERS QUOTED VARSTR MARKERSTR 
%token EOF

/* precedence */
/* low */
%nonassoc THEN ELSE WITH BY IN
%left COMMA
%left U 
%left OR PPLUS
%left AND ATMARK
%nonassoc EQ LT GT ASSIGN
%right HAT
%left UNION
%left DOT
%left STAR PLUS OPTION
%nonassoc NOT ISEMPTY CYCLE BAN
/* high */

%start entry
%type <unit UnQL.expr> entry
/* %type <UnQL.query> entry */
%type <[>unit UnQL.variable]> variable
%type <[>unit UnQL.label]> label
%type <[>UnQL.fun_name]> fun_name
%type <[>unit UnQL.variable]> label_variable
%type <[>unit UnQL.const]> const
%type <[>unit UnQL.value_expr]> value_expr
%type <[>unit UnQL.rpp]> rpp
%type <[>unit UnQL.pattern]> pattern
%type <[>unit UnQL.pat_label]> pat_label
%type <[>unit UnQL.bool_cond]> bool_cond
%type <[>unit UnQL.bind_cond]> bind_cond
%type <[>unit UnQL.definition]> definition 
%type <[>unit UnQL.branch]> branch
%type <[>unit UnQL.argument]> argument
%type <[>UnQL.marker]> marker
%%
entry:
| expr EOF
{ return ~ntsym:"EntryPoint" $1 }
| template EOF
{ return ~ntsym:"EntryPoint" { action = `query((),$1); where = [`bool((),true)] } }

expr:
| REPLACE rep_target BY template where
{ return ~ntsym:"Edit(replace)" { action = `replace((),$2,$4); where = $5 } }
| REPLACE rpp ARROW rep_target BY template IN template where
{ return ~ntsym:"Edit(replace_in)" { action = `replace_in((),$2,$4,$6,$8); where = $9 } }
| DELETE rep_target              where
{ return ~ntsym:"Edit(delete)"  { action = `delete((),$2); where = $3 } }
| DELETE rpp ARROW rep_target IN template              where
{ return ~ntsym:"Edit(delete_in)"  { action = `delete_in((),$2,$4,$6); where = $7 } }
| EXTEND rep_target WITH template where
{ return ~ntsym:"Edit(extend)"  { action = `extend((),$2,$4); where = $5 } }
| EXTEND rpp ARROW rep_target WITH template IN template where
{ return ~ntsym:"Edit(extend_in)"  { action = `extend_in((),$2,$4,$6,$8); where = $9 } }
| SELECT template where
{ return ~ntsym:"Query" { action = `query((),$2); where = $3 } }
/* | template where
  { return ~ntsym:"Query(no select)" { action = `query((),$1); where = $2 } } */

rep_target:
| variable
{ return ~ntsym:"Replace target(variable)" $1}
| LBRACE pat_label COLON variable RBRACE 
{ return ~ntsym:"Replace target(tree)" (`tree($2,$4))}
| LBRACE pat_label COLON variable RBRACE UNDER variable
{ return ~ntsym:"Replace target(tree)" (`under($2,$4,$7))}

where:
| 
{ return ~ntsym:"Where(true)" [`bool((),true)] }
| WHERE bcond_list
{ return ~ntsym:"Where(bcond list)" $2 }

variable:
| VARSTR
{ return ~ntsym:"Var" (`var((),$1)) }
| DOC LPAREN QUOTED RPAREN
{ return ~ntsym:"Var" (`doc((),unquote $3)) }
| DATABASE
{ return ~ntsym:"Var" (`database()) }

label:
| LETTERS
{ return ~ntsym:"Label" (`label ((),$1)) }

fun_name:
| LETTERS
{ return ~ntsym:"Fun_name" (`fun_name $1) }

label_variable:
| VARSTR
{ return ~ntsym:"Label" (`var ((),$1)) (* labelvar $1 *) }

const_without_label:
| BOOL
{ return ~ntsym:"ConstWithoutLabel" (`bool ((),$1)) }
| INT
{ return ~ntsym:"ConstWithoutLabel" (`int ((),$1)) }
| QUOTED
{ return ~ntsym:"ConstWithoutLabel" (`string((),unquote $1)) }

const:
| const_without_label
{ return ~ntsym:"Const" $1 }
| label
{ return ~ntsym:"Const" $1 }

value_expr:
| variable
{ return ~ntsym:"ValueExpr" $1 }
| const
{ return ~ntsym:"ValueExpr" $1 }
| LPAREN value_expr RPAREN
{ return ~ntsym:"ValueExpr" $2 }
| unary_op value_expr %prec NOT
{ return ~ntsym:"ValueExpr" (`unary((),$1,$2)) }
| value_expr binary_op value_expr %prec AND
{ return ~ntsym:"ValueExpr" (`binary((),$2,$1,$3)) }

unary_op:
| NOT
{ return ~ntsym:"UnaryOperator" `NOT }
| ISEMPTY
{ return ~ntsym:"UnaryOperator" `IsEmpty }

binary_op:
| AND
{ return ~ntsym:"BinaryOperator" `AND }
| OR
{ return ~ntsym:"BinaryOperator" `OR }
| EQ
{ return ~ntsym:"BinaryOperator" `EQ }
| LT
{ return ~ntsym:"BinaryOperator" `LT }
| GT
{ return ~ntsym:"BinaryOperator" `GT }
| HAT
{ return ~ntsym:"BinaryOperator" `CONCAT }

rpp:
| label
{ return ~ntsym:"RPP" $1 }
| ANY
{ return ~ntsym:"RPP" `any }
| TILDA
{ return ~ntsym:"RPP" `eps }
| rpp DOT rpp
{ return ~ntsym:"RPP" (`concat($1,$3)) }
| rpp UNION rpp
{ return ~ntsym:"RPP" (`union($1,$3)) }
| rpp OPTION
{ return ~ntsym:"RPP" (`option $1) }
| rpp STAR
{ return ~ntsym:"RPP" (`star $1) }
| rpp PLUS
{ return ~ntsym:"RPP" (`plus $1) }
| BAN rpp
{ return ~ntsym:"RPP" (`not $2) }
| LPAREN rpp RPAREN
{ return ~ntsym:"RPP" $2 }

pattern:
| LBRACE pattern_tree_list RBRACE
{ return ~ntsym:"Pat" (`tree $2) }
| variable
{ return ~ntsym:"Pat" $1 }
| const
{ return ~ntsym:"Pat" $1 }

pattern_tree_list:
|
{ return ~ntsym:"Pat tree list" [] }
| pattern_tree
{ return ~ntsym:"Pat tree list" [$1] }
| pattern_tree COMMA pattern_tree_list
{ return ~ntsym:"Pat tree list" ($1::$3) }

pattern_tree:
| pat_label COLON pattern
{ return ~ntsym:"Pat tree list" ($1,$3) }

pat_label:
| label_variable
{ return ~ntsym:"PE" $1 }
| rpp
{ return ~ntsym:"PE" $1 }
| const_without_label    /* label is regarded as rpp */
{ return ~ntsym:"PE" (`label_const $1) }

bind_cond:
| pattern IN template
{ return ~ntsym:"BindCond" (`pat_in($1,$3)) }

bool_cond:
| value_expr
{ return ~ntsym:"BoolCond" $1 }

/* query:
   | SELECT template WHERE bcond_list
   { return ~ntsym:"Query" { action = `query $2; where = $4 } }
   | SELECT template
   { return ~ntsym:"Query" { action = `query $2; where = [`bool true] } } */

template:
| LBRACE template_tree_list RBRACE
{ return ~ntsym:"Template (list)" (`tree ((),$2)) }
| variable
{ return ~ntsym:"Template (variable)" $1 }
/* | LPAREN query RPAREN
   { return ~ntsym:"Template (query)" (`query $2) }
   | LPAREN edit RPAREN
   { return ~ntsym:"Template (edit)" (`edit $2) } */
| LPAREN expr RPAREN
{ return ~ntsym:"Template (expr)" (`expr ((),$2)) }
| template U template 
{ return ~ntsym:"Template (union)" (`union((),$1,$3)) }
| fun_name LPAREN template RPAREN
{ return ~ntsym:"Template (fun call)" (`app_exp((),$1,$3)) }
| LET definition IN template
{ return ~ntsym:"Template (let)" (`let_exp((),$2,$4)) }
| LET variable EQ template IN template
{ return ~ntsym:"Template (letvalue)" (`letvalue((),$2,$4,$6)) }
| LETREC definition_list IN template
{ return ~ntsym:"Template (let)" (`letrec_exp((),$2,$4)) }
| LPAREN template_list RPAREN
{ return ~ntsym:"Template (temlate list)" (`template_list((),$2)) }
| marker ASSIGN template
{ return ~ntsym:"Template (:=)" (`i_marker((),$1,$3)) }
| marker 
{ return ~ntsym:"Template (out marker)" (`o_marker((),$1)) }
| LPAREN RPAREN
{ return ~ntsym:"Template (out marker)" (`graph_empty ()) }
| template PPLUS template
{ return ~ntsym:"Template (out marker)" (`graph_union((),$1,$3)) }
| template ATMARK template
{ return ~ntsym:"Template (out marker)" (`graph_append((),$1,$3)) }
| CYCLE LPAREN template RPAREN
{ return ~ntsym:"Template (out marker)" (`graph_cycle((),$3)) }
| REC LPAREN fun_name COMMA template RPAREN
{ return ~ntsym:"Template (rec)" (`srec((),$3,$5)) } 
| IF bool_cond THEN template ELSE template 
{ return ~ntsym:"Template (if)"  (`ifcond ((),$2,$4,$6)) }

template_list:
| template
{ return ~ntsym:"Template list" [$1] }
| template COMMA template_list
{ return ~ntsym:"Template list" ($1::$3) }

template_tree_list:
|
{ return ~ntsym:"Template tree list" [] }
| template_tree
{ return ~ntsym:"Template tree list" [$1] }
| template_tree COMMA template_tree_list
{ return ~ntsym:"Template tree list" ($1::$3) }

template_tree:
| tree_label COLON template
{ return ~ntsym:"Template tree" ($1,$3) }

tree_label:
| value_expr
{ return ~ntsym:"TE" $1 }

bcond_list:
|
{ return ~ntsym:"BC list" [] }
| bcond
{ return ~ntsym:"BC list" [$1] }
| bcond COMMA bcond_list
{ return ~ntsym:"BC list" ($1::$3) }

bcond:
| bind_cond
{ return ~ntsym:"BC" $1 }
| bool_cond
{ return ~ntsym:"BC" $1 }

definition_list:
|
{ return ~ntsym:"Definition list" [] }
| definition
{ return ~ntsym:"Definition list" [$1] }
| definition AND definition_list
{ return ~ntsym:"Definition list" ($1::$3) }

definition:
| SFUN branch_list
{ return ~ntsym:"Definition" (`def($2)) }

branch_list:
| branch
{ return ~ntsym:"Branch list" [$1] }
| branch UNION branch_list
{ return ~ntsym:"Branch list" ($1::$3) }

branch:
| fun_name argument EQ template
{ return ~ntsym:"Branch" (`branch ($1,$2,$4)) }

argument:
| LPAREN argument RPAREN
{ return ~ntsym:"Argument" $2 }
| LBRACE pat_label COLON pattern RBRACE
{ return ~ntsym:"Argument" (`argument ($2,$4)) }

marker:
| MARKERSTR
{ return ~ntsym:"Marker" (`marker_var $1) }
