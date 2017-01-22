/* parser for ATL */
%{
open Parse
open Atl

%}
%token RARROW LARROW SHARP ITERATE
%token NOT
%token MUL QUOT DIV MOD
%token PLUS MINUS
%token EQ GT LT GE LE NE
%token AND OR XOR IMPLIES
%token COMMA COLON SEMICOLON MID DOT BANG LBRACE RBRACE LPAREN RPAREN
%token MODULE CREATE RULE FROM TO IN
%token IF THEN ELSE ENDIF LET
%token OCLANY TUPLETYPE MAP INTEGER REAL BOOLEAN STRING BAG SET ORDEREDSET SEQUENCE TUPLE COLLECTION OCLTYPE
%token OCLUNDEF SUPER
%token <bool> BOOL
%token <int> INT
%token <float> FLOAT
%token <string> LETTERS DQUOTED SQUOTED
%token EOF

/* precedence */
/* low */
%left COMMA
%nonassoc FROM TO IN
%left AND OR XOR IMPLIES     /* priority_5 */
%left EQ GT LT GE LE NE      /* priotity_4 */
%left PLUS MINUS             /* priotity_3 */
%left MUL QUOT DIV MOD       /* priotity_2 */
%nonassoc NOT                /* priotity_1 */
%left RARROW                 /* priority_0 */
%nonassoc IF THEN ELSE       /* priority_0 */
%nonassoc BANG SHARP ITERATE /* priority_0 */
/* high */

%start entry
%type <Atl.atl_module> entry
%%
entry:
| atl_module EOF
{ return ~ntsym: "EntryPoint" $1 }

/* module */
atl_module:
| MODULE id SEMICOLON CREATE oclModel_nelist FROM oclModel_nelist SEMICOLON moduleElement_list
{ return ~ntsym:"atl_module" (Module($2,$5,$7,$9)) }

/* nonempty list of oclModel */
oclModel_nelist:
| oclModel
{ return ~ntsym:"oclModel_nelist(sng)" [$1] }
| oclModel COMMA oclModel_nelist
{ return ~ntsym:"oclModel_nelist(cons)" $1::$3 }

oclModel:
| id COLON id
{ return ~ntsym:"oclModel" (OclModel($1,$3)) }

moduleElement_list:
|
{ return ~ntsym:"moduleElement_list(nil)"  [] }
| moduleElement moduleElement_list
{ return ~ntsym:"moduleElement_list(cons)"  $1::$2 }

moduleElement:
| rule
{ return ~ntsym:"moduleElement(rule)" (Rule($1)) }

rule:
| matchedRule
{ return ~ntsym:"rule(matchedRule)" $1 }

matchedRule:
| RULE id LBRACE inPattern RBRACE
{ return ~ntsym:"matchedRule" (MatchedRule($2,$4,None)) }
| RULE id LBRACE inPattern outPattern RBRACE
{ return ~ntsym:"matchedRule" (MatchedRule($2,$4,Some $5)) }

inPattern:
| FROM inPatternElement 
{ return ~ntsym:"inPattern(noOclExp)" (From($2,None)) }
| FROM inPatternElement LPAREN oclExp RPAREN
{ return ~ntsym:"inPattern(noOclExp)" (From($2,Some $4)) }

inPatternElement: /* simpleInPatternElement */
| id COLON oclType 
{ return ~ntsym:"inPatternElement(noIn)" (InPat($1,$3,None)) }
| id COLON oclType IN id
{ return ~ntsym:"inPatternElement(noIn)" (InPat($1,$3,Some $5)) }

outPattern:
| TO outPatternElement_nelist
{  return ~ntsym:"outPattern" (To($2))}

outPatternElement_nelist:
| outPatternElement
{ return ~ntsym:"outPatternElement_nelist(sng)" [$1]}
| outPatternElement COMMA outPatternElement_nelist
{ return ~ntsym:"outPatternElement_nelist(cons)" $1::$3 }

outPatternElement: /* simpleOutPatternElement */
| id COLON oclType in_id_opt 
{ return ~ntsym:"outPatternElement(nobind)" (OutPat($1,$3,$4,None))}
| id COLON oclType in_id_opt LPAREN binding_list RPAREN
{ return ~ntsym:"outPatternElement(nobind)" (OutPat($1,$3,$4,Some $6))}

in_id_opt:
| 
{ return ~ntsym:"in_id_opt(None)" None }
| IN id 
{ return ~ntsym:"in_id_opt(Some)" (Some $2) }

binding_list:
| 
{ return ~ntsym:"binding_list(nil)" [] }
| binding
{ return ~ntsym:"binding_list(sng)" [$1] }
| binding COMMA binding_list
{ return ~ntsym:"binding_list(cons)" $1::$3 }

binding:
| id LARROW oclExp
{ return ~ntsym:"binding" (Bind($1,$3))}

