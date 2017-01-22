(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
open UnCALDM
open UnCAL

(** converters to UnCAL and its file representation **)
(** Known Issue: For g2uncalT and dumpGT, please refer to comments in g2UnCAL.ml.  **)
val g2uncal :  graph -> 'a option aexpr
val g2uncalT : graph -> 'a option aexpr     
val dumpG :    graph -> string -> unit
val dumpGT :   graph -> string -> unit

