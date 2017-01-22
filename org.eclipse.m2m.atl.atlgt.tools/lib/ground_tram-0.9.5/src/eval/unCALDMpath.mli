(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
(* shortest path using Dijkstra search *)
open UnQL
open UnCAL
open UnCALDM


(* shortest_path ~weight:weight g vt vs
  returns list of edge labels corresponding to shortest path from vs to vt using weighting function 
  weight (takes edge labels and returns floating point value. Default value is 1.0) *)
val shortest_path :  ?weight:(allit -> float) ->  graph -> vtx -> vtx -> allit list
(* extract_rpp ~weight:weight g vt returns rpp from root to vt *)
val extract_rpp :  ?weight:(allit -> float) ->  graph ->  vtx -> 'a option rpp

(* conversion from list of edge labels to rpp *)
val path2rpp :  allit list -> 'a option rpp

(* given an output marker and uncal that has the form &java@cycle(...), 
   evaluate the uncal and extract the node corresponding to the output marker *)
val omarker2vtx : marker -> 'a option aexpr -> graph * SetofVtx.elt

(* given an output marker and uncal file, extract and return rpp from the root *)
val omarker2path : marker -> string -> 'a option rpp
 