id:
| LETTERS
{ return ~ntsym:"id" $1 }

oclType:
| id BANG id
{ return ~ntsym:"oclType(OclModelElement)" (OclModelElement($1,$3)) } 
| OCLANY
{ return ~ntsym:"oclType(OclAnyType)" OclAny }
| TUPLETYPE LPAREN tupleTypeAttribute_list RPAREN
{ return ~ntsym:"oclType(OclAnyType)" (TupleType($3)) }
| MAP LPAREN oclType COMMA oclType RPAREN
{ return ~ntsym:"oclType(mapType)" (MapType($3,$5)) }
| INTEGER
{ return ~ntsym:"oclType(integerType)" Integer }
| REAL
{ return ~ntsym:"oclType(realType)" Real }
| STRING
{ return ~ntsym:"oclType(mapType)" String }
| BAG LPAREN oclType RPAREN
{ return ~ntsym:"oclType(bagType)" (BagType($3)) }
| SET LPAREN oclType RPAREN
{ return ~ntsym:"oclType(setType)" (SetType($3)) }
| ORDEREDSET LPAREN oclType RPAREN
{ return ~ntsym:"oclType(orderedSetType)" (OrderedSetType($3)) }
| SEQUENCE LPAREN oclType RPAREN
{ return ~ntsym:"oclType(sequenceType)" (SequenceType($3)) }
| COLLECTION LPAREN oclType RPAREN
{ return ~ntsym:"oclType(collectionType_abstractContents)" (CollectionType($3)) }
| OCLTYPE
{ return ~ntsym:"oclType(oclType_abstractContents)" OclType }

tupleTypeAttribute_list:
| 
{ return ~ntsym:"tupleTypeAttribute_list(nil)" []      }
| tupleTypeAttribute
{ return ~ntsym:"tupleTypeAttribute_list(sng)" [$1]    }
| tupleTypeAttribute COMMA tupleTypeAttribute_list
{ return ~ntsym:"tupleTypeAttribute_list(cons)" $1::$3 }


tupleTypeAttribute:
| id COLON oclType
{ return ~ntsym:"typleTypeAttribute" (TupTypAttr($1,$3)) }


oclExp:
| id
{ return ~ntsym:"oclExp(var)"     (Vref($1)) }
| OCLUNDEF
{ return ~ntsym:"oclExp(oclundef)" OclUndef }
| INT
{ return ~ntsym:"oclExp(int)"     (Int($1)) }
| FLOAT
{ return ~ntsym:"oclExp(float)"   (Rea($1)) }
| BOOL
{ return ~ntsym:"oclExp(bool)"    (Bl($1)) }
| DQUOTED 
{ return ~ntsym:"oclExp(dquot)"   (Str(unquote $1)) }
| SQUOTED 
{ return ~ntsym:"oclExp(squot)"   (Str(unquote $1)) }
| IF oclExp THEN oclExp ELSE oclExp ENDIF
{ return ~ntsym:"oclExp(if)"   (If($2,$4,$6)) }
| SUPER
{ return ~ntsym:"oclExp(super)" Super }
| SHARP id
{ return ~ntsym:"oclExp(enum)"  (Enum($2)) }
| BAG        LBRACE oclExp_list RBRACE
{ return ~ntsym:"oclExp(bag)"   (Bag($3)) }
| SET        LBRACE oclExp_list RBRACE
{ return ~ntsym:"oclExp(set)"   (Set($3)) }
| ORDEREDSET LBRACE oclExp_list RBRACE
{ return ~ntsym:"oclExp(orderedset)" (OSet($3)) }
| SEQUENCE   LBRACE oclExp_list RBRACE
{ return ~ntsym:"oclExp(seq)" (Seq($3)) }
| MAP LBRACE RBRACE
{ return ~ntsym:"oclExp(map(emp))" (Map([])) }
| MAP LBRACE mapElement_list RBRACE
{ return ~ntsym:"oclExp(map(lst))" (Map($3)) }
| TUPLE LBRACE tuplePart_list RBRACE
{ return ~ntsym:"oclExp(tuple)" (Tup($3)) }
| oclType                                        /* type as expression? */
{ return ~ntsym:"oclExp(oclType)" (Ot($1)) }
| LPAREN oclExp RPAREN
{ return ~ntsym:"oclExp(paren)" $2 }
| oclExp DOT op_navi_exp 
{ return ~ntsym:"oclExp(dot)"   (Dot($1,$3)) }
| oclExp RARROW it_col_exp
{ return ~ntsym:"oclExp(rarrow)"(Arr($1,$3)) }
| NOT oclExp %prec NOT
{ return ~ntsym:"oclExp(not)"   (Not($2)) }
| MINUS oclExp
{ return ~ntsym:"oclExp(un-)"   (Neg($2)) }
| oclExp MUL     oclExp
{ return ~ntsym:"oclExp(*)"     (Bin($1,Mul,$3)) }
| oclExp QUOT      oclExp
{ return ~ntsym:"oclExp(/)"     (Bin($1,Quot,$3))  }
| oclExp DIV     oclExp
{ return ~ntsym:"oclExp(div)"   (Bin($1,Div,$3)) }
| oclExp MOD     oclExp
{ return ~ntsym:"oclExp(mod)"   (Bin($1,Mod,$3)) }
| oclExp PLUS     oclExp
{ return ~ntsym:"oclExp(+)"     (Bin($1,Plus,$3)) }
| oclExp MINUS    oclExp
{ return ~ntsym:"oclExp(-)"     (Bin($1,Minus,$3))  }
| oclExp EQ      oclExp
{ return ~ntsym:"oclExp(=)"     (Bin($1,Eq,$3)) }
| oclExp GT     oclExp
{ return ~ntsym:"oclExp(>)"     (Bin($1,Gt,$3)) }
| oclExp LT     oclExp
{ return ~ntsym:"oclExp(<)"     (Bin($1,Lt,$3)) }
| oclExp GE    oclExp
{ return ~ntsym:"oclExp(>=)"    (Bin($1,Ge,$3)) }
| oclExp LE      oclExp
{ return ~ntsym:"oclExp(<=)"    (Bin($1,Le,$3)) }
| oclExp NE      oclExp
{ return ~ntsym:"oclExp(<>)"    (Bin($1,Ne,$3)) }
| oclExp AND     oclExp
{ return ~ntsym:"oclExp(and)"   (Bin($1,And,$3)) }
| oclExp OR      oclExp
{ return ~ntsym:"oclExp(or)"    (Bin($1,Or,$3))  }
| oclExp XOR     oclExp
{ return ~ntsym:"oclExp(xor)"   (Bin($1,Xor,$3)) }
| oclExp IMPLIES oclExp
{ return ~ntsym:"oclExp(implies)" (Bin($1,Implies,$3)) }
| LET variableDeclaration IN oclExp
{ return ~ntsym:"oclExp(letExp)" (Let($2,$4)) }

