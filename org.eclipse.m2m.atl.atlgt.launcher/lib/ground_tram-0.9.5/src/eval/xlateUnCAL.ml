(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
(* translator from unCAL to OCaml funciton taking dynamic environment and
   returns a graph *)

open UnCAL
open UnCALSAST
open UnCALSA
open UnCALDM
open UnCALDMutil
open Fputil
open EvalUnCAL
open UnCALdynenv
open Contraction


let rec xlate te = match te.saexpr with
  SAETEmp   -> (fun env -> evalg_AETEmp ())
| SAEGEmp   -> (fun env -> emptyGraph)
| SAEOMrk m -> (fun env -> evalg_AEOMrk m)
| SAEEdg (lpat,expr) -> 
    let (fp,fg) = cross (xlate_L,xlate) (lpat,expr) in
    (fun env -> evalg_AEEdg (fp env) (fg env))
| SAEIMrk (m,expr) -> 
    let f = xlate expr in
    (fun env -> evalg_AEIMrkG m (f env))
| SAEVar n -> (fun env -> lookupVar env n)
| SAEUni (e1,e2) -> 
    let (fg1,fg2) = mapT2 xlate (e1,e2) in 
    (fun env -> evalg_AEUni (fg1 env) (fg2 env))
| SAEDUni (e1,e2) -> 
    let (fg1,fg2) = mapT2 xlate (e1,e2) in 
    (fun env -> evalg_AEDUni (fg1 env) (fg2 env))
| SAEApnd (e1,e2) -> 
    let (fg1,fg2) = mapT2 xlate (e1,e2) in 
    (fun env -> evalg_AEApnd (fg1 env) (fg2 env))
| SAECyc e -> 
	let fg = xlate e in (fun env -> evalg_AECyc (fg env))
| SAEIf  (be,et,ef) -> 
    let fb = xlate_Bexp be in
    let (ft,ff) = mapT2 xlate (et,ef) in
    (fun env -> if (fb env) then (ft env) else (ff env))
| SAELet (v,ebind,ebody) -> 
    let fd = xlate ebind in
    let fb = xlate ebody in
    (fun env -> fb (intern_gv v (fd env) env))
| SAELLet (l,lpat,ebody) -> 
    let flv = xlate_L lpat in
    let fb  = xlate  ebody in 
    (fun env -> fb (intern_lv l (flv env) env))
| SAERec  (l,t,ebody,earg) -> 
    let fearg  = xlate earg  in
    let febody = xlate ebody in
    let (iS,oS) = ebody.vtype in
    let setZ = SetofMarker.union iS oS in 
    (fun env ->
      let d = fearg env in
      let (epsEdgS,nonEpsEdgS) = SetofEdge.partition isEpsEdge d.e in
      let mapE =
	(SetofEdge.fold (fun (u,a,v) -> MapofEbody.add (a,v)
	    (let eg = febody (intern_gv t (make_dv d v) (intern_lv l a env)) in
	    eg))
	   nonEpsEdgS MapofEbody.empty) in
      evalg_AERec te.expid setZ (epsEdgS,nonEpsEdgS) mapE d)
and xlate_L talpat = match talpat.salpat with
    SALVar n -> (fun env -> lookupLVar env n)
  | SALLit x -> (fun env -> x)
  | SALBin (lpat1,op,lpat2) -> 
      let (fl1,fl2) = mapT2 xlate_L (lpat1,lpat2) in
      (fun env -> evall_bin (fl1 env) op (fl2 env))
and xlate_Bexp tabexpr = match tabexpr.sabexpr with
  SAIsemp expr            -> 
    let fd0 = xlate expr in (fun env -> evalg_AIsemp (fd0 env))
| SABisim (e1,e2) -> 
    let (fg1,fg2) = mapT2 xlate (e1,e2) in 
    (fun env -> evalg_ABisim (fg1 env) (fg2 env))
| SALcmp (lpat1,op,lpat2) -> 
    let fl1 = xlate_L lpat1 in
    let fl2 = xlate_L lpat2 in
    (fun env -> evall_cmp (fl1 env) op (fl2 env))
  | SANot   bexpr           -> 
      let fflag = xlate_Bexp bexpr in
      (fun env -> not (fflag env))
  | SAAnd  (bexpr1,bexpr2)  -> 
      let (f1,f2) = mapT2 xlate_Bexp (bexpr1,bexpr2) in
      (fun env -> (f1 env) && (f2 env))
  | SAOr   (bexpr1,bexpr2)  -> 
      let (f1,f2) = mapT2 xlate_Bexp (bexpr1,bexpr2) in
      (fun env -> (f1 env) || (f2 env))
  | SATrue                  -> (fun env -> true)
  | SAFalse                 -> (fun env -> false)
  | SALpred (alpt,lpat)     -> 
      let fl = xlate_L lpat in
      (fun env -> evall_ALpred alpt  (fl env))
let xlate_with_env (env:dynenv) (expr: 'a aexpr) =
  let stEnv = dynenv2stenv env in
  let expr = augType stEnv expr in
  let nexpr = numberE expr in
  xlate nexpr

let xlate_L_with_env (env:dynenv) (lexpr: 'a alpat) = 
  let stEnv = dynenv2stenv env in
  let lexpr = augTypeL stEnv lexpr in
  xlate_L lexpr

let xlate_unCAL db (expr: 'a aexpr) =
  let env = (intern_gv "$db" db emptyDynEnv) in
  xlate_with_env env expr

let xeval_unCAL db expr = 
  let f = (xlate_unCAL db expr) in
  let env = (intern_gv "$db" db emptyDynEnv) in
  f env
