/* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 */
%{
open Parse
open UnCAL

%}

%token DB COMMA COLON LBRACE RBRACE LPAREN RPAREN U DU DOC
%token COLON_EQ ATMARK CYCLE REC BACKSLASH DOT
%token IF THEN ELSE LET LLET IN
%token AND OR NOT ISEMPTY BISIMILAR EQ LT GT ISEMPTY ISINT ISBOOL ISSTRING ISLABEL ISFLOAT
%token PLUS MINUS STAR SLASH PERCENT HAT BAN UKN ATAT
%token <bool> BOOL
%token <int> INT
%token <float> FLOAT
%token <string> LETTERS VARSTR QUOTED MARKERSTR
%token EOF

/* precedence */
/* low */
%left COMMA
%right DU
%left COLON_EQ
%nonassoc IN
%right U
%nonassoc THEN ELSE
%left ATMARK
%left OR
%left AND
%nonassoc NOT
%left EQ
%nonassoc LT GT
%left HAT PLUS MINUS
%left STAR SLASH PERCENT
%left ATAT
/* high */

%start entry
%type <UnCAL.info UnCAL.aexpr> entry
%%
entry:
| annot_aexpr EOF
{ return ~ntsym:"EntryPoint" ($1 None) }

/* annot_aexpr assumes that aexpr returns a function taking an annotation */
annot_aexpr:
| aexpr
{ return ~ntsym:"annot_aexpr" $1 }
| aexpr ATAT QUOTED
{ return ~ntsym:"annot_aexpr" (fun annot -> $1 (Some (unquote $3))) }

aexpr:
| LBRACE RBRACE
{ return ~ntsym:"aexpr" (fun annot -> AETEmp{annot}) }
| LBRACE alpat_aexpr_list RBRACE
{ return ~ntsym:"aexpr" (fun annot -> $2 annot) }
| annot_aexpr U annot_aexpr
{ return ~ntsym:"aexpr" (fun annot -> AEUni({annot},$1 None,$3 None)) }
| annot_aexpr DU annot_aexpr
{ return ~ntsym:"aexpr" (fun annot -> AEDUni({annot},$1 None,$3 None)) }
| marker COLON_EQ annot_aexpr
{ return ~ntsym:"aexpr" (fun annot -> AEIMrk({annot},$1,$3 None)) }
| marker
{ return ~ntsym:"aexpr" (fun annot -> AEOMrk({annot},$1)) }
| LPAREN RPAREN
{ return ~ntsym:"aexpr" (fun annot -> AEGEmp{annot}) }
| LPAREN aexpr_list RPAREN
{ return ~ntsym:"aexpr" $2 }
| annot_aexpr ATMARK annot_aexpr
{ return ~ntsym:"aexpr" (fun annot -> AEApnd({annot},$1 None,$3 None)) }
| CYCLE LPAREN annot_aexpr RPAREN
{ return ~ntsym:"aexpr" (fun annot -> AECyc({annot},$3 None)) }
| variable
{ return ~ntsym:"aexpr" (fun annot -> AEVar({annot},$1)) }
| DOC LPAREN QUOTED RPAREN
{ return ~ntsym:"aexpr" (fun annot -> AEDoc({annot},unquote $3)) }
| IF annot_abexpr THEN annot_aexpr ELSE annot_aexpr
{ return ~ntsym:"aexpr" (fun annot -> AEIf({annot},$2 None,$4 None,$6 None)) }
| REC LPAREN BACKSLASH LPAREN aexpr_rec_core
{ return ~ntsym:"aexpr" $5 }
| LET variable EQ annot_aexpr IN annot_aexpr
{ return ~ntsym:"aexpr" (fun annot -> AELet({annot},$2,{annot=None},$4 None,$6 None)) }
| LLET label_variable EQ alpat IN annot_aexpr
{ return ~ntsym:"aexpr" (fun annot -> AELLet({annot},$2,{annot=None},$4,$6 None)) }
| allit
{ return ~ntsym:"aexpr" (fun annot -> AEEdg({annot},ALLit({annot},$1),AETEmp{annot=None})) }

alpat_aexpr_list:
| annot_alpat_aexpr
{ return ~ntsym:"alpat_aexpr_list" $1 }
| annot_alpat_aexpr COMMA alpat_aexpr_list
{ return ~ntsym:"alpat_aexpr_list" (fun annot -> AEUni({annot},$1 None,$3 annot)) }

annot_alpat_aexpr:
| alpat_aexpr
{ return ~ntsym:"annot_alpat_aexpr" (fun annot -> $1 None) }
| alpat_aexpr ATAT QUOTED
{ return ~ntsym:"annot_alpat_aexpr" (fun annot -> $1 (Some (unquote $3))) }

alpat_aexpr:
| alpat
{ return ~ntsym:"alpat_aexpr" (fun annot -> AEEdg({annot},$1,AETEmp{annot=None})) }
| alpat COLON annot_aexpr
{ return ~ntsym:"alpat_aexpr" (fun annot -> AEEdg({annot},$1,$3 None)) }

aexpr_list:
| annot_aexpr
{ return ~ntsym:"aexpr_list" $1 }
| annot_aexpr COMMA aexpr_list
{ return ~ntsym:"aexpr_list" (fun annot -> AEDUni({annot},$1 None,$3 annot)) }

