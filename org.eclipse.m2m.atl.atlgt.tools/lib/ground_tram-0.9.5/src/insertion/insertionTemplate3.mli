(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
val isNarrowingLVar : UnCAL.allit -> 'a -> bool
type label_restriction = {
  eqL : (UnCAL.allit * UnCAL.allit) list;
  neqL : (UnCAL.allit * UnCAL.allit) list;
}
type restriction = {
  label : label_restriction;
  count : int;
  deact : UnCALDM.SetofVtx.t;
  graph : UnCALDM.graph;
}
val init_restriction : restriction
type 'a stream = Next of ('a * 'a stream Lazy.t) | SEnd
val filter_stream : ('a -> bool) -> 'a stream -> 'a stream
val nth_stream : int -> 'a stream -> 'a
val hd_stream : 'a stream -> 'a
val map_stream : ('a -> 'b) -> 'a stream -> 'b stream
val replaceList : 'a -> 'a -> ('a * 'a) list -> ('a * 'a) list
val substituteG :
  (UnCAL.allit * UnCAL.allit) list -> UnCALDM.graph -> UnCALDM.graph
val test_eval_small :
  'a option UnCAL.aexpr -> UnCALDM.graph -> UnCALDM.graph
val test_insert :
  UnCALDM.vtx ->
  'a option UnCAL.aexpr ->
  UnCALDM.graph ->
  (UnCALDM.graph * (UnCAL.allit * UnCAL.allit) list * UnCALDM.graph -> bool) ->
  (UnCALDM.graph * (UnCAL.allit * UnCAL.allit) list * UnCALDM.graph) stream