op_navi_exp:
| id LPAREN oclExp_list RPAREN
{ return ~ntsym:"op_navi_exp(operationCallExp)"             (OpCall($1,$3)) }
| id
{ return ~ntsym:"op_navi_exp(navigationOrAttributeCallExp)" (NvCall($1)) }

it_col_exp:
| id LPAREN iterator_nelist MID oclExp RPAREN
{ return ~ntsym:"it_col_exp(iteratorExp)"    (Iterator($1,$3,$5)) }
| ITERATE LPAREN iterator_nelist SEMICOLON variableDeclaration MID oclExp RPAREN
{ return ~ntsym:"it_col_exp(iterateExp)"     (Iterate($3,$5,$7)) }
| id LPAREN oclExp_list RPAREN
{ return ~ntsym:"it_col_exp(collectionOperationCallExp)"    (COCall($1,$3)) }

iterator_nelist:
| iterator 
{ return ~ntsym:"iterator_nelist(sng)" [$1] }
| iterator COMMA iterator_nelist
{ return ~ntsym:"iterator_nelist(cons)" $1::$3 }

iterator:
| id
{ return ~ntsym:"iterator" $1 }

variableDeclaration:
| id COLON oclType EQ oclExp
{ return ~ntsym:"variableDeclaration" (Vdecl($1,$3,$5)) }

oclExp_list:
| 
{ return ~ntsym:"oclExp_list(nil)"   [] }
| oclExp
{ return ~ntsym:"oclExp_list(sng)" [$1] }
| oclExp COMMA oclExp_list
{ return ~ntsym:"oclExp_list(cons)" $1::$3 }

mapElement_list:
| 
{ return ~ntsym:"mapElement_list(nil)" [] }
| mapElement
{ return ~ntsym:"mapElement_list(sng)" [$1] }
| mapElement COMMA mapElement_list
{ return ~ntsym:"mapElement_list(cons)" $1::$3 }

mapElement:
| LPAREN oclExp COMMA oclExp RPAREN
{ return ~ntsym:"mapElement" ($2,$4) }

tuplePart_list:
| 
{ return ~ntsym:"tuplePart_list(nil)"   []      }
| tuplePart
{ return ~ntsym:"tuplePart_nelist(sng)" [$1]    }
| tuplePart COMMA tuplePart_list
{ return ~ntsym:"tuplePart_nelist(cons)" $1::$3 }

tuplePart:
| id COLON oclType EQ oclExp
{ return ~ntsym:"tuplePart(withtype)" ($1,Some $3,$5) }
| id               EQ oclExp
{ return ~ntsym:"tuplePart(notype)"   ($1,None,   $3) }