aexpr_rec_core:
| annot_label_variable COMMA annot_variable RPAREN DOT
    annot_aexpr RPAREN LPAREN annot_aexpr RPAREN
{ return ~ntsym:"aexpr_rec_core" (fun annot -> AERec({annot},fst $1,snd $1,fst $3,snd $3,
                                                     $6 None,$9 None)) }

alpat:
| label_variable
{ return ~ntsym:"alpat" (ALVar({annot=None},$1)) }
| allit
{ return ~ntsym:"alpat" (ALLit({annot=None},$1)) }
| alpat_albinop_alpat
{ return ~ntsym:"alpat" $1 }

alpat_albinop_alpat:
| alpat PLUS alpat
{ return ~ntsym:"alpat_albinop_alpat" (ALBin({annot=None},$1,ALAdd,$3)) }
| alpat MINUS alpat
{ return ~ntsym:"alpat_albinop_alpat" (ALBin({annot=None},$1,ALSub,$3)) }
| alpat STAR alpat
{ return ~ntsym:"alpat_albinop_alpat" (ALBin({annot=None},$1,ALMul,$3)) }
| alpat SLASH alpat
{ return ~ntsym:"alpat_albinop_alpat" (ALBin({annot=None},$1,ALDiv,$3)) }
| alpat PERCENT alpat
{ return ~ntsym:"alpat_albinop_alpat" (ALBin({annot=None},$1,ALMod,$3)) }
| alpat HAT alpat
{ return ~ntsym:"alpat_albinop_alpat" (ALBin({annot=None},$1,ALConc,$3)) }
| LPAREN alpat_albinop_alpat RPAREN
{ return ~ntsym:"alpat_albinop_alpat" $2 }

alptype:
| ISINT
{ return ~ntsym:"alptype" ALPInt }
| ISBOOL
{ return ~ntsym:"alptype" ALPBol }
| ISSTRING
{ return ~ntsym:"alptype" ALPStr }
| ISLABEL
{ return ~ntsym:"alptype" ALPLbl }
| ISFLOAT 
{ return ~ntsym:"alptype" ALPFlt }

annot_abexpr:
| abexpr
{ return ~ntsym:"annot_abexpr" $1 }
| abexpr ATAT QUOTED
{ return ~ntsym:"annot_abexpr" (fun annot -> $1 (Some (unquote $3))) }

abexpr:
| ISEMPTY LPAREN annot_aexpr RPAREN
{ return ~ntsym:"abexpr" (fun annot -> AIsemp({annot},$3 None)) }
| BISIMILAR LPAREN annot_aexpr COMMA annot_aexpr RPAREN
{ return ~ntsym:"abexpr" (fun annot -> ABisim({annot},$3 None,$5 None)) }
| alptype LPAREN alpat RPAREN
{ return ~ntsym:"abexpr" (fun annot -> ALpred({annot},$1,$3)) }
| NOT annot_abexpr
{ return ~ntsym:"abexpr" (fun annot -> ANot({annot},$2 None)) }
| annot_abexpr AND annot_abexpr
{ return ~ntsym:"abexpr" (fun annot -> AAnd({annot},$1 None,$3 None)) }
| annot_abexpr OR annot_abexpr
{ return ~ntsym:"abexpr" (fun annot -> AOr({annot},$1 None,$3 None)) }
| alpat_alcmp_alpat
{ return ~ntsym:"abexpr" (fun annot -> $1 annot) }
| BOOL
{ return ~ntsym:"abexpr" (fun annot -> if $1 then ATrue{annot} else AFalse{annot}) }
| LPAREN abexpr RPAREN
{ return ~ntsym:"abexpr" $2 }

alpat_alcmp_alpat:
| alpat EQ alpat
{ return ~ntsym:"alpat_alcmp_alpat" (fun annot -> ALcmp({annot},$1,ALOEq,$3)) }
| alpat LT alpat
{ return ~ntsym:"alpat_alcmp_alpat" (fun annot -> ALcmp({annot},$1,ALOLt,$3)) }
| alpat GT alpat
{ return ~ntsym:"alpat_alcmp_alpat" (fun annot -> ALcmp({annot},$1,ALOGt,$3)) }

annot_label_variable:
| label_variable
{ return ~ntsym:"annot_label_variable" ($1,{annot=None}) }
| label_variable ATAT QUOTED
{ return ~ntsym:"annot_label_variable" ($1,{annot=Some (unquote $3)}) }

label_variable:
| VARSTR
{ return ~ntsym:"label_variable" $1 }

annot_variable:
| variable
{ return ~ntsym:"annot_varible" ($1,{annot=None}) }
| variable ATAT QUOTED
{ return ~ntsym:"annot_varible" ($1,{annot=Some (unquote $3)}) }

variable:
| DB
{ return ~ntsym:"variable" "$db" }
| VARSTR
{ return ~ntsym:"variable" $1 }

allit:
| LETTERS
{ return ~ntsym:"allit" (ALLbl $1) }
| QUOTED
{ return ~ntsym:"allit" (ALStr(unquote $1)) }
| INT
{ return ~ntsym:"allit" (ALInt $1) }
| FLOAT
{ return ~ntsym:"allit" (ALFlt $1) }
| BOOL
{ return ~ntsym:"allit" (ALBol $1) }
| BAN
{ return ~ntsym:"allit" ALEps }
| UKN
{ return ~ntsym:"allit" ALUkn }

marker:
| MARKERSTR
{ return ~ntsym:"marker" $1 }

