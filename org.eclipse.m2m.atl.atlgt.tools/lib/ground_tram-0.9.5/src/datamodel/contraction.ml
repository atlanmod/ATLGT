(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
(* Bisimulation contraction using UnCAL edge labels and node markers. *)
(* Edge label is moved to nodes and markers are translated to 
   label on nodes. 
   These labels are used to cluster nodes by labels and create 
   initial partiton that is fed to Paige-Tarjan algorithm. *)


open UnCALDM
open UnCALDMutil
open Fputil
open Format
open UnCALDMnlabel
open Prefine
open PrefOpt

(* classify set of labeled nodes u by their node labels *)
let classify_by_nlabel (u:SetofLNode.t) : SSetofLNode.t = 
  let nlabel_map =
      SetofLNode.fold (fun ((nid,nlabel) as node) m0 ->
	match (MapofNlabel.find_some nlabel m0) with
	  None    -> MapofNlabel.add nlabel (SetofLNode.singleton node) m0
	| Some nS -> MapofNlabel.add nlabel (SetofLNode.add node nS)    m0)
	u MapofNlabel.empty in
  MapofNlabel.fold (fun _ nS -> SSetofLNode.add nS) nlabel_map SSetofLNode.empty

(* assuming the uniqueness of node IDs, each class consists of list of nodes *)
let listOfnodeListByNlabel (u:SetofLNode.t) (* : lnode list list *) =
  let nlabel_map =
      SetofLNode.fold (fun ((nid,nlabel) as node) m0 ->
	match (MapofNlabel.find_some nlabel m0) with
	  None    -> MapofNlabel.add nlabel [node]     m0
	| Some nL -> MapofNlabel.add nlabel (node::nL) m0)
	u MapofNlabel.empty in
  MapofNlabel.fold (fun _ nL -> cons nL) nlabel_map []


(* return function from lnode to its representative *)
let build_lnode2repr (q:SSetofLNode.t) =
  let lnode2repr_map = 
    SSetofLNode.fold (fun nS ->
      let repr = SetofLNode.choose nS in
      SetofLNode.fold (fun lnode -> MapofLNode.add lnode repr) nS) q MapofLNode.empty in
  (fun lnode -> MapofLNode.find lnode lnode2repr_map)
    


(* module that provide set of nodes, set of pair of nodes and
  map of nodes *)

module UnCALNLGraph =
  struct
    module SLNode = struct
      include SetofLNode
    end
    module SULEdge = struct 
      include SetofULEdge
    end
    module SSLNode = struct
      include SSetofLNode
    end
    let pr_SLNode = pr_SetofLNode
    let pr_SSLNode = pr_SSetofLNode
end

(* instantiate paige_tarjan *)
module UPT = PT(UnCALNLGraph)

(* apply Paige-Tarjan on edge-labeled graph *)
let paige_tarjan_graph (g:graph) = 
  let nlg = elg2nlg g in
  let p = classify_by_nlabel nlg.nv in
  let q = UPT.paige_tarjan nlg.nv nlg.ne p in
  let lnode2repr = build_lnode2repr q in
  let nlg' = { nv = SetofLNode.map lnode2repr nlg.nv;
	       ne = SetofULEdge.map (cross (lnode2repr,lnode2repr)) nlg.ne;} in
  nlg2elg nlg'


let contract = paige_tarjan_graph


module OUnCALNLGraph =
  struct
    type nid = lnode
    module SetofEdg = struct 
      include SetofULEdge
    end
    let pp_nid = pp_lnode
end

(* instantiate paige_tarjan *)
module OUPT = OPT(OUnCALNLGraph)

(* return function from lnode to its representative (list of list version) *)
let build_lnode2repr_nLL nLL =
  let lnode2repr_map =
    List.fold_left (fun m1 nL ->
      let repr = List.hd nL in
      List.fold_left (fun m0 lnode -> MapofLNode.add lnode repr m0) m1 nL) MapofLNode.empty nLL  in
  (fun lnode -> MapofLNode.find lnode lnode2repr_map)


(* apply Paige-Tarjan on edge-labeled graph *)

(* auxiliary function to convert edge-labeled graph to node-labeled graph,
   partition, and return triple of node labeled graph, function from node to labeled node,
   and function from labeled-node to its representative in the partition *)
let paige_tarjan_graph_opt_aux (g:graph) = 
  let (nlg,vtx2lnode) = elg2nlg_vtx2lnode g in
  let nLL = listOfnodeListByNlabel nlg.nv in
  let nLL = OUPT.paige_tarjan_opt nLL nlg.ne in
  let lnode2repr = build_lnode2repr_nLL nLL in
  (nlg,vtx2lnode,lnode2repr)

(* contract node-labeled graph using function from labeled-node to its representative *)
let contract_nlg lnode2repr nlg =
  { nv = SetofLNode.map lnode2repr nlg.nv;
    ne = SetofULEdge.map (cross (lnode2repr,lnode2repr)) nlg.ne;}

