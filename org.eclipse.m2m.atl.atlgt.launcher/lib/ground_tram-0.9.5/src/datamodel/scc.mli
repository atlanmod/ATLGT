(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
open ExtSetMap

(* SCC modlule requirements:
   SVtx:  Module implementing set of nodes  
   SEdge: Module implementing set of edges
   MVtx:  Module implementing map from nodes
   getEnds: Function from edge to pair of end nodes
   mapEnds: Function that apply a pair of node-to-node functions to edges

   Clients should create a module that implements the above and pass to
   functor SCC to obtain implementation of SCC or TC computation for the
   graph data type.
 *)

module type UGsig =
  sig
    module SVtx :
      sig
	include Set.S
      end
    module SEdge :
      sig
	include Set.S 
      end
    module MVtx :
      sig
	include Map.S with type key = SVtx.elt
      end
    val getEnds : SEdge.elt -> (SVtx.elt * SVtx.elt)
    val mapEnds : ((SVtx.elt -> SVtx.elt) * (SVtx.elt -> SVtx.elt)) -> SEdge.elt -> SEdge.elt
  end

module SCC : functor (UG : UGsig) -> 
  sig
    val make_scc : UG.SVtx.t -> UG.SEdge.t -> UG.SVtx.t UG.MVtx.t 
    val make_gscc : UG.SEdge.t -> UG.SVtx.t UG.MVtx.t ->
        (UG.SVtx.t * UG.SEdge.t) * (UG.SVtx.t * UG.SEdge.t * UG.SEdge.t) UG.MVtx.t *
        (UG.MVtx.key -> UG.MVtx.key)
    val make_tc : UG.SVtx.t -> UG.SEdge.t -> (UG.SVtx.t * UG.SEdge.t) UG.MVtx.t   
    val build_ioedge_map : UG.SVtx.t -> UG.SEdge.t -> (UG.MVtx.key -> UG.SEdge.t) * (UG.MVtx.key -> UG.SEdge.t)
  end

