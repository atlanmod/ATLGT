(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
(**
  Utilities for the UnCAL data model
 *)
open UnCALDM
open UnCAL
open PrintUnCALDM
open PrintUnCAL
open Fputil
open ExtSetMap

let evalg_simple_union g1 g2 =
  { v =    SetofVtx.union g1.v g2.v; 
    e =   SetofEdge.union g1.e g2.e;
    i = SetofInodeR.union g1.i g2.i;
    o = SetofOnodeR.union g1.o g2.o;
  }

let evalg_simple_diff g1 g2 =
  { v =    SetofVtx.diff g1.v g2.v; 
    e =   SetofEdge.diff g1.e g2.e;
    i = SetofInodeR.diff g1.i g2.i;
    o = SetofOnodeR.diff g1.o g2.o;
  }

module      Vtx2EdgeSHom =    SetofVtx.SHom(SetofEdge)
module      Edge2VtxSHom =   SetofEdge.SHom(SetofVtx)
module     Edge2PVtxSHom =   SetofEdge.SHom(SetofPVtx)
module     PVtx2EdgeSHom =   SetofPVtx.SHom(SetofEdge)
module    InodeR2VtxSHom = SetofInodeR.SHom(SetofVtx)
module   InodeR2EdgeSHom = SetofInodeR.SHom(SetofEdge)
module   OnodeR2EdgeSHom = SetofOnodeR.SHom(SetofEdge)
module InodeR2MarkerSHom = SetofInodeR.SHom(SetofMarker)
module OnodeR2MarkerSHom = SetofOnodeR.SHom(SetofMarker)
module    Marker2VtxSHom = SetofMarker.SHom(SetofVtx)
module Marker2InodeRSHom = SetofMarker.SHom(SetofInodeR)
module Marker2OnodeRSHom = SetofMarker.SHom(SetofOnodeR)

(* let maps_Edge2Vtx      = SetofEdge.mapto (module SetofVtx : Set.S with type elt = vtx and type t = SetofVtx.t) *)
let maps_Vtx2Edge      =      Vtx2EdgeSHom.maps
let maps_Edge2Vtx      =      Edge2VtxSHom.maps
let maps_Edge2PVtx     =     Edge2PVtxSHom.maps
let maps_PVtx2Edge     =     PVtx2EdgeSHom.maps
let maps_InodeR2Vtx    =    InodeR2VtxSHom.maps
let maps_InodeR2Edge   =   InodeR2EdgeSHom.maps
let maps_OnodeR2Edge   =   OnodeR2EdgeSHom.maps
let maps_InodeR2Marker = InodeR2MarkerSHom.maps
let maps_OnodeR2Marker = OnodeR2MarkerSHom.maps
let maps_Marker2Vtx    =    Marker2VtxSHom.maps
let maps_Marker2InodeR = Marker2InodeRSHom.maps
let maps_Marker2OnodeR = Marker2OnodeRSHom.maps

module  Marker2EdgeSHom =   SetofMarker.SHom(SetofEdge)
module  Edge2MarkerSHom =     SetofEdge.SHom(SetofMarker)

let setmap_Vtx2Edge      =      Vtx2EdgeSHom.setmap
let setmap_PVtx2Edge     =     PVtx2EdgeSHom.setmap
let setmap_Edge2PVtx     =     Edge2PVtxSHom.setmap
let setmap_Edge2Vtx      =      Edge2VtxSHom.setmap
let setmap_OnodeR2Edge   =   OnodeR2EdgeSHom.setmap
let setmap_InodeR2Edge   =   InodeR2EdgeSHom.setmap
let setmap_Marker2Edge   =   Marker2EdgeSHom.setmap
let setmap_Marker2OnodeR = Marker2OnodeRSHom.setmap
let setmap_Edge2Marker   =   Edge2MarkerSHom.setmap

(* let  vtxSet2Map f vS =  SetofVtx.fold (fun v ->  MapofVtx.add v (f v)) vS  MapofVtx.empty *)
let  vtxSet2Map f = MapofVtx.set2map  (module SetofVtx  : Set.S with type elt = vtx  and type t = SetofVtx.t)  f
(* let edgeSet2Map f eS = SetofEdge.fold (fun v -> MapofEdge.add v (f v)) eS MapofEdge.empty *)
let edgeSet2Map f = MapofEdge.set2map (module SetofEdge : Set.S with type elt = edge and type t = SetofEdge.t) f

(*
let invert_MapofVtx2SVtx m =
  let mapofVtx_uadd = MapofVtx.uadd SetofVtx.singleton SetofVtx.add in
  MapofVtx.fold (fun key -> SetofVtx.fold ((flip mapofVtx_uadd) key)) m MapofVtx.empty
*)
(*
let invert_MapofEdge2SEdge m =
  let mapofEdge_uadd = MapofEdge.uadd SetofEdge.singleton SetofEdge.add in
  MapofEdge.fold (fun key -> SetofEdge.fold ((flip mapofEdge_uadd) key)) m MapofEdge.empty
*)

let (&^) m1 m2 = match (m1,m2) with
  ("&",_) -> m2
| (_,"&") -> m1
|  _      -> m1 ^ m2

(* requirement for Skolem function S1 & S2 in bulk semantics:
   1. different value for different pair of arguments
   2. values are ordered  (to be hosted by O'Caml Set container)
   3. meets type constraints (to be hosted by O'Caml type system)
      i.e., closed under function application:

    nodeid : Tn
    marker : Tm
    S1 : (Tn,Tm) -> T1
    T1 = Tn   (since values of S1 are used as node IDs)
    label : Te
    S2 : (Tn,Te,Tn,Tn) -> T2
    T2 = Tn   (since values of S2 are used as node IDs)

    Skolem function here is used to properly coalesce nodes
    independently constructed in parallel. As long as these
    coalescing takes place properly, Skolem function is not
    required. We might simulate these functionality using 
    gensym, a globally unique sequential ID generator.
    However, the approach taken here is straightforward
    using algebraic data type, because in O'Caml, it seems 
    that you can get ordering function for any algebraic data 
    type and tuple built from orderable basic data type for free 

    # (S1 (Bid 1,"yama")) < (S2 ((S1 (Bid 1,"yama")),2,(S1 (Bid 1,"yama")),(S1 (Bid 1,"yama"))));;
    - : bool = true
    # 
*)

(* Skolem function S1 and S2 *)
(*
let s1 u z = S1 (u,z)
let s2 u a v w = S2 (u,a,v,w)
*)
(* tuple argument version as used in eval_fwd_AERec might be more useful *)

(** apply function [f] on each node id *)
let map_VEIO f g' =
  { v =    SetofVtx.map          f        g'.v;
    e =   SetofEdge.map (cross3 (f,id,f)) g'.e; 
    i = SetofInodeR.map (cross  (id,f))   g'.i;
    o = SetofOnodeR.map (cross  (f,id))   g'.o; }

(** returns true for tuples in I that contain root node  *)
let isroot : (inodeR -> bool)  = function 
    ("&",_) -> true
  | _       -> false

(** returns true if [v] is root in graph [g] *)
let isrootG g v = SetofInodeR.mem ("&",v) g.i

(** returns true if [v] is an input node  in graph [g] *)
let isInodeG g v = SetofInodeR.exists (fun (_,n) -> n = v) g.i

(** returns true if [v] is an output node in graph [g] *)
let isOnodeG g v = SetofOnodeR.exists (fun (n,_) -> n = v) g.o


(* (tentative) graph printer *)
let graph2lists g = match g with
  {v=v;e=e;i=i;o=o;} -> 
   (   SetofVtx.elements v,  SetofEdge.elements e,
    SetofInodeR.elements i,SetofOnodeR.elements o)
(** the empty graph () instance *)
let emptyGraph = { v=   SetofVtx.empty; e=  SetofEdge.empty;
		   i=SetofInodeR.empty; o=SetofOnodeR.empty; }


(** returns set of incoming edges to node [v] in graph [g] *)
let incomEdgeS g v = SetofEdge.filter (fun (_,_,v') -> v' = v) g.e
(** returns set of outgoing edges from node [v] in graph [g] *)
let outgoEdgeS g v = SetofEdge.filter (fun (v',_,_) -> v' = v) g.e
(** returns set of outgoing edges from set of nodes [vS] in graph [g] *)
let outgoEdgeSS g vS = setmap_Vtx2Edge (fun v -> outgoEdgeS g v) vS 
(** returns set of incoming edges from set of nodes [vS] in graph [g] *)
let incomEdgeSS g vS = setmap_Vtx2Edge (fun v -> incomEdgeS g v) vS


(** function I(m): lookup node in input node relation I using marker m as a key *)
(*
let lookupI g m = 
  let vS = SetofInodeR.fold (fun (m',v) -> 
    if (m' = m) then (SetofVtx.add v) else id)  g.i SetofVtx.empty in
  let nvS = SetofVtx.cardinal vS in
  if (nvS = 0) then raise Not_found (* ("no such input node marked with " ^ m) *)
  else if (nvS = 1) then SetofVtx.choose vS
  else failwith ("lookupI: Multiple or negative number of input nodes marked with " ^ m)
*)
let lookupI g m = 
  let mir = SetofInodeR.filter (fun (m',_) -> (m' = m)) g.i in
  match SetofInodeR.cardinal mir with
    0 -> raise Not_found (* ("no such input node marked with " ^ m) *)
  | 1 -> snd (SetofInodeR.choose mir)
  | _ -> failwith ("lookupI: Multiple or negative number of input nodes marked with " ^ m)

(** extract nodes from set of edges *)
let setofEdge_collectNodes = setmap_Edge2Vtx (fun (vs,_,vt) -> SetofVtx.fromList [vs;vt])

(** add an edge (and its end nodes) to a graph *)
let add_edge (g:graph) ((u,l,v) as e:edge) : graph = 
  { g with 
    v = SetofVtx.addl [u;v] g.v;
    e = SetofEdge.add e     g.e;}

(** remove an edge (and its end nodes if the node becomes unreachable) *)
let remove_edge (g:graph) ((u,l,v) as e:edge) : graph =
  let will_disconnected u =
  (* if u is not an input node and there is no other edge incoming
     or outgoing, u is deleted *)
     (not (isInodeG g u)) &&
      let   ioEdgesU = SetofEdge.union (incomEdgeS g u) (outgoEdgeS g u) in
      let restEdgesU = SetofEdge.remove e ioEdgesU in
      (SetofEdge.is_empty restEdgesU) in
  let remove_oR u =
    (* if u has an output marker, then corresponding marker is also deleted *)
    if (isOnodeG g u) then SetofOnodeR.filter (fun (y,_) -> (y <> u)) else id in
  let (vS,oS) =
    if (will_disconnected u)
    then (SetofVtx.remove u g.v,remove_oR u g.o)
    else (g.v,g.o) in
  let (vS,oS) =
    if (will_disconnected v)
    then (SetofVtx.remove v vS, remove_oR v oS)
    else (vS,oS) in
  { g with  v = vS; o = oS;   e = SetofEdge.remove e g.e; }

(** partitions nodes in [g] into set of input nodes the rest of the nodes *)
let inputNodes g = 
  let setofinodes = maps_InodeR2Vtx (fun (m,n) -> n) g.i in
  SetofVtx.partition (fun x -> SetofVtx.mem x setofinodes) g.v
(** extract set of input markers from I *)
let inputMarkers g  = maps_InodeR2Marker (fun (m,n) -> m) g.i
(** extract set of output markers from O *)
let outputMarkers g = maps_OnodeR2Marker (fun (n,m) -> m) g.o


(** returns sets of input and output markers for vertex [v] in graph [g] *)
let markersV (g:graph) (v:vtx) = 
  maps_InodeR2Marker (fun (m,v) -> m) (SetofInodeR.filter (fun (m,v') -> v = v') g.i),
  maps_OnodeR2Marker (fun (v,m) -> m) (SetofOnodeR.filter (fun (v',m) -> v = v') g.o)

(** {9 navigation} *)

(** image (set of successor nodes) of node [v] *)
let imageVS (g:graph) (v:vtx) = SetofEdge.fold 
    (fun (u,_,w) vS -> if (u = v) then SetofVtx.add w vS else vS) g.e SetofVtx.empty

(** set of successor nodes traversing label [l] *)
let fwd (g:graph) (v:vtx) (l:allit) = 
  let oe = outgoEdgeS g v in
  maps_Edge2Vtx (fun (_,l',v') -> v')   (SetofEdge.filter (fun (_,l',v') -> l' = l) oe)

(** set of successor nodes of nodes [vS] traversing label [l] *)
let fwdS (g:graph) (vS:SetofVtx.t) (l:allit) = SetofVtx.setmap (fun v -> fwd g v l) vS

(** preimage (set of predecessor nodes) of node [v] *)
let preimgVS (g:graph) (v:vtx) = SetofEdge.fold
    (fun (u,_,w) vS -> if (w = v) then SetofVtx.add u vS else vS) g.e SetofVtx.empty

(** set of predecessor nodes traversing label [l] *)
let bwd (g:graph) (v:vtx) (l:allit) = 
  let ie = incomEdgeS g v in
  maps_Edge2Vtx (fun (v',l',v) -> v')   (SetofEdge.filter (fun (_,l',_) -> l' = l) ie)

(** set of predecessor nodes of nodes [vS] traversing label [l] *)
let bwdS (g:graph) (vS:SetofVtx.t) (l:allit) = SetofVtx.setmap (fun v -> bwd g v l) vS

(** {9 viewmaps } 

 Utilities for maps between internal nodes and edges and those on the view
*)


let empty_viewmaps :  viewmaps =
  { mapV =  MapofVtx.empty;
    mapE = MapofEdge.empty;}

let init_viewmaps (g:graph) : viewmaps =
  { mapV =  vtxSet2Map  SetofVtx.singleton g.v;
    mapE = edgeSet2Map SetofEdge.singleton g.e;}

(* Along with merger of v_from with v_to in mgraph_glue_safe_eps, *)
(* migrate data mapped from v_from to that of v_to. Entry         *)
(* (key and value) of v_from is removed. *)
let viewmaps_merge_vtx ~(v_to:vtx) ~(v_from:vtx) (vm: viewmaps) : unit = 
  let vSfrom = MapofVtx.find v_from vm.mapV in
  vm.mapV <- MapofVtx.remove                         v_from vm.mapV;
  vm.mapV <- MapofVtx.update (SetofVtx.union vSfrom) v_to   vm.mapV

(* Along with alteration of e_from to e_to in mgraph_glue_safe_eps,*)
(* migrate ONE member of the data mapped from e_from to that of    *)
(* e_to (ONE because identical edges as the result of migration    *)
(* do not collapse into one because of their distinct              *)
(* representations using mutable data structure and unique ids,    *)
(* and consequently this function is called as often as the        *)
(* number of entries that is equal to the number of collapsed      *)
(* edges. Migration of all members would cause failure of finding  *)
(* entry in the next call.) Entry of e_to is created if it doesn't *)
(* exist. If the data becomes empty after migration, then the      *)
(* entry (key and value) of e_from is removed. *)
let viewmaps_migrate_1edge ~(e_to:edge) ~(e_from:edge) (vm : viewmaps) : unit =
  let eMig = (* edge to migrate *)
    let eSfrom = MapofEdge.find e_from vm.mapE in
    let c = SetofEdge.cardinal eSfrom in
    if c = 0 then failwith "viewmaps_migrate_1edge: empty entry"
    else
      let e = SetofEdge.choose eSfrom in
      vm.mapE <-
	if c = 1 then                        (* e_from entry removal *)
	  MapofEdge.remove                      e_from vm.mapE
	else                                 (* e_from entry update *)
      	  MapofEdge.update (SetofEdge.remove e) e_from vm.mapE; e in
  if (not (MapofEdge.mem e_to vm.mapE)) then (* e_to entry creation *)
    vm.mapE <- MapofEdge.add e_to SetofEdge.empty vm.mapE;
  vm.mapE <- MapofEdge.update (SetofEdge.add eMig) e_to vm.mapE

(* build map from pair of vtx to set of connecting edges *)
let setofEdge2mapofPVtx eS =
  let add_edge (((vs,_,vt) as e):edge) map =
    let entOrg = try (MapofPVtx.find (vs,vt) map) with
      Not_found -> SetofEdge.empty in
    let entNew = SetofEdge.add e entOrg in
    MapofPVtx.add (vs,vt) entNew map  in
  SetofEdge.fold add_edge eS  MapofPVtx.empty 
  

(** check if graph has multiple edges between any pair of nodes *)
let check_multiedge (g:graph) : bool =
  let mPVtx = setofEdge2mapofPVtx g.e in
  MapofPVtx.fold (fun (_,_) eS -> (||) (SetofEdge.cardinal eS > 1)) mPVtx false 

(** [merge_viewmaps view view' src vm] is a backward transformation
    of epsilon elimination. It reflects [view] to [view'] editing 
    operations back to [src] through epsilon-expanding mappings [vm].
    [view] is an epsilon-glued (shrinked) graph produced from [src]
    for presentation to user.
    Traceback map [vm] stores maps from node/edge in [view] to
    corresponding  nodes and edges in [src].
    User is assumed to edit [view] to produce [view'].
    Difference between [view] and [view'] is detected and translated to
    difference at the src (pre-shrinkage) level.
    This difference is applied to [src] and updated src is returned. 

    TODO: Output markers are not considered.  *)
let merge_viewmaps (view:graph) (view':graph) (src:graph) (vm:viewmaps) : graph = 
  (* functions that traceback node/edge beyond epsilon eliminations *)
  let lookup_v (v:vtx)  :  SetofVtx.t =  MapofVtx.find v vm.mapV in
  let lookup_e (e:edge) : SetofEdge.t = MapofEdge.find e vm.mapE in
  (* componentwise graph difference at view level *)
  let vAdd = evalg_simple_diff view' view  in (* components added   *)
  let vDel = evalg_simple_diff view  view' in (* components deleted *)
  (* function that traceback node beyond epsilon eliminations,
     taking possible node insertion on the view into account.
     getModVtx takes a node n in view' and returns a corresponding
     node in src. If n is not in the map (i.e., in original view),
     it is considered as an inserted node and returned as is. *)
  (* Argument n comes from an endpoint of newly detected
     edge in view' and the result is used in getModEdgS. *)
  let getModVtx (n:vtx) : vtx  =
    let vS = try lookup_v n with
      Not_found -> SetofVtx.singleton n in
    match SetofVtx.cardinal vS with
      1 -> SetofVtx.choose vS
    | _ -> failwith "ambiguous edge/node insertion" in
  (* returns true if two edges have source and destination in common *)
  let eqEnds  ((u',l',v'):edge) ((u,l,v):edge) : bool = (u=u') && (v=v') in
  (* returns a set of edges on src in modified form that corresponds to e'. *)
  (* Multiple edges may have been collapsed to one. *)
  (* First, obtain a set of edges that shares identical endpoints.
     If unique edge matches, consult viewmap and returns corresponding edges.
     Fails if more than one edge match.
     If no such edge is found, considered an insertion but if either
     of the endpoint is contained in origival view, correspoinding endpoint
     in the src is used. *)
  (* Since check_multiedge is called in make_editinfo that is called from
     edit_g, and if mutiedge is detected then merge_viewmaps is not used,
     multiedge is unlikely to be detected here.
     If multiple edge resides at src level, it is still fed to backward 
     evaluator as is, although it is detected by check_multiedge after 
     viewmap_glue_safe_eps whose result is unused. *)
  let getModEdgS ((u',l',v') as e':edge) : SetofEdge.t =
    let eS = SetofEdge.filter (eqEnds e') view.e in
    match SetofEdge.cardinal eS with
      1 -> let e =  SetofEdge.choose eS in
      SetofEdge.map (fun (u,l,v) -> (u,l',v)) (lookup_e e)
    | 0 ->  (* inserted edge *)
      SetofEdge.singleton (getModVtx u',l', getModVtx v')
    | _ -> 
	let (eAdd,eDel) = mapT2 (SetofEdge.filter  (eqEnds e')) (vAdd.e,vDel.e) in
	let (nAdd,nDel) = mapT2  SetofEdge.cardinal             (eAdd,  eDel  ) in
	if (nAdd = nDel) && nAdd = 1 then
	  let e = SetofEdge.choose eDel in
	  SetofEdge.map (fun (u,l,v) -> (u,l',v)) (lookup_e e)
	else 
	  failwith ("merge_viewmaps: multiple edge between nodes " 
		     ^ (toStr pr_vtx u') ^ " and " ^ (toStr pr_vtx v')
		    ^  "and editing is ambiguous"
		   ) in
  (* returns nodes in src that correspond to v on the view.  *)
  (* since it seems to be used only to detect added nodes,   *)
  (* lookup_v should never succeed ?   *)
  let getModVtxS (v:vtx) : SetofVtx.t  = 
    try (lookup_v v) with
      Not_found -> SetofVtx.singleton v in
  (* translate   added edges and nodes at view level into those at src level *)
  let eSadd = SetofEdge.setmap getModEdgS vAdd.e in
  let vSadd =  SetofVtx.setmap getModVtxS vAdd.v in
  (* translate deleted edges and nodes at view level into those at src level *)
  let eSdel = SetofEdge.setmap lookup_e   vDel.e in
  let vSdel =  SetofVtx.setmap lookup_v   vDel.v in
  (* apply differences to src *)
  let src' = {src  with e =  SetofEdge.diff  src.e  eSdel; 
                        v =   SetofVtx.diff  src.v  vSdel;} in
  let src' = {src' with e =  SetofEdge.union src'.e eSadd;
                        v =   SetofVtx.union src'.v vSadd;} in src'
   

(* update entry associated with key v of map m with the return value
   of f applied to the entry, and returns updated map *)
(*
let updateMapofVtx (f:'a->'a) (v:vtx) (m:'a MapofVtx.t) : 'a MapofVtx.t = 
  let orig = try (MapofVtx.find v m) with
    Not_found -> failwith "updateMapofVtx: Not_found" in
  MapofVtx.add v (f orig) m
*)

(** {9 graph indices}  *)

(** build a pair of maps from nodes to outgoing edges and incoming edges *)
let build_ioedge_map g =
  let initMapIE = vtxSet2Map (fun v -> SetofEdge.empty) g.v in
  let initMapOE = vtxSet2Map (fun v -> SetofEdge.empty) g.v in
  let (imap,omap) = SetofEdge.fold
    (* (fun ((u,l,v) as e) (im,om) ->
         (MapofVtx.add v (SetofEdge.add e (MapofVtx.find v im)) im,
          MapofVtx.add u (SetofEdge.add e (MapofVtx.find u om)) om)) *)
      (fun ((u,l,v) as e) -> cross (mapT2 (MapofVtx.update (SetofEdge.add e)) (v,u)))
      g.e (initMapIE,initMapOE) in
  ((fun v -> MapofVtx.find v omap),
   (fun v -> MapofVtx.find v imap))


(** Build a map from node id to pair consisting of
    - a pair of sets of outgoing and incoming edges and
    - a pair of sets of input    and output   markers. *)
let build_node_map g =
  let initMap = vtxSet2Map (fun v -> ((  SetofEdge.empty,   SetofEdge.empty), 
				      (SetofMarker.empty, SetofMarker.empty))) g.v in
  let eadd =   SetofEdge.add
  and madd = SetofMarker.add in
  let nmap = SetofEdge.fold
   (* (fun ((u,_,v) as e) nm ->
   let nm' = (MapofVtx.add v (cross (cross (id,SetofEdge.add e),cross (id,id)) (MapofVtx.find v nm)) nm)
           in MapofVtx.add u (cross (cross (SetofEdge.add e,id),cross (id,id)) (MapofVtx.find u nm')) nm') *)
 (fun ((u,_,v) as e) ->
   (MapofVtx.update (cross (cross (eadd e,    id),cross (    id,    id))) u) @@
   (MapofVtx.update (cross (cross (    id,eadd e),cross (    id,    id))) v)
      ) g.e initMap in
  let nmap' = SetofInodeR.fold (fun (m,v) -> 
    MapofVtx.update (cross (cross (    id,    id),cross (madd m,    id))) v)
      g.i nmap in
  let nmap'' = SetofOnodeR.fold (fun (v,m) -> 
    MapofVtx.update (cross (cross (    id,    id),cross (    id,madd m))) v)
      g.o nmap' in
  nmap''

(** quadruple  of lookup functions (outgoing_edges, incoming_edges,input_markers, output_markers) *)
let build_ioedge_ionode_map g =
  let nmap = build_node_map g in
  let lookup v = MapofVtx.find v nmap in
  ((fst @@ fst @@ lookup),(snd @@ fst @@ lookup),(fst @@ snd @@ lookup),(snd @@ snd @@ lookup))

(** Compute map from vertex to pair of its Upstream/Downstream Epsilon Closures.
   Set of non-epsilon edges and epsilon edges are returned as well. *)
let build_ud_EC (g:graph) : ((SetofVtx.t * SetofVtx.t) MapofVtx.t) * SetofEdge.t * SetofEdge.t =
  let initEC = vtxSet2Map (fsplit (SetofVtx.singleton,SetofVtx.singleton)) g.v in
  let vuni = SetofVtx.union in
  SetofEdge.fold (fun ((u,l,v) as e) (mapV',sNonEpsE',sEpsE') ->
    if l=ALEps then
      let (upEcU,_  ) = MapofVtx.find u mapV' in
      let (_,downEcV) = MapofVtx.find v mapV' in
      let mapV'' = SetofVtx.fold (MapofVtx.update (cross (        id,vuni downEcV))) upEcU   mapV'  in
      let mapV'''= SetofVtx.fold (MapofVtx.update (cross (vuni upEcU,          id))) downEcV mapV'' in
      (mapV''',sNonEpsE',SetofEdge.add e sEpsE')
    else (mapV',SetofEdge.add e sNonEpsE',sEpsE')) g.e (initEC,SetofEdge.empty,SetofEdge.empty)

(** {9 extracting difference} *)

let graph_diff_aux (gOrg:graph) (gMod:graph) =
  let gAdd = evalg_simple_diff gMod gOrg in
  let gDel = evalg_simple_diff gOrg gMod in
  let (mPVadd,mPVdel) = mapT2 setofEdge2mapofPVtx      (gAdd.e,gDel.e) in
  let getEnds ((vs,_,vt):edge) : (vtx * vtx) = (vs,vt) in
  let (sPVadd,sPVdel) = mapT2 (maps_Edge2PVtx getEnds) (gAdd.e,gDel.e) in
  let sPVmod = SetofPVtx.inter sPVadd sPVdel in
  let eSmod_alist = SetofPVtx.fold
      (fun pvtx  ->
	let (eAdd,eDel) = mapT2 (MapofPVtx.find pvtx) (mPVadd,mPVdel) in
	let (nAdd,nDel) = mapT2 SetofEdge.cardinal    (eAdd,  eDel  ) in
        (if (nAdd = nDel) && nAdd = 1
	       then (cons (mapT2 SetofEdge.choose (eAdd,eDel)))
               else id
              ))
       sPVmod [] in
  let (eSmodAdd,eSmodDel) = List.fold_right (fun (eAdd,eDel) -> 
    cross (mapT2 SetofEdge.add (eAdd,eDel))) eSmod_alist (SetofEdge.empty,SetofEdge.empty) in
  let eSadd = SetofEdge.diff  gAdd.e eSmodAdd in
  let eSdel = SetofEdge.diff  gDel.e eSmodDel in
  let eScon = SetofEdge.inter gOrg.e gMod.e   in
  let eSmod = eSmodAdd in
  let g = { v =    SetofVtx.fromLSet [gOrg.v;gDel.v;gAdd.v];
	    e =   SetofEdge.fromLSet [eScon;eSmod;eSadd;eSdel];
	    i = SetofInodeR.fromLSet [gOrg.i;gDel.i;gAdd.i];
	    o = SetofOnodeR.fromLSet [gOrg.o;gDel.o;gAdd.o]; } in
  (g,gAdd.v,gDel.v,eSadd,eSdel,eSmod,eSmod_alist)

(** {9 node ID generator} *)

(** base ID generator for nodes *)
module type GENID = 
  sig 
    val reset : unit -> unit
    val next : unit -> int
    val set  : int -> unit
    val current : unit -> int
end

module GenId : GENID = 
  struct
    let c = ref 0
    let reset () = c:=0
    let next () = incr c ; !c
    (* Setting and restoration of states for bidirectionalization
       (reproduce same result for same input expression). *)
    let set i = c := i 
    let current () = !c
  end
(* usage: p415 of O'reilly book *)
(* GenId.reset() 
   GenId.next ()
*)

(* node creation with unique identity *)
let newnode () : vtx  = Bid (GenId.next ()) 

(** {9 operators on nodes} *)

(* returns list of epsilon edges connecting edges between output node marker relation (list)
   onoderList1S with input nodes with identical markers in input node marker relation (list) inoderList2
   input relation lists should be sorted by marker
   (output relation list is sorted by this function)
   *)

let connect_nodesL (onoderList1S:onodeR list) (inoderList2:inodeR list) =
  let onoderList1 = (List.sort (fun x y -> Pervasives.compare (snd x) (snd y)) onoderList1S) in
  let rec cn ol il = match (ol,il) with
    ([],_) -> SetofEdge.empty
  | (_,[]) -> SetofEdge.empty (* in case of cycle(), not all output nodes have counterpart input nodes *)
  | (((onode,omark)::os as ols),((imark,inode)::is as ils)) ->
      if (omark = imark)
      then SetofEdge.add (onode,ALEps,inode) (cn os ils)
      else if (omark < imark) 
      then (cn os ils)
      else (cn ols is)
  in cn onoderList1 inoderList2

let connect_nodes (orS:SetofOnodeR.t) (irS:SetofInodeR.t) =
  connect_nodesL (SetofOnodeR.elements orS) (SetofInodeR.elements irS)

(* set comprehension version of connect_nodes *)
(* { (u,ALEps,v) | (u,y) \in orS, (x,v) \in irS, x = y } *)
let connect_nodesS (orS:SetofOnodeR.t) (irS:SetofInodeR.t) :  SetofEdge.t =
  setmap_OnodeR2Edge (fun (u,y) -> 
    maps_InodeR2Edge (fun (x,v) -> (u,ALEps,v)) (SetofInodeR.filter (fun (x,v) -> x = y) irS)) orS

(* Unify  v_src with v_dest. v_src disappears. Markers remain unchanged. *)
let glue_nodes (g:graph) (v_dest:vtx) (v_src:vtx) : graph =
  let iES = incomEdgeS g v_src in
  let oES = outgoEdgeS g v_src in
  let v  = SetofVtx.remove v_src g.v in 
  let e  = SetofEdge.fold (fun ((vs,l,vt) as iE) ->
           ((SetofEdge.add (vs,l,v_dest)) @@  (SetofEdge.remove iE))) iES g.e in
  let e' = SetofEdge.fold (fun ((vs,l,vt) as oE) ->
           ((SetofEdge.add (v_dest,l,vt)) @@  (SetofEdge.remove oE))) oES e in
  let i  = SetofInodeR.map (cross (id,(fun v -> if v = v_src then v_dest else v)))  g.i in
  let o  = SetofOnodeR.map (cross ((fun v -> if v = v_src then v_dest else v),id))  g.o in
  { v=v; e=e'; i=i;o=o;}

(**/**)
(* Epsilon edge elimination *)
(* Build and modify a map of vertex using records with mutable slots.
   The vertexes in the map are removed together with eliminated edges.
 *)


(*
type mVtx = 
    {id : vtx ;
     mutable incomE : mEdge ref list;
     mutable outgoE : mEdge ref list;
     mutable imarks : marker list;
     mutable omarks : marker list;
   }
and mEdge = {
     mutable sourceV : mVtx ref;
             xlabel  : allit;
     mutable destV   : mVtx ref;
   }

*)


(*
let remove_eps_opt g = 
  let mapIMark = SetofInodeR.fold (fun (x,v) -> MapofVtx.add v x) g.i MapofVtx.empty in
  let mapOMark = SetofOnodeR.fold (fun (v,y) -> MapofVtx.add v y) g.o MapofVtx.empty in
  let rmapMV = ref (SetofVtx.fold (fun v -> MapofVtx.add v (ref {
						      id=v;incomE=[];outgoE=[];
						      imarks=
						        (try let x=MapofVtx.find v mapIMark
							    in [x]
							with Not_found -> []);
						      omarks=
						        (try let y=MapofVtx.find v mapOMark
							    in [y]
							with Not_found -> []);
						    })) g.v MapofVtx.empty) in
  let lookupMVMap v = try (MapofVtx.find v !rmapMV) with
		 Not_found -> failwith "lookupMVMap: not found" in
  let listME = SetofEdge.fold (fun (u,e,v) -> cons (
      
      let sv = lookupMVMap u in
      let dv = lookupMVMap v in
      let mE = {sourceV = sv; xlabel = e; destV = dv;} in
      let oE = (!(mE.sourceV)).outgoE in
      let iE = (!(mE.destV)).incomE in
      (
       (! (mE.sourceV)).outgoE <- ((ref mE)::oE); 
       (! (mE.destV)).incomE  <-  ((ref mE)::iE);
      ref mE 
      ))) g.e [] in
  let listME2 = List.fold_right (fun rmE -> (@) (
      let mE  = !rmE in
      let {sourceV=sv;xlabel=e;destV=dv;} = mE in
      if (e = ALEps) then (* replace destV with sourceV *)
          let il = (!(dv)).incomE in
       (* let nil = List.length il in *) (* for debug *) 
          let ol = (!(dv)).outgoE in
          let newil = 
	    List.fold_right (fun rmE2 -> (@) (
	      if (!rmE2 == mE) then []
	      else (!rmE2.destV <- sv;  [rmE2]))
		) il [] in
	  let newol = 
	    List.fold_right (fun rmE2 -> (@) (
	      if (!rmE2 == mE) then []
	      else (!rmE2.sourceV <- sv;  [rmE2]))
		) ol [] in
	  if (!dv).imarks = [] then () else !(sv).imarks <- (!dv).imarks;
	  if (!dv).omarks = [] then () else !(sv).omarks <- (!dv).omarks;
	  if (!sv == !dv) then () else rmapMV := (MapofVtx.remove !dv.id !rmapMV);
	  (!(sv)).incomE <- ((!(sv)).incomE) @ newil;
	  (!(sv)).outgoE <- List.fold_right (fun rmE3 -> (@) (
	    if !rmE3 == !rmE then []
	    else [rmE3])) ((!(sv)).outgoE) newol;
	  []
      else [!rmE]
      )
      )
     listME [] in
  let (vS,irS,orS) = MapofVtx.fold (fun v rv (vs,irs,ors) -> 
    let {id=id;imarks=im;omarks=om;} = !rv in
    (SetofVtx.add id vs,
     (if (im = []) then irs else (SetofInodeR.add ((List.hd im),v) irs)),
     (if (om = []) then ors else (SetofOnodeR.add (v,(List.hd om)) ors))))
     !rmapMV (SetofVtx.empty,SetofInodeR.empty,SetofOnodeR.empty) in
  let setE' = List.fold_right (fun mE -> 
    let {sourceV=sv;xlabel=e;destV=dv;} = mE in 
    SetofEdge.add (!sv.id,e,!dv.id)
      )listME2 SetofEdge.empty in
  {v=vS;e=setE';i=irS;o=orS}
*)

let remove_eps_org g = 
  let setElist = SetofEdge.elements g.e in
  let rec re accg = function
     []                         -> accg (* finished *)
    | ((u,ALEps,v) as edge)::es -> (* replace v with u *)
	let e2 = SetofEdge.remove edge accg.e in
	let v2 = if (u = v) then accg.v else SetofVtx.remove  v accg.v in
        let e2' = SetofEdge.map (fun (n1,e,n2) -> 
	    ((replaceif v u n1), e, (replaceif v u n2))) e2 in
	let i2 = SetofInodeR.map (fun (m,n1) -> 
	    (m, (replaceif v u n1))) accg.i in
	let o2 = SetofOnodeR.map (fun (n1,m) ->
	    ((replaceif v u n1),m)) accg.o in
	let accg' = {v=v2; e=e2'; i=i2; o=o2;} in
	re accg' (SetofEdge.elements e2')
    | _                    ::es -> re accg es
  in re g setElist

(* Implementation of epsilon edge removal without using mutable data structure *)
(* Glue source and destination of edges that satisfies pred *)
let glue_sdof_edge pred g = 
  let initMapV = vtxSet2Map SetofVtx.singleton g.v in
  let (mapV,sE) = SetofEdge.fold (fun ((u,l,v) as e) (mapV',sE') ->
    if pred e then
      let equivClassU = MapofVtx.find u mapV' in
      let equivClassV = MapofVtx.find v mapV' in
      let equivClass = SetofVtx.union equivClassU equivClassV in
      let mapV'' = SetofVtx.fold (fun v -> MapofVtx.add v equivClass) equivClassU mapV'  in
      let mapV'''= SetofVtx.fold (fun v -> MapofVtx.add v equivClass) equivClassV mapV'' in
      (mapV''',sE')
    else (mapV',SetofEdge.add e sE')) g.e (initMapV,SetofEdge.empty) in
   let mapRepV = MapofVtx.map SetofVtx.min_elt mapV in
   (*  let lookupRepV v = SetofVtx.min_elt (MapofVtx.find v mapV) in *)
   let lookupRepV v = MapofVtx.find v mapRepV in
   let g = { g with e = sE; } in
   map_VEIO lookupRepV g

(* DO NOT USE THIS
   Glue source and destination of epsilon edges only if it is safe to do so.
   Judgement of safety should be done upon the snapshot of every removal, 
   not like in this implementation. *)
let glue_safe_eps g = 
  let is_safe_eps =
    let (oEdgeS,iEdgeS) = build_ioedge_map g in
    (fun ((u,l,v) as e) -> 
      (l = ALEps) && (u=v || 
       (((SetofEdge.is_empty (SetofEdge.remove e (oEdgeS u))) 
            && (not (isInodeG g u)) )
       ||(SetofEdge.is_empty (SetofEdge.remove e (iEdgeS v)))))) in
  glue_sdof_edge is_safe_eps g

(* Removal safety should be evaluated on map that is updated every time after 
   removal, i.e, map should reflect the removal itself. *)
let is_safe_eps ((u,l,v) as e) map =
  let lookup v = MapofVtx.find v map in
  let (oEdgeS,iEdgeS,iMarkS,oMarkS) =
    ((fst @@ fst @@ lookup),(snd @@ fst @@ lookup),(fst @@ snd @@ lookup),(snd @@ snd @@ lookup)) in
  (l = ALEps) && (u=v ||
  (((SetofEdge.is_empty (SetofEdge.remove e (oEdgeS u)))
      && (   SetofMarker.is_empty (iMarkS u)) )
 ||(SetofEdge.is_empty (SetofEdge.remove e (iEdgeS v)))))
(**/**)

(* let addME meS mE : unit =  (meS := SetofMEdge.add mE !meS) *)
(* let unionMS mmS ms : unit =  (mmS := SetofMarker.union ms !mmS) *)


(** {9 data structures for destructive graph manipulation} *)

(* Unique id for mEdge type. It can never be reset. *)
module type GENEID = 
  sig 
    val next : unit -> int
  end

module GenEId : GENEID = 
  struct
    let c = ref 0
    let next () = incr c ; !c
  end

let newEid () : int  = (GenEId.next ())

(** {9 helper functions for graph converters} *)

(***** Convert pure graph data structure to mutable one.
   Result of conversion is a map mapMV from node id to mutable node structure
    mVtx and a list listME of mutable edge structures mEdge. 
  it optionally creates viewmap that stores mapping from remaining 
  node and edge to original ones. it is empty if create_viewmaps is set to false
  *******)
let pgraph2mgraph ?(create_viewmaps=false) g = 
  let initMMap = vtxSet2Map (fun v -> (SetofMarker.empty, SetofMarker.empty)) g.v in
  let nmap = SetofInodeR.fold
      (fun (m,v) -> MapofVtx.update (cross (SetofMarker.add m,id)) v)
      g.i initMMap in
  let nmap' = SetofOnodeR.fold
      (fun (v,m) -> MapofVtx.update (cross (id,SetofMarker.add m)) v)
      g.o nmap in
  let ioMarksS_g v = MapofVtx.find v nmap' in
  let mapMV = vtxSet2Map (fun v ->
              let (im,om) = ioMarksS_g v in
              { id = v; 
		incomE = SetofMEdge.empty;
		outgoE = SetofMEdge.empty;
		imarks = im;omarks = om;}) g.v in
  let listME = SetofEdge.fold (fun (u,l,v) -> cons (
     let mE = { eid = newEid (); sourceV = u; xlabel  = l;  destV = v;} in
     let (srcV,dstV) = fsplit (mapT2 MapofVtx.find (u,v)) mapMV in
     srcV.outgoE <- SetofMEdge.add mE srcV.outgoE;
     dstV.incomE <- SetofMEdge.add mE dstV.incomE;
     mE )) g.e [] in
  (mapMV,listME,if create_viewmaps then init_viewmaps g else empty_viewmaps)

(***** Convert (mMV,listME2) back to pure data structure  *****)
let mgraph2pgraph (mMV,listME2,vm) = 
  let (vS,irS,orS) = MapofVtx.fold (fun v mV ->
    let {id=id;imarks=im;omarks=om;} = mV in
    cross3 (SetofVtx.add                                id,
     SetofMarker.fold (fun m -> SetofInodeR.add (m,id)) im,
     SetofMarker.fold (fun m -> SetofOnodeR.add (id,m)) om))
     mMV (SetofVtx.empty,SetofInodeR.empty,SetofOnodeR.empty) in
  let setE' = List.fold_right 
      (fun mE -> SetofEdge.add (mE.sourceV,mE.xlabel,mE.destV)) listME2 SetofEdge.empty in
  ({v=vS;e=setE';i=irS;o=orS},vm)

(* safety judgement of epsilon removal based on both ends and its label *)
let mgraph_is_safe_eps srcV dstV mE =
    (mE.xlabel = ALEps) && (srcV == dstV ||
    (((SetofMEdge.is_empty (SetofMEdge.remove mE (srcV.outgoE)))
	&& (   SetofMarker.is_empty (srcV.imarks)) )
   ||(SetofMEdge.is_empty (SetofMEdge.remove mE (dstV.incomE)))))


let mVdestVS   mES = SetofMEdge.fold (fun mE -> 
  if(* mE.xlabel<>ALEps *)true then SetofVtx.add mE.destV else id) mES SetofVtx.empty
let mVsourceVS mES = SetofMEdge.fold (fun mE -> 
  if(* mE.xlabel<>ALEps *)true then SetofVtx.add mE.sourceV else id) mES SetofVtx.empty

(* more conservative one to prevent multiedge *)
let mgraph_is_safe_eps ?(allow_multiedge=true) srcV dstV mE =
  (mE.xlabel = ALEps) && (srcV == dstV ||
  (( let oES = SetofMEdge.remove mE (srcV.outgoE) in
     let iES = SetofMEdge.remove mE (dstV.incomE) in
       (SetofMEdge.is_empty oES)
    && (SetofMarker.is_empty (srcV.imarks))
    && (allow_multiedge || (SetofVtx.is_empty (SetofVtx.inter (mVsourceVS srcV.incomE) (mVsourceVS iES))))
     )
   ||(let iES = (SetofMEdge.remove mE (dstV.incomE)) in
      let oES = (SetofMEdge.remove mE (srcV.outgoE)) in
     SetofMEdge.is_empty iES
      && 
      (allow_multiedge || (SetofVtx.is_empty (SetofVtx.inter (mVdestVS oES) (mVdestVS dstV.outgoE))))
     )
			 ))



(* Glue ends of safe epsilon edges of mutable graphs. (mapMV,listME) => (mMV,listME2) 
   Result of epsilon removal is an updated map mMV with possible reduced number
     of nodes and a list of edges remain listME2 *)
let mgraph_glue_safe_eps ?(create_viewmaps=false) (mapMV,listME,vm) = 
  let (mMV,listME2) = List.fold_right (fun mE (mMV0,lME0) ->
    let (srcV,dstV) = fsplit (mapT2 MapofVtx.find (mE.sourceV,mE.destV)) mMV0 in
    if mgraph_is_safe_eps ~allow_multiedge:(not create_viewmaps) srcV dstV mE then (* remove mE *)
      begin 
        (* remove mE from (outgoing edge of) srcV and (incoming edge of) dstV *)
        srcV.outgoE <- SetofMEdge.remove mE srcV.outgoE;
        dstV.incomE <- SetofMEdge.remove mE dstV.incomE;
	if srcV == dstV then (mMV0, lME0)  (* self cycle eps: do not remove dstV *)
	else  (* migrate markers and edges from destV to sourceV and remove destV *)
	  begin
	    (* migrate markers *)
	    srcV.imarks <- SetofMarker.union dstV.imarks srcV.imarks;
	    srcV.omarks <- SetofMarker.union dstV.omarks srcV.omarks;
	    (* migrate outgoing edges of dstV to srcV  *)
	    SetofMEdge.iter (fun mE' ->
	      if (create_viewmaps (* && (mE'.xlabel <> ALEps) *)) 
	      then viewmaps_migrate_1edge 
		  ~e_to:  (srcV.id,mE'.xlabel,mE'.destV)
		  ~e_from:(dstV.id,mE'.xlabel,mE'.destV) vm;
	      mE'.sourceV <- srcV.id;
	      srcV.outgoE <- SetofMEdge.add mE' srcV.outgoE;
	     ) dstV.outgoE;
	    (* migrate incoming edges of dstV to srcV  *)
	    SetofMEdge.iter (fun mE' ->
	      if (create_viewmaps (* && (mE'.xlabel <> ALEps) *)) 
	      then viewmaps_migrate_1edge 
		  ~e_to:  (mE'.sourceV,mE'.xlabel,srcV.id)
		  ~e_from:(mE'.sourceV,mE'.xlabel,dstV.id) vm;
	      mE'.destV <- srcV.id;
	      srcV.incomE <- SetofMEdge.add mE' srcV.incomE;
	     ) dstV.incomE;
	    if create_viewmaps then viewmaps_merge_vtx ~v_to:srcV.id ~v_from:dstV.id vm;
            (* return map of mVtx with dstV removed, and list of mEdge
               with mE removed *)
	    (MapofVtx.remove dstV.id mMV0, lME0)
	  end
      end
    else (mMV0,(mE::lME0)) (* non-eps or unsafe eps: pass mE through *)
				      ) listME (mapMV,[])
   in (mMV,listME2,vm)

(* Using mutable data structure. Once the structure is constructed,
   index is no longer used. *)
(** Glue ends of safe epsilon edges of graph *)
let glue_safe_eps = 
  (* Convert pure graph data structure to mutable one,
     epsilon edge removal (mapMV,listME) => (mMV,listME2),
     convert (mMV,listME2) back to pure data structure. *)
  (*
  fun g ->
    let (mapMV,listME,vm) = pgraph2mgraph g in
    let (mMV,listME2,vm)  = mgraph_glue_safe_eps (mapMV,listME,vm) in
    let (g',vm)           = mgraph2pgraph (mMV,listME2,vm) in 
    g' 
   *)
  fst @@ mgraph2pgraph @@ mgraph_glue_safe_eps @@ pgraph2mgraph

(** Glue ends safe epsilon edges and returns a pair of the result graph and viewmap *)
let viewmaps_glue_safe_eps
    = mgraph2pgraph @@ (mgraph_glue_safe_eps ~create_viewmaps:true) @@ (pgraph2mgraph ~create_viewmaps:true)

(** {9 predicates} *)

let isEpsEdge ((_,l,_):edge) : bool  = (l = ALEps)

(** {9 graph converters} *)

(** Glue source and destination of every epsilon edge, thus disregarding orientation.
     Output is NOT bisimilar to input. *)
let glue_every_eps g = glue_sdof_edge isEpsEdge g

(** Compute map from vertex to pair of its Upstream/Downstream Epsilon Closure
   and remove epsilon using this closure.
   If you have many markers, then it may be more efficient to build 
   index (map) from node to markers as well. 
    @param leave_unreachable if set to [true], leaves unreachable parts introduced 
           while removing epsilon edges.
    @param g                 input graph
*)
let remove_eps_ec ?(leave_unreachable = false) g =
  let (mapV,sNonEpsE,sEpsE) = build_ud_EC g in
  let (oEdgeS,_) = build_ioedge_map {g with e=sNonEpsE} in
  let sEpsSrcV = maps_Edge2Vtx (fun (u,_,_) -> u) sEpsE in
  let (eS,oS) = SetofVtx.fold (fun vEpsSrc ->
    (cross (cross (SetofEdge.union ,SetofOnodeR.union)
      (let (_,downEc) = MapofVtx.find vEpsSrc mapV in
      SetofVtx.fold (fun vEC  -> 
	cross (SetofEdge.union   (SetofEdge.map (cross3 ((fun _ -> vEpsSrc),id,id)) (oEdgeS vEC)),
	       SetofOnodeR.union (maps_Marker2OnodeR (fun m -> (vEpsSrc,m)) (snd (markersV g vEC))))
		    ) downEc (SetofEdge.empty,SetofOnodeR.empty))))) sEpsSrcV (sNonEpsE,g.o) in
  let gnew = { g with e=eS; o = oS; } in
  if leave_unreachable then gnew else
  (******** remove unreachable parts introduced during the above process ***********)
  let (_,iEdgeS) = build_ioedge_map g in
  let isAllEps s = (not (SetofEdge.is_empty s)) && SetofEdge.for_all isEpsEdge s in
  let (oEdgeS,_) = build_ioedge_map gnew (* for cascading epsilon *) in
  (* Nodes whose incoming edge are all epsilon, then the node and its 
     direct outgoing edges has become unreachable. Store them in vEfunnel and eEfunnel.
     Input nodes are excluded for funnel condition.
     Output marker relation should be shrinked along with deletion of the funnel node.
   *)
  let (vEfunnel,eEfunnel) = SetofVtx.fold
           (fun v (vE,eE) ->
             if (not (isInodeG g v)) && (isAllEps (iEdgeS v)) 
	     then (SetofVtx.add v vE,SetofEdge.union (oEdgeS v) eE)
	     else (vE, eE)) g.v (SetofVtx.empty,SetofEdge.empty) in
  { gnew with v = SetofVtx.diff gnew.v vEfunnel; e=SetofEdge.diff gnew.e eEfunnel; 
    o = SetofOnodeR.filter (fun (v,_) -> not (SetofVtx.mem v vEfunnel)) gnew.o;  }

(** viewmap version of {!remove_eps_ec}. takes a pair of graph and associated viewmap,
  and returns epsilon-removed graph and Updated viewmap. [mapV] component
   remains unchanged, assuming that all the safe epsilons are already glued together.
   Without this function, unsafe epsilon would remain in the view being edited by the user. *)
let viewmaps_remove_eps_ec (g,vm) =
  let isAllEps s = (not (SetofEdge.is_empty s)) && SetofEdge.for_all isEpsEdge s in
  let (mapV,sNonEpsE,sEpsE) = build_ud_EC g in
  let (oEdgeS,iEdgeS) = build_ioedge_map g in
  (* candidates of the origin of epsilon closure *)
  let candVS = SetofVtx.filter (fun v -> (not (SetofEdge.is_empty (oEdgeS v))) &&
					 (isInodeG g v || SetofEdge.is_empty (iEdgeS v) || 
  (not (SetofEdge.is_empty (SetofEdge.filter (not @@ isEpsEdge) (iEdgeS v)))))) g.v in
  (* compute edges added, OnodeR added, and updated viewmaps. 
     for each epsilon closure, migrate the source of the edges outgoing from the closure
     to the origin of the closure. viewmap is updated accordingly *)
  let (addES,addOS,vm') = SetofVtx.fold (fun v (eS0,oS0,vm0) ->
    let (_,dnVS) = MapofVtx.find v mapV in (* downstream epsilon closure *)
    let oES      = setmap_Vtx2Edge oEdgeS dnVS in
    let oES      = SetofEdge.filter (not @@ isEpsEdge) oES in (* outedge of closure *)
    let (oES,vm1)= SetofEdge.fold (fun (vs,l,vt) (oES0,vm00) ->
	SetofEdge.add (v,l,vt) oES0, (* migration of edge *)
      let eSsrc = MapofEdge.find (vs,l,vt) vm00.mapE in
      (* entry of the added edge is created. If the entry already exists, then the
	 content of the entry is unified *)
      { vm00 with mapE = MapofEdge.uadd id SetofEdge.union (v,l,vt) eSsrc vm00.mapE})
	oES (SetofEdge.empty,vm0)  (* edges moved to the origin *) in 
    (* let  _ = Format.fprintf Format.std_formatter "oES(%a)=%a@." pr_vtx v pr_SetofEdge oES in *)
    let oRS      = SetofOnodeR.filter (fun (mv,m) -> SetofVtx.mem mv dnVS) g.o in
    let oRS      = SetofOnodeR.map (fun (mv,m) -> (v,m)) oRS in (* markers moved to the origin *)
    SetofEdge.union oES eS0, SetofOnodeR.union oRS oS0,{vm0 with mapE=vm1.mapE}) candVS
      (SetofEdge.empty,SetofOnodeR.empty,vm) in
  let gnew = { g with e=SetofEdge.union addES sNonEpsE; o = SetofOnodeR.union addOS g.o; } in
   (* rest of the code is mostly copied from remove_eps_ec *)
  let (oEdgeS,_) = build_ioedge_map gnew (* for cascading epsilon *) in
  let (vEfunnel,eEfunnel) = SetofVtx.fold
      (fun v (vE,eE) ->
        if (not (isInodeG g v)) && (isAllEps (iEdgeS v))
	then (SetofVtx.add v vE,SetofEdge.union (oEdgeS v) eE)
	else (vE, eE)) g.v (SetofVtx.empty,SetofEdge.empty) in
  ({ gnew with v = SetofVtx.diff gnew.v vEfunnel; e=SetofEdge.diff gnew.e eEfunnel;
    o = SetofOnodeR.filter (fun (v,_) -> not (SetofVtx.mem v vEfunnel)) gnew.o; },vm')


(* Algorithm based on value equivalence described in section 4 of UnQL paper. *)
(* This procedure should be repeated until no epsilon edge is contained
   in the output. This function performs only 1 step. 
   Note that if epsilon edges form a cycle, this removal process reaches
   stable state with epsilon edge still remained. Self cycle epsilon 
   should be removed to avoid this situation.
  *)
let remove_eps_ec1 (g:graph) : graph = 
  SetofEdge.fold (fun ((u,l,v) as e) g0 -> 
    if l = ALEps then
      let eS1 = SetofEdge.remove e g0.e in
      let eS2 = SetofEdge.union eS1 
          (SetofEdge.map (cross3 ((fun _ -> u),id,id)) (outgoEdgeS g0 v)) in
      let oS1 = SetofMarker.fold
	  (fun m -> SetofOnodeR.add (u,m)) (snd (markersV g0 v)) g0.o in
      { g0 with	e = eS2; o = oS1; }
    else g0) g.e g

(* let remove_eps = glue_every_eps *)
(** remove epsilon edges *)
let remove_eps = remove_eps_ec @@ glue_safe_eps

(** {9 subgraph extractors} *)

(** local function: returns (V,E,I,O) quadruple reachable from v in g
    accumulating from (vS0,eS0,iS0,oS0). The actual value of 
    accumulation parameter is always empty so far but it has been intended
    to be repeatedly invoked for multiple components of an identical graph. *)
(* FIXME: input markers should not be collected here but at the caller site?  *)
let reachableG1 outgoEdgeS_g (g:graph) ((vS0,eS0,iS0,oS0):(SetofVtx.t*SetofEdge.t*SetofInodeR.t*SetofOnodeR.t))
   (v:vtx) : (SetofVtx.t*SetofEdge.t*SetofInodeR.t*SetofOnodeR.t) =
  let rec rG1 (g:graph) ((vS0,eS0,iS0,oS0):(SetofVtx.t*SetofEdge.t*SetofInodeR.t*SetofOnodeR.t))
      (v:vtx) : (SetofVtx.t*SetofEdge.t*SetofInodeR.t*SetofOnodeR.t) =
    if (SetofVtx.mem v vS0) then (vS0,eS0,iS0,oS0)
    else SetofEdge.fold (fun ((v1,l,v2) as e) (vS,eS,iS,oS) ->
      rG1 g
	(vS,
	 SetofEdge.add e eS,
	 iS,
	 oS) 
	v2) (outgoEdgeS_g v)
	(SetofVtx.add v vS0,
	 eS0,
	 SetofInodeR.union (SetofInodeR.filter (fun (_,v') -> v'=v) g.i) iS0,
	 SetofOnodeR.union (SetofOnodeR.filter (fun (v',_) -> v'=v) g.o) oS0)
  in rG1 g (vS0,eS0,iS0,oS0) v

(** make dv (subgraph reachable from node v) with [outgoEdgeS] equivalent prebuilt map outgoEdggeS_g *)
let make_dv_with_oEmap outgoEdgeS_g d root = 
  let g = {d with i= SetofInodeR.singleton ("&",root)} in
  let (vS,eS,iS,oS) = reachableG1 outgoEdgeS_g g
      (SetofVtx.empty, SetofEdge.empty, SetofInodeR.empty, SetofOnodeR.empty) root in
  {v=vS;e=eS;i=iS;o=oS}

(** returns subgraph reachable from the root, assuming graph with a default root *)
let reachableG (g:graph) : graph =
  let root =
    try lookupI g "&" with
      Not_found -> failwith "reachableG: no root marker"
    | e         -> raise e
  in 
  let (outgoEdgeS_g,_,_,_) = build_ioedge_ionode_map g in
  let (vS,eS,iS,oS) = reachableG1 outgoEdgeS_g g
      (SetofVtx.empty, SetofEdge.empty, SetofInodeR.empty, SetofOnodeR.empty) root in
  {v=vS;e=eS;i=iS;o=oS}

(** [make_dv d v] returns a subgraph of graph [d] reachable from node [v] *)
let make_dv d node = reachableG {d with i= SetofInodeR.singleton ("&",node)}

(** returns only the parts reachable from roots *)
let reachableGI (g:graph) : graph = (* traverse from all input nodes rather than only root *)
  (* we could have just unioned the results of reachableG1, but it would have caused
     duplicate traversals in case there were intersection between these results.
     In fact the reachableG1 could be used in place of rg1 so that the accumulation
     parameter of reachableG1 takes effect. *)
  let (outgoEdgeS_g,_,_,_) = build_ioedge_ionode_map g in
  let rec rg1 ((vS0,eS0,iS0,oS0):(SetofVtx.t*SetofEdge.t*SetofInodeR.t*SetofOnodeR.t))
      (v:vtx) : (SetofVtx.t*SetofEdge.t*SetofInodeR.t*SetofOnodeR.t) =
    if (SetofVtx.mem v vS0) then (vS0,eS0,iS0,oS0)
    else SetofEdge.fold (fun ((v1,l,v2) as e) (vS,eS,iS,oS) ->
      rg1
	(vS,
	 SetofEdge.add e eS,
	 iS,
	 oS) 
	v2) (outgoEdgeS_g v)
	(SetofVtx.add v vS0,
	 eS0,
	 SetofInodeR.union (SetofInodeR.filter (fun (_,v') -> v'=v) g.i) iS0,
	 SetofOnodeR.union (SetofOnodeR.filter (fun (v',_) -> v'=v) g.o) oS0)
  in 
  let (vS,eS,iS,oS) = 
    SetofMarker.fold (fun m (vS,eS,iS,oS) ->
       let (vS0,eS0,iS0,oS0) = (rg1 (vS,eS,iS,oS) (lookupI g m)) in
       (   SetofVtx.union vS0 vS,
	  SetofEdge.union eS0 eS,
	SetofInodeR.union iS0 iS,
	SetofOnodeR.union oS0 oS))
    (inputMarkers g) (SetofVtx.empty, SetofEdge.empty, SetofInodeR.empty, SetofOnodeR.empty) 
  in {v=vS;e=eS;i=iS;o=oS}

(** split graph into reachable and unreachable parts *)
let split_reachableGI g =
  let reachable = reachableGI g in
  (reachable, evalg_simple_diff g reachable)

(* collect portion of a graph that is 1-step reachable from node x *)
(* val reachable1s : UnCALDM.graph -> UnCALDM.vtx -> UnCALDM.graph  *)
let reachable1s (g0:graph) (x:vtx) : graph =
  let (outgoEdgeS_g0,_,_,_) = build_ioedge_ionode_map g0 in
  (* mode= true:found non-eps, false: non-eps not found yet *)
  let rec r mode ((_,l,vt) as e) g = 
    let nepsf   = (l <> ALEps) in 
    let flip    = mode && nepsf in
    let newmode = mode or nepsf in
if (SetofEdge.mem e g.e || flip )  then g else
    SetofEdge.fold (r newmode) (outgoEdgeS_g0 vt) { g with v = SetofVtx.add vt g.v; e = SetofEdge.add e g.e;} in
  let g = SetofEdge.fold (r false) (outgoEdgeS_g0 x) { emptyGraph with v = SetofVtx.singleton x;} in
  { g with 
    i = SetofInodeR.filter (fun (_,v) -> SetofVtx.mem v g0.v) g0.i;
    o = SetofOnodeR.filter (fun (v,_) -> SetofVtx.mem v g0.v) g0.o; }

(** compute 1-step reachable parts from all the input nodes *)
let reachableGI1s (g0:graph) =
(* disjoint union can't be used assuming an edge destined to input node *)
  SetofInodeR.fold (fun (_,v) -> (evalg_simple_union (reachable1s g0 v))) g0.i emptyGraph 

(** {9 graph constructors} *)
(* These  function uses value equality in unification of nodes and
   edges,  so when you supply two graphs that have "physically" shared
    nodes, the result may not be what you want. *)
(* Strange names of infix operators come from operator precedence
   in OCaml:   (|++) < (^:=) < (+|) < (/:) *)

(* operations on graphs  *)
let inT expid =
  match expid with
    None   -> newnode ()
  | Some i -> InT i

let evalg_AETEmp ?expid () =
  let vr = inT expid
      in { emptyGraph with 
	   v=SetofVtx.singleton vr;
           i=SetofInodeR.singleton ("&",vr); (* the only node is labeled as root *)
	 }
let (!<>) = evalg_AETEmp

let evalg_AEOMrk ?expid m =
  let vr = inT expid in
  {v=   SetofVtx.singleton vr; 
   e=  SetofEdge.empty;
   i=SetofInodeR.singleton ("&",vr); (* labeled with default input marker & *)
   o=SetofOnodeR.singleton (vr,m)}   (* labeled with        output marker &m *)
let (!&) = evalg_AEOMrk
let evalg_AEEdg ?expid p g = (* relabel root marker and connect with the lpat edge *)
  let {v=v;e=e;i=i;o=o} = g in
  let (rir,ir) = SetofInodeR.partition isroot i in
  let vr = inT expid in
  if ((SetofInodeR.cardinal rir) = 1)
  then 
    let (_,root) = SetofInodeR.choose rir in
    {  v =    SetofVtx.add  vr         v;
       e =   SetofEdge.add (vr,p,root) e;
       i = SetofInodeR.add ("&",vr)   ir;
       o = o; }
  else failwith "evalg_AEEdg: Multiple or no root marker"
let (/:) = evalg_AEEdg
let evalg_AEIMrkG m g =
  let nI = (SetofInodeR.cardinal g.i) in
  if (nI > 0)  then {  g with i = SetofInodeR.map (cross (((&^) m), id))
			 (* (fun (m',v) -> (m &^ m',v)) *)
			 g.i  }
  else failwith "evalg_AEIMrkG: no input marker"
let (^:=) = evalg_AEIMrkG

let make_nodegen expid =
  match expid with
    None   -> newnode
  | Some i ->
      let cnt = ref i in
      fun () -> let v = Bid !cnt in incr cnt; v

let make_nodegen expid =
  match expid with
    None   -> fun m -> newnode ()
  | Some i -> fun m -> ImT (i,m)

let evalg_AEUni ?expid g1 g2 =
  let (imarks1,inodes1) = List.split (SetofInodeR.elements g1.i) in
  let (imarks2,inodes2) = List.split (SetofInodeR.elements g2.i) in
  if imarks1 = imarks2 then
    let newnode = make_nodegen expid in
    let inodelist = List.map newnode imarks1 in
    let epsEdgLst =
        (List.map2 (fun n n1 -> (n,ALEps,n1))  inodelist inodes1)
      @ (List.map2 (fun n n1 -> (n,ALEps,n1))  inodelist inodes2) in
    let inodeRSet = List.fold_right2 (fun m n -> SetofInodeR.add (m,n)) imarks1 inodelist SetofInodeR.empty in 
    { v =    SetofVtx.fromLSet [g1.v; g2.v;( SetofVtx.fromList inodelist)]; 
      e =   SetofEdge.fromLSet [g1.e; g2.e;(SetofEdge.fromList epsEdgLst)];
      i = inodeRSet;
      o = SetofOnodeR.fromLSet [g1.o;g2.o];
    }
  else failwith "evalg_AEUni: Unioned graphs have different set of input markers"
let (+|) = evalg_AEUni

(* More faithful (but more epsilon-producing) implementation of  "s1 U:= x" used 
   as s1 := !s1 U x  in recursive semantics.
   Epsilon edges are added from Input nodes in s1 to those in x (NOT unified).
   This operation is also asymmetric. *)
let (+|<!) (g1:graph) (g2:graph) =
  let i1L = (SetofInodeR.elements g1.i) in
  let i2L = (SetofInodeR.elements g2.i) in
  let newEps = List.fold_right2 
      (fun (m1,v1) (m2,v2) -> 
        if m1 <> m2 then failwith "(+|<!): Unified graphs disagree in input markers."
	else SetofEdge.add (v1,ALEps,v2)) i1L i2L SetofEdge.empty in
    { v =    SetofVtx.fromLSet [g1.v;g2.v];
      e =   SetofEdge.fromLSet [g1.e;g2.e;newEps];
      i =                       g1.i;
      o = SetofOnodeR.fromLSet [g1.o;g2.o]; }

(* Implements union that is used as s1 := !s1 U x  in recursive semantics.
   Input nodes in x are unified to those in s1. Therefore, this operation is asymmetric. *)
let (+|<) (g1:graph) (g2:graph) =
  let i1L = (SetofInodeR.elements g1.i) in
  let i2L = (SetofInodeR.elements g2.i) in
  let (imarks1,_) = List.split i1L in
  let (imarks2,_) = List.split i2L in
  if imarks1 = imarks2 then
    let mapV = List.fold_right2
	(fun (_,v1) (_,v2) -> MapofVtx.add v2 v1) i1L i2L MapofVtx.empty in
    let lookupMap v = try (MapofVtx.find v mapV) with
      (* if not found, it is not input node, and unique to g2 *)
      Not_found -> v (* failwith "lookupMap(+|<): counterpart node not found" *) in
    { v =    SetofVtx.union g1.v (  SetofVtx.map lookupMap                         g2.v);
      e =   SetofEdge.union g1.e ( SetofEdge.map (cross3 (lookupMap,id,lookupMap)) g2.e);
      i =                   g1.i;
      o = SetofOnodeR.union g1.o (SetofOnodeR.map (cross (lookupMap,id))           g2.o);
    }
  else failwith "(+|<): Unified graphs have different set of input markers."

(* Uncomment reveals initial bug *)
(* let (+|<) = (fun x y -> evalg_AEUni x y) *)

let faithfulUnion = ref true (* if true, epsilon edge is used in s1 := s1 U x *)

let (+|<) s1 x = if !faithfulUnion then s1 +|<! x else s1 +|< x

let evalg_AEDUni g1 g2 =
  let imarks1 = inputMarkers g1 in
  let imarks2 = inputMarkers g2 in
  if (SetofMarker.is_empty (SetofMarker.inter imarks1 imarks2)) then
    evalg_simple_union g1 g2
  else failwith "evalg_AEDUni: Dunioned graphs have duplicate input markers"
let (|++) = evalg_AEDUni
let maps_Marker2DUni  = SetofMarker.hom evalg_AEDUni emptyGraph 

let escapeApnd = ref true (* escape 1st operand of @ with Skolem term IaT *)
let leaveOMrkApnd = ref false (* leave the residual output markers of the 1st operand of @ (experimental) *)

let skolemIaT (i:int) (g:graph) =
  { v =    SetofVtx.map (fun v       ->  IaT (i,v)             ) g.v;
    e =   SetofEdge.map (fun (u,l,v) -> (IaT (i,u),l,IaT (i,v))) g.e;
    i = SetofInodeR.map (fun (m,v)   -> (m,IaT (i,v))          ) g.i;
    o = SetofOnodeR.map (fun (v,m)   -> (IaT (i,v),m)          ) g.o; }

(** [clean_id_aux ?(start_id=0) g] reassigns a sequence of flat node IDs to graph [g].

   @param start_id      start id of flat ID
   @param g             input graph
   @return              triple of ID-flattened graph of [g], map to flat ID and end ID
*)
let clean_id_aux ?(start_id=0) g =
 let (mapV,end_id) = SetofVtx.fold 
     (fun v (mV,n) -> (MapofVtx.add v (Bid n) mV,n+1)) g.v (MapofVtx.empty,start_id) in
 let lookupMap v = try (MapofVtx.find v mapV) with
		 Not_found -> failwith "lookupMap: Flat ID not found" in
 let newG = map_VEIO lookupMap g in
 (newG,mapV,end_id)

let escapeApndG1 expid g1 =
  match expid with
    None   -> 
      let (g1',_,end_id) = clean_id_aux ~start_id:(GenId.current () + 1) g1 in
      GenId.set end_id; g1'
  | Some i -> skolemIaT i g1

let evalg_simple_append g1 g2 =
   let edgs = connect_nodes g1.o g2.i in
   { v =  SetofVtx.fromLSet [g1.v;g2.v     ];
     e = SetofEdge.fromLSet [g1.e;g2.e;edgs];
     i =                     g1.i;
     o = if !leaveOMrkApnd then
       let iS = inputMarkers g2 in
       let (_,roS) = SetofOnodeR.partition  (fun (v,m) -> SetofMarker.mem m iS) g1.o in
       SetofOnodeR.union roS g2.o
     else                   g2.o;}

let (@&&) = evalg_simple_append

let evalg_AEApnd ?expid g1 g2 =
  (* if (SetofMarker.equal (outputMarkers g1) (inputMarkers  g2)) then ()
     else  print_endline "Warning: evalAEApnd: Appended graphs have incompatible I/O markers"; *)
   let g1 = if !escapeApnd then escapeApndG1 expid g1 else g1 in
   evalg_simple_append g1 g2 

let (@&) = evalg_AEApnd 

(* if set to true, typing and evaluation of cycle() 
   adheres to  original semantics  which leaves all 
   the input markers *)
let cycleSemanticsOriginal = ref false

let evalg_AECyc ?expid g =
(* Fig.7 in the paper leaves input nodes by introducing
   epsilon edges, but it contradicts with the constraint that input node should 
   not have incoming edges. So the epsilon connected input nodes are eliminated here.
   Setting !cycleSemanticsOriginal to true switchies to original semantics. *)
  let omarkSet1 = outputMarkers g in
  let imarkSet2 = inputMarkers  g in
  let connectedMarkSet = SetofMarker.inter omarkSet1 imarkSet2 in
  let (cir,rir) = SetofInodeR.partition (fun (m,_) -> SetofMarker.mem m connectedMarkSet) g.i in
  let (cor,ror) = SetofOnodeR.partition (fun (_,m) -> SetofMarker.mem m connectedMarkSet) g.o in
  let edgs = connect_nodes cor cir in
  if !cycleSemanticsOriginal then
    let newnode = make_nodegen expid in
    let (ir,iedge,v') = SetofInodeR.fold 
	(fun (m,v) (ir0,ie0,v0) ->
	  let u = newnode m in SetofInodeR.add (m,u) ir0,SetofEdge.add (u,ALEps,v) ie0,SetofVtx.add u v0)
        g.i (SetofInodeR.empty,SetofEdge.empty,SetofVtx.empty) in
    let edgs = SetofEdge.union edgs iedge in
    {v = SetofVtx.union g.v v'; e = SetofEdge.union g.e edgs; i =  ir; o = ror;}
  else  
    {v =                g.v;    e = SetofEdge.union g.e edgs; i = rir; o = ror;}
let (!!<>) = evalg_AECyc

let evalg_AERec sid setZ (epsEdgS,nonEpsEdgS) mapE d = (* run-time portion of bulk semantics *)
  let ebody a v = try (MapofEbody.find (a,v) mapE) with
    Not_found -> failwith  "evalg_AERec: Cached ebody value not found" in
  let (s1,s2) =
    ((fun (u,z)     -> Hub (u,z,sid)),   (* S1 (u,z) *)
     (fun (u,a,v,w) -> S2 (u,a,v,w))) in
  let setV = (* S1 nodes (Hub) *)
    SetofVtx.setmap (fun u -> maps_Marker2Vtx (fun z -> s1 (u,z)) setZ) d.v in
  let setiV = (* S2 nodes *)
    setmap_Edge2Vtx (fun (u,a,v) -> 
      SetofVtx.map (fun w -> s2 (u,a,v,w)) (ebody a v).v) nonEpsEdgS  in
  let edge3 = (* S1-S2 epsilons (Spoke_out) *)
    SetofEdge.setmap (fun (u,a,v) ->
      maps_InodeR2Edge (fun (z,w) -> (s1 (u,z),ALEps,s2 (u,a,v,w))) (ebody a v).i) nonEpsEdgS in
  let edge4 = (* S2 edges *)
    SetofEdge.setmap (fun (u,a,v) ->
      SetofEdge.map (fun (w,b,w') -> (s2 (u,a,v,w),b,s2 (u,a,v,w'))) (ebody a v).e) nonEpsEdgS in
  let edge5 = (* S2-S1 epsilons (Spoke_in) *)
    SetofEdge.setmap (fun (u,a,v) -> 
      maps_OnodeR2Edge (fun (w,z) -> (s2 (u,a,v,w),ALEps,s1 (v,z))) (ebody a v).o) nonEpsEdgS in
  let edge6 = (* S1-S1 epsilons *)
    setmap_Marker2Edge (fun z -> 
      SetofEdge.map (fun (u,a,v) -> (s1 (u,z),a,s1 (v,z))) epsEdgS) setZ in
  let setI = 
    SetofInodeR.setmap (fun (x,u) -> maps_Marker2InodeR (fun z -> (x &^ z,s1(u,z))) setZ) d.i in
  let setO =
    SetofOnodeR.setmap (fun (u,y) -> maps_Marker2OnodeR (fun z ->(s1(u,z), y &^ z)) setZ) d.o in
  { v =  SetofVtx.fromLSet [setV;setiV];
    e = SetofEdge.fromLSet [edge3;edge4;edge5;edge6];
    i =                     setI;
    o =                     setO }

let evalg_AIsemp d0 =
  let d = remove_eps d0  in 
  let root =
    try lookupI d "&" with
      Not_found -> failwith "evalg_AIsemp: no root marker"
    | e         -> raise e
  in SetofEdge.is_empty (outgoEdgeS d root)

(** {9 operations on labels} *)

exception Eval_ALUkn of string

let evall_ALpred  (alpt:alptype) (l:allit) :bool =
  match (alpt,l) with
    (ALPStr,(ALStr _)) | (ALPLbl,(ALLbl _)) | (ALPInt,(ALInt _))
  | (ALPFlt,(ALFlt _)) | (ALPBol,(ALBol _)) -> true
  | (_     ,ALUkn)     -> raise (Eval_ALUkn "eval_ALpred: unknown label")
  | _                  -> false

let evall_bin l1 op l2 =
  match (l1,op,l2) with
    (ALUkn,_,_) | (_,_,ALUkn)  -> ALUkn
  | (ALStr s1,ALConc,ALStr s2) -> ALStr (s1 ^ s2)
  | (ALInt i1,op    ,ALInt i2) -> 
      ALInt (match op with 
	ALAdd -> i1 + i2
      | ALSub -> i1 - i2
      | ALMul -> i1 * i2
      | ALDiv -> i1 / i2
      | ALMod -> i1 mod i2
      | ALConc -> failwith "evall_bin: can't concatenate integers with ^"
	    )
  | (ALFlt f1,op    ,ALFlt f2) -> 
      ALFlt (match op with 
	ALAdd -> f1 +. f2
      | ALSub -> f1 -. f2
      | ALMul -> f1 *. f2
      | ALDiv -> f1 /. f2
      | ALConc -> failwith "evall_bin: can't concatenate floats with ^"
	    )
  | _ -> failwith "evall_bin: type mismatch in binary operand"

let evall_cmp l1 op l2 = 
  match (l1,l2) with
    (ALUkn,_) | (_,ALUkn) -> raise (Eval_ALUkn "evall_cmp: Unknown label encountered")
  | _ ->
      match op with
	ALOEq -> l1 = l2 (* equality coincides with O'Caml semantics *)
      | ALOLt -> l1 < l2 (* order coincides with O'Caml semantics *)
      | ALOGt -> l1 > l2 (* order coincides with O'Caml semantics *)


(* Following graph operation functions should have gone to UnCALDM
   module, but staying here for debugging purpose.
   Ocamldebug seems to invoke pretty printer using pattern matching
   on the type of values. Since ocamldebug requires pretty printer
   to be loaded from the object file  which is different from
   object file being debugged, the signatures of the pretty printer
   is fully qualified with module names. If the data type of the 
   values you want to print in the debugger is defined in the same
   module as the functions you want to debug, that type -- 
   recognized as local -- is not qualified and would not match
   with pretty printer whose signature is fully qualified.
   To keep pretty printer (which is typically defined with data 
   type definition) "foreign", I had no choice but to place the
   function debugged outside of the type-defining module.
   Therefore, remove_eps etc., that should have been inside UnCALDM, 
   is located here.
*)

(** {9 graph converters} *)

(** replace all node IDs including 'Skolemized' ones with 
   sequential flat numbers *)
let clean_id ?start_id g =
  let (g,mapV,end_id) = clean_id_aux ?start_id g in g


(** Split graph g at node v with marker m. 
    Introduce new node v' and attach new input marker m' to it.
    Original outgoing edges and output markers of v are moved to v',
    and output marker m' is attached to v instead.
    Original input markers of v remain. *)
let split_graph (g:graph) (v:vtx) (v':vtx) (m':marker) =
    let {v=vS;e=eS;i=iS;o=oS} = g in
    (* check overlap *)
    let (imS,omS) = fsplit (inputMarkers,outputMarkers) g  in
    let mS = SetofMarker.union imS omS in
    if SetofMarker.mem m' mS then
      failwith  ("split_graph: given marker " ^ (toStr pr_marker m') ^ " already exists")
    else if SetofVtx.mem v' vS then
      failwith  ("split_graph: given node " ^ (toStr pr_vtx v') ^ " already exists")
    else
     (* move output marker of v to v' *)
     let oS = SetofOnodeR.map (fun (u,m)   -> ((if u = v then v' else u),m))     oS in
     (* move outgoing edges of v to v' *)
     let eS =   SetofEdge.map (fun (u,l,w) -> ((if u = v then v' else u), l, w)) eS in
     (* assign  output marker m' to v *)
     let oS = SetofOnodeR.add (v,m')  oS in
     (* assign  input  marker m' to v' *)
     let iS = SetofInodeR.add (m',v') iS in
     (* register node v' *)
     let vS = SetofVtx.add v' vS in
     {v=vS;e=eS;i=iS;o=oS}



(** unused *)
let dumpableG (g:graph) =
  let is_cleaned : vtx -> bool = function
      (Bid _) -> true
    |  _     -> false 
  in SetofVtx.for_all is_cleaned g.v


(** [bundle g vS] bundles the set of nodes [vS] in graph [g]
     into a new root node and returns the graph with the new root  *)
let bundle (g:graph) (vS:SetofVtx.t) : graph = 
 SetofVtx.fold (fun v -> (+|) (make_dv g v)) vS (!<> ())

(** conponentwise equivalence *)
let cpntw_eq g1 g2 = 
    SetofVtx.equal g1.v g2.v &&   SetofEdge.equal g1.e g2.e && 
 SetofInodeR.equal g1.i g2.i && SetofOnodeR.equal g1.o g2.o
(** alias to {!cpntw_eq} *)
let (=.=) = cpntw_eq
  
(** bisimilar predicate *) 
(* now works for cyclic graphs as well *)
(* output markers are also checked *)
let bisimilar (g1:graph) (g2:graph) =
  let (g1,g2) = mapT2 (clean_id @@ reachableGI @@ remove_eps) (g1,g2) in
  let (imarks1,inodes1) = List.split (SetofInodeR.elements g1.i)
  and (imarks2,inodes2) = List.split (SetofInodeR.elements g2.i) in
  let (outgoEdgeS_g1,_,_,oMarkS_g1) = build_ioedge_ionode_map g1 
  and (outgoEdgeS_g2,_,_,oMarkS_g2) = build_ioedge_ionode_map g2 in
 (* let isLeaf (g:graph) (v:vtx) = SetofEdge.is_empty (outgoEdgeS g v) in  *)
  let rec bisimv (v1:vtx) (v2:vtx) (sS:SetofPVtx.t)
      (visitedVS1:SetofVtx.t) (visitedVS2:SetofVtx.t)
      =
    false (* ((isLeaf g1 v1) && (isLeaf g2 v2)) *)  
      (* if theres no outgoing edges, the result will automatically be true *)
  ||
    ((SetofPVtx.mem (v1,v2) sS) &&
     (false (* revisiting check *)  ||
     (let (eS1,eS2) = cross (outgoEdgeS_g1,outgoEdgeS_g2) (v1,v2)
      and (oS1,oS2) = cross (    oMarkS_g1,    oMarkS_g2) (v1,v2) in
     (oS1 = oS2) &&
     (SetofEdge.fold (fun (vs1,l1,vt1) ->
       (&&)
          (SetofEdge.fold (fun (vs2,l2,vt2) ->
                (||)
                   ((l1 = l2) &&
		    ( ((SetofVtx.mem vt1 visitedVS1) &&  (SetofVtx.mem vt2 visitedVS2))
			(* revisiting check *)  ||
                     (bisimv vt1 vt2 (SetofPVtx.add (vt1,vt2) sS)
			(SetofVtx.add vt1 visitedVS1) (SetofVtx.add vt2 visitedVS2)
		     ))
                   )
                        )  (SetofEdge.filter (fun (_,l',_) -> l1=l') eS2) false)
                   )  eS1 true)

      &&
      (SetofEdge.fold (fun (vs2,l2,vt2) ->
       (&&)
          (SetofEdge.fold (fun (vs1,l1,vt1) ->
                (||)
                   ((l1 = l2) &&
		    (((SetofVtx.mem vt1 visitedVS1) && (SetofVtx.mem vt2 visitedVS2))  ||
                     (bisimv vt1 vt2 (SetofPVtx.add (vt1,vt2) sS)
			(SetofVtx.add vt1 visitedVS1) (SetofVtx.add vt2 visitedVS2)
		     ))
                   )
                        )  (SetofEdge.filter (fun (_,l',_)->l2=l') eS1) false)
                   )  eS2 true)
     ))
     )
  in
  ((imarks1 = imarks2) &&
    (List.fold_right2 (fun v1 v2 -> (&&)
	(bisimv v1 v2 (SetofPVtx.singleton (v1,v2))
	               (SetofVtx.singleton v1)  (SetofVtx.singleton v2)
	))    inodes1 inodes2 true))

(** node trace function *)
let trace tid =
  let rec tr tid = match tid with
    Bid i             -> tid
  | S1 (v,_)          -> tr v
  | Hub (v,_,p)       -> tr v
  | S2 (u,a,v,w)      -> tr w
  | FrE (w,(u,a,v),p) -> tr w 
  | InT  p            -> failwith "untraceable"
  | ImT (p,_)         -> failwith "untraceable"
  | IaT (p,v)         -> tr v in
  tr tid

exception Trace of string

(**/**)
(* old implementation *)
let corr edg =
  let rec cr edg = match edg with
    (Bid _        ,_,Bid _        )                     -> edg
  | (FrE (_,e1,p1),_,FrE (_,e2,p2)) when e1=e2 && p1=p2 -> cr e1 
  | (S2 (u1,a1,v1,_), _,S2 (u2,a2,v2,_)) when (u1,a1,v1)=(u2,a2,v2) -> cr (u1,a1,v1) 
  | _ -> failwith "untraceable" in
  cr edg
(**/**)

(* new implementation *)
(** edge trace function *)
let corr (edg:edge) =
  let rec cr edg = match edg with
    (Bid _        ,_,Bid _        )                     -> edg
  | (FrE (u,e1,p1),l,FrE (v,e2,p2)) when e1=e2 && p1=p2 ->
      (try cr (u,l,v) with 
	Trace _ -> cr e1)
  | (S2 (u1,a1,v1,s), l,S2 (u2,a2,v2,t)) when (u1,a1,v1)=(u2,a2,v2) -> 
      (try cr (s,l,t) with
	Trace _ -> cr (u1,a1,v1))
  | _ -> raise (Trace "untraceable") in
  cr edg

(** edge trace function (returns all possible edges) *)
let corr_set (edg:edge) =
  let (uni,sng,emp)=(SetofEdge.union,SetofEdge.singleton,SetofEdge.empty) in
  let rec cr edg = match edg with
    (Bid _        ,_,Bid _        )                     -> sng edg
  | (FrE (u,e1,p1),l,FrE (v,e2,p2)) when e1=e2 && p1=p2 ->
      uni (cr (u,l,v)) (cr e1)
  | (S2 (u1,a1,v1,s), l,S2 (u2,a2,v2,t)) when (u1,a1,v1)=(u2,a2,v2) -> 
      uni (cr (s,l,t)) (cr (u1,a1,v1))
  | _ -> emp in
  cr edg

(** [any2none_aexpr] naturally converts [_ aexpr] to [_ option aexpr]. *)
let rec any2none_aexpr = function
  | AETEmp _ -> AETEmp None
  | AEEdg(_,p,e) -> AEEdg(None,any2none_alpat p,any2none_aexpr e)
  | AEUni(_,e1,e2) -> AEUni(None,any2none_aexpr e1,any2none_aexpr e2)
  | AEIMrk(_,m,e) -> AEIMrk(None,m,any2none_aexpr e)
  | AEOMrk(_,m) -> AEOMrk(None,m)
  | AEGEmp _ -> AEGEmp None
  | AEDUni(_,e1,e2) -> AEDUni(None,any2none_aexpr e1,any2none_aexpr e2)
  | AEApnd(_,e1,e2) -> AEApnd(None,any2none_aexpr e1,any2none_aexpr e2)
  | AECyc(_,e) -> AECyc(None,any2none_aexpr e)
  | AEVar(_,v) -> AEVar(None,v)
  | AEDoc(_,s) -> AEDoc(None,s)
  | AEIf(_,b,e1,e2) ->
    AEIf(None,any2none_abexpr b,any2none_aexpr e1,any2none_aexpr e2)
  | AERec(_,l,_,v,_,e1,e2) ->
    AERec(None,l,None,v,None,any2none_aexpr e1,any2none_aexpr e2)
  | AELet(_,v,_,e1,e2) -> AELet(None,v,None,any2none_aexpr e1,any2none_aexpr e2)
  | AELLet(_,l,_,p,e) -> AELLet(None,l,None,any2none_alpat p,any2none_aexpr e)

and any2none_alpat = function
  | ALVar(_,l) -> ALVar(None,l)
  | ALLit(_,l) -> ALLit(None,l)
  | ALBin(_,p1,b,p2) -> ALBin(None,any2none_alpat p1,b,any2none_alpat p2)

and any2none_abexpr = function
  | AIsemp(_,e) -> AIsemp(None,any2none_aexpr e)
  | ABisim(_,e1,e2) -> ABisim(None,any2none_aexpr e1,any2none_aexpr e2)
  | ANot(_,b) -> ANot(None,any2none_abexpr b)
  | AAnd(_,b1,b2) -> AAnd(None,any2none_abexpr b1,any2none_abexpr b2)
  | AOr(_,b1,b2) -> AOr(None,any2none_abexpr b1,any2none_abexpr b2)
  | ALcmp(_,p1,c,p2) -> ALcmp(None,any2none_alpat p1,c,any2none_alpat p2)
  | ATrue _ -> ATrue None
  | AFalse _ -> AFalse None
  | ALpred(_,t,p) -> ALpred(None,t,any2none_alpat p)

(* 
let compareEdge ((vxs,lx,vxt) as ex) ((vys,ly,vyt) as ey) = 
   if      (vxs < vys) then -1
   else if (vxs > vys) then  1
   else if (vxt < vyt) then -1
   else if (vxt > vyt) then  1
   else match (lx,ly) with
          (ALEps,    ALEps   ) -> 0
       |  (ALInt ix, ALInt iy) -> compareOrd ix iy
       |  (ALFlt fx, ALFlt fy) -> compareOrd fx fy
       |  (ALStr sx, ALStr sy) -> compareOrd sx sy
       |  (ALLbl lx, ALLbl ly) -> compareOrd lx ly
       |  (ALEps   , _       ) -> -1
       |  (_       , ALEps)    ->  1
       |  (ALStr _ ,  _)       -> -1 
       |  (_       , ALStr _)  ->  1
       |  (ALFlt _ , _)        -> -1
       |  (     _  , ALFlt _)  ->  1
       |  (ALInt _ , _  )      -> -1
       |  ( _     ,  ALInt _)  ->  1
*)

(* Inverter for option type.
   It may be implemented as a generic module in extSetMap *)
let invert_MapofEdgeToEdgeOpt m =
  (* First, remove entry that maps to None, and turn into endomap *)
  let m = MapofEdge.fold (fun key value ->
    match value with
      Some value -> MapofEdge.add key value
    | None       -> id) m MapofEdge.empty in
  MapofEdge.invert2m2s (module SetofEdge : Set.S with type elt = edge and type t = SetofEdge.t) m
