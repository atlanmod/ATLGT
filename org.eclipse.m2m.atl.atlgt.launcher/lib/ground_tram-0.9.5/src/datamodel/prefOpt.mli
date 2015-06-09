(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
module type ONLGsig =
  sig
    type nid
    module SetofEdg : Set.S with type elt = (nid * nid)
    val pp_nid : Format.formatter -> nid -> unit
  end

module OPT :
  functor (NLG : ONLGsig) ->
  sig
    val paige_tarjan_opt : NLG.nid list list -> NLG.SetofEdg.t -> NLG.nid list list
  end
