/* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 */
%{
open Parse
open Dot
open UnCAL
open UnCALDM
%}

%token DIGRAPH GRAPH NODE EDGE
%token LBRACKET RBRACKET LBRACE RBRACE DQ LPAREN RPAREN
%token COMMA S1 S2 Hub FrE InT ImT IaT SEMICOLON BAR SELF BAN UKN NEWLINE
%token ARROW EQ
%token <string> ESCAPED
%token <string> ATTRNAME
%token <string> LABEL
%token <string> LETTERS MARKERSTR
%token <float> FLOAT
%token <bool> BOOL
%token <int> INT DOTTY_NODE_ID
%token EOF

%start entry
%type <Dot.dot> entry
%%
entry:
| graph EOF
{ return ~ntsym: "EntryPoint" $1 }
;

graph:
| DIGRAPH gid  LBRACE stmt_list RBRACE
{ return ~ntsym: "graph" { graph_id = $2; stmt_list = $4 }}
;

gid:
| DQ LETTERS DQ
{ return ~ntsym: "gid(quoted)" $2}
|    LETTERS                            /* for grappy */
{ return ~ntsym: "gid"         $1}
;

stmt_list:
|
{ return ~ntsym: "stmt_list(emp)" [] }
| stmt_delim stmt_list
{ return ~ntsym: "stmt_list..." $1::$2 }
;

stmt_delim:
| stmt SEMICOLON                           /* for grappy */
{ return ~ntsym: "stmt_delim(delim)" $1 }
| stmt 
{ return ~ntsym: "stmt_delim"        $1 }
;


node_id:
| DOTTY_NODE_ID
{ return ~ntsym: "node_id(dotty)" (Bid $1) }
| uncal_node_id
{ return ~ntsym: "node_id(uncal)" $1 }
;

qnode_id:
| DQ node_id DQ
{ return ~ntsym: "qnode_id(quoted)" $2 }
| node_id
{ return ~ntsym: "qnode_id"         $1 } /* for grappy */
;

uncal_node_id:
| INT
{ return ~ntsym: "uncal_node_id(base)" (Bid $1) }
| S1 LPAREN uncal_node_id COMMA MARKERSTR RPAREN
{ return ~ntsym: "uncal_node_id(s1)" (S1($3,$5)) }
| S2 LPAREN uncal_node_id COMMA allit COMMA uncal_node_id COMMA uncal_node_id RPAREN
{ return ~ntsym: "uncal_node_id(s2)" (S2($3,$5,$7,$9)) }
| Hub LPAREN uncal_node_id COMMA MARKERSTR COMMA codeid RPAREN
{ return ~ntsym: "uncal_node_id(Hub)" (Hub($3,$5,$7)) }
| FrE LPAREN uncal_node_id COMMA edge COMMA codeid RPAREN
{ return ~ntsym: "uncal_node_id(FrE)" (FrE($3,$5,$7)) }
| InT LPAREN codeid RPAREN 
{ return ~ntsym: "uncal_node_id(Int)" (InT($3)) }
| ImT LPAREN codeid COMMA MARKERSTR RPAREN 
{ return ~ntsym: "uncal_node_id(Imt)" (ImT($3,$5)) }
| IaT LPAREN codeid COMMA uncal_node_id RPAREN 
{ return ~ntsym: "uncal_node_id(Iat)" (IaT($3,$5)) }
;

codeid:
| INT
{ return ~ntsym: "expid" $1 }
;

edge:
| LPAREN uncal_node_id COMMA allit COMMA uncal_node_id RPAREN
{ return ~ntsym: "edge" ($2,$4,$6) }
;

stmt:
| GRAPH    LBRACKET  graph_attr_list RBRACKET
{ return ~ntsym: "stmt(graphattr)" (DAGraph $3) }
| NODE     LBRACKET   node_attr_list RBRACKET
{ return ~ntsym: "stmt(nodeattr)"  (DANode $3) }
| EDGE     LBRACKET   edge_attr_list RBRACKET
{ return ~ntsym: "stmt(edgeattr)"  (DAEdge $3) }
| qnode_id LBRACKET   node_attr_list RBRACKET 
{ return ~ntsym: "stmt(node)"      (DNode (DVtx $1,$3))}
| qnode_id ARROW qnode_id LBRACKET edge_attr_list RBRACKET
{ return ~ntsym: "stmt(edge)"      (DEdge (DVtx $1,$5,DVtx $3))}

