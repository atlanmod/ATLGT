(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
open UnCALDM
open Scc

(* Module that provide set of nodes, set of edges, map of nodes,
  element-wise converter from labeled edge to unlabeled edge,
  and map function for each endpoints that do not touch labels.
  The last two functions absorbs the difference between 
  labeled and unlabeled edges so that instantiation of 
  clients native graph model is realized.
 *)

module UnCALGraph =
  struct
    module SVtx = struct
      include SetofVtx
    end
    module SEdge = struct 
      include SetofEdge
    end
    module MVtx = struct
      include MapofVtx
    end
    let getEnds (vs,l,vt) = (vs,vt) 
    let mapEnds (f,g) (vs,l,vt) = (f vs,l,g vt)
end

(* Instantiation of SCC related computations for UnCAL graph data model *)
module USCC = SCC(UnCALGraph)

let g2tc (g:graph) = USCC.make_tc g.v g.e

let make_dvmap (g:graph) = 
  let mtc = g2tc g in
  MapofVtx.mapi (fun key (vS,eS) ->
    { v = vS; e = eS; i = SetofInodeR.singleton ("&",key);
      o = SetofOnodeR.filter (fun (v,m) -> SetofVtx.mem v vS) g.o}) mtc

(* returns a function that obtains d_v from node v *)
let build_dvmap (g:graph) = 
  let dvmap = make_dvmap g in
  (fun v -> MapofVtx.find v dvmap)

(* SCC with shared edge *)

(*
let g4 = slists2graph
    [1;2;3;4]
    [(1,"a",2);(2,"a",3);(3,"a",4);(4,"a",2);(3,"a",1);] 
    [] []
let _ = dispG_gc ~is_raw:true g4

let m = g2scc g4
let vS = MapofVtx.find (Bid 1) m

let _ = Format.fprintf  Format.std_formatter "%a@." pr_SetofVtx vS
*)
