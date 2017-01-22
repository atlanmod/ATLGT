(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
open ExtSetMap

module type NLGsig =
  sig
    module SLNode : sig include Set.S end 
    module SULEdge : Set.S with type elt = (SLNode.elt * SLNode.elt)
    module SSLNode : Set.S with type elt = SLNode.t
    val pr_SLNode : Format.formatter -> SLNode.t -> unit
    val pr_SSLNode : Format.formatter -> SSLNode.t -> unit 
  end

module PT :
  functor (NLG : NLGsig) ->
  sig
    val paige_tarjan : NLG.SLNode.t -> NLG.SULEdge.t -> NLG.SSLNode.t -> NLG.SSLNode.t
  end
