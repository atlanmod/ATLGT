(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
(* node labeled graph representation of UnCAL data model *)

open UnCAL
open UnCALDM
open UnCALDMutil
open Format
open PrintUnCAL
open PrintUnCALDM
open ExtSetMap
open Fputil

(* node label *)
type nlabel =
    El of allit                            (* labels  on original edge *)
  | Mk of (SetofMarker.t * SetofMarker.t)  (* markers on original node *)

let pp_nlabel fmt = function
    El l   -> fprintf fmt "%a" pr_allit l
  | Mk pm  -> 
      let (iml,oml) = mapT2 SetofMarker.elements pm  in
      let ppr_marker ppf m = fprintf ppf "%s" m in
      let pr_lmarks ppf mL = 
	fprintf ppf "{@[%a@]}" (pr_list ppr_marker) mL in
      fprintf fmt "%a%a" pr_lmarks iml pr_lmarks oml 

(* node identifier *)
type nid = 
    Vtx of vtx
  | Edg of edge

let pp_nid fmt = function
    Vtx v -> fprintf fmt "%a" pr_vtx  v
  | Edg e -> fprintf fmt "%a" pr_edge e

(* labeled node *)
type lnode = nid * nlabel

let pp_lnode fmt ((v,l):lnode) : unit =
  fprintf fmt "@[<1>(%a,@,%a)@]" pp_nid v pp_nlabel l 

(* set of labeled nodes *)
module SetofLNode = Set.Make (
  struct
    type t = lnode
    let compare = Pervasives.compare
  end
)

(* set of set of labeded nodes *)
module SSetofLNode = Set.Make (
  struct
    type t = SetofLNode.t
    let compare = SetofLNode.compare
  end
)


(* unlabeled edge *)
type uledge = lnode * lnode

let pp_uledge fmt ((u,v):uledge) : unit = 
  fprintf fmt "%a -> %a" pp_lnode u pp_lnode v



(* set of unlabeled edge *)
module SetofULEdge = Set.Make (
  struct 
    type t = uledge
    let compare = Pervasives.compare
  end
)

(* pretty printers for sets *)
let pr_SetofLNode   =   SetofLNode.pp_t "" pp_lnode
let pr_SetofULEdge  =  SetofULEdge.pp_t "" pp_uledge
let pr_SSetofLNode  =  SSetofLNode.pp_t "" pr_SetofLNode

(*
#install_printer pr_SetofLNode;;
#install_printer pr_SetofULEdge;;
#install_printer pr_SSetofLNode;;
*)

let print_SetofLNode     = fprintf std_formatter "%a@." pr_SetofLNode
let print_SetofNLEdge    = fprintf std_formatter "%a@." pr_SetofULEdge
let print_SSetofLNode    = fprintf std_formatter "%a@." pr_SSetofLNode

(* node labeled graph *)
type nlgraph = {
  nv : SetofLNode.t;  (* set of labeled nodes *)
  ne : SetofULEdge.t; (* set of unlabeled edges *)
}

module   Vtx2LNodeSHom =    SetofVtx.SHom(SetofLNode)
module Edge2ULEdgeSHom =   SetofEdge.SHom(SetofULEdge)
module ULEdge2EdgeSHom = SetofULEdge.SHom(SetofEdge)
module  LNode2EdgeSHom =  SetofLNode.SHom(SetofEdge)
let maps_Vtx2LNode     =   Vtx2LNodeSHom.maps
let setmap_Edge2ULEdge = Edge2ULEdgeSHom.setmap
let setmap_ULEdge2Edge = ULEdge2EdgeSHom.setmap
let setmap_LNode2Edge  =  LNode2EdgeSHom.setmap


(* build a map from vtx to a pair of sets of I/O markers *)
let build_markers_map g =
  let initMap = vtxSet2Map (fun v -> (SetofMarker.empty, SetofMarker.empty)) g.v in
  let madd = SetofMarker.add in
  let nmap = SetofInodeR.fold (fun (m,v) ->
    MapofVtx.update (cross (madd m,    id)) v) g.i initMap in
  let nmap' = SetofOnodeR.fold (fun (v,m) -> 
    MapofVtx.update (cross (    id,madd m)) v) g.o nmap in
  nmap'

(* make a function that maps vtx to pair of sets of its I/O markers *)
let build_ionode_map g =
  let nmap = build_markers_map g in
  let lookup v = MapofVtx.find v nmap in
  lookup