graph_attr_list:
  common_attr_list
{ return ~ntsym: "graph_attr_list(common)" $1 }

common_attr_list:
{ return ~ntsym: "common_attr_list(empty)" [] }
| common_attribute common_attr_list
{ return ~ntsym: "common_attr_list(cons)" $1::$2 }

edge_attr_list:
{ return ~ntsym: "edge_attr_list(empty)" [] }
| edge_attribute edge_attr_list
{ return ~ntsym: "edge_attr_list(cons)" $1::$2 }

node_attr_list:
{ return ~ntsym: "node_attr_list(empty)" [] }
| node_attribute node_attr_list
{ return ~ntsym: "node_attr_list(cons)" $1::$2 }


common_attribute:
  ATTRNAME EQ DQ attr_literal DQ
{ return ~ntsym: "common_attribute(qattr_value)" (DAttr($1,$4)) }
| ATTRNAME EQ    attr_literal
{ return ~ntsym: "common_attribute(attr_value)"  (DAttr($1,$3)) }

qallit: 
  DQ allit DQ
{ return ~ntsym: "qallit(quoted)" $2 }
|    allit
{ return ~ntsym: "qallit"         $1 }  /* for grappy */
edge_attribute:
  LABEL    EQ qallit
{ return ~ntsym: "edge_attribute(edgeattr)" (DELabel $3) }
| common_attribute
{ return ~ntsym: "edge_attribute(common)"    $1 }


node_attribute:
  LABEL    EQ DQ node_attr DQ
{ return ~ntsym: "node_attribute(node_attr)" (let (im,om)=$4 in (DNLabel(im,om))) }
| common_attribute
{ return ~ntsym: "node_attribute(common)"    $1 }


attr_literal:
  LETTERS
{ return ~ntsym: "attr_literal(letters)" $1 }
| INT
{ return ~ntsym: "attr_literal(int)"     string_of_int($1) }
| FLOAT
{ return ~ntsym: "attr_literal(float)"   string_of_float($1) }


node_attr:
  ellipse_node_attr
{ return ~ntsym: "node_attr(ellipse_label)" $1 }
| record_node_attr
{ return ~ntsym: "node_attr(record_label)"  $1 }

allit:
  LETTERS
{ return ~ntsym:"allit" (ALLbl $1) }
| ESCAPED
{ return ~ntsym:"allit" (ALStr $1) }
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

node_label:
SELF
{ return ~ntsym: "node_label(self)"    None }
| node_id
{ return ~ntsym: "node_label(node_id)" None }


record_node_attr:
  LBRACE marker_list BAR node_label BAR marker_list RBRACE
{ return ~ntsym: "node_attr"      ($2,$6) }

ellipse_node_attr:
ellipse_input_markers node_label ellipse_output_markers
{ return ~ntsym: "ellipsenode_attr" ($1,$3) }

ellipse_input_markers:
{ return ~ntsym: "ellipse_input_markers(null)" [] }
| ellipse_marker_list NEWLINE
{ return ~ntsym: "ellipse_input_markers(null)" $1 }

ellipse_output_markers:
{ return ~ntsym: "ellipse_output_markers(null)" [] }
| NEWLINE ellipse_marker_list
{ return ~ntsym: "ellipse_output_markers(null)" $2 }

ellipse_marker_list:
  LBRACE marker_list RBRACE
{ return ~ntsym: "ellipse_marker_list" $2 }

marker_list:

{ return ~ntsym: "marker_list(null)"      []   }
| MARKERSTR 
{ return ~ntsym: "marker_list(singleton)" [$1] }
| MARKERSTR SEMICOLON marker_list
{ return ~ntsym: "marker_list" $1::$3 }
