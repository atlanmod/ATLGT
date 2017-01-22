(*	$Id: biEvalUnCAL.ml,v 1.22 2010/09/11 16:08:53 hidaka Exp $	*)

(********************************************************************
		 the bidirectional UnCAL interpreter
 ********************************************************************)

open Fputil
open UnCALMAST
open UnCALMASTWalk
open EvalUnCAL
open UnCALdynenv
open UnCALenv
open ECenv
open UnCALSAST
open UnCALSA
open UnCAL
open PrintUnCAL
open PrintUnCALDM
open UnCALDM
open UnCALDMutil
open ExtSetMap


(************** BEGIN  tentative code for insertion *****************)
(* It is intended for Hidaka to understand  "Insertion Handing in 
   Bidirectional Transformation of UnCAL (Jul. 12) " by Matsuda  san *)
(* symbol table for guessing *)
type neg = In | NotIn
type eta = (lname * (SetofAllit.t * neg)) list

let lookupEta n env =
	(try List.assoc n env with 
	  Not_found ->
	   failwith ("lookupEta: Undefined variable "  ^n))

let mergeAnd = function
    ((v1,   In),(v2,   In)) -> (SetofAllit.inter v1 v2,    In)
  | ((v1,NotIn),(v2,   In)) -> (SetofAllit.diff  v2 v1,    In)
  | ((v1,   In),(v2,NotIn)) -> (SetofAllit.diff  v1 v2,    In)
  | ((v1,NotIn),(v2,NotIn)) -> (SetofAllit.union v1 v2, NotIn)
let mergeOr = function
    ((v1,   In),(v2,   In)) -> (SetofAllit.union v1 v2,    In)
  | ((v1,NotIn),(v2,   In)) -> (SetofAllit.diff  v1 v2, NotIn)
  | ((v1,   In),(v2,NotIn)) -> (SetofAllit.diff  v2 v1, NotIn)
  | ((v1,NotIn),(v2,NotIn)) -> (SetofAllit.inter v1 v2, NotIn)
let doNot = function
    (v1,   In) -> (v1, NotIn)
  | (v1,NotIn) -> (v1,    In)
let bindEta (env:dynenv) (l:lname) (v:allit) : eta =
  (* don't touch shadowed variable *)
  let conv1 = function
      (n,ALUkn) -> (n,(SetofAllit.empty,      NotIn))
    | (n,v)     -> (n,(SetofAllit.singleton v,   In)) in
  let conv = List.map conv1 in
  let rec be = function 
      (((lent,vent) as ent)::rest) -> 
      if lent = l then (lent,(SetofAllit.singleton v,   In))::(conv rest)
      else (conv1 ent)::(be rest)
    | [] -> []
  in be env.lvenv

let rec guess (env:dynenv) (t:'a tabexpr) = match t.sabexpr with
  SAIsemp expr            -> guess env { sabexpr=SATrue; abexpr=ATrue None; }
| SABisim (e1,e2)         -> failwith "not implemented"
| SALcmp (lpat1,op,lpat2) ->
    (match op with
      ALOEq -> (match (lpat1.salpat,lpat2.salpat) with
	(SALVar l,SALVar r) -> guess env { sabexpr=SATrue; abexpr=ATrue None; } (* no information obtained *)
      | (SALVar l,SALLit v) -> bindEta env l v
      | (SALLit v,SALVar l) -> bindEta env l v
      | (_       ,_       ) -> guess env { sabexpr=SATrue; abexpr=ATrue None; })
    |  ALOLt | ALOGt      -> guess env { sabexpr=SATrue; abexpr=ATrue None; })
| SANot   bexpr           -> 
    List.map (fun (lent,vent) ->
	(lent,
          if vent = ALUkn then
	    let et1 = guess env bexpr in
	    let g1 = lookupEta lent et1 in
	    doNot g1
	  else  SetofAllit.singleton vent, In)) env.lvenv
| SAAnd  (bexpr1,bexpr2)  ->
    List.map (fun (lent,vent) ->
	(lent,
          if vent = ALUkn then
	    let et1 = guess env bexpr1
  	    and et2 = guess env bexpr2 in
	    let g1 = lookupEta lent et1 
	    and g2 = lookupEta lent et2 in
	    mergeAnd (g1,g2)
	  else  (SetofAllit.singleton vent, In))) env.lvenv
| SAOr  (bexpr1,bexpr2)  -> 
    List.map (fun (lent,vent) ->
	(lent,
          if vent = ALUkn then
	    let et1 = guess env bexpr1
  	    and et2 = guess env bexpr2 in
	    let g1 = lookupEta lent et1 
	    and g2 = lookupEta lent et2 in
	    mergeOr (g1,g2)
	  else  (SetofAllit.singleton vent, In))) env.lvenv
| SATrue                  ->  List.map (fun (lent,vent) ->
	(lent,
          if vent = ALUkn then (SetofAllit.empty, NotIn)
	  else  (SetofAllit.singleton vent, In))) env.lvenv
| SAFalse                 -> List.map (fun (lent,vent) ->
	(lent,
          if vent = ALUkn then (SetofAllit.empty,   In)
	  else  (SetofAllit.singleton vent, In))) env.lvenv
| SALpred (alpt,lpat)     -> guess env { sabexpr=SATrue; abexpr=ATrue None; }

let makeTrue (t,rho) = 
  let eta = guess rho t in
  match t.sabexpr with
    SAFalse -> failwith "makeTrue: can't make false true"
  | SATrue  -> rho
  | _       ->
      let eta = guess rho t in
      { rho with lvenv =
	let rec be = function
	    (((lent,vent) as ent)::rest) ->
	      let (vS,flg) = lookupEta lent eta in
	      if vent = ALUkn && (SetofAllit.cardinal vS = 1) then
		(lent,(SetofAllit.choose vS))::rest
	      else ent::(be rest)
	  | [] -> []
	in be rho.lvenv
      }

(**************  END   tentative code for insertion *****************)

(** If true, debug write by dprintf is enabled *)
let biEvalUnCAL_verbose = ref true

(** [dprintf ?flag] acts like printf except that it prints
    nothing if [flag] or {!biEvalUnCAL_verbose} is false.
    These values are checked at run-time. *)
let dprintf ?(verbose:bool = false) =
  if (!biEvalUnCAL_verbose || verbose)
  then Format.printf
  else Format.ifprintf Format.std_formatter

(********************************************************************
			  forward evaluator
 ********************************************************************)

(* if set to true, S1 and S2 constructor do not appear in the
   result of rec. In particular, subgraph split for each edge 
   does not occur. *)
let skolemBulk = ref false

(* if set to true, unreachable part is set aside after fwd evaluation *)
let saUnreach = ref false

(* Bulk semantics with or without structural node *)
let dfwd_AERec expid (setZ:SetofMarker.t) ((epsEdgS,nonEpsEdgS):(SetofEdge.t * SetofEdge.t))
    (mapE: graph MapofEdge.t) (incomEdgeS_d: vtx -> SetofEdge.t) (outgoEdgeS_d: vtx -> SetofEdge.t) 
    (d: graph)  : (graph * SetofVtx.t * SetofEdge.t * SetofEdge.t) = 
  let lookupEbody u a v = try (MapofEdge.find (u,a,v) mapE) with
    Not_found -> failwith  "dfwd_AERec: Cached ebody value not found." in
  (* Skolem function S1 and S2 *)
  let rMapV = ref MapofVtx.empty in
  let lookupOrRegister (sv:vtx) =
    try (MapofVtx.find sv !rMapV) with
      Not_found ->
	let nv = (newnode ()) in (* generate flat ID *)
	rMapV := MapofVtx.add sv nv !rMapV; (* register flat ID *)
	nv in 
  let (s1,s2) =
    if !skolemBulk then
       ((fun (u,z)     ->  Hub (u,z,expid)),
	(fun (u,a,v,w) ->  FrE (w,(u,a,v),expid)))
    else    (* avoid generating structured IDs *)
      ((fun (u,z)     ->  lookupOrRegister (S1 (u,z))),
       (fun (u,a,v,w) ->  w)) in

  (* converging points of the outputs of ebody *)
  let hubV = SetofVtx.setmap (fun u -> maps_Marker2Vtx (fun z -> (s1 (u,z))) setZ) d.v in

  (* connections between the outputs of ebody *)
  let spokeEps = setmap_Vtx2Edge
    (fun u ->
       SetofEdge.union
	(SetofEdge.setmap (fun (v,lbl,_) ->
          if lbl = ALEps then SetofEdge.empty else
	  let eg = lookupEbody v lbl u in
	  maps_OnodeR2Edge (fun (w,m) -> (s2(v,lbl,u,w),ALEps,s1(u,m))) eg.o)
	   (incomEdgeS_d u))
	(SetofEdge.setmap (fun (_,lbl,u') ->
          if lbl = ALEps then SetofEdge.empty else
	  let eg = (lookupEbody u lbl u') in
	  maps_InodeR2Edge (fun (m,w) -> (s1(u,m),ALEps,s2(u,lbl,u',w))) eg.i)
	   (outgoEdgeS_d u))) d.v in
  let setI = SetofInodeR.setmap (fun (x,u) ->
    maps_Marker2InodeR (fun z -> (x &^ z,s1(u,z))) setZ) d.i in
  let setO = SetofOnodeR.setmap (fun (u,y) ->
    maps_Marker2OnodeR (fun z -> (s1(u,z),y &^ z)) setZ) d.o in
  let (bodyV,bodyE) =
   (*
      MapofEdge.fold (fun _ gi -> 
	cross (SetofVtx.union  gi.v,SetofEdge.union gi.e))
	mapE (SetofVtx.empty,SetofEdge.empty)  *)
    SetofEdge.fold (fun (u,a,v) ->
      let gi = lookupEbody u a v in
      cross (SetofVtx.union
	       (SetofVtx.map (fun w -> s2(u,a,v,w)) gi.v),
	     SetofEdge.union 
	       (SetofEdge.map (fun (s,l,t) -> (s2(u,a,v,s),l,s2(u,a,v,t))) gi.e)))
	nonEpsEdgS (SetofVtx.empty,SetofEdge.empty) in
  let s1s1Eps =
    setmap_Marker2Edge (fun z -> 
      SetofEdge.map (fun (u,a,v) -> (s1 (u,z),a,s1 (v,z))) epsEdgS) setZ in
  let g = 
    { v =  SetofVtx.fromLSet [hubV;    bodyV        ];
      e = SetofEdge.fromLSet [spokeEps;bodyE;s1s1Eps];
      i = setI; o = setO;} in
  (g,hubV,spokeEps,s1s1Eps)

(****  create graph corresponding to
   (&z1 := {!:&z1}, &z2:={!:&z2}, ...,&zN={!:&zN}) ****)
(* currently unused *)
let ebodyEpsGraph (setZ:SetofMarker.t) : graph =
  let (sV,sE,sI,sO) = SetofMarker.fold (fun m (sV0,sE0,sI0,sO0) ->
    let (sv,tv)  = mapT2 newnode ((),()) in
    (   SetofVtx.addl [sv;tv]       sV0,
       SetofEdge.add  (sv,ALEps,tv) sE0,
     SetofInodeR.add  (m,sv)        sI0,
     SetofOnodeR.add  (tv,m)        sO0)
       ) setZ (   SetofVtx.empty,  SetofEdge.empty,
	       SetofInodeR.empty,SetofOnodeR.empty)
  in {v=sV; e=sE; i=sI; o=sO}

(*** create expression corresponding to
  (&z1 := {!:&z1}, &z2:={!:&z2}, ...,&zN={!:&zN}) ****)
let ebodyEpsExpr (setZ:SetofMarker.t) : 'a aexpr = 
  SetofMarker.fold (fun m es ->
    AEDUni (None,AEIMrk (None,m, AEEdg (None,ALLit (None, ALEps), AEOMrk (None,m))),es)) setZ (AEGEmp None)


(* Adjust the keys of ecmap according to escapeApnd.
   Although escapeApndG1 considers the case in which expid is missing,
   the caller here always provide expid, so we disregard the missing case. *)
let wrap_ecmap_AEApnd expid ecmap =
  if !escapeApnd then
    let wrapIaT (u,l,v) = (IaT (expid,u),l,IaT (expid,v)) in
    MapofEdge.endomap_kv wrapIaT id ecmap
  else ecmap

(* Returns the entry of ecmap for label expression. 
   If the label expression is either literal or binary expression,
   the entry will be none. If it is a label variable reference,
   then resolve the reference by looking up  ecenv *)
let salpat2ecmap_entL ecenv salpat =
  match salpat with
    SALLit x -> None
  | SALVar n -> lookupLVar_aux ecenv n
  | SALBin _ -> None

let rec eval_fwd (ecenv:ecenv) (rho:dynenv) (taexpr:('a taexpr)) : 'b maexpr =
  let eid = if !skolemBulk then Some taexpr.expid else None in
  match taexpr.saexpr with
    SAETEmp   -> 
      let g = (!<>) ?expid:eid () in 
      {graph = g ;taexpr=taexpr; daexpr=DAETEmp; ecmap=MapofEdge.empty; ecenv; reach=true}
  | SAEGEmp   -> {graph = emptyGraph;     taexpr=taexpr; daexpr=DAEGEmp; ecmap=MapofEdge.empty; ecenv; reach=true}
  | SAEOMrk m -> let g = (!&) ?expid:eid m in
    {graph = g; taexpr=taexpr; daexpr=DAEOMrk m; ecmap=MapofEdge.empty; ecenv; reach=true}
  | SAEEdg (lpat,expr) ->
      let p = eval_fwdL rho lpat in
      let g = eval_fwd  ecenv rho expr in
      let pg = (/:) ?expid:eid p.allit g.graph in
      let ecmap =
        (* TODO: unify with the other function with the same name *) 
	let pick_top1edge (g:graph) : edge = 
	  let r = try (lookupI g "&") with
	    Not_found -> failwith ("pick_top1edge: no input node marked '&'")  in
	  let s = outgoEdgeS g r in
	  if SetofEdge.cardinal s = 1 then SetofEdge.choose s
	  else failwith ("pick_top1edge: multiple toplevel edge for {le:e}.") in
	let edge = pick_top1edge pg in
	let ecmap_entL = salpat2ecmap_entL ecenv lpat.salpat in
	MapofEdge.union (=) (MapofEdge.singleton edge ecmap_entL) g.ecmap in
      { graph= pg; taexpr=taexpr; daexpr=DAEEdg (p,g); ecmap=ecmap; ecenv; reach=true}
  | SAEVar v -> 
      { graph = lookupVar rho v; taexpr=taexpr; daexpr= DAEVar v; ecmap=lookupGVar_aux ecenv v; ecenv; reach=true}
  | SAEApnd (e1,e2) ->
      let g1 = eval_fwd ecenv rho e1 in
      let g2 = eval_fwd ecenv rho e2 in
      let g = (@&) ~expid:taexpr.expid g1.graph g2.graph in
      (* adjust ecmap according to escapeApnd value *)
      let ecmap1 = wrap_ecmap_AEApnd taexpr.expid g1.ecmap in
      let ecmap = MapofEdge.union (=) ecmap1 g2.ecmap in
      { graph = g; taexpr=taexpr; daexpr=DAEApnd (g1,g2); ecmap=ecmap; ecenv; reach=true}
  | SAECyc e -> 
      let g = eval_fwd ecenv rho e in
      let pg = (!!<>) ?expid:eid g.graph in
      { graph = pg; taexpr=taexpr; daexpr=DAECyc g; ecmap=g.ecmap;ecenv; reach=true}
  | SAEUni (e1,e2) ->
      let g1 = eval_fwd ecenv rho e1 in
      let g2 = eval_fwd ecenv rho e2 in
      let g = (+|) ?expid:eid g1.graph g2.graph in
      let ecmap = MapofEdge.union (=) g1.ecmap g2.ecmap in
      { graph = g; taexpr=taexpr; daexpr=DAEUni (g1,g2); ecmap=ecmap; ecenv; reach=true}
  | SAEDUni (e1,e2) ->
      let g1 = eval_fwd ecenv rho e1 in
      let g2 = eval_fwd ecenv rho e2 in
      let ecmap = MapofEdge.union (=) g1.ecmap g2.ecmap in
      { graph = evalg_AEDUni g1.graph g2.graph; taexpr=taexpr; daexpr=DAEDUni (g1,g2); ecmap=ecmap; ecenv; reach=true}
  | SAEIMrk (m,expr) ->
      let g = eval_fwd ecenv rho expr in
      { graph = evalg_AEIMrkG m g.graph; taexpr=taexpr; daexpr=DAEIMrk (m,g); ecmap=g.ecmap; ecenv; reach=true}
  | SAEIf  (be,et,ef) -> 
      let flag = eval_Bexp rho be in (* normal forward evaluation *)
      let g = if flag  then eval_fwd ecenv rho et  else eval_fwd ecenv rho ef in
      { graph = g.graph; taexpr=taexpr; daexpr=DAEIf (flag,g); ecmap=g.ecmap; ecenv; reach=true}
  | SAELet (v,ebind,ebody) ->
      let gbin = eval_fwd ecenv rho ebind in
      let gbod = eval_fwd (intern_gv_aux v gbin.ecmap ecenv) (intern_gv v gbin.graph rho) ebody in
      { graph = gbod.graph; taexpr=taexpr; daexpr=DAELet (v,gbin,gbod); ecmap=gbod.ecmap; ecenv; reach=true}
  | SAELLet (v,lbind,ebody) ->
      let llbin = eval_fwdL rho lbind in
      let ecmap_entL = salpat2ecmap_entL ecenv lbind.salpat in 
      let gbod = eval_fwd (intern_lv_aux v ecmap_entL ecenv) (intern_lv v llbin.allit rho) ebody in
      { graph = gbod.graph; taexpr=taexpr; daexpr=DAELLet (v,llbin,gbod); ecmap=gbod.ecmap; ecenv; reach=true}
  | SAERec (l,t,ebody,earg) -> eval_fwd_AERec ecenv rho l t ebody earg taexpr
(* and eval_fwd_AERec_skolem rho l t ebody earg taexpr = *)
(*   let xd = eval_fwd rho earg in *)
(*   let d = xd.graph in *)
(*   let (epsEdgS,nonEpsEdgS) = SetofEdge.partition (fun (_,l,_) -> l = ALEps) d.e in *)
(*   let mapE =  *)
(*     (SetofEdge.fold (fun (u,a,v) -> MapofEbody.add (a,v) *)
(*      (let eg = eval_fwd (intern_gv t (make_dv d v) (intern_lv l a rho)) ebody in *)
(*        eg)) *)
(*      nonEpsEdgS MapofEbody.empty) in *)
(*   let lookupEbodyX a v = try (MapofEbody.find (a,v) mapE) with *)
(*     Not_found -> failwith  "eval_fwd_AERec_skolem: Cached ebody value not found." in *)
(*   let lookupEbody a v = (lookupEbodyX a v).graph in *)
(*   let (iS,oS) = ebody.vtype in *)
(*   let setZ = SetofMarker.union iS oS in  *)
(*   (\* Skolem function S1 and S2 *\) *)
(*   let rMapV = ref MapofVtx.empty in *)
(*   let lookupOrRegister (sv:vtx) =  *)
(*     try (MapofVtx.find sv !rMapV) with *)
(*       Not_found -> *)
(* 	let nv = (newnode ()) in (\* generate flat ID *\) *)
(* 	rMapV := MapofVtx.add sv nv !rMapV; (\* register flat ID *\) *)
(* 	nv in  *)
(*   let s1 (u,z) = lookupOrRegister (S1 (u,z)) in *)
(*   let s2 (u,a,v,w) = lookupOrRegister (S2 (u,a,v,w)) in *)
  
(*   let setV =  *)
(*     (SetofVtx.fold (fun u -> SetofVtx.union *)
(* 	(SetofMarker.fold (fun z -> SetofVtx.add *)
(* 	    (s1 (u,z)) *)
(* 	    ) setZ SetofVtx.empty)) d.v SetofVtx.empty) in *)
(*   let setiV = *)
(*     (SetofEdge.fold (fun (u,a,v) -> SetofVtx.union *)
(* 	(SetofVtx.fold (fun w -> SetofVtx.add *)
(*          (s2 (u,a,v,w)) *)
(*    ) ( *)
(*        let eg = lookupEbody a v *)
(*        in *)
(*        eg.v *)
(*      ) *)
(*       SetofVtx.empty)) nonEpsEdgS SetofVtx.empty) in *)
(*   let edge3 =  *)
(* 	(SetofEdge.fold (fun (u,a,v) -> SetofEdge.union *)
(* 	    (SetofInodeR.fold (fun (z,w) -> SetofEdge.add *)
(* 		(s1 (u,z),ALEps,s2 (u,a,v,w)) *)
(*      ) ( *)
(* 	     let eg = lookupEbody a v *)
(* 	     in *)
(* 	     eg.i *)
(* 	       ) *)
(* 	       SetofEdge.empty)) nonEpsEdgS SetofEdge.empty) in *)
(*   let edge4 =  *)
(*     (SetofEdge.fold (fun (u,a,v) -> SetofEdge.union *)
(* 	(SetofEdge.fold (fun (w,b,w') -> SetofEdge.add *)
(* 	    (s2 (u,a,v,w),b,s2 (u,a,v,w')) *)
(*     ) ( let eg = lookupEbody a v in eg.e *)
(* 	 ) SetofEdge.empty)) nonEpsEdgS SetofEdge.empty) in  *)
(*   let edge5 =  *)
(*     (SetofEdge.fold (fun (u,a,v) -> SetofEdge.union *)
(* 	(SetofOnodeR.fold (fun (w,z) -> SetofEdge.add *)
(* 	    (s2 (u,a,v,w),ALEps,s1 (v,z)) *)
(*     ) (let eg = lookupEbody a v in eg.o *)
(*       ) SetofEdge.empty)) nonEpsEdgS SetofEdge.empty) in *)
(*   let edge6 = *)
(*     (SetofMarker.fold (fun z -> SetofEdge.union *)
(* 	(SetofEdge.fold (fun (u,a,v) -> SetofEdge.add *)
(* 	    (s1 (u,z),a,s1 (v,z)) *)
(*     ) epsEdgS  SetofEdge.empty)) setZ SetofEdge.empty) in *)
(*   let setI = SetofInodeR.fold (fun (x,u) -> SetofInodeR.union *)
(*       (SetofMarker.fold (fun z -> SetofInodeR.add *)
(* 	  (x &^ z,s1(u,z)) *)
(* 	  ) setZ SetofInodeR.empty)) d.i SetofInodeR.empty in *)
(*   let setO = SetofOnodeR.fold (fun (u,y) -> SetofOnodeR.union *)
(*       (SetofMarker.fold (fun z -> SetofOnodeR.add *)
(* 	  (s1(u,z), y &^ z) *)
(* 	  ) setZ SetofOnodeR.empty)) d.o SetofOnodeR.empty in *)
(*   let g = { v = SetofVtx.union setV setiV; *)
(* 	    e = SetofEdge.union edge3  *)
(* 	      (SetofEdge.union edge4 (SetofEdge.union edge5 edge6)); *)
(* 	    i = setI; o = setO } in *)
(*   { graph=g; taexpr=taexpr; daexpr=DAERec (l,t,mapE,xd); } *)
and eval_fwd_AERec ecenv rho l t ebody earg taexpr =
  (********** (1) forwared evaluation of the argument **************)
  let xd = eval_fwd ecenv rho earg in

  (*** (2),(3) generate bindings and compute the body recursively **)
  let (iS,oS) = ebody.vtype in
  let setZ = SetofMarker.union iS oS in 
  let d = xd.graph in
  let (outgoEdgeS_d,incomEdgeS_d,_,_) = build_ioedge_ionode_map d in
  let (epsEdgS,nonEpsEdgS) = SetofEdge.partition isEpsEdge d.e in
  let ebodyEps = ebodyEpsExpr setZ in
  let mapE =
    (SetofEdge.fold (fun (u,a,v) mE ->
      if MapofEdge.mem (u,a,v) mE then mE else 
      MapofEdge.add (u,a,v)
	 (* if a = ALEps then bd_fwd rho ebodyEps else *)
	  (let dv   = make_dv_with_oEmap outgoEdgeS_d d v in
	   let rho1 = intern_gv t dv (intern_lv l a rho) in
	   let ecmap_dv = MapofEdge.filter (fun edge _ -> SetofEdge.mem edge dv.e) xd.ecmap in
	   let ecenv1 = intern_lv_aux l (MapofEdge.find (u,a,v) xd.ecmap) ecenv in
	   let ecenv1 = intern_gv_aux t ecmap_dv ecenv1 in
	     eval_fwd ecenv1 rho1 ebody)
	  mE) nonEpsEdgS MapofEdge.empty) in

  (************** (4) compose g according to mapE *****************)
  let pmapE = MapofEdge.map (fun xg -> xg.graph) mapE in
  let (g,hubV,spokeEps,s1s1Eps) = dfwd_AERec taexpr.expid
      setZ (epsEdgS,nonEpsEdgS) pmapE incomEdgeS_d outgoEdgeS_d d in
  (* don't throw away garbage here like let g = reachableGI g in ... *)
  (* flag the unreachable part to avoid branch behavior check in backward trans. *)
  let mapE = if SetofMarker.is_empty oS then
    let d_1s = reachableGI1s d in
    let f xg = {xg with reach = false } in
    let g edge xg = if SetofEdge.mem edge d_1s.e then xg else map_maexpr f xg in
    MapofEdge.mapi g mapE
  else mapE in
  let (g,cmpl) = if !saUnreach then split_reachableGI g else (g,emptyGraph) in
  (******************** equivalence class map *********************************)
  (* For spokeEps and s1s1Eps, we just map to None.
     For FrE edges, depending on the value of SkolemBulk, we wrap the 
     nodes of the keys.  *)
  (* Maybe we don't have to care the epsilon edges sice they will not be in the range of ecmap *)
  let ecmap_spokeEPS = (* build a map from a set of edge *)
   edgeSet2Map (fun _ -> None) (if !saUnreach then (SetofEdge.filter (fun edge -> SetofEdge.mem edge g.e) spokeEps) else spokeEps) in
  let ecmap_s1s1Eps = 
   edgeSet2Map (fun _ -> None) (if !saUnreach then (SetofEdge.filter (fun edge -> SetofEdge.mem edge g.e) s1s1Eps) else s1s1Eps) in
  let s2 = if !skolemBulk then (fun (u,a,v,w) ->  FrE (w,(u,a,v),taexpr.expid))
                          else (fun (u,a,v,w) ->  w) in
  let ecmap_mapE = (* unify the results *)
   (* Filter the body of mapE first depending on !saUnReach.
      We could have also projected the mapE not just for the sake of equivalence class mapping *)
   (* Prepare map to ecmap *)
    let mapE_ecmap =
      if !saUnreach then 
         MapofEdge.mapi (fun (u,a,v) xg ->
	   let wrap (w,wa,w') = (s2 (u,a,v,w),wa,s2(u,a,v,w')) in
           MapofEdge.filter (fun edge _ -> SetofEdge.mem (wrap edge) g.e) xg.ecmap) mapE
      else 
	MapofEdge.mapi (fun (u,a,v) xg -> xg.ecmap) mapE in
    (* For each entry of mapE, xg contains the ecmap, so we wrap the key and unify these maps.
       Wrapping depends on the value of skolemBulk *)
    MapofEdge.fold (fun (u,a,v) ecmap ->
      let wrap (w,wa,w') = (s2 (u,a,v,w),wa,s2(u,a,v,w')) in
      MapofEdge.union (=) (MapofEdge.endomap_kv wrap id ecmap)) mapE_ecmap MapofEdge.empty in
  { graph=g; taexpr=taexpr; daexpr=DAERec (l,t,mapE,hubV,spokeEps,s1s1Eps,xd,cmpl); ecmap=ecmap_mapE; ecenv; reach=true}

and eval_fwdL (rho:dynenv) (talpat:('a talpat)) : 'b malpat =
  match talpat.salpat with
    SALLit x -> { allit = x; talpat = talpat; dalpat = DALLit x; }
  | SALVar n -> { allit = lookupLVar rho n; talpat=talpat; dalpat=DALVar n;}
  | SALBin (lpat1,op,lpat2) ->
      let (l1,l2) = mapT2 (eval_fwdL rho) (lpat1,lpat2) in
      { allit = evall_bin l1.allit op l2.allit; 
	talpat = talpat; dalpat = DALBin (l1,op,l2); }
and bd_fwd ecenv rho aexpr = 
  let stEnv:stenv = dynenv2stenv rho in
  let texpr = augType stEnv aexpr in
  let nexpr = numberE texpr in
  eval_fwd ecenv rho nexpr
and bd_fwdL rho alpat =
  let stEnv:stenv = dynenv2stenv rho in
  let talpat = augTypeL stEnv alpat in
  eval_fwdL rho talpat

(********************************************************************
  Exception raised with error messages when illegal or unsupported
  modification is encountered.
 ********************************************************************)
exception Eval_Bwd of string

(** operation on marker **)
(* strip input marker from the left *)
let stripMarker m1 m2 =
  if m1 = "&" then m2 
  else if m1 = m2 then "&"
  else
    let len = String.length m1 in
    let prefix = String.sub m2 0 len in
    if prefix = m1 then String.sub m2 len (String.length m2 -len) 
    else raise (Eval_Bwd ("stripMarker: can't strip marker " ^ m1 ^ " from " ^ m2))

(********************************************************************
		       environment manipulation
 ********************************************************************)
(** consistency checking and unification of bindings **)
(* unused *)
let mg_eq_env l1 l2 = (* checks consistency *) 
    (List.fold_right2 (fun (n1,v1) (n2,v2) -> cons
     (if (n1 <> n2)
      then failwith ("mg_eq_env: binding order difference detected "   ^ n1 ^ " and " ^ n2)
      else if v1 <> v2 
      then raise (Eval_Bwd ("mg_eq_env: bindings of " ^ n1 ^ " and " ^ n2 ^ "disagree."))
      else (n1,v1))) l1 l2 [] )
(* unused *)
let merge_eq_env (rho1:dynenv) (rho2:dynenv) : dynenv = 
  { gvenv = (mg_eq_env rho1.gvenv rho2.gvenv);
    lvenv = (mg_eq_env rho1.lvenv rho2.lvenv);}
(* unused *)
let mg_env l1 l2 = (* l1 takes precedence *)
    (List.fold_right2 (fun (n1,v1) (n2,v2) -> cons
     (if (n1 <> n2)
      then failwith ("mg_env: binding order difference detected "   ^ n1 ^ " and " ^ n2)
      else (n1,v1))) l1 l2 [] )

(* merge two alists l1 and l2 according to orgl *)
(* eqv : equivalence predicate *)
let mg_env_cmp eqv l1 l2 orgl = 
  (fold_right3 (fun (n1,v1) (n2,v2) (n,v) -> cons
     (if (not ((n1 = n2) && (n2 = n)))
      then failwith ("mg_env_cmp: binding order difference detected "   ^ n1)
      else 
       if eqv v1 v2 (* equal binding (possibly modified) *)
       then (n1,v1)
       else if (eqv v1 v) then (n2,v2) (* only v2 is modified *)
       else if (eqv v2 v) then (n1,v1) (* only v1 is modified *)
       else raise (Eval_Bwd ("mg_env_cmp: binding conflicts detected for "  ^ n1))
     )) l1 l2 orgl [] )

(* experimental extension of mg_env_cmp *)
let mg_env_cmp_aux l1 l2 orgl = 
  (fold_right3 (fun (n1,v1) (n2,v2) (n,v) -> cons
     (if (not ((n1 = n2) && (n2 = n)))
      then failwith ("mg_env_cmp: binding order difference detected "   ^ n1)
      else 
       if v1 = v2 (* equal binding (possibly modified) *)
       then (n1,v1)
       else if (v1 = v) then raise (Eval_Bwd ("mg_env_cmp: only v2 is modified.")) (* only v2 is modified *)
       else if (v2 = v) then raise (Eval_Bwd ("mg_env_cmp: only v1 is modified.")) (* only v1 is modified *)
       else raise (Eval_Bwd ("mg_env_cmp: binding conflicts detected for "  ^ n1))
     )) l1 l2 orgl [] )

(* merge two environments updated relative to original one *)
let uplus_cmp (rhoL':dynenv) (rho':dynenv) (rho:dynenv) : dynenv = 
      { gvenv = mg_env_cmp (=.=) rhoL'.gvenv rho'.gvenv rho.gvenv;
	lvenv = mg_env_cmp (=)   rhoL'.lvenv rho'.lvenv rho.lvenv; }

(* eqv : equivalence predicate *)
let mg_env_cmpM (eqv:'a -> 'a -> bool) ll orgl =
    List.fold_right2 (fun bds (n,v) -> cons (
      if not (List.for_all (fun x -> n = (fst x)) bds)
      then failwith ("mg_env_cmpM: inconsistent binding order detected " ^ n)
      else 
	let (unchanged,changed) = List.partition (fun (_,vi) -> eqv vi v) bds in
	match changed with
	  []     -> (n,v)  (* no binding in ll is changed *)
	| [x]    -> x      (* one binding been changed is selected *)
        | xs     ->
	    let eqv x1 x2 = eqv (snd x1) (snd x2) in
	    if uniform eqv id xs then List.hd xs (* consistent changes are allowed *)
	    else raise (Eval_Bwd ("mg_env_cmpM: inconsistent change detected for binding of " ^ n)))) ll orgl []

let uplus_cmpM mggenv'' mglenv'' rho = 
  { gvenv = mg_env_cmpM (=.=) mggenv'' rho.gvenv;
    lvenv = mg_env_cmpM (=)   mglenv'' rho.lvenv; }

(* biguplus: merge set (map) of environments updated relative to original one *)
let biguplus_cmp mapRho' rho = 
  (* generate list of list of bindings
     input  (a,v) => {gvenv=[("$V1",g1);("$V2",g2);...],lvenv=[("$L1",l1);("$L2",l2);...]}  map
     output [[("$V1",g1_1);("$V1",g1_2);...;("$V1",g1_n)];
             [("$V2",g2_1);("$V2",g2_2);...;("$V2",g2_n)]; ...]
            [[("$L1",l1_1);("$L1",ll_2);...;("$L1",l1_n)];
             [("$L2",l2_1);("$L2",l2_2);...;("$L2",l2_n)]; ...] *)
  let mggenv'' =
    transpose (MapofEdge.fold (fun _ rhoi' -> cons rhoi'.gvenv) mapRho' []) in
  let mglenv'' = 
    transpose (MapofEdge.fold (fun _ rhoi' -> cons rhoi'.lvenv) mapRho' []) in

  (* merge rho'', rho and each member of mapRho' *)
  if MapofEdge.is_empty mapRho' then rho
  else uplus_cmpM mggenv'' mglenv'' rho

(** evaluation parameter **)
(* Take tree variable t into account in the body. If false, fully tupled 
   recursive version can be handled. Modification to the result of
   non-recursive rec is not reflected *)

let bwdRecUseT = ref true

(********************************************************************
			 graph decomposition
 ********************************************************************)

(* used only as a helper function *)
let decompose_union_reachable
  (g1:graph) (g2:graph) (g:graph) (g':graph) : (graph * graph) =
   mapT2 reachableGI ({ g' with i = g1.i },{ g' with i = g2.i })
let decompose_AEDUni_reachable = decompose_union_reachable
let decompose_AEUni_reachable  = decompose_union_reachable

let decompose_union
  (g1:graph) (g2:graph) (g:graph) (g':graph) : (graph * graph) =
  let (g1reachable',g2reachable') = decompose_union_reachable g1 g2 g g' in
  let (g1reachable,g2reachable)   = mapT2 reachableGI (g1,g2) in
  let g1unreachable = evalg_simple_diff g1 g1reachable in
  let g2unreachable = evalg_simple_diff g2 g2reachable in
  (evalg_simple_union g1reachable' g1unreachable,
   evalg_simple_union g2reachable' g2unreachable)

(* divisibility check *)
let check_decompose_AEUni (((((g1:graph),(g2:graph)),(g:graph)),(g':graph)) as arg) =
  let (imarks1,inodes1) = List.split (SetofInodeR.elements g1.i)
  and (imarks2,inodes2) = List.split (SetofInodeR.elements g2.i) in
  if imarks1 = imarks2 
  then
    begin 
      if List.exists2 (=) inodes1 inodes2
      then (Printf.fprintf stdout  "check_decompose_AEDuni: identical input node\n%!")
      else ();
      arg
    end
  else failwith "check_decompose_AEDUni: Unioned graphs have different set of input markers"
  
let decompose_AEDUni = decompose_union
let decompose_AEUni  = (curry @@ curry @@ curry)
   (((uncurry @@ uncurry @@ uncurry) decompose_union) @@ check_decompose_AEUni)

(* unused *)
let decompose_AEApnd_reachable 
    (g1:graph) (g2:graph) (g:graph) (g':graph) : (graph * graph) =
      let g2' = reachableGI { g' with i = g2.i } in
      let g1v' = SetofVtx.diff g'.v g2'.v in
      let g1e'= SetofEdge.diff g'.e g2'.e in
      (* remove epsilon edges that connected g1 to g2 *)
      let g1e'= SetofEdge.diff g1e'
	  (SetofEdge.filter (fun (vs,l,vt) -> (l = ALEps) && SetofVtx.mem vt g2.v) g1e') in
      let g1' = { v = g1v'; e = g1e';  i = g1.i; o=g1.o; } in
      (g1',g2')

(* unused *)
let decompose_AEApnd_org (g1:graph) (g2:graph) (g:graph) (g':graph) : (graph * graph) =
  let epsEdgeS = SetofEdge.filter (fun (vs,l,vt) ->
    (l=ALEps) && SetofVtx.mem vs g1.v  && SetofVtx.mem vt g2.v) g.e  in
  let g'          = { g' with e = SetofEdge.diff g'.e epsEdgeS; } in
  let reachableG2 = reachableGI g2 in
  let gbg2EdgeS   = SetofEdge.diff g2.e reachableG2.e in
  let gbg2VtxS    = SetofVtx.diff  g2.v reachableG2.v in
  let g2''        = reachableGI { g' with i = g2.i } in
  let g2'         = { g2'' with 
		      v = SetofVtx.union g2''.v gbg2VtxS;
		      e = SetofEdge.union g2''.e gbg2EdgeS; } in
  let g1'         = { v = SetofVtx.diff  g'.v g2'.v;
		      e = SetofEdge.diff g'.e g2'.e;
		      i = g1.i;
		      o = g1.o; } in
  (g1',g2')

let stripIaT = function 
    IaT (_,v) -> v
  | v         -> v

let stripIaT_VEIO = map_VEIO stripIaT

let decompose_AEApnd (eid:expid) (g1:graph) (g2:graph) (g:graph) (g':graph) : (graph * graph) =
  let g1 = if !escapeApnd then escapeApndG1 (Some eid) g1 else g1 in
  let isCrossEps ((u,l,v) as e) =
    (not (SetofEdge.mem e g1.e)) && (not (SetofEdge.mem e g2.e)) (* should be enough *)
      && isEpsEdge e && SetofVtx.mem u g1.v && SetofVtx.mem v g2.v (* sanity test *) in
  let g' = { g' with e = SetofEdge.filter (not @@ isCrossEps) g'.e } in
  let (g1reachable',g2reachable') = mapT2 reachableGI ({g' with i=g1.i},{g' with i=g2.i}) in
  let (g1reachable, g2reachable)  = mapT2 reachableGI (g1,g2) in
  let g1unreachable = evalg_simple_diff g1 g1reachable in
  let g2unreachable = evalg_simple_diff g2 g2reachable in
  let survivedOnodeRS =
      SetofOnodeR.filter (fun (v,m) -> SetofVtx.mem v g1reachable'.v) g1reachable.o in
  let g1reachable' = {g1reachable' with 
		      o= SetofOnodeR.union g1reachable'.o survivedOnodeRS;} in
  let (g1',g2') = (evalg_simple_union g1reachable' g1unreachable,
		   evalg_simple_union g2reachable' g2unreachable) in
  ((if !escapeApnd then stripIaT_VEIO g1' else g1'),g2')

let pick_top1edge (g:graph) : edge =
  let r = try (lookupI g "&") with
    Not_found -> raise (Eval_Bwd "pick_top1edge: no input node marked '&'")  in
  let s = outgoEdgeS g r in
  if SetofEdge.cardinal s = 1 then SetofEdge.choose s
  else raise (Eval_Bwd "pick_top1edge: multiple toplevel edge for {le:e}.")

(* unused *)
let decompose_AEEdg_reachable (l:allit) (g1:graph) (g:graph) (g':graph) : (allit * graph) =
  let (_,l',v) = pick_top1edge g' in
  (l',make_dv g' v)

(* unreachable part is taken into account *)
(* unused *)
let decompose_AEEdg_keepUnreach (l:allit) (g1:graph) (g:graph) (g':graph) : (allit * graph) =
  let g1reachable = reachableGI g1 in
  let g1unreachable = evalg_simple_diff g1 g1reachable in
  let ((u,l',v) as e) = pick_top1edge g' in
  let g1reachable'  = reachableGI { g' with i = g1.i } in
  (l', evalg_simple_union g1reachable' g1unreachable)

(* just do reverse of evalg_AEEdg  *)
let decompose_AEEdg (l:allit) (g1:graph) (g:graph) (g':graph) : (allit * graph) =
  let ((u,l',v) as e) = pick_top1edge g' in
  (l', { g' with i = g1.i; e = SetofEdge.remove e g'.e; v = SetofVtx.remove u g'.v;} )

(** currently g (result of forward evaluatin) is unsused **)
let decompose_AECyc (g0:graph) (g:graph) (g':graph) : graph = 
  let epsEdgeS = SetofEdge.filter (fun (vs,l,vt) ->
    (l=ALEps) &&
    let (_,omS) = markersV g0 vs in
    let (imS,_) = markersV g0 vt in
    not (SetofMarker.is_empty (SetofMarker.inter omS imS))) g'.e in
  if !cycleSemanticsOriginal then
    let v' = maps_InodeR2Vtx (fun (_,v)-> v) g'.i in
    let getTopEps ((_,v):inodeR) =
      let s = outgoEdgeS g' v in
      if SetofEdge.cardinal s <> 1 
      then raise (Eval_Bwd "bwd(cycle):multiple edges form inode")
      else let (_,l,_) as e = SetofEdge.choose s in
      if l <> ALEps then raise (Eval_Bwd "bwd(cycle):non-epsilon from inode")
      else e in
    let epsEdgeS = SetofEdge.union epsEdgeS (maps_InodeR2Edge getTopEps g'.i) in
    { v = SetofVtx.diff  g'.v v';
      e = SetofEdge.diff g'.e epsEdgeS;  
      i = g0.i; o = g0.o; }
  else
    { g' with e = SetofEdge.diff g'.e epsEdgeS; 
      i = g0.i; o = g0.o; }

let decompose_AEIMrk (m:marker) (g1:graph) (g:graph) (g':graph) : graph =
  {  g' with i = SetofInodeR.map (cross ((stripMarker m), id))
			 (* (fun (m',v) -> (stripMarker m  m',v)) *)
			 g'.i  }

(* strip S1 and S2 node *)
let stripS1 = function
    S1 (v,m) -> v
  | v        -> v
let stripS2 = function
    S2 (_,_,_,w) -> w
  | v            -> v

let stripFrE = function
    FrE (w,_,_) -> w
  | v           -> v

let collect_S2_ionode sInodeR sOnodeR vS =
  let collect_ir v w =
   SetofInodeR.map (fun (m,iv) ->(m,v)) (SetofInodeR.filter (fun (m,iv) -> iv = w) sInodeR)
  and collect_or v w =
   SetofOnodeR.map (fun (ov,m) ->(v,m)) (SetofOnodeR.filter (fun (ov,m) -> ov = w) sOnodeR) in
  SetofVtx.fold (fun v  ->
    match v with
      S2 (_,_,_,w) -> cross (SetofInodeR.union (collect_ir v w),SetofOnodeR.union (collect_or v w))
    | _ ->            cross (id,id)) vS (SetofInodeR.empty, SetofOnodeR.empty)

(* since id's of the node of ebody is no longer unique, 
   collecting node w using matching w entry in FrE(w,_,_) collects more than you want *)

   
let collect_FrE_ionode (eid:expid) (e:edge) sInodeR sOnodeR vS =
  let collect_ir v = SetofInodeR.map (fun (m,iv) -> (m,v))
      (SetofInodeR.filter (fun (m,iv)-> FrE (iv,e,eid) = v) sInodeR)
  and collect_or v = SetofOnodeR.map (fun (ov,m) -> (v,m))
      (SetofOnodeR.filter (fun (ov,m)-> FrE (ov,e,eid) = v) sOnodeR) in
  SetofVtx.fold (fun v ->
    match v with
      FrE (_,_,_) -> cross (SetofInodeR.union (collect_ir v),SetofOnodeR.union (collect_or v))
    | _           -> cross (id,                              id))
    vS (SetofInodeR.empty, SetofOnodeR.empty)

let stripS2_VEIO  = map_VEIO stripS2
let stripFrE_VEIO = map_VEIO stripFrE

(* decomposition of the value of rec: g' -> map of gi' *)
let decompose_AERec (eid:expid) pmbody hub spoke s1s1eps g' =
  let g' = { g' with  (* remove hub and spoke that connected gi's *)
	     v = SetofVtx.diff  g'.v hub;
	     e = SetofEdge.diff g'.e spoke; } in
  let g' = { g' with  (* remove S1S1 epsilon that bypassed S2 parts *)
	     e = SetofEdge.diff g'.e s1s1eps; } in
    
  (* restore gi' *)
  MapofEdge.mapi (fun e gi ->
    (* collect entry point for each gi  *)
    let (iS,oS) = if !skolemBulk then collect_FrE_ionode eid e gi.i gi.o g'.v else (gi.i,gi.o) in
    let gi''           = { g' with i=iS;o=oS;  }           in
    let gi_reachable'  = reachableGI gi''                  in
    let gi_reachable'  = 
      if !skolemBulk then stripFrE_VEIO gi_reachable'
      else gi_reachable'                                   in
    let gi_reachable   = reachableGI gi                    in
    let gi_unreachable = evalg_simple_diff gi gi_reachable in
    evalg_simple_union gi_reachable' gi_unreachable) pmbody 

(** decomposition of label values **)
let decompose_ALBin (op:albinop) (l1:allit) (l2:allit) (l:allit) (l':allit) : (allit * allit) = 
  if l = l' then (l1,l2) 
  else 
    match op with
      ALConc ->
	match (l1,l2,l,l') with
	  (ALStr s1,ALStr s2, ALStr s,ALStr s')
	    -> (* s1 ^ = l, updated to l'*)
	      let (l_s1, l_s2, l_s, l_s') = (String.length s1,String.length s2, String.length s,String.length s') in
	      (* try to see update on the second operand *)
	      try 
		if (l_s1 < l_s') then
                  let s1' = String.sub s' 0 l_s1 in
		  if s1 = s1' then
		    (ALStr s1', ALStr (String.sub s' l_s1 (l_s' - l_s1)))
		  else failwith "left side unmatch"
		else  failwith "rite side cut too much"
	      with
		e -> (* try to see update on the first operand *)
		  if (l_s2 < l_s') then
		    let s2' = String.sub s' (l_s' - l_s2) l_s2 in
		    if s2 = s2' then
		      (ALStr (String.sub s' 0 (l_s' - l_s2)), ALStr s2)
		    else
		      failwith "decompose_ALBin(string): doesn't much on both ends"
		  else
		    if (s' = "") then 
		      (ALStr "",ALStr "")
		    else 
		      failwith "decompose_ALBin(string): both strings are cut too much"
	      | _  -> failwith "decompose_ALBin: not implemented yet"
      

(********************************************************************
			  backward evaluator
 ********************************************************************)

(** detect inconstent in-place update of graph variables in rec *)
let detectInConsistentGVarUpdateInRec = ref false

(* unused *)
(* detection of difference that only works for edges *)
(*
let apply_diff gOrg gRev = 
  let mPVtxOrg = setofEdge2mapofPVtx gOrg.e in
  let mPVtxRev = setofEdge2mapofPVtx gRev.e in
  let eS = MapofPVtx.fold (fun (v1,v2) eSent ->
    let nEorg = SetofEdge.cardinal eSent in
    let sSentRev = try (MapofPVtx.find (vs,vt) mPVtxRev) with 
      Not_found -> SetofEdge.empty in
    let nErev = SetofEdge.cardinal sSentRev in
    SetofEdge.union
      if nEorg = 1 then
	(SetofEdge.fold (fun ((vs,l,vt) as e) ->
	  SetofEdge.union
            (if (isEpsEdge e) then (SetofEdge.singleton e)
	     else 
                     SetofEdge.
		  ) 
                   )  eSent SetofEdge.empty)
             ))  mPVtxOrg SetofEdge.empty
*)

let extract_EVdiff (vSRev,eSRev) (vSOrg,eSOrg) =
  let eSadd = (SetofEdge.diff eSRev eSOrg) 
  and eSdel = (SetofEdge.diff eSOrg eSRev) 
  and vSadd = ( SetofVtx.diff vSRev vSOrg) 
  and vSdel = ( SetofVtx.diff vSOrg vSRev) in
  ( eSadd, eSdel, vSadd,  vSdel)

let apply_EVdiff eSdel vSdel eSadd vSadd d = 
  let d' = 
    {d  with 
     e = SetofEdge.diff d.e  eSdel; 
     v =  SetofVtx.diff d.v  vSdel;} in 
  {d' with
   e =  SetofEdge.union d'.e eSadd;
   v =  SetofVtx.union  d'.v vSadd; }


(********************************************************************
  Restore entire input of the body of rec 
  mapRho':  map of individual updated environment
  d :       original input
  g':       modified view (for consisitency check)
 ********************************************************************)

let restore_input_AERec (l:lname) (t:vname) (mapRho':dynenv MapofEdge.t)
    (d:graph) (g':graph) =
  let (epsEdgS,nonEpsEdgS) =
    SetofEdge.partition isEpsEdge d.e in
  let lookupMapRho' u a v = try (MapofEdge.find (u,a,v) mapRho') with
    Not_found -> failwith "lookupMapRho': not found" in
  (* glue together each rho'($L):rho'($T) to construct input of
     backward transformation of garg *)
  let (vS,eS,eSadd,eSdel,vSadd,vSdel) =
  (SetofEdge.fold (fun ((vs,a,vt) as e) (vS0,eS0,eSadd0,eSdel0,vSadd0,vSdel0) ->
    let rhoi' = lookupMapRho' vs a vt in 
    let a'    = lookupLVar rhoi' l    in
    if !bwdRecUseT then
      let dv'   = lookupVar rhoi' t in
      let dv    = make_dv d vt in 

      (* begin unused *)
      let eS'   = SetofEdge.add (vs,a',lookupI dv' "&") eS0 in
      let eS'   = SetofEdge.union eS' dv'.e in
      let vS'   = SetofVtx.add vs vS0 in
      let vS'   = SetofVtx.union vS' dv'.v in
      (* end   unused *)

      let dv'   = if SetofEdge.mem e dv'.e then { dv' with e=SetofEdge.remove e dv'.e;} else dv' in
      (* inconsistency between copies *)
(*      let _     = if (SetofEdge.mem e g'.e && (a <> a')) then 
	raise (Eval_Bwd ("bd_bwd_AERec: inconsistent copies " ^ (allit2str a) ^ " and " ^ (allit2str a'))) in *)
      let vt'   = lookupI dv' "&" in
      let eSRev = SetofEdge.add (vs,a',vt') dv'.e
      and vSRev = SetofVtx.addl [vs;vt']    dv'.v
      and eSOrg = SetofEdge.add (vs,a,vt)   dv.e
      and vSOrg = SetofVtx.addl [vs;vt]     dv.v  in
      let (eSadd,eSdel,vSadd,vSdel) = extract_EVdiff (vSRev,eSRev) (vSOrg,eSOrg) in
      let (eSadd',eSdel') = (cross (mapT2 SetofEdge.union (eSadd,eSdel))) (eSadd0,eSdel0)
      and (vSadd',vSdel') = (cross (mapT2  SetofVtx.union (vSadd,vSdel))) (vSadd0,vSdel0) in
      (vS',eS',eSadd',eSdel',vSadd',vSdel')
    else
      let eS'   = SetofEdge.add   (vs,a',vt)  eS0
      and vS'   = SetofVtx.addl   [vs;vt]     vS0 in
      let dv'   = (* lookupVar rhoi' t in *) emptyGraph in
   (* 
      let eS'   = SetofEdge.union dv'.e  eS'
      and vS'   = SetofVtx.union  dv'.v  vS' in 
    *)
      (vS',eS',eSadd0,eSdel0,vSadd0,vSdel0)
		  )
        nonEpsEdgS (SetofVtx.empty,SetofEdge.empty,
		    SetofEdge.empty,SetofEdge.empty,
		    SetofVtx.empty,SetofVtx.empty))  in
  if !bwdRecUseT then
    let _ = (if !detectInConsistentGVarUpdateInRec then
      (* Detect inconsistency updates via graph variables. 
	 edited edges are included in eSdel so it is used to 
	 print original edges. eSadd includes edges after modification.
	 If edits are only edge renaming, then multiple edges
	 in eSadd with identical endpoint results in inconsistency
	 updates, and they are warned. If original graph has 
	 more than one edge sharing identical endpoints, 
	 only edited edges are stored in eSdel, so we count
	 the cardinality in eSdel and eSadd to cope with
	 updating multiple edges.
	 If user edits include insertion, then it doesn't work
	 as expected, so detectInConsistentGVarUpdateInRec should
	 be turned off.
       *)
      let mPVtxDel = setofEdge2mapofPVtx eSdel in
      let mPVtxAdd = setofEdge2mapofPVtx eSadd in
      MapofPVtx.iter (fun p eSAdd_p ->
	let eSDel_p = MapofPVtx.find p mPVtxDel in
	if (SetofEdge.cardinal eSAdd_p) > (SetofEdge.cardinal eSDel_p) then
	  Format.fprintf Format.err_formatter "Warning: edge(s)%a inconsistently modified to @.%a@." 
	    pr_SetofEdge eSDel_p pr_SetofEdge eSAdd_p
	) mPVtxAdd
        ) in
      apply_EVdiff eSdel vSdel eSadd vSadd d
  else
    let epsEdgV = setofEdge_collectNodes epsEdgS in
    { v= SetofVtx.union vS epsEdgV;
      e=SetofEdge.union eS epsEdgS;
      i=d.i; o=d.o; }
      (*  let g'' =  if !bwdRecUseT then apply_diff d g'' else g'' *)

(** Some prettier printers related with edit operations and its maps. *)
let pp_editop ppf = function
     EMod (org,rev) -> Format.fprintf ppf "Modify %a=>%a" PrintDot.pp_allit org PrintDot.pp_allit rev
  |  EDel           -> Format.fprintf ppf "Delete"
  |  EAdd           -> Format.fprintf ppf "Add"

let pp_MapofEdgeToeditop  = MapofEdge.pp_t "MapofEdge" PrintDot.pp_edge pp_editop
let pp_MapofEdgeToEdgeOpt = MapofEdge.pp_t "MapofEdge" PrintDot.pp_edge (Print.pp_option PrintDot.pp_edge)

let rec bd_bwd (rho:dynenv) (maexpr: 'a maexpr) (g':graph)  : dynenv =
  if (not maexpr.reach) then rho else
  match maexpr.daexpr with
    DAETEmp ->
      (* let g = evalg_AETEmp () in *)
      if (* evalg_AIsemp g' *) maexpr.graph = g'
      then rho
      else raise (Eval_Bwd "bd_bwd: no modifications allowed for empty trees.")
  | DAEGEmp ->
      if maexpr.graph = g' 
      then rho
      else raise (Eval_Bwd "bd_bwd: no modifications allowed for empty graphs.")
  | DAEOMrk m -> 
      (* let g = evalg_AEOMrk m in *)
      if  maexpr.graph = g'
      then rho
      else raise (Eval_Bwd "bd_bwd: no modifications allowed for output nodes.")
  | DAEEdg (mlpat,mexpr) -> 
    let (l',gv') =  decompose_AEEdg mlpat.allit mexpr.graph maexpr.graph g' in
    let rhoL' = bd_bwdL rho mlpat l'  in
    let rho'  = bd_bwd  rho mexpr gv' in
    (* merge_eq_env rhoL' rho' *)
    (*
    { gvenv = mg_env rho'.gvenv  rhoL'.gvenv;
      lvenv = mg_env rhoL'.lvenv rho'.lvenv; } *)
    uplus_cmp rhoL' rho' rho
  | DAEVar v -> replace_bindingG v g' rho
  | DAECyc e -> 
      let g0 = e.graph in
      let g0'= decompose_AECyc g0 maexpr.graph g' in
      bd_bwd rho e g0'
  | DAEApnd (e1,e2) ->
      let g1 = e1.graph in
      let g2 = e2.graph in
      (* decompose g' into g1' and g2' *)
      let (g1',g2') = 
	(* decompose_AEApnd_reachable *) 
	(* reachableGI doesn't work because we have to keep unreachable parts
	   produced by rec for currently unavoidable backward computation
           of the body expression  on unreachable parts. 
	   Here we take more robust approach *)
	decompose_AEApnd maexpr.taexpr.expid g1 g2 maexpr.graph g' in
      let rho1' = bd_bwd rho e1 g1' in
      let rho2' = bd_bwd rho e2 g2' in
      uplus_cmp rho1' rho2' rho
  | DAEUni (e1,e2) ->
      let g1 = e1.graph in
      let g2 = e2.graph in
      (* decompose g' into g1' and g2' *)
      let (g1',g2') = decompose_AEUni g1 g2 maexpr.graph g' in
      let rho1' = bd_bwd rho e1 g1' in
      let rho2' = bd_bwd rho e2 g2' in 
      uplus_cmp rho1' rho2' rho
  | DAEIMrk (m,e) ->
      let g1 = e.graph in
      (* strip imput marker *)
      let g1' = decompose_AEIMrk m g1 maexpr.graph g' in
      let rho1' = bd_bwd rho e g1' in rho1'
  | DAEDUni (e1,e2) ->
  let g1 = e1.graph in
  let g2 = e2.graph in
  (* decompose g' into g1' and g2' *)
  let (g1',g2') = (* decompose_AEDUni_reachable g1 g2 maexpr.graph g' *) 
  decompose_AEDUni g1 g2 maexpr.graph g' in
  let rho1' = bd_bwd rho e1 g1' in
  let rho2' = bd_bwd rho e2 g2' in 
  uplus_cmp rho1' rho2' rho
  | DAEIf (flag,e1) ->
      let g = e1.graph in
      let rho' = bd_bwd rho e1 g' in 
      let (tecond,tet,tef) = match maexpr.taexpr.saexpr with 
	SAEIf(be,et,ef) -> (be,et,ef)
      | _               -> failwith "bd_bwd(DAEIf: not match)" in
      (* Propagate changes to environments using equivalence class and its operation. **)
      (* We have only to check free variables, and those can be looked
	 up by checking only the first entries of them in the environments. 
	 So iterate over free variables and replace bindings accordingly. *)
      let (freeLVars,freeGVars) = freeVarsB (detypeB tecond) in
      let rho' = 
	SetofLname.fold (fun lname rho0' ->
	  dprintf "Checking free label variable %s(=%a)@." lname  PrintDot.pp_allit (lookupLVar rho' lname);
	  let edge_ec_opt = lookupLVar_aux maexpr.ecenv lname in
	  (match edge_ec_opt with
	    Some edge_ec ->
	      (match (MapofEdge.find_some edge_ec !editop_map) with
		None -> rho'
	      | Some editop ->
		  dprintf "Apply modification %a@." pp_editop editop;
		  match editop with
		    EMod (org,rev) -> replace_bindingL lname rev rho0'
		  | EDel           -> raise (Eval_Bwd "bd_bwd: deletion for label variable")
		  | EAdd           -> raise (Eval_Bwd "bd_bwd: insertion for label variable"))
	  | None -> rho0')) freeLVars rho' in
      let rho' = 
        SetofVname.fold (fun vname rho0' ->
	  dprintf "Checking free graph variable %s@." vname;
          let graph = lookupVar      rho'         vname in
	  let ecmap = lookupGVar_aux maexpr.ecenv vname in
	  (* Iterate over operations on affected part of the graph.
	     editop_map : source edge -> edit operation
             ecmap      : current edge -> Some (source edge) | None *)
          let ecmap_inv = invert_MapofEdgeToEdgeOpt ecmap in
	  (* ecmap_inv maps source edge to set of affected copies in the view. *)
          (* Intersections of the domains of ecmap_inv and editop_map 
             indicates the edit should be reflected to the target set of 
             edges mapped by ecmap_inv *)
	  let overlapS = SetofEdge.inter 
	      (MapofEdge.collect_key (module SetofEdge : Set.S with 
				      type elt = edge and type t =SetofEdge.t) ecmap_inv)
	      (MapofEdge.collect_key (module SetofEdge : Set.S with 
				      type elt = edge and type t =SetofEdge.t) !editop_map) in
	  SetofEdge.fold (fun edge rho00' ->
	    let view_edgeS = MapofEdge.find edge ecmap_inv in
	    let operation  = MapofEdge.find edge !editop_map in
	    match operation with
	      EMod (org,rev) ->
		(* apply the same modification for set of view edges *)
		dprintf "Apply %a to edges %a in the view@." pp_editop operation (SetofEdge.pp_t "" PrintDot.pp_edge) view_edgeS;
		let inserted_view_edgeS =
		  SetofEdge.map (fun (u,l,v) -> (u,rev,v)) view_edgeS in
		let graph' = {graph with
			      e = SetofEdge.union inserted_view_edgeS 
				(SetofEdge.diff graph.e view_edgeS)} in
		replace_bindingG vname graph' rho00'
	    | EDel -> (* FIXME: can we simply reflect deletion to deletion?  *)
		let graph' = SetofEdge.fold (fun edge graph0 ->
		  remove_edge graph0 edge) view_edgeS graph in
		replace_bindingG vname graph' rho00'
	    | EAdd -> (* FIXME: we would like to deal with lightweight insertion  *)
		raise (Eval_Bwd "bd_bwd: insertion for graphl variable")
                         ) overlapS rho0'
			      ) freeGVars rho'
      in
      let flag' = eval_Bexp rho' tecond (* check for branching *) in
      if flag = flag' then rho'
      else (* branching behavior changed *)
	(Printf.fprintf stdout  "be_bwd: branch behavior changed \n%!";
	 raise (Eval_Bwd "bd_bwd: branch behavior changed.");
	if ((flag = true) && (flag' = false)) then
	  let _ = Printf.fprintf stdout  "be_bwd: trying false branch \n%!" in
	  (* FIXME: ecenv should reflect the user's update intention *)
	  let xg = eval_fwd maexpr.ecenv rho' tef in
	  bd_bwd rho' xg g'
	else (*  ((flag = false) && (flag' = true)) *)
	  let _ = Printf.fprintf stdout  "be_bwd: trying true branch \n%!" in
	  (* FIXME: ecenv should reflect the user's update intention *)
	  let xg = eval_fwd maexpr.ecenv rho' tet in
	  bd_bwd rho' xg g')
  | DAELet (v,gbin,gbod) ->
      let rho1' = bd_bwd (intern_gv v gbin.graph rho ) gbod g' in
      let rho'  = bd_bwd rho gbin (lookupVar rho1' v) in
      let rho1' = unintern_gv v rho1' in
      uplus_cmp rho1' rho' rho
  | DAELLet (v,llbin,gbod) ->
      let rho1' = bd_bwd (intern_lv v llbin.allit rho) gbod g' in
      let rho'  = bd_bwdL rho llbin (lookupLVar rho1' v) in
      let rho1' = unintern_lv v rho1' in
      uplus_cmp rho1' rho' rho
  | DAERec (l,t,mbody,hub,spoke,s1s1eps,garg,cmpl) ->
      let g' = if !saUnreach then evalg_simple_union g' cmpl else g' in
      bd_bwd_AERec maexpr.taexpr.expid rho l t mbody hub spoke s1s1eps garg g'
and bd_bwd_AERec (eid:expid) (rho:dynenv) (l:lname) (t:vname)
     (mbody:('a maexpr) MapofEdge.t) (hub:SetofVtx.t) (spoke:SetofEdge.t) (s1s1eps:SetofEdge.t)
     (garg:'a maexpr) (g':graph) : dynenv =
     
  (************ (4)' decompose g' according to mbody **************)
  let pmbody = MapofEdge.map (fun xg -> xg.graph) mbody in
  let mapE' = decompose_AERec eid pmbody hub spoke s1s1eps g' in

  (******** (3)' recursively evaluate the body backwards **********)
  let lookupMEbody u a v = try (MapofEdge.find (u,a,v) mbody) with
    Not_found -> failwith ("lookupMEbody(bd_bwd_AERec): not found.") in
  (* backward transformation along non-epsilon edges *)
  let mapRho' = 
    MapofEdge.fold 
      (fun (u,a,v) gi' m ->
	if (a <> ALEps) then
	  MapofEdge.add (u,a,v)
	    (let dv     = make_dv garg.graph v in
             let ex_rho = intern_gv t dv (intern_lv l a rho) in
	     bd_bwd ex_rho (lookupMEbody u a v) gi') m
	else m) mapE' MapofEdge.empty in

  (******** (2)' compose the modified input of the body ************)
  let d' = restore_input_AERec l t mapRho' garg.graph g' in

  (******** (1)' backwared evaluation of the argument **************)
  let rho'' = bd_bwd rho garg d' in

  (******** (0)' merge rho'', rho and each member of mapRho' *******) 
  (* remove bindings of l and t from mapRho' entries *)
  let mapRho' = MapofEdge.map 
      (fun env -> unintern_gv t (unintern_lv l env)) mapRho' in
  (* merge rho and each member of mapRho' *)
  let mgrho'' = biguplus_cmp mapRho' rho in
  (* merge mgrho'' and rho'' *)
  uplus_cmp mgrho'' rho'' rho 
  
and bd_bwdL (rho:dynenv) (malpat:('a malpat)) (l':allit)  : dynenv =
  match malpat.dalpat with
    DALLit x ->
    let l = malpat.allit in if l' = l then  rho 
      else begin
	let (lStr,lStr') = mapT2 allit2str (l,l') in
	let msg = "bd_bwdL: constant label " ^ lStr ^ " changed to " ^ lStr' in
	Format.fprintf Format.err_formatter "%s@." msg;
	raise (Eval_Bwd "bd_bwdL: no modifications allowed for label literals.")
      end 
  | DALVar n -> replace_bindingL n l' rho
  | DALBin (l1,op,l2) -> 
      let (lit1 ,lit2 ) = (l1.allit,l2.allit) in
      let (lit1',lit2') = decompose_ALBin op lit1 lit2 malpat.allit l' in
      let rho1' = bd_bwdL rho l1 lit1' in
      let rho2' = bd_bwdL rho l2 lit2' in
      uplus_cmp rho1' rho2' rho


(* Redefine the main function with identical name, and takes
   care of the global reference of the update operation with
   respect to equivalence class for branching behavior change detection. *)
let bd_bwd (rho:dynenv) (maexpr: 'a maexpr) (g':graph)  : dynenv =
  let ecmap = maexpr.ecmap in
  let _ = dprintf "ecmap=%a@." pp_MapofEdgeToEdgeOpt ecmap in
  let g = maexpr.graph in
  let (_,gAdd_v,gDel_v,eSadd,eSdel,eSmod,eSmod_alist) = graph_diff_aux g g' in
  let editop_map_mod =
    List.fold_right (fun (eAdd,eDel) ->
      let (_,oldlabel,_) = eDel in
      let (_,newlabel,_) = eAdd in
      MapofEdge.add eDel (EMod (oldlabel,newlabel)))
      eSmod_alist MapofEdge.empty in
  let editop_map_del = edgeSet2Map (fun _ -> EDel) eSdel in
  let editop_map_aux = MapofEdge.union (=) editop_map_mod editop_map_del in
  let _ = dprintf "editop_map_aux=%a@." pp_MapofEdgeToeditop editop_map_aux in
  (* create map from equivalence class to its operation *)
  let editop_map_new = 
    ( dprintf "updating editop_map@.";
    (MapofEdge.fold (fun edge ent editop_map0 ->
        (dprintf "looking for edge=%a@." PrintDot.pp_edge edge);
       (match (MapofEdge.find edge ecmap) with
	 Some srcedge ->
	   let _ = dprintf  "srcedge hit =%a@." PrintDot.pp_edge srcedge in
	   if MapofEdge.mem srcedge editop_map0 then
	     let ent' = MapofEdge.find srcedge editop_map0 in
	     if ent = ent' then editop_map0
	     else raise (Eval_Bwd (Printf.sprintf "Edit on source edge %s conflictts: %s and %s." 
		      (Print.string_of PrintDot.pp_edge srcedge)
		      (Print.string_of pp_editop ent) (Print.string_of pp_editop ent')))
	   else MapofEdge.add srcedge ent editop_map0
       | None         -> 
	   dprintf  "srcedge NOT hit \n%!";
	   editop_map0)   ) editop_map_aux MapofEdge.empty)) in
  editop_map := editop_map_new;
  let _ = dprintf "!editop_map=%a@." pp_MapofEdgeToeditop !editop_map in
  bd_bwd rho maexpr g'
  

(********************************************************************

	      closure based bidirectional implementation

 Don't rely on extended AST. To host backward evaluator in a separate
 command, closure should be marshaled. However, OCaml doesn't support
 persistent closure since Marshal library doesn't support unmarshaling
 of closure made in different process.
 ********************************************************************)
(* FIXME: equivalence class based branching behavior detection is not supported *)

let rec bd_eval (rho:dynenv) (taexpr:('a taexpr)) : (graph * (graph -> dynenv)) =
  let eid = if !skolemBulk then Some taexpr.expid else None in
  match taexpr.saexpr with
    SAETEmp ->
      let g = (!<>) ?expid:eid () in
      (g, fun g' ->
	if g = g' then rho 
	else raise (Eval_Bwd "bd_eval: no modifications allowed for empty trees."))
  | SAEGEmp -> 
      let g = emptyGraph in
      (g, fun g' ->
	if g = g' then rho
	else raise (Eval_Bwd "bd_eval: no modifications allowed for empty graphs."))
  | SAEOMrk m -> 
      let g = (!&) ?expid:eid m in
      (g, fun g' ->
	if  g = g' then rho
	else raise (Eval_Bwd "bd_eval: no modifications allowed for output nodes."))
  | SAEEdg (lpat,expr) ->
      let (l,bfL) = bd_evalL rho lpat in
      let (t,bf)  = bd_eval  rho expr in
      let g = (/:) ?expid:eid l t in
      (g, fun g' ->
	let (l',t') = decompose_AEEdg l t g g' in
	uplus_cmp (bfL l') (bf t') rho)
  | SAEVar v ->
      let g = lookupVar rho v in
      (g, fun g' -> replace_bindingG v g' rho)
  | SAEApnd (e1,e2) ->
      let (g1,bf1) = bd_eval rho e1 in
      let (g2,bf2) = bd_eval rho e2 in
      let g = (@&) ~expid:taexpr.expid g1 g2 in
      (g, fun g' ->
	let (g1',g2') = decompose_AEApnd taexpr.expid g1 g2 g g' in
	uplus_cmp (bf1 g1') (bf2 g2') rho)
  | SAECyc e ->
      let (g0,bf0) = bd_eval rho e in
      let g = (!!<>) ?expid:eid g0 in
      (g, fun g' -> 
	let g0' = decompose_AECyc g0 g g' in bf0 g0')
  | SAEUni (e1,e2) ->
      let (g1,bf1) = bd_eval rho e1 in
      let (g2,bf2) = bd_eval rho e2 in 
      let g = (+|) ?expid:eid g1  g2 in
      (g, fun g' ->
	let (g1',g2') = decompose_AEUni g1 g2 g g' in
	uplus_cmp (bf1 g1') (bf2 g2') rho)
  | SAEDUni (e1,e2) ->
      let (g1,bf1) = bd_eval rho e1 in
      let (g2,bf2) = bd_eval rho e2 in 
      let g = g1 |++ g2 in
      (g, fun g' ->
	let (g1',g2') = decompose_AEDUni g1 g2 g g' in
	uplus_cmp (bf1 g1') (bf2 g2') rho)
  | SAEIMrk (m,expr) ->
      let (g1,bf1) = bd_eval rho expr in
      let g = (m ^:= g1) in
      (g, fun g' ->
	let g1' = decompose_AEIMrk m g1 g g' in	bf1 g1')
  | SAEIf  (be,et,ef) ->
      let flag = eval_Bexp rho be in (* normal forward evaluation *)
      let (g,bf) = bd_eval rho (if flag then et else ef) in
      (g, fun g' ->
	let rho'  = bf g' in
	let flag' = eval_Bexp rho' be (* check for branching *) in
	if flag = flag' then rho'
	else (* branching behavior changed *)
	  (Printf.fprintf stdout  "bd_eval(if): branch behavior changed \n%!";
	   if ((flag = true) && (flag' = false)) then
	     let _ = Printf.fprintf stdout  "bd_eval(if): trying false branch \n%!" in
	     let (_,bf) = bd_eval rho' ef in bf g'
	   else (*  ((flag = false) && (flag' = true)) *)
	     let _ = Printf.fprintf stdout  "bd_eval(if): trying true branch \n%!" in
	     let (_,bf) = bd_eval rho' et in bf g'))
  | SAELet (v,ebind,ebody) ->
      let (gbin,bfbin) = bd_eval rho ebind in
      let (gbod,bfbod) = bd_eval (intern_gv v gbin rho) ebody in
      (gbod, fun g' ->
	let rho1' = bfbod g' in
	let rho'  = bfbin (lookupVar rho1' v) in
	let rho1' = unintern_gv v rho1' in
      uplus_cmp rho1' rho' rho)
  | SAELLet (v,lbind,ebody) ->
      let (llbin,bfL) = bd_evalL rho lbind in
      let (gbod,bf)   = bd_eval (intern_lv v llbin rho) ebody in
      (gbod, fun g' ->
	let rho1' = bf g' in
	let rho'  = bfL (lookupLVar rho1' v) in
	let rho1' = unintern_lv v rho1' in
	uplus_cmp rho1' rho' rho)
  | SAERec (l,t,ebody,earg) ->
      (********** (1) forwared evaluation of the argument **************)
      let (d,bfa) = bd_eval rho earg in

      (*** (2),(3) generate bindings and compute the body recursively **)
      let (iS,oS) = ebody.vtype in
      let setZ = SetofMarker.union iS oS in 
      let (outgoEdgeS_d,incomEdgeS_d,_,_) = build_ioedge_ionode_map d in
      let (epsEdgS,nonEpsEdgS) = SetofEdge.partition isEpsEdge d.e in
      let ebodyEps = ebodyEpsExpr setZ in
      let mapE =
	(SetofEdge.fold (fun (u,a,v) mE ->
	  if MapofEdge.mem (u,a,v) mE then mE else 
	  MapofEdge.add (u,a,v)
	    (* if a = ALEps then bd_eval_top rho ebodyEps else *)
	      (let dv   = make_dv_with_oEmap outgoEdgeS_d d v in
	       let rho1 = intern_gv t dv (intern_lv l a rho)  in
	      bd_eval rho1 ebody)
	      mE) nonEpsEdgS MapofEdge.empty) in
      let pmapE = MapofEdge.map (fun (gi,_) -> gi) mapE in

      (************** (4) compose g according to mapE *****************)
      let (g,hubV,spokeEps,s1s1Eps) = dfwd_AERec taexpr.expid
	  setZ (epsEdgS,nonEpsEdgS) pmapE incomEdgeS_d outgoEdgeS_d d in
      let (g,cmpl) = if !saUnreach then split_reachableGI g else (g,emptyGraph) in
      (g,fun g' ->
	let g' = if !saUnreach then evalg_simple_union g' cmpl else g' in
	(************ (4)' decompose g' according to mbody **************)
	let mapE' = decompose_AERec taexpr.expid pmapE hubV spokeEps s1s1Eps g' in

	(******** (3)' recursively evaluate the body backwards **********)
	let lookupMEbody u a v = try (MapofEdge.find (u,a,v) mapE) with
	  Not_found -> failwith ("lookupMEbody(bd_eval_AERec): not found.") in
	(* backward transformation along non-epsilon edges *)
	let mapRho' = 
	  MapofEdge.fold 
	    (fun (u,a,v) gi' m ->
	      if (a <> ALEps) then
		(let (_,bfi) = (lookupMEbody u a v) in
		MapofEdge.add (u,a,v) (bfi gi')) m
	      else m) mapE' MapofEdge.empty in

	(******** (2)' compose the modified input of the body ************)
	let d' = restore_input_AERec l t mapRho' d g' in
	
	(******** (1)' backwared evaluation of the argument **************)
	let rho'' = bfa d' in

	(******** (0)' merge rho'', rho and each member of mapRho' *******) 
	(* remove bindings of l and t from mapRho' entries *)
	let mapRho' = MapofEdge.map 
	    (fun env -> unintern_gv t (unintern_lv l env)) mapRho' in
	(* merge rho and each member of mapRho' *)
	let mgrho'' = biguplus_cmp mapRho' rho in
	(* merge mgrho'' and rho'' *)
	uplus_cmp mgrho'' rho'' rho)

and bd_evalL (rho:dynenv) (talpat:('a talpat)) : (allit * (allit -> dynenv)) =
  match talpat.salpat with
    SALLit x -> 
      let l = x in
      (l, fun l' -> if l' = l then rho 
      else begin
	let (lStr,lStr') = mapT2 allit2str (l,l') in
	let msg = "bd_bwdL: constant label " ^ lStr ^ " changed to " ^ lStr' in
	Format.fprintf Format.err_formatter "%s@." msg;
	raise (Eval_Bwd "bd_evalL: no modifications allowed for label literals.")
       end)
  | SALVar n -> 
      let l = lookupLVar rho n in
      (l, fun l' -> replace_bindingL n l' rho)
  | SALBin (lpat1,op,lpat2) ->
      let ((l1,bf1),(l2,bf2)) = mapT2 (bd_evalL rho) (lpat1,lpat2) in
      let l = evall_bin l1 op l2 in
      (l, fun l' ->
	let (l1',l2') = decompose_ALBin op l1 l2 l l' in
	uplus_cmp (bf1 l1') (bf2 l2') rho)
and bd_eval_top rho aexpr =
  let stEnv = dynenv2stenv rho in
  let texpr = augType stEnv aexpr in
  let nexpr = numberE texpr in
  bd_eval rho nexpr
