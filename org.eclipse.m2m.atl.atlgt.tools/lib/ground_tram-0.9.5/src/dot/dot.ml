(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
(* 
 Objective Caml representation of dot file of Graphviz
 subgraph is not supported
 *)

open UnCAL
open UnCALDM

(*
type graph_attr_name = [
   `fontsize
|  `fontname
|  `fontcolor
] and node_attr_name = [
   `fontsize
|  `fontname
|  `fontcolor
|  `label
|  `shape
|  `style
] and edge_attr_name = [
  `fontsize
| `fontname 
| `fontcolor
| `style
]
*)
type dot = {
  graph_id      : string;
  stmt_list     : stmt list;     (* '{' stmt-list '}' *)
  }
and dot_id    =
  | DVtx of vtx
  | DRaw of string
and stmt =
  | DAGraph of (attr list)
  | DANode  of (attr list)
  | DAEdge  of (attr list)
  | DNode   of node_id * (attr list)		
  | DEdge   of node_id * (attr list) * node_id
  | DGroup  of attr list * stmt list
and node_id = dot_id
and attr = 
  DAttr of string * attr_value
| DELabel of allit
| DNLabel of (marker list) * (marker list)
and attr_value = string
(*
and attr_name = [
   graph_attr_name
|  node_attr_name
|  edge_attr_name
]
*)

type shape = [`ellipse|`plaintext|`point|`record]

