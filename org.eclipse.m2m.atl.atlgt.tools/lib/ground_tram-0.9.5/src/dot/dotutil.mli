(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
(* manipulation on dot format and conversion from/to graph *)
open Dot
open UnCALDM
open UnCAL

(** adding attributes **)
val addAttrToNodeSet :  dot -> SetofVtx.t  -> string -> attr_value -> dot
val addAttrToEdgeSet :  dot -> SetofEdge.t -> string -> attr_value -> dot
val addAttrToNodeAttr : dot ->                string -> attr_value -> dot

(** finding attribute **) 
val find_attr : string -> attr list -> attr_value option

(** extract edge label from a list of attributes **)
val find_elabel : attr list -> allit

(** conversion to/from graph **)
val g2dot : ?gray_unreachable:bool ->  ?cmp_eps:bool -> ?ops:allit list -> 
            graph -> dot
val dot2g : dot   -> graph

(** render difference of two graphs  **)
val graph_diff : graph -> graph -> dot
val gdiff2dot : ?mcol:string -> ?acol:string -> ?dcol:string ->
 (graph * SetofVtx.t * SetofVtx.t * SetofEdge.t * SetofEdge.t * SetofEdge.t) -> dot

(** dump dot data structure to file **)
val dumpDot : ?shape:shape -> ?prefix_n:bool -> ?expnl:bool -> dot -> string -> unit

(** dump graph data structure to dot file **)
val g2dot_file : ?shape:shape -> ?prefix_n:bool -> ?gray_unreachable:bool ->
  ?ops:allit list -> ?cmp_eps:bool -> ?expnl:bool -> graph -> string -> unit

(** dump dot data structure to image file **)
val dot2imagef : string -> ?remove_dot_file:bool -> ?dot_file:string -> 
   ?shape:shape -> ?prefix_n:bool -> dot -> string -> unit

(** dump graph data structure to image file **)
val g2image : string -> ?remove_dot_file:bool ->  ?dot_file:string ->
  ?gray_unreachable:bool ->
  ?shape:shape ->  ?prefix_n:bool -> ?ops:allit list -> ?cmp_eps:bool -> graph -> string -> unit


(** dump graph data structure to png file **)
val g2png : ?remove_dot_file:bool -> ?dot_file:string -> ?gray_unreachable:bool ->
  ?shape:shape ->  ?prefix_n:bool -> ?ops:allit list -> ?cmp_eps:bool -> graph -> string -> unit