(* edge-labeled graph to node-labeled graph *)
let elg2nlg_vtx2lnode (g:graph) : (nlgraph * (vtx -> lnode)) =
  let markers_g = build_ionode_map g in
  let vtx2lnode v = (Vtx v,Mk (markers_g v)) in
  let (nv,ne) = SetofEdge.fold
       (fun ((u,l,v) as e) (nvS0,neS0) ->
	 let (nlnode_u,nlnode_v) = mapT2 vtx2lnode (u,v) in
	 let nlnode_l = (Edg e,El l) in
	 (SetofLNode.add nlnode_l nvS0,
	  SetofULEdge.union (SetofULEdge.fromList [(nlnode_u,nlnode_l);(nlnode_l,nlnode_v)])
	    neS0)) g.e (maps_Vtx2LNode vtx2lnode g.v, SetofULEdge.empty) in
  ({ nv=nv; ne=ne; },vtx2lnode)

let elg2nlg (g:graph) : nlgraph = fst (elg2nlg_vtx2lnode g)

(* map of labeled node *)
module MapofLNode = Map.Make (struct 
    type t = lnode
    let compare = Pervasives.compare
  end )

(* map of node label *)
module MapofNlabel = Map.Make (struct 
    type t = nlabel
    let compare = Pervasives.compare
  end )

let lnodeSet2Map f = MapofLNode.set2map (module SetofLNode : Set.S with type elt = lnode and type t = SetofLNode.t) f

(* make a pair of functions that maps labeled node to set of its
   incoming and outgoing unlabeled edges *)
let build_nlgraph_ioedge_map g =
  let initMapIE = lnodeSet2Map (fun v -> SetofULEdge.empty) g.nv in
  let initMapOE = lnodeSet2Map (fun v -> SetofULEdge.empty) g.nv in
  let (imap,omap) = SetofULEdge.fold
      (fun ((u,v) as e) -> cross (mapT2 (MapofLNode.update (SetofULEdge.add e)) (v,u)))
      g.ne (initMapIE,initMapOE) in
  ((fun v -> MapofLNode.find v omap),
   (fun v -> MapofLNode.find v imap))

(* make a function that maps labeled node to its preimage *)
let build_ngraph_preimage_map g =
  let initMap = lnodeSet2Map (fun v -> SetofLNode.empty) g.nv in
  let pmap = SetofULEdge.fold
      (fun (u,v) -> MapofLNode.update (SetofLNode.add u) v)
      g.ne initMap in
  (fun v -> MapofLNode.find v pmap)

(* node-labeled graph to edge-labeled graph *)
let nlg2elg (g:nlgraph) : graph = 
  let (oEdgeS,iEdgeS) = build_nlgraph_ioedge_map g in
  let combEdge (ieS:SetofULEdge.t) (oeS:SetofULEdge.t) : SetofEdge.t = 
    SetofULEdge.fold (fun (nu,ln1) -> SetofEdge.union
      (SetofULEdge.fold (fun (ln2,nv) ->
	SetofEdge.add
	(match (nu,ln1,ln2,nv) with
	  ((Vtx u,_),(Edg _,El l1),(Edg _,El l2),(Vtx v,_)) when ln1=ln2 -> (u,l1,v)
	| _  -> failwith "nlg2elg: unmatched intermediate labeled node")) oeS SetofEdge.empty))
	ieS SetofEdge.empty in
  let (vS,lnS,iS,oS) = SetofLNode.fold (fun (v,ol) (vS0,lnS0,iS0,oS0) ->
     match (v,ol) with
       (Vtx v,Mk (imS,omS)) ->
	  let iS1 = maps_Marker2InodeR (fun m -> (m,v)) imS in
	  let oS1 = maps_Marker2OnodeR (fun m -> (v,m)) omS in
	  (SetofVtx.add v vS0,lnS0,SetofInodeR.union iS1 iS0,SetofOnodeR.union oS1 oS0)
     | (Edg e,El l) -> (vS0,SetofLNode.add (v,ol) lnS0,iS0,oS0)
     | _            -> failwith "lng2elg: invalid combination") 
      g.nv (SetofVtx.empty,SetofLNode.empty,SetofInodeR.empty,SetofOnodeR.empty) in
  let lnode2edgeS ln = match ln with
    (Vtx _, _) -> failwith "lnode2edgeS: can't make edge from Vtx node"
  | (Edg _, _) -> 
      let (ieS,oeS) = fsplit (iEdgeS,oEdgeS) ln in
      combEdge ieS oeS in
  let eS = setmap_LNode2Edge lnode2edgeS lnS in
  { v = vS; e = eS; i = iS; o = oS;}

