(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
(********************************************************************
		an UnCAL interpreter (unidirectional)
 ********************************************************************)

open UnCAL
open PrintUnCAL
open UnCALDM
open UnCALDMutil
open UnCALSAST
open UnCALSA (* static type is required for estimating set Z in bulk semantics *)
open Fputil
open UnCALdynenv
open UnCALDMutil_scc
open Contraction

(* MEMO
   - rec function as a result of tupling has to be called in form of
   &z1@rec(\(L,T).e1)(e2) where z is a marker corresponding to the
   primary component function, i.e, for mutually recursive functions
   f1,f2, ..., fk, e1 should look like 
      if L=l1      then (&z1 := ...,&z2 := ...) 
      else if L=l2 then (&z1 := ... ))
      ...
   If user originally wanted the value of f1, then &z1@  should 
   be placed before rec invocation.

   - it may be interesting to eliminate direct occrrence of T in the 
   body of rec() using another tupling transformation using id function.
 *)

(* TODO:
   - graph serializer/loader (DONE in Dotutil)
   - primitive to apply operator on values rather than on expressions (DONE in UnCALDMutil)
     -> first bind value to special variable db by load_db and evaluate
        whatever operator on that variable reference, eg. eval_unCAL db (.. (AEVar "$db"))
   - elimination of unreachable parts from a graph (DONE in UnCALDMutil)
   - elimination of epsilon edges (DONE in UnCALDMutil)
   - rename id and nodes for 
        1. disjoint unification,  and
        2. flatten the values of Skolem functions (not required by specification) (DONE in UnCALDMutil)
   - wrap seed of id generator into environment, to produce same result under same environment.  
   - unify output nodes (for bulk semantics) (semantics is unchanged by this optimization)
   - misc operators such as isInt(), not, ... (DONE)
 *)

let useTransNodeId      = ref false (* if true, use node id based on lexical position 
                                      and recursive semantics escapes body with Skolem term S2 *)
let skolemRec           = ref true  (* if true, recursive semantics emits Skolem term Hub (S1) *)
let recShrinkBaseS1     = ref true  (* if true, recursive semantics uses minimum nodes for base_s1 *)
let evalRecRecursive    = ref false (* if true, recursive semantics is used *)
let optApndRecRecursive = ref false (* if true, @ in recursive semantics is optimized *)
let optTCRec            = ref false (* if true, make_dv in rec is optimized for both semantics *)
let pruneBulk           = ref false (* if true, non-recurseve rec exploits pruning of input graph *)
let cleanAfterBulk      = ref false (* if true, (remove_eps . reachableGI) after bulk *)

(* To make the output fully structural (and evaluation order independent), 
  set (!evalRecRecursive,!skolemRec,!recShrinkBaseS1,!useTransNodeId) 
    = (true,true,true,true) *)


(* unused *)
(* setZ in the body of rec had once been estimated at run-time, which was incorrect. *)
(* qtype in UnCALSA properly estimates it statically *)
let collect_marker_runtime nonEpsEdgS mapE =
  let lookupEbody a v = MapofEbody.find (a,v) in 
  let setZ = setmap_Edge2Marker (fun (u,a,v) ->
    (let eg =  lookupEbody a v mapE in SetofMarker.union (inputMarkers eg) (outputMarkers eg))
      ) nonEpsEdgS in
  SetofMarker.add "&" setZ

let rr x = if !cleanAfterBulk then (remove_eps (reachableGI x)) else x

let marker_mismatch e1 e2 =
  let ((_,oS),(iS,_)) = (e1.vtype,e2.vtype) in 
  SetofMarker.is_empty (SetofMarker.inter oS iS)

let skolemS2 ((u,a,v):edge) (g:graph) =
  let s2 w = S2 (u,a,v,w) in
  map_VEIO s2 g

let skolemFrE sid ((u,a,v):edge) (g:graph) =
  let frE w = FrE (w,(u,a,v),sid) in
  map_VEIO frE g

let rec eval_AEIMrk_org env m expr = (* &x := d *)
(* relabel root node with root marker *)
  let g = eval env expr in
  let (rir,ir) = SetofInodeR.partition isroot g.i in
  if ((SetofInodeR.cardinal rir) = 1) 
  then 
    let (_,root) = SetofInodeR.choose rir in
    {  g with i = SetofInodeR.add (m,root) ir;  }
  else failwith "eval_AEIMrk: Multiple or no root marker"
