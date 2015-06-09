(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
(* pretty printer for Dot format *)
open UnCALDM
open Dot
open UnCAL
open Format


val node_id2str : int -> string
val shape2str : shape -> string

(* exported for other tools that print node ID, allit and edge *)
val pp_skolemV : formatter -> vtx   -> unit
val pp_allit :   formatter -> allit -> unit
val pp_edge :    formatter -> edge  -> unit

(** main pretty printer **)
val pp_dot : ?shape:shape -> ?prefix_n:bool
  -> ?expnl:bool -> ?is_uncal:bool -> formatter -> dot -> unit

val g2dot_file_light : ?noclean:bool -> ?expnl:bool              -> graph -> string -> unit
val g2png_light :      ?remove_dot_file:bool -> ?dot_file:string -> graph -> string -> unit

val dotf2pngf   :           string -> string -> unit
val dotf2imagef : string -> string -> string -> unit

