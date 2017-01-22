(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
(* general-purpose SCC computation  *)

open Fputil
open ExtSetMap

module type UGsig =
  sig
    module SVtx : sig include Set.S end 
    module SEdge : Set.S 
    module MVtx : Map.S with type key = SVtx.elt
    val getEnds : SEdge.elt -> (SVtx.elt * SVtx.elt)
    val mapEnds : ((SVtx.elt -> SVtx.elt) * (SVtx.elt -> SVtx.elt)) -> SEdge.elt -> SEdge.elt
  end
      
type 'a vertex = {
            node  :   'a;
    mutable index :   int;
    mutable lowlink : int;
    mutable instack : bool;
    mutable succ    : 'a vertex list;
  }
exception Dummy_scc

module SCC (UG : UGsig)  = struct
  module SVtx  = UG.SVtx
  module SEdge = UG.SEdge
  module MVtx  = UG.MVtx
  let getEnds = UG.getEnds
  let mapEnds = UG.mapEnds

  (* input: vS : set of nodes, eS : set of edges (pair of nodes)
     output: map from representative node of SCC to set of its members *)
  let make_scc vS eS =
    let index = ref 0 in
    let s = Stack.create () in
    let sscSS = ref MVtx.empty in
    (* initialization *)
    let m = SVtx.fold (fun n ->
      MVtx.add n {  node = n;
		    index = -1;
		    lowlink = -1;
		    instack = false;
		    succ   = []; }
		      ) vS  MVtx.empty in
    let _ = SEdge.iter (fun e ->
      let (u,v) = getEnds e in
      let ur = MVtx.find u m in
      let vr = MVtx.find v m in
      ur.succ <- vr::ur.succ;)  eS in
    let rec tarjan (v:'a vertex) : unit =
      v.index   <- !index;
      v.lowlink <- !index;
      index := !index + 1;
      Stack.push v s; v.instack <- true;
      List.iter (fun v' -> 
	if v'.index = -1 then 
	  begin 
	    tarjan(v');
	    v.lowlink <- min v.lowlink v'.lowlink;
	  end 
	else if (v'.instack) then
	  v.lowlink  <- min v.lowlink v'.index;
		) v.succ;
      if (v.lowlink = v.index) then
	begin
	  let sscS = ref SVtx.empty in
	  (try
	    (while true  do
	      let v' = Stack.pop s in
	      v'.instack <- false;
	      sscS := SVtx.add v'.node !sscS;
	      if v'.node = v.node then
		(raise Dummy_scc)
            done) with e -> ());
           sscSS := MVtx.add ((SVtx.choose !sscS):SVtx.elt) !sscS !sscSS
	end; in
    SVtx.iter (fun n ->
      let nr = MVtx.find n m in
      if nr.index = -1 then tarjan(nr);) vS;
    !sscSS

   (* Gscc : graph in which strongly connected components are represented
   by one representative node, and inter-component edges are represented by 
   crossing edges. *)
   (* ((nSin, nEin), sccMapVE, v2repr) = make_gscc eSin0 sccMapV  *)
   (* input: eSin0 : set of original edges 
             sccMapV : map from representative node of SCC to iset of its members 
      Returns: nSin : Set of nodes in Gscc
               nEin : Set of edges in Gscc
               sccMapVE : Map from representative node of SCC to 
                  its triple of set of nodes, set of internal edges and set of 
                  edges that go outside of the SCC 
               v2repr : function that maps node to its representative node in SCC
*)
  let make_gscc eSin sccMapV =
    let v2repr = (* maps node id to its representative *)
      let m = MVtx.fold (fun key vS ->
	SVtx.fold (fun v -> MVtx.add v key) vS) sccMapV MVtx.empty in
      fun v -> MVtx.find v m in
    (* map from represenative to set of edges toward inside and outside of SCC *)
    let mapVE0 = MVtx.map (fun vS -> (vS,SEdge.empty,SEdge.empty)) sccMapV in
    let (mapVE,eS) = SEdge.fold (fun  e (sme0,eS0) ->
      let (u,v) = getEnds e in
      let (ur,vr) = mapT2 v2repr (u,v) in
      let (vS0,eSI0,eSO0) = MVtx.find ur sme0 in
      if (ur=vr)
      then (MVtx.add ur (vS0,SEdge.add e eSI0,eSO0) sme0,eS0)
      else (MVtx.add ur (vS0,eSI0,SEdge.add e eSO0) sme0,SEdge.add (mapEnds ((fun _ -> ur),(fun _ -> vr)) e) eS0))
	eSin (mapVE0,SEdge.empty) in
    ((MVtx.collect_key (module SVtx : Set.S with type elt = MVtx.key and type t = SVtx.t) sccMapV,eS), mapVE ,v2repr)

  let lnodeSet2Map f = MVtx.set2map (module SVtx : Set.S with type elt = MVtx.key and type t = SVtx.t) f

  let build_ioedge_map nS eS =
    let initMapIE = lnodeSet2Map (fun v -> SEdge.empty) nS in
    let initMapOE = lnodeSet2Map (fun v -> SEdge.empty) nS in
    let (imap,omap) = SEdge.fold
	(fun e -> let (u,v) = getEnds e in cross (mapT2 (MVtx.update (SEdge.add e)) (v,u)))
	eS (initMapIE,initMapOE) in
    ((fun v -> MVtx.find v omap),
     (fun v -> MVtx.find v imap))

  let make_tc vSin0 eSin0 =
    let sccMapV = make_scc vSin0 eSin0 in
    let ((nSin, nEin), sccMapVE, v2repr) = make_gscc eSin0 sccMapV in
    let (oEdgeS_scc,iEdgeS_scc) = build_ioedge_map nSin nEin in
    let rootVS = (* nodes that have no incoming edges *)
      MVtx.fold (fun v _ ->
	if (SEdge.is_empty (iEdgeS_scc v)) then SVtx.add v else id) sccMapVE SVtx.empty in
    let visited = ref MVtx.empty in
    let rec r v : (SVtx.t * SEdge.t) = 
      try (MVtx.find v !visited) with
	Not_found ->
	  (let (sccVS,sccEIS,sccEOS) = MVtx.find v sccMapVE in
          let vScc = (sccVS,sccEIS) in
 	  let oeS = oEdgeS_scc v in
	  if SEdge.is_empty oeS 
	  then
	    (visited := MVtx.add v vScc !visited; vScc)
          else
	    let vScc0 =
	      let (vS,eS)=vScc in
              let eS11 = sccEOS in 
              let eS1 = SEdge.union eS11 eS in (vS,eS1) in
	    let vScc' = 
	      SEdge.fold (fun e ->
		let (_,vi) = getEnds e in
		let (vS1,eS1) = (r vi) in
		cross (SVtx.union vS1,SEdge.union eS1)) oeS vScc0 in
	    (visited := MVtx.add v vScc' !visited; vScc')) in
    let _ = SVtx.iter (fun v -> ignore (r v)) rootVS in
    (* expand the scc map *)
    let result = SVtx.fold (fun v -> MVtx.add v (MVtx.find (v2repr v) !visited)) vSin0 MVtx.empty in
    result  
end
  
(* note: performance penalty is high if UnCAL graph is converted to 
   node labeled graph, and resultant tc is converted to UnCAL graph 
   for each TC.
*)
