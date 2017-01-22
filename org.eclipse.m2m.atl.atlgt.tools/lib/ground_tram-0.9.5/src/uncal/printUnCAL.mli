(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
open UnCAL
open Format
val allit2str : allit -> string
val pr_allit : formatter -> allit -> unit
val marker2str : marker -> string
val pr_marker : formatter -> marker -> unit
val pr_vname : formatter -> vname -> unit
val pr_lname : formatter -> lname -> unit


val pr_SetofVname : formatter -> SetofVname.t -> unit
val pr_SetofLname : formatter -> SetofLname.t -> unit

val ppr_aexpr  : ?pp_a:(formatter -> 'a -> unit) -> formatter -> 'a aexpr  -> unit
val ppr_abexpr : ?pp_a:(formatter -> 'a -> unit) -> formatter -> 'a abexpr -> unit
val ppr_alpat  : formatter -> allit alpat  -> unit
val ppr_a_aexpr  : formatter -> 'a aexpr  -> unit
val print_aexpr : ?pp_a:(formatter -> 'a -> unit) -> 'a aexpr -> unit

val ensugar : bool ref
val vname2str : string -> string
val lname2str : string -> string