(* contraction of edge-labeled graph *)
let paige_tarjan_graph_opt (g:graph) =
  let (nlg,vtx2lnode,lnode2repr) = paige_tarjan_graph_opt_aux g in
  let nlg' = contract_nlg lnode2repr nlg in
  nlg2elg nlg'

let contract_opt = paige_tarjan_graph_opt

(* Contraction with maps: returns triple of graph after contraction,
   map from original node to representative node, and
   map from original edge to representative edge *)
let contract_opt_with_map (g:graph) =
  let (nlg,vtx2lnode,lnode2repr) = paige_tarjan_graph_opt_aux g in 
  let nlg' = contract_nlg lnode2repr nlg in
  let g'   = nlg2elg nlg' in
  let lnode2vtx = function
     (Vtx v, _) -> v | _ -> failwith "lnode2vtx: cannot map edge-oriented node" in
  let node2repr_map = vtxSet2Map (lnode2vtx @@ lnode2repr @@ vtx2lnode) g.v in
  let node2repr v   = MapofVtx.find v node2repr_map in
  let edge2repr_map = edgeSet2Map (cross3 (node2repr,id,node2repr))     g.e in
  (g',node2repr_map,edge2repr_map)

(***** bisimulation predicates  based on contraction  *******)

(* build a predicate for bisimilarity test of given pair of nodes
   for graph g *)
let build_bisimv_opt (g:graph) = 
  let (nlg,vtx2lnode,lnode2repr) = paige_tarjan_graph_opt_aux g in
  fun ((v1,v2):(vtx*vtx)) ->
    let (repr1,repr2) = mapT2 (lnode2repr @@ vtx2lnode) (v1,v2) in repr1 = repr2

(* returns true if nodes v1 and v2 are bisimilar in graph g *)
let bisimv_opt (v1:vtx) (v2:vtx) (g:graph) : bool =
  let f = build_bisimv_opt g in f (v1,v2)

(* Returns true if two graphs g1 and g2 are bisimilar.
   This function assumes that 
   1. Input markers of g1 and g2 coincide,
   2. Node IDs of g1 and g2 do not overlap,  i.e., overlapped nodes
      are treated as physically identical nodes, and
   3. No epsilon edge *)
let bisimilar_opt_aux (g1:graph) (g2:graph) = 
(* let setofinodes g = maps_InodeR2Vtx (fun (m,n) -> n) g.i in
   let (iL1,iL2) = mapT2 (SetofVtx.elements @@ setofinodes) (g1,g2) in  *)
  let g = evalg_simple_union g1 g2 in
  let bisimv = build_bisimv_opt g in
  let (iL1,iL2) = mapT2 (snd @@ List.split @@ SetofInodeR.elements) (g1.i,g2.i) in
  List.for_all bisimv (List.combine iL1 iL2)

(* Returns true if two graphs g1 and g2 are bisimilar. 
   It immediately return false if the input markers of g1 and g2 
   do not coincide. In addition, this function renames the 
   node IDs of g1 and g2 to make simple union taken in 
   bisimilar_opt_aux safe. *)
let bisimilar_opt (g1:graph) (g2:graph) = 
  let (mS1,mS2) = mapT2 inputMarkers (g1,g2) in
  (mS1 = mS2) &&
  let (g1,g2)   = mapT2 (reachableGI @@ remove_eps) (g1,g2) in
  let gid = GenId.current () in
  let (g1,_,end_id) = clean_id_aux ~start_id:(gid + 1) g1 in
  let (g2,_,_     ) = clean_id_aux ~start_id:end_id    g2 in
  let _ = GenId.set gid in
  bisimilar_opt_aux g1 g2

let bisimilar_opt_org = bisimilar_opt 

let bisimilar_opt2 (g1:graph) (g2:graph) =
  let (mS1,mS2) = mapT2 inputMarkers (g1,g2) in
  (mS1 = mS2) &&
  let (g1,g2) = mapT2 (reachableGI @@ remove_eps) (g1,g2) in
  let gid = GenId.current () in
  let (g1,_,end_id) = clean_id_aux ~start_id:(gid + 1) g1 in
  let (g2,_,_     ) = clean_id_aux ~start_id:end_id    g2 in
  let _ = GenId.set gid in
  let proj g m = reachableGI { g with i = SetofInodeR.singleton (m,lookupI g m);} in
  let gL1 =  List.map (proj g1) (SetofMarker.elements mS1) in
  let gL2 =  List.map (proj g2) (SetofMarker.elements mS2) in
  List.for_all (uncurry bisimilar_opt_aux) (List.combine gL1 gL2)

let bisimilar_opt = bisimilar_opt2

let evalg_ABisim = bisimilar_opt