and eval_AEIMrkG env m expr = (* &x . d *)
(* currrent parser doesn't recognize this syntax *)
(* eval_AEIMrk generalizes to the case where expr has multiple input markers 
   so that it can implement 
       &x .(&z1 := d1, &z2 := d2, ..., &zp = dp) =def
        (&x.&z1 := d1, &x.&z2 := d2, ..., &x.&zp := dp), 
   i.e, relabel every input node &zi with &x.&zi  
   Pre-generalized semantics is the special case where expr has only one
   special input marker &, where the result input marker will be &x.& = &x
   by the property of the Skolem function on markers   *)
  let g = eval env expr in
  evalg_AEIMrkG m g

and eval_AEIMrk env  = eval_AEIMrkG env
and eval_AEVar env n = lookupVar env n
and eval_Bexp env tabexpr = match tabexpr.sabexpr with
    SAIsemp expr            -> eval_AIsemp env expr
  | SABisim (e1,e2)         -> eval_ABisim env e1     e2
  | SALcmp (lpat1,op,lpat2) -> eval_ALcmp  env lpat1 op lpat2
  | SANot   bexpr           -> eval_ANot   env bexpr
  | SAAnd  (bexpr1,bexpr2)  -> eval_AAnd   env bexpr1 bexpr2
  | SAOr   (bexpr1,bexpr2)  -> eval_AOr    env bexpr1 bexpr2
  | SATrue                  -> true
  | SAFalse                 -> false
  | SALpred (alpt,lpat)     -> eval_ALpred env alpt lpat
and eval_ANot env bexpr =
  let flag = eval_Bexp env bexpr in
  not flag
and eval_AAnd env bexpr1 bexpr2 =
  (eval_Bexp env bexpr1) && (eval_Bexp env bexpr2)
and eval_AOr env bexpr1 bexpr2 =
  (eval_Bexp env bexpr1) || (eval_Bexp env bexpr2)
(*  noemp_forest(n) = (||) {a <> ALEps || noemp_forest(v) | (u,a,v) \in E, u=n }  *)
and noemp_forest (n:vtx) (d:graph) = (* UNUSED: may infinitely loops for graph with cycles *)
  let rec nf n' =
    SetofEdge.fold (fun (u,a,v) -> (||)	((a <> ALEps) || (nf v))) (outgoEdgeS d n') false
  in nf n
and eval_AIsemp env expr = 
  let d0 = (eval env expr) in
  evalg_AIsemp d0
and eval_ABisim env e1 e2 = 
  let (d1,d2) = mapT2 (eval env) (e1,e2) in 
  evalg_ABisim d1 d2
and eval_ALeq env lpat1 lpat2 = (* DEPRECATED *)
  eval_ALcmp env lpat1 ALOEq lpat2
and eval_ALpred env alpt lpat = 
  let l = eval_L env lpat in evall_ALpred alpt l
and eval_ALcmp env lpat1 op lpat2 =
  let l1 = eval_L env lpat1 in
  let l2 = eval_L env lpat2 in
  evall_cmp l1 op l2
and eval_L env talpat = match talpat.salpat with
    SALVar n -> lookupLVar env n
  | SALLit x -> x
  | SALBin (lpat1,op,lpat2) ->
      let (l1,l2) = mapT2 (eval_L env) (lpat1,lpat2) in
      evall_bin l1 op l2
and eval_AERec sid env l t ebody earg = (* interpreted by bulk semantics *)
  let orig_d = eval env earg in
  let make_dv_orig_d = if !optTCRec then build_dvmap orig_d else
    let (outgoEdgeS_orig_d,_,_,_) = build_ioedge_ionode_map orig_d in
    (fun v -> make_dv_with_oEmap outgoEdgeS_orig_d orig_d v) in
  let (iS,oS) = ebody.vtype in   (* setZ is estimated statically *)
  let setZ = SetofMarker.union iS oS in 
  let d = if !pruneBulk && SetofMarker.is_empty oS then reachableGI1s orig_d else orig_d in
  (* epsilon and non-epsilon edges *)
  let (epsEdgS,nonEpsEdgS) = SetofEdge.partition isEpsEdge d.e in
  (* the results of e(a,d_v) are accumulated into MapofEbody for later lookup 
     to correctly rendezvous with other set comprehensions  *)
  let mapE = 
    (SetofEdge.fold (fun (u,a,v) -> MapofEbody.add (a,v)
     (let dv   = make_dv_orig_d v in
      let xenv = (intern_gv t dv (intern_lv l a env)) in
         eval xenv ebody))
     nonEpsEdgS MapofEbody.empty) in
  evalg_AERec sid setZ (epsEdgS,nonEpsEdgS) mapE d
and eval_AERec_rec sid env l t ebody earg = (* interpreted by recursive semantics *)
  let d = eval env earg in
  let (outgoEdgeS_d,_,_,_) = build_ioedge_ionode_map d in
  let make_dv_d = if !optTCRec then build_dvmap d else
    (fun vi -> make_dv_with_oEmap outgoEdgeS_d d vi) in
  let visited = ref MapofVtx.empty in
  let setX = inputMarkers d in
  let (setZi,setZo) = ebody.vtype in
  let setZ = if !leaveOMrkApnd then
    setZi
  else SetofMarker.union setZi setZo in
(* let md_alist = SetofMarker.fold 
      (fun m -> cons (m, (make_dv d (lookupI d m)))) setX [] in*)
(*  let mapIM = SetofMarker.fold 
      (fun m -> MapofMarker.add m (make_dv d (lookupI d m))) setX MapofMarker.empty in *)
  let base_s1_expr () =  (* excess node construction *)
    maps_Marker2DUni (fun z -> evalg_AEIMrkG z (evalg_AETEmp ())) setZ in
  let rMapV = ref MapofVtx.empty in
  let omark_s1_expr omS = (* excess node construction *)
    maps_Marker2DUni (fun z -> evalg_AEIMrkG z 
		      (SetofMarker.fold (fun y ->
			evalg_AEUni 
			  (evalg_AEOMrk (y &^ z))
					) omS (evalg_AETEmp ()))
		   ) setZ in
  let lookupOrRegister (sv:vtx) =
    try (MapofVtx.find sv !rMapV) with
      Not_found ->
	let nv = (newnode ()) in (* generate flat ID *)
	rMapV := MapofVtx.add sv nv !rMapV; (* register flat ID *)
	nv in 
  let s1 = if !skolemRec then
    fun (u,z) -> Hub (u,z,sid) (* S1 (u,z) *)
  else 
    fun (u,z) -> lookupOrRegister (S1 (u,z)) in
  let base_s1 (u:vtx) = 
    { v = maps_Marker2Vtx    (fun z -> s1 (u,z))      setZ;
      i = maps_Marker2InodeR (fun z -> (z, s1 (u,z))) setZ;
      e = SetofEdge.empty; o = SetofOnodeR.empty; } in
  let omark_s1 (u:vtx) omS = 
    { v = maps_Marker2Vtx    (fun z ->  s1 (u,z))     setZ;
      i = maps_Marker2InodeR (fun z -> (z, s1 (u,z))) setZ;
      e = SetofEdge.empty; 
      o = setmap_Marker2OnodeR (fun z -> 
           maps_Marker2OnodeR (fun y -> (s1 (u,z), (y &^ z))) omS) setZ ; } in
  let (base_s1,omark_s1) = 
    if  ! recShrinkBaseS1 then (base_s1,omark_s1) else 
    ((fun v -> base_s1_expr ()),(fun v -> omark_s1_expr)) in
  let rec r (u:vtx) : graph = 
    let oeS = outgoEdgeS_d u in
    if SetofEdge.is_empty oeS then 
      let (_,omS) = markersV d u in
      if SetofMarker.is_empty omS then  (* case u of {} *)
	base_s1 u
      else  (* case u of &y1 U &y2 U ...  *)
        omark_s1 u omS
    else (* case u of {a_1:v_1, ..., a_n:v_n} *) 
      try !(MapofVtx.find u !visited) with
	Not_found -> 
	  let s1 = ref (base_s1 u) in
	  visited := (MapofVtx.add u s1 !visited);
	  SetofEdge.iter (fun (_,a,vi) ->
	    if (a = ALEps) then s1 := !s1 +|< (r vi)
	    else s1 := !s1 +|<
		(let dv      = make_dv_d vi in
		 let env'    = intern_gv t dv (intern_lv l a  env)  in
		 let e_a_dvi = eval env' ebody in
		 let e_a_dvi = if !useTransNodeId then (* skolemS2 *) skolemFrE sid (u,a,vi) e_a_dvi else e_a_dvi in
                 if !optApndRecRecursive && SetofOnodeR.is_empty e_a_dvi.o then e_a_dvi 
		 else e_a_dvi @&& (r vi)
		)) oeS;
	  !s1
  in 
     maps_Marker2DUni (fun x ->
         (let rdi = r (lookupI d x) in
         maps_Marker2DUni (fun z -> 
	     (evalg_AEIMrkG (x &^ z) (make_dv rdi (lookupI rdi z))))
	   setZ)) setX
and eval_AELet env v ebind ebody =
  let d = eval env ebind in 
  eval (intern_gv v d env) ebody
and eval_AELLet env l lpat ebody = 
  let lv = eval_L env lpat in
  eval (intern_lv l lv env) ebody
and eval env te = 
  let i = if !useTransNodeId then Some te.expid else None in
match te.saexpr with
  SAEGEmp         ->                                                     emptyGraph
| SAETEmp         ->                                                     (!<>) ?expid:i ()
| SAEOMrk  m      ->                                                     (!&)  ?expid:i m
| SAEIMrk (m,e)   -> let g       =                   eval env      e  in (^:=)          m  g
| SAECyc  e       -> let g       =                   eval env      e  in (!!<>)?expid:i    g
| SAEEdg  (lp,e)  -> let (p,g)   = cross (eval_L env,eval env) (lp,e) in (/:)  ?expid:i p  g
| SAEUni  (e1,e2) -> let (g1,g2) = mapT2            (eval env) (e1,e2)in (+|)  ?expid:i g1 g2
| SAEDUni (e1,e2) -> let (g1,g2) = mapT2            (eval env) (e1,e2)in (|++)          g1 g2
| SAEApnd (e1,e2) -> if !optApndRecRecursive && (marker_mismatch e1 e2)  
        then                                     eval                    env     e1
	else         let (g1,g2) = mapT2            (eval env) (e1,e2)in (@&)  ?expid:i g1 g2
| SAEVar n                 ->                    eval_AEVar              env n
| SAELet (v,ebind,ebody)   ->                    eval_AELet              env v   ebind ebody
| SAELLet (l,lpat,ebody)   ->                    eval_AELLet             env l   lpat  ebody
| SAERec  (l,t,ebody,earg) -> if !evalRecRecursive 
                                        then     eval_AERec_rec te.expid env l t ebody earg
                                    	else rr (eval_AERec     te.expid env l t ebody earg)
| SAEIf  (be,et,ef)        -> let flag = eval_Bexp env be in 
                              if flag   then     eval                    env     et
                                        else     eval                    env     ef

let dynenv2stenv (de:dynenv) : stenv =
  { gvartype = List.fold_right 
	(fun (v,g) -> cons (v,(inputMarkers g,outputMarkers g))) de.gvenv [];
    lvartype= List.fold_right 
	(fun (l,a) -> cons (l,(qtype_lpat emptyEnv (ALLit (None,a)) ))) de.lvenv [];}

let load_db expr =
  let emptyStEnv = dynenv2stenv emptyDynEnv in
  let expr = augType emptyStEnv expr in
  let nexpr = numberE expr in
  eval emptyDynEnv nexpr

let eval_with_env (env:dynenv) (expr: 'a option aexpr) = 
  let stEnv = dynenv2stenv env  in
  let expr = augType stEnv expr in
  let nexpr = numberE expr in
  eval env nexpr

let eval_L_with_env (env:dynenv) (lexpr: 'a alpat) = 
  let stEnv = dynenv2stenv env in
  let lexpr = augTypeL stEnv lexpr in
  eval_L env lexpr

let eval_unCAL db (expr: 'a aexpr) = 
  let env = (intern_gv "$db" db emptyDynEnv) in
  eval_with_env env expr


(* preliminaries for set comprehension in bulk semantics:
   how to convert set comprehension in the paper into nested 'fold's *)
(* set to set monoid homomorphism: basics
   - sru (structural recursion on union) style
   (U,sng,{}) -> (U,sng,{})
    H f (x U y) = (H f x) U (H f y)
    H f (sng x) = sng (f x)
    H f {}      = {}
    (x U y) U z = x U (y U z) {associative}
    x U y = y U x  {commutative},  x U x = x {idempotent}
    {} U x = x, x U {} = x {left & right unit}
   - sri (structural recursion on insertion) style
   (Ins, {}) -> (Ins, {})
    G f {}          = {}
    G f (Ins x, xs) = Ins (f x,G f xs)
    Ins x (Ins y z) = Ins y (Ins x z) {order indifference}
*)
(* converting set comprehension to (nested) homomorphism:
   f : a -> b, S : set of a 
   {f(x) | x \in S} => Set.fold (fun x y -> Set.add f(x) y) S

# SetofInt.elements (SetofInt.fold (fun x y -> SetofInt.add (1 + x) y) sx SetofInt.empty);;
- : SetofInt.elt list = [2; 3; 4]
# SetofInt.elements sx;;
- : SetofInt.elt list = [1; 2; 3]
# 
  predicate in quantifier is converted to filter
  {x | pred(x), x \in S } => Set.filter pred S

# SetofInt.elements (SetofInt.filter (fun x -> x > 2) sx);;
- : SetofInt.elt list = [3]
# 

*)

(* symbol generation *)
module type GENSYM = 
  sig 
    val reset : unit -> unit
    val next : string -> string
end

module Gensym : GENSYM = 
  struct
    let c = ref 0
    let reset () = c:=0
    let next s = incr c ; s ^ (string_of_int !c)
  end
(* usage: p415 of O'reilly book *)
(* Gensym.reset() 
   Gensym.next "T"
*)
(* may be used for generating markers *)
(* node IDs should be unique *)
(* to make use of standard Set library, 
   node id should be ordered  *)

let genMarker () : marker =
  Gensym.next "&z"
