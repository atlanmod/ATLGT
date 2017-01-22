(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
(* Static Analysis module of UnCAL *)

open UnCAL
open PrintUnCAL
open UnCALDM
open PrintUnCALDM
open UnCALDMutil
open UnCALSAST
open Format
open Fputil

(* optimize append statically *)
let optApndStat   = ref false (* if true, rewriting for @ by marker analysis is activated *)

(* static analysis environment *)
type stenv = {
    gvartype : (vname*vtype) list;  (* symbol -> type of graph variable *) 
    lvartype : (lname*ltype) list;  (* symbol -> type of label variable *)
  }

let lookup_gvtype env n =
  let { gvartype=vl; } = env in  
  (try List.assoc n vl with 
    Not_found -> 
      failwith ("lookup_gvtype: no type info. found for variable "  ^ n))

let lookup_lvtype env n =
  let { lvartype=vl; } = env in  
  (try List.assoc n vl with 
    Not_found -> 
      failwith ("lookup_lvtype: no type info. found for label variable "  ^ n))

let intern_lvtype (l:lname) (t:ltype) (env:stenv) =
  { env with lvartype=(l,t)::env.lvartype; }

let intern_gvtype (v:vname) (t:vtype) (env:stenv) =
  { env with gvartype=(v,t)::env.gvartype;}

let emptyEnv : stenv = { gvartype = []; lvartype = []; }

(* query type of expression under static environment env *)
(* register the type of the global variable using graph instance db *)
let make_defaultEnv (db:graph) : stenv  =
  { gvartype=[("$db",(inputMarkers db,outputMarkers db))]; lvartype=[]}
(*  Caller may want to tentatively initialize type of db with ({"&"},{}) -- only 
   default input (root) marker and no output markers *)
let defaultEnv = { gvartype=[("$db",(SetofMarker.singleton "&",SetofMarker.empty))]; lvartype=[]}
(* 
   It is tempting to create default static environment in which 
   all free variables are registered. But graph type, which are 
   used in rewriting can not be of unknown type.
   So all types has to be statically known. It means that
   no stray (free) variables is allowed for the input of rewriting.
*)

let incRoot : SetofMarker.t -> bool = SetofMarker.mem "&"

let (&^^) sM1 sM2 = SetofMarker.setmap (fun m1 ->
  SetofMarker.map (fun m2 -> (m1 &^ m2)) sM2) sM1

let isEps = function
    SLEps -> true
  | _     -> false

let isUkn = function
    SLUkn -> true  (* tentative *)
  | _     -> false

let isNumeric = function
    SLLbl -> false
  | SLStr -> false
  | SLInt | SLFlt -> true
  | SLBol -> false
  | SLEps -> false
  | SLUkn -> false  (* tentative *)

let isString = function
    SLLbl -> false
  | SLStr -> true
  | SLInt | SLFlt -> false
  | SLBol -> false
  | SLEps -> false
  | SLUkn -> false (* tentative *)


(* apply function f to annotation *)
let rec map_info (f:'a -> 'b) (aexpr:('a aexpr)) :'b aexpr =
   match aexpr with
     AETEmp a    -> AETEmp (f a)
   | AEGEmp a    -> AEGEmp (f a)
   | AEVar (a,n) -> AEVar (f a,n)
   | AEDUni (a,e1,e2) -> let (e1',e2') = mapT2 (map_info f) (e1,e2)            in AEDUni (f a,e1',e2')
   | AEUni  (a,e1,e2) -> let (e1',e2') = mapT2 (map_info f) (e1,e2)            in AEUni  (f a,e1',e2')
   | AEApnd (a,e1,e2) -> let (e1',e2') = mapT2 (map_info f) (e1,e2)            in AEApnd (f a,e1',e2')
   | AEDoc (a,s) -> AEDoc(f a,s)
   | AEEdg (a,l,e)    -> let (l',e') = cross (map_infoL f, map_info f) (l,e)   in AEEdg (f a,l',e')
   | AEIMrk (a,m,e)   -> let     e'  =          map_info f    e                in AEIMrk (f a,m,e')
   | AEOMrk (a,m)     ->                                                          AEOMrk (f a,m)
   | AECyc (a,e)      -> let     e'    =        map_info f    e                in AECyc (f a,e')
   | AEIf (a,eb,et,ef)-> let  eb'      =        map_infoB f   eb in
                         let (et',ef') = mapT2 (map_info f) (et,ef)            in AEIf (f a,eb',et',ef')
   | AERec (ar,l,al,t,at,ebody,earg) ->
       let earg' = map_info f earg in
       let ebody' = map_info f ebody in
       AERec (f ar,l,f al,t,f at,ebody',earg')
  | AELet (a,vname,av,ebind,ebody) ->
      let ebind' = map_info f ebind in
      let ebody' = map_info f ebody in
      AELet (f a,vname,f av,ebind',ebody')
  | AELLet (a,lname,al,eb,ebody) ->
      let eb' =  map_infoL f eb in
      let ebody' = map_info f ebody in
      AELLet (f a,lname,f al,eb',ebody')
and map_infoB (f:'a -> 'b) (abexpr: 'a abexpr) : 'b abexpr = 
    match abexpr with
      AIsemp (a,e)       -> let e'         =       map_info f e           in AIsemp (f a,e')
    | ABisim (a,e1,e2)   -> let (e1',e2') = mapT2 (map_info f) (e1,e2 )   in ABisim (f a,e1',e2')
    | ALcmp (a,p1,op,p2) -> let (p1',p2')  =mapT2 (map_infoL f) (p1,p2)   in ALcmp (f a,p1',op,p2')
    | ANot (a,be)        -> let be'        =        map_infoB f  be       in ANot (f a,be')
    | AAnd (a,be1,be2)   -> let (be1',be2')=mapT2 (map_infoB f) (be1,be2) in AAnd (f a,be1',be2')
    | AOr  (a,be1,be2)   -> let (be1',be2')=mapT2 (map_infoB f) (be1,be2) in AOr (f a,be1',be2')
    | ATrue a            ->                                                  ATrue (f a)
    | AFalse a           ->                                                  AFalse (f a)
    | ALpred (a,alpt,p)  -> let p'         =       map_infoL f   p        in ALpred (f a,alpt,p')
and map_infoL (f:'a -> 'b) (l:('a alpat)) : 'b alpat =
   match l with
     ALVar (a,n)          ->                                                  ALVar (f a,n)
   | ALLit (a,lit)        ->                                                  ALLit (f a,lit)
   | ALBin (a,lp1,op,lp2) -> let (lp1',lp2')=mapT2 (map_infoL f) (lp1,lp2) in ALBin (f a,lp1',op,lp2')

let rec qtype env = function
    AETEmp _  -> (SetofMarker.singleton "&",SetofMarker.empty)
  | AEGEmp _  -> (SetofMarker.empty,SetofMarker.empty)
  | AEVar (_,n) -> lookup_gvtype env n
  | AEDoc (_,s) -> failwith "qtype: remove AEDoc with elimDoc"
  | AEEdg (_,_,e) ->
      let (sI,sO) = qtype env e in
      if (incRoot sI) then (sI, sO)
      else failwith "qtype: AEEdg operand has no root marker"
  | AEIMrk (_,m,e) -> qtype_AEIMrkG env m e
  | AEOMrk (_,m) -> (SetofMarker.singleton "&", SetofMarker.singleton m)
  | AEUni (_,e1,e2) ->
      let ((sI1,sO1),(sI2,sO2)) = mapT2 (qtype env) (e1,e2) in
      if (SetofMarker.equal sI1 sI2) then (sI1, SetofMarker.union sO1 sO2)
      else failwith ("qtype: AEUni operands have different set of input markers: "
		     ^ (toStr pr_SetofMarker sI1) ^ " and " ^ (toStr pr_SetofMarker sI2))
  | AEDUni (_,e1,e2)  ->
      let ((sI1,sO1),(sI2,sO2)) = mapT2 (qtype env) (e1,e2) in
      let unionsI = (SetofMarker.inter sI1 sI2) in
      if (SetofMarker.is_empty unionsI) 
      then (SetofMarker.union sI1 sI2, SetofMarker.union sO1 sO2)
      else failwith ("qtype: AEDUni operands have duplicate set of input markers: "
		     ^ (toStr pr_SetofMarker unionsI))
  | AEIf (_,_,et,ef) ->
      let ((sIt,sOt),(sIf,sOf)) = mapT2 (qtype env) (et,ef) in
      if (SetofMarker.equal sIt sIf) then (sIt, SetofMarker.union sOt sOf)
      else failwith ("qtype: AEIf operands have different set of input markers: "
		     ^ (toStr pr_SetofMarker sIt) ^ " and " ^ (toStr pr_SetofMarker sIf))
  | AERec (_,l,_,t,_,ebody,earg) ->
      let (setX,setY) = qtype env earg in
      let env' = intern_lvtype l SLUkn env in
      let env' = intern_gvtype t (SetofMarker.singleton "&",setY) env' in
      let (setZi,setZo) = qtype env' ebody in
      let setZ = SetofMarker.union setZi setZo in
      (setX &^^ setZ, setY &^^ setZ)
  | AELet (_,vname,_,ebind,ebody) ->
      let tbind = qtype env ebind in 
      qtype (intern_gvtype vname tbind env) ebody
  | AELLet (_,lname,_,eb,ebody) ->
      let teb = qtype_lpat env eb in
      let env' = intern_lvtype lname teb env in
      qtype env' ebody
  | AEApnd (_,e1,e2) ->
      let ((sI1,_),(_,sO2)) = mapT2 (qtype env) (e1,e2) in (sI1, sO2)
  | AECyc (_,e) ->
      let (sI,sO) = qtype env e in
      let interM  = SetofMarker.inter sI sO in
      ((if !cycleSemanticsOriginal 
        then sI
         else
         SetofMarker.diff sI interM)
	 ,  SetofMarker.diff sO interM)
and qtype_AEIMrk_org env m e = (* DEPRECATED: It is no longer maintained. *)
  let (sI,sO) = qtype env e in
  if (incRoot sI) then (SetofMarker.add m (SetofMarker.remove "&" sI), sO)
  else failwith "qtype: AEIMrk operand has no root marker"
and qtype_AEIMrkG env m e =
  let (sI,sO) = qtype env e in
  if SetofMarker.is_empty sI then failwith "qtype: AEIMrkG operand has no input marker" (* FIXME: nothing wrong with empty sI *)
  else ((SetofMarker.singleton m) &^^  sI, sO)
and qtype_lpat env = function
    ALVar (_,n) -> lookup_lvtype env n
  | ALLit (_,lit) -> (match lit with 
      ALLbl _ -> SLLbl
    | ALStr _ -> SLStr 
    | ALInt _ -> SLInt
    | ALFlt _ -> SLFlt
    | ALBol _ -> SLBol
    | ALUkn   -> SLUkn
    | ALEps   -> SLEps)
  | ALBin (_,l1,op,l2) -> 
      let (t1,t2) = mapT2 (qtype_lpat env) (l1,l2) in
      match op with
	ALAdd | ALSub | ALMul | ALDiv | ALMod -> 
          (match (t1,t2) with
	    (SLUkn,SLUkn) -> SLUkn  (* there's no way to represent numeric type in general *)
	  | (SLEps,_    ) | (_, SLEps) -> failwith "qtype_lpat: non-numeric type operand"
	  | (SLUkn,t) |(t,SLUkn) -> if  (isNumeric t) then t else failwith "qtype_lpat: non-numeric type operand"
          | (_ ,_ )  -> if (t1 = t2) then t1 else failwith "qtype_lpat: numeric operand type mismatch")
      | ALConc ->
          match (t1,t2) with
	    (SLUkn,SLUkn) -> SLStr 
	  | (SLEps,_    ) | (_, SLEps) -> failwith "qtype_lpat: non-string type operand"
	  | (SLUkn,t) |(t,SLUkn) -> if  (isString t) then t else failwith "qtype_lpat: non-string type operand"
          | (_ ,_ )  -> 
	      if (isString t1) && (isString t2) then t1
	      else failwith "qtype_lpat: string operand type mismatch"




(* returns a pair of set of label variables and graph variables that occur free in
   given expression e *)
let rec freeVarsE = function 
    AETEmp _
  | AEGEmp _
  | AEOMrk (_,_)
  | AEDoc  (_,_) -> (SetofLname.empty,SetofVname.empty)
  | AEVar (_,n)  -> (SetofLname.empty,SetofVname.singleton n)
  | AEEdg (_,l,e) ->
      let ((sL1,sV1),(sL2,sV2)) = cross (freeVars_lpat,freeVarsE) (l,e) in
      (SetofLname.union sL1 sL2,SetofVname.union sV1 sV2)
  | AEIMrk (_,_,e) -> freeVarsE e
  | AEUni  (_,e1,e2)
  | AEDUni (_,e1,e2)
  | AEApnd (_,e1,e2) ->
      let ((sL1,sV1),(sL2,sV2)) = mapT2 freeVarsE (e1,e2) in
      (SetofLname.union sL1 sL2,SetofVname.union sV1 sV2)
  | AEIf (_,be,et,ef) ->
      let (sLb,sVb) = freeVarsB be in
      let ((sLt,sVt),(sLf,sVf)) = mapT2 freeVarsE (et,ef) in
      (SetofLname.fromLSet [sLb;sLt;sLf],
       SetofVname.fromLSet [sVb;sVt;sVf])
  | AERec (_,l,_,t,_,ebody,earg) ->
      let ((sLbody,sVbody),(sLarg,sVarg)) = mapT2 freeVarsE (ebody,earg) in
      (SetofLname.union (SetofLname.remove l sLbody) sLarg,
       SetofVname.union (SetofVname.remove t sVbody) sVarg)
  | AELet (_,vname,_,ebind,ebody) ->
      let ((sLbind,sVbind),(sLbody,sVbody)) = mapT2 freeVarsE (ebind,ebody) in
      (SetofLname.union sLbind sLbody,
       SetofVname.union sVbind (SetofVname.remove vname sVbody))
  | AELLet (_,lname,_,eb,ebody) ->
      let (sLbind,sVbind) = freeVars_lpat eb in
      let (sLbody,sVbody) = freeVarsE ebody in
      (SetofLname.union sLbind (SetofLname.remove lname sLbody),
       SetofVname.union sVbind                          sVbody)
  | AECyc (_,e) -> freeVarsE e
and freeVars_lpat = function
    ALVar (_,ln) -> (SetofLname.singleton ln,SetofVname.empty)
  | ALLit (_,_)  -> (SetofLname.empty,       SetofVname.empty)
  | ALBin (_,p1,_,p2) -> 
      let ((sL1,sV1),(sL2,sV2)) = mapT2 freeVars_lpat (p1,p2) in
      (SetofLname.union sL1 sL2,SetofVname.union sV1 sV2)
and freeVarsB = function
    AIsemp (_,expr)  -> freeVarsE expr
  | ABisim (_,e1,e2)   ->  
      let ((sL1,sV1),(sL2,sV2)) = mapT2 freeVarsE (e1,e2) in
      (SetofLname.union sL1 sL2,SetofVname.union sV1 sV2)
  | ALcmp (_,p1,_,p2)  -> 
   let ((sL1,sV1),(sL2,sV2)) = mapT2 freeVars_lpat (p1,p2) in
   (SetofLname.union sL1 sL2,SetofVname.union sV1 sV2)
  | ANot (_,be)        -> freeVarsB be
  | AAnd (_,be1,be2)
  | AOr  (_,be1,be2)   -> 
   let ((sL1,sV1),(sL2,sV2)) = mapT2 freeVarsB (be1,be2) in
   (SetofLname.union sL1 sL2,SetofVname.union sV1 sV2)
  | ATrue _
  | AFalse _ -> (SetofLname.empty,SetofVname.empty)
  | ALpred (_,_,p) -> freeVars_lpat p



(* predicate of dependency of an input expression on variable v 
  it may be too conservative. 
  env is currently dummy, so any value can be passed.
  *)

let rec dependVarE env (vS:SetofVname.t) = function
    AETEmp _
  | AEGEmp _
  | AEOMrk (_,_)
  | AEDoc  (_,_)       -> false
  | AEEdg  (_,_,expr)
  | AEIMrk (_,_,expr)  -> dependVarE env vS expr
  | AEVar (_,n)        -> SetofVname.mem n vS
  | AEUni  (_,e1,e2) 
  | AEDUni (_,e1,e2) 
  | AEApnd (_,e1,e2)   -> (dependVarE env vS e1) || (dependVarE env vS e2)
  | AECyc (_,e)        -> (dependVarE env vS e)
  | AEIf  (_,be,et,ef) -> (dependVarB env vS be) || (dependVarE env vS et) || (dependVarE env vS ef)
  | AERec  (_,l,_,t,_,ebody,earg) ->
      (* case analysis: 
	   If earg depend on vS,
             then dependency unconditionally carries over ebody
             (because number of edges under the root of the earg determines
              the number of evaluations of ebody in any case).
           else, 
             if t is included in vS, then t should be removed from vS for the check of ebody.
           else, just check ebody with original vS.
       *)
      let dependBindP = (dependVarE env vS earg) in
      let shadowP     = (SetofVname.mem t vS) in
      (dependBindP || (dependVarE env ((if shadowP then (SetofVname.remove t) else id) vS) ebody))
  | AELet (_,v,_,ebind,ebody) ->
      (* case analysis:
	   If ebind depend on vS,
             then dependency carries over ebody via v.
             If v is included in vS, then it is shadowed, but dependency 
                still carries over ebody via v.
             else, v should be added to vS for the check of ebody
           else, 
             if v is included in vS, then v should be removed from vS for the check of ebody
           else, just check ebody with original vS 
       *)
      let dependBindP = (dependVarE env vS ebind) in
      let shadowP     = (SetofVname.mem v vS) in
      if dependBindP
      then (dependVarE env ((if shadowP then id else (SetofVname.add v)) vS)    ebody)
      else (dependVarE env ((if shadowP then (SetofVname.remove v) else id) vS) ebody)
  | AELLet (_,lv,_,lexp,ebody) -> dependVarE env vS ebody
and dependVarB env vS = function
    AIsemp (_,expr)         -> dependVarE env vS expr
  | ABisim (_,e1,e2)        ->(dependVarE env vS e1) || (dependVarE env vS e2)
  | ALcmp (_,lpat1,_,lpat2) -> false
  | ANot   (_,bexpr)        -> dependVarB env vS bexpr
  | AAnd  (_,bexpr1,bexpr2)
  | AOr   (_,bexpr1,bexpr2) -> (dependVarB env vS bexpr1) || (dependVarB env vS bexpr2)
  | ATrue _ | AFalse _      -> false
  | ALpred (_,_,_)          -> false
and dependVarLE env (lS:SetofLname.t) = function
    AETEmp _
  | AEGEmp _
  | AEOMrk (_,_)
  | AEVar  (_,_)
  | AEDoc  (_,_)        -> false
  | AEEdg (_,lpat,expr) -> (dependVarL_lpat env lS lpat) || (dependVarLE env lS expr)
  | AEIMrk (_,_,expr)
  | AECyc  (_,expr)    -> dependVarLE env lS expr
  | AEUni  (_,e1,e2)
  | AEDUni (_,e1,e2)
  | AEApnd (_,e1,e2)   -> (dependVarLE env lS e1) || (dependVarLE env lS e2)
  | AEIf  (_,be,et,ef) -> (dependVarLB env lS be) 
                      || (dependVarLE env lS et) || (dependVarLE env lS ef)
  | AERec (_,l,_,t,_,ebody,earg) ->
      (* case analysis: 
	   If earg depend on lS,
             then dependency unconditionally carries over ebody
             (because number of edges under the root of the earg determines
              the number of evaluations of ebody in any case)
           else, 
             if l is included in lS, then l should be removed from lS for the check of ebody
           else, just check ebody with original lS 
       *)
      let dependBindP = (dependVarLE env lS earg) in
      let shadowP     = (SetofLname.mem l lS) in
      (dependBindP || (dependVarLE env ((if shadowP then (SetofLname.remove l) else id) lS) ebody))
  | AELet (_,v,_,ebind,ebody) -> 
      (* case analysis: 
	   If ebind depend on lS,
             then dependency carries over ebody via v, 
             so dependency on {v} of ebody should be checked as well as dependency on lS in ebody. *)
      let dependBindP = (dependVarLE env lS ebind) in
      let dependBodyP = (dependVarLE env lS ebody) in
      if dependBindP
      then
	let dependBodyV = (dependVarE env (SetofVname.singleton v) ebody) in
	(dependBindP || dependBodyP || dependBodyV)
      else dependBindP || dependBodyP
  | AELLet (_,lv,_,lexp,ebody) -> 
      (* case analysis: 
	   If lexp depend on lS, 
             then dependency carries over ebody via lv.
             If lv is included in lS, then it is shadowed, but dependency 
                still carries over ebody via lv.
             else, lv should be added to lS for the check of ebody
           else, 
             if lv is included in lS, then lv should be removed from lS for the check of ebody
           else, just check ebody with original lS 
       *)
      let dependBindP = (dependVarL_lpat env lS lexp) in
      let shadowP     = (SetofLname.mem lv lS) in
      if dependBindP
      then (dependVarLE env ((if shadowP then id else (SetofLname.add lv)) lS)    ebody)
      else (dependVarLE env ((if shadowP then (SetofLname.remove lv) else id) lS) ebody)
and dependVarLB env lS = function
    AIsemp (_,expr)        -> dependVarLE env lS expr
  | ABisim (_,e1,e2)       ->(dependVarLE env lS e1) || (dependVarLE env lS e2)
  | ALcmp (_,lpat1,_,lpat2)-> dependVarL_lpat env lS lpat1 || dependVarL_lpat env lS lpat2
  | ANot  (_,bexpr)        -> dependVarLB env lS bexpr
  | AAnd  (_,bexpr1,bexpr2)
  | AOr   (_,bexpr1,bexpr2) -> dependVarLB env lS bexpr1    || dependVarLB env lS bexpr2
  | ATrue _| AFalse _       -> false
  | ALpred (_,alpt,lpat)    -> dependVarL_lpat env lS lpat
and dependVarL_lpat env lS = function
    ALLit (_,lit)     -> false
  | ALVar (_,ln)      -> (SetofLname.mem ln lS)
  | ALBin (_,p1,_,p2) -> let (f1,f2) = mapT2 (dependVarL_lpat env lS) (p1,p2) in (f1 || f2)
(* 
   dependVarLE and dependVarE are mutually recursive because
   dependency on variable v of label pattern (i.e., the binder) of llet
   carries over its body if by future extension label pattern 
   includes expression that can include graph variable 
 *)




let rec renameV env (v:vname) (v':vname) taexpr:('a taexpr) = 
  {taexpr with saexpr=match taexpr.saexpr with
    SAETEmp   ->                                                            SAETEmp
  | SAEEdg (lpat,e)  -> let e'        =        renameV env v v' e        in SAEEdg (lpat,e')
  | SAEGEmp   ->                                                            SAEGEmp
  | SAEOMrk m ->                                                            SAEOMrk m
  | SAEIMrk (m,expr) -> let expr'     =        renameV env v v' expr     in SAEIMrk (m, expr')
  | SAEVar n         -> let n' = (if n = v then v' else n)               in SAEVar n'
  | SAEUni (e1,e2)   -> let (e1',e2') = mapT2 (renameV env v v') (e1,e2) in SAEUni  (e1',e2')
  | SAEDUni (e1,e2)  -> let (e1',e2') = mapT2 (renameV env v v') (e1,e2) in SAEDUni (e1',e2')
  | SAEApnd (e1,e2)  -> let (e1',e2') = mapT2 (renameV env v v') (e1,e2) in SAEApnd (e1',e2')
  | SAECyc e         -> let   e'      =        renameV env v v'   e      in SAECyc e'
  | SAEIf (be,et,ef) -> let be'       =        renameVB env v v' be in
                        let(et',ef')  = mapT2 (renameV env v v') (et,ef) in SAEIf (be',et', ef')
  | SAERec (l,t,ebody,earg) ->
      let earg'                             =  renameV env v v' earg in
      let ebody' = if (t=v) then ebody else    renameV env v v' ebody    in SAERec (l,t,ebody',earg')
  | SAELet (vlet,ebind,ebody) -> let ebind' =  renameV env v v' ebind in
    let ebody' = if vlet = v then ebody else   renameV env v v' ebody    in SAELet (vlet, ebind',ebody')
  | SAELLet (lv,lbind,ebody) -> let lbind' =   renameV_lpat env v v' lbind in
    let                             ebody' =   renameV  env v v' ebody   in SAELLet (lv,lbind',ebody')
 }
and renameV_lpat env (v:vname) (v':vname) = function
    (* currently identity, since no graph variable reference
      is possible inside alpat *)
  | x                         -> x
and renameVB env (v:vname) (v':vname) tabexpr:('a tabexpr) = 
  {tabexpr with sabexpr=
  (* replace occurrence of v with v' *)
   match tabexpr.sabexpr with
     SAIsemp e         -> let e'         =         renameV env v v'   e             in SAIsemp e'
   | SABisim (e1,e2)   -> let (e1',e2')  = mapT2  (renameV env v v') (e1,e2)        in SABisim (e1',e2')
   | SALcmp (p1,op,p2) -> let (p1',p2')   = mapT2 (renameV_lpat env v v') (p1,p2)   in SALcmp (p1',op,p2')
   | SANot   be        -> let be'         =        renameVB     env v v'   be       in SANot  be'
   | SAAnd (be1,be2)   -> let (be1',be2') = mapT2 (renameVB     env v v') (be1,be2) in SAAnd (be1',be2')
   | SAOr  (be1,be2)   -> let (be1',be2') = mapT2 (renameVB     env v v') (be1,be2) in SAOr  (be1',be2')
   | SATrue            ->                                                              SATrue
   | SAFalse           ->                                                              SAFalse
   | SALpred (alpt,p)  -> let p'          =        renameV_lpat env v v'   p        in SALpred (alpt, p')
 }


let (reset,gensym) = (* fresh name generator for variables *)
  let c = ref 0
  in (
  (fun () -> c := 0),
  (fun () -> c := !c + 1; "$Sa" ^ (string_of_int !c)))

(* generate graph variable name that do not conflict in set vS *)
let genVar vS =
   let v = ref (gensym ()) in
   while (SetofVname.mem !v vS)
   do
     v := !v ^ "'" (* append prime (') each time *)
   done;
   !v

let genLVar lS =
   let v = ref (gensym ()) in
   while (SetofLname.mem !v lS)
   do
     v := !v ^ "'" (* append prime (') each time *)
   done;
   !v

(* strip type information *)
let rec detypeE (taexpr: 'a taexpr) : ('b option UnCAL.aexpr) =
  match taexpr.saexpr with
    SAETEmp             -> AETEmp None
  | SAEGEmp             -> AEGEmp None
  | SAEOMrk m           -> AEOMrk (None,m)
  | SAEVar  n           -> AEVar  (None,n)
  | SAEIMrk (m,e)       -> AEIMrk (None,m,                      detypeE e)
  | SAECyc     e        -> AECyc                          (None,detypeE e)
  | SAEDUni (e1,e2)     -> AEDUni              (None,detypeE e1,detypeE e2)
  | SAEUni  (e1,e2)     -> AEUni               (None,detypeE e1,detypeE e2)
  | SAEApnd (e1,e2)     -> AEApnd              (None,detypeE e1,detypeE e2)
  | SAERec (l,t,eb,ea)  -> AERec (None,l,None,t,None,detypeE eb,detypeE ea)
  | SAELet  (v,ea,eb)   -> AELet        (None,v,None,detypeE ea,detypeE eb)
  | SAELLet (l,ea,eb)   -> AELLet     (None,l,None,  detypeL ea,detypeE eb)
  | SAEEdg  ( l,e)      -> AEEdg               (None,detypeL l, detypeE e)
  | SAEIf (eb,et,ef)    -> AEIf   (None,detypeB eb, detypeE et, detypeE ef)
and detypeB (tabexpr: 'a tabexpr) : 'b option abexpr = 
  match tabexpr.sabexpr with
    SATrue              -> ATrue   None
  | SAFalse             -> AFalse  None
  | SAIsemp e           -> AIsemp (None,detypeE e)
  | SABisim (e1,e2)     -> ABisim (None,detypeE e1,    detypeE e2)
  | SALcmp (p1,op,p2)   -> ALcmp  (None,detypeL p1,op, detypeL p2) 
  | SANot be            -> ANot   (None,detypeB be)
  | SAAnd (be1,be2)     -> AAnd   (None,detypeB be1,   detypeB be2)
  | SAOr  (be1,be2)     -> AOr    (None,detypeB be1,   detypeB be2)
  | SALpred (alpt,p)    -> ALpred (None,       alpt,   detypeL p)
and detypeL (talpat:'a talpat) =
  match talpat.salpat with
    SALVar n            -> ALVar (None,n)
  | SALLit lit          -> ALLit (None,lit)
  | SALBin (lp1,op,lp2) -> ALBin (None,detypeL lp1,op,detypeL lp2)


let sa2ta env (sa:'a option saexpr) :'a option taexpr = 
  let vtype=match sa with
    SAETEmp  -> (SetofMarker.singleton "&",SetofMarker.empty)
  | SAEGEmp  -> (SetofMarker.empty,SetofMarker.empty)
  | SAEVar n -> lookup_gvtype env n
  | SAEEdg (_,e) ->
      let (sI,sO) = e.vtype in
      if (incRoot sI) then (sI, sO)
      else failwith "sa2ta: AEEdg operand has no root marker"
  | SAEIMrk (m,e) -> 
      let (sI,sO) = e.vtype in
      if SetofMarker.is_empty sI then failwith "sa2ta: SAIMrk operand has no input marker"
      else ((SetofMarker.singleton m) &^^  sI, sO)
  | SAEOMrk m -> (SetofMarker.singleton "&", SetofMarker.singleton m)
  | SAEUni (e1,e2) ->
      let ((sI1,sO1),(sI2,sO2)) =(e1.vtype,e2.vtype) in
      if (SetofMarker.equal sI1 sI2) then (sI1, SetofMarker.union sO1 sO2)
      else failwith ("sa2ta: SAEUni operands have different set of input markers: "
		     ^ (toStr pr_SetofMarker sI1) ^ " and " ^ (toStr pr_SetofMarker sI2))
  | SAEDUni (e1,e2)  ->
      let ((sI1,sO1),(sI2,sO2)) = (e1.vtype,e2.vtype) in
      let unionsI = (SetofMarker.inter sI1 sI2) in
      if (SetofMarker.is_empty unionsI) 
      then (SetofMarker.union sI1 sI2, SetofMarker.union sO1 sO2)
      else failwith ("sa2ta: SAEDUni operands have duplicate set of input markers: "
		     ^ (toStr pr_SetofMarker unionsI))
  | SAEIf (_,et,ef) ->
      let ((sIt,sOt),(sIf,sOf)) = (et.vtype,ef.vtype) in
      if (SetofMarker.equal sIt sIf) then (sIt, SetofMarker.union sOt sOf)
      else failwith ("sa2ta: SAEIf operands have different set of input markers: "
		     ^ (toStr pr_SetofMarker sIt) ^ " and " ^ (toStr pr_SetofMarker sIf))
  | SAERec (l,t,ebody,earg) ->
      let (setX,setY) = earg.vtype in
      let (setZi,setZo) = ebody.vtype in
      if !leaveOMrkApnd then
	(let setZ = setZi in
	(setX &^^ setZ, SetofMarker.union (setY &^^ setZ) setZo))
      else
	let setZ = SetofMarker.union setZi setZo in
	(setX &^^ setZ, setY &^^ setZ)
  | SAELet (vname,ebind,ebody) -> ebody.vtype
  | SAELLet (lname,eb,ebody) -> ebody.vtype
  | SAEApnd (e1,e2) ->
      let ((sI1,sO1),(sI2,sO2)) = (e1.vtype,e2.vtype) in 
      if !leaveOMrkApnd then
	(sI1, SetofMarker.union (SetofMarker.diff sO1 sI2) sO2)
	else (sI1, sO2)
  | SAECyc e ->
      let (sI,sO) = e.vtype in
      let interM  = SetofMarker.inter sI sO in
      (
       (if !cycleSemanticsOriginal then sI else SetofMarker.diff sI interM),
       SetofMarker.diff sO interM)
  in let r = {vtype=vtype;aexpr=AEGEmp None;saexpr=sa;expid=default_expid;} in
  {r with aexpr=detypeE r;}

let slp2tlp env (sl:('a salpat)) : 'a talpat = 
  let ltype=
    match sl with
      SALVar n -> lookup_lvtype env n
    | SALLit lit -> (match lit with 
   	ALLbl _ -> SLLbl
      | ALStr _ -> SLStr
      | ALInt _ -> SLInt
      | ALFlt _ -> SLFlt
      | ALBol _ -> SLBol
      | ALUkn   -> SLUkn
      | ALEps   -> SLEps)
  | SALBin (l1,op,l2) -> 
      let (t1,t2) = (l1.ltype,l2.ltype) in
      match op with
	ALAdd | ALSub | ALMul | ALDiv | ALMod -> 
          (match (t1,t2) with
	    (SLUkn,SLUkn) -> SLUkn  (* there's no way to represent numeric type in general *)
	  | (SLEps,_    ) | (_, SLEps) -> failwith "qtype_lpat: non-numeric type operand"
	  | (SLUkn,t) |(t,SLUkn) -> if  (isNumeric t) then t else failwith "qtype_lpat: non-numeric type operand"
          | (_ ,_ )  -> if (t1 = t2) then t1 else failwith "qtype_lpat: numeric operand type mismatch")
      | ALConc ->
          match (t1,t2) with
	    (SLUkn,SLUkn) -> SLStr 
	  | (SLEps,_    ) | (_, SLEps) -> failwith "qtype_lpat: non-string type operand"
	  | (SLUkn,t) |(t,SLUkn) -> if  (isString t) then t else failwith "qtype_lpat: non-string type operand"
          | (_ ,_ )  -> 
	      if (isString t1) && (isString t2) then t1
	      else failwith "qtype_lpat: string operand type mismatch"
  in let r = { ltype=ltype; alpat=ALLit (None,ALStr "dummy"); salpat=sl;}
  in {r with alpat=detypeL r;}

let rec augType (env:stenv) (aexpr:('a UnCAL.aexpr)) :'a taexpr =
  let saexpr = 
   match aexpr with
     AETEmp _    -> SAETEmp
   | AEGEmp _    -> SAEGEmp
   | AEVar (_,n) -> SAEVar n
   | AEDUni (_,e1,e2) -> let (e1',e2') = mapT2 (augType env) (e1,e2)           in SAEDUni (e1',e2')
   | AEUni  (_,e1,e2) -> let (e1',e2') = mapT2 (augType env) (e1,e2)           in SAEUni  (e1',e2')
   | AEApnd (_,e1,e2) -> let (e1',e2') = mapT2 (augType env) (e1,e2)           in SAEApnd (e1',e2')
   | AEDoc (_,s) -> failwith "augType: remove AEDoc with elimDoc"
   | AEEdg (_,l,e)    -> let (l',e') = cross (augTypeL env, augType env) (l,e) in SAEEdg (l',e')
   | AEIMrk (_,m,e)   -> let     e'  =          augType env    e               in SAEIMrk (m,e')
   | AEOMrk (_,m)     ->                                                          SAEOMrk m
   | AECyc (_,e)      -> let     e'    =        augType env    e               in SAECyc e'
   | AEIf (_,eb,et,ef)-> let  eb'      =        augTypeB env   eb in
                         let (et',ef') = mapT2 (augType env) (et,ef)           in SAEIf (eb',et',ef')
   | AERec (_,l,_,t,_,ebody,earg) ->
       let earg' = augType env earg in
       let (_,setY) = earg'.vtype in
       let ebody' = augType 
	 (intern_lvtype l SLUkn
	    (intern_gvtype t (SetofMarker.singleton "&",setY) env)) ebody in
       SAERec (l,t,ebody',earg')
  | AELet (_,vname,_,ebind,ebody) ->
      let ebind' = augType env ebind in
      let tebind' = ebind'.vtype in
      let ebody' = augType (intern_gvtype vname tebind' env) ebody in
      SAELet (vname,ebind',ebody')
  | AELLet (_,lname,_,eb,ebody) ->
      let eb' =  augTypeL env eb in
      let ltype = eb'.ltype in
      let env' = intern_lvtype lname ltype env in
      let ebody' = augType env' ebody in
      SAELLet (lname,eb',ebody')
  in { (sa2ta env saexpr) with aexpr=aexpr; }
and augTypeB env (abexpr: 'a abexpr) : 'a tabexpr = 
  { abexpr=abexpr;
    sabexpr=
    match abexpr with
      AIsemp (_,e)       -> let e'         =       augType  env  e        in SAIsemp e'
    | ABisim (_,e1,e2)   -> let (e1',e2') = mapT2 (augType env) (e1,e2)   in SABisim (e1',e2')
    | ALcmp (_,p1,op,p2) -> let (p1',p2')  =mapT2 (augTypeL env) (p1,p2)  in SALcmp (p1',op,p2')
    | ANot (_,be)        -> let be'        =        augTypeB env   be     in SANot   be'
    | AAnd (_,be1,be2)   -> let (be1',be2')=mapT2 (augTypeB env) (be1,be2)in SAAnd (be1',be2')
    | AOr  (_,be1,be2)   -> let (be1',be2')=mapT2 (augTypeB env) (be1,be2)in SAOr (be1',be2')
    | ATrue _            ->                                                  SATrue
    | AFalse _           ->                                                  SAFalse
    | ALpred (_,alpt,p)  -> let p'         =       augTypeL env   p       in SALpred (alpt,p')
  }
and augTypeL (env:stenv) (l:('a alpat)) : 'a talpat =
  let salpat=
   match l with
     ALVar (_,n)          ->                                                   SALVar n
   | ALLit (_,lit)        ->                                                   SALLit lit
   | ALBin (_,lp1,op,lp2) -> let (lp1',lp2')=mapT2 (augTypeL env) (lp1,lp2) in SALBin (lp1',op,lp2')
  in {(slp2tlp env salpat) with alpat=l;}


let ppr_taexpr ?pp_a ppf taexpr = ppr_aexpr ?pp_a ppf (detypeE taexpr)

(* rewrite typed AST *)
let rec rewriteE env (taexpr: 'a taexpr) :  'a taexpr = 
  let taexpr' = 
    { taexpr with saexpr = match taexpr.saexpr with
      SAETEmp         ->                                                           SAETEmp
    | SAEGEmp         ->                                                           SAEGEmp
    | SAEOMrk m       ->                                                           SAEOMrk m
    | SAEEdg (p,e)    -> let (p',e')= cross (rewriteL env,rewriteE env)(p,e)    in SAEEdg (p',e')
    | SAEIMrk (m,e)   -> let      e'=                     rewriteE env e        in SAEIMrk (m,e')
    | SAEVar n        ->                                                           SAEVar n
    | SAEUni  (e1,e2) -> let (e1',e2') = mapT2           (rewriteE env) (e1,e2) in SAEUni  (e1',e2')
    | SAEDUni (e1,e2) -> let (e1',e2') = mapT2           (rewriteE env) (e1,e2) in SAEDUni (e1',e2')
    | SAEApnd (e1,e2) -> let (e1',e2') = mapT2           (rewriteE env) (e1,e2) in SAEApnd (e1',e2')
    | SAECyc e        -> let      e'   =                  rewriteE env e        in SAECyc e'
    | SAEIf (be,et,ef)-> let be'       =                  rewriteB env   be in
	                 let (et',ef') = mapT2           (rewriteE env) (et,ef) in SAEIf (be',et',ef')
    | SAERec  (l,t,ebody,earg) -> rewrite_AERec env l t ebody earg
    | SAELet (v,ebind,ebody) ->
	let ebind' = rewriteE env ebind in
	let tbind = ebind'.vtype in
	let env' = intern_gvtype v tbind env in
	let ebody'    = rewriteE env' ebody in
	SAELet (v,ebind',ebody')
    | SAELLet (lv,lexpr,ebody) -> 
	let lexpr = rewriteL env lexpr in
	let ebody = (match lexpr.salpat with
	  SALLit lit  -> lpropE env lv lexpr ebody
	| _           ->                    ebody) in
	let lt = lexpr.ltype in
	let env' = intern_lvtype lv lt env in
	let ebody' = rewriteE env' ebody in
	SAELLet (lv,lexpr,ebody')
    } in
  foldE env taexpr'
and rewrite_AERec env l t ebody earg : 'a saexpr = 
  let ea2 = rewriteE env earg in 
  (match ea2.saexpr with
    SAETEmp -> (* not SAETEmp. original UnQL paper was wrong. Should be transformed in a similar way as output maker case *)
      let (setZi,setZo) = ebody.vtype in
      let setZ = SetofMarker.union setZi setZo in
      let e' = SetofMarker.hom1 (fun e1 e2 -> AEDUni (None,e1,e2))
	  (fun z -> AEIMrk (None,z, (AETEmp None))) setZ
      in (augType env e').saexpr
  | SAEGEmp -> SAEGEmp
  | SAEOMrk y -> 
      let (setZi,setZo) = ebody.vtype in
      let setZ = SetofMarker.union setZi setZo in
      let e' = SetofMarker.hom1 (fun e1 e2 -> AEDUni (None,e1,e2))
	  (fun z -> AEIMrk (None,z, AEOMrk (None,y &^ z))) setZ
      in (augType env e').saexpr
  | SAEIMrk (m,d) -> 
      let taexpr = sa2ta env (SAERec (l,t,ebody,d)) in
      let expr' = rewriteE env taexpr in
      SAEIMrk (m,expr') (* with the help of eval_AEIMrkG *)
  | SAEEdg (lpat,expr) ->
      let ebody' = 
	(match lpat.salpat with
	    SALLit lit  -> (lpropE env l lpat ebody)
	  | _           -> { ebody with saexpr=SAELLet (l,lpat,ebody)}) in
      let lexpr = {ebody' with saexpr=SAELet (t,expr,ebody')} in
      let lexpr' = rewriteE env lexpr in
      let e2     = rewriteE env (sa2ta env (SAERec (l,t,ebody,expr))) in
      SAEApnd (lexpr',e2)
  | SAEUni (e1,e2) -> 
      let taexpr1 = sa2ta env (SAERec (l,t,ebody,e1)) in
      let taexpr2 = sa2ta env (SAERec (l,t,ebody,e2)) in
      let (e1',e2') = mapT2 (rewriteE env) (taexpr1,taexpr2) in
      SAEUni (e1',e2')
  | SAEDUni (e1,e2) ->
      let taexpr1 = sa2ta env (SAERec (l,t,ebody,e1)) in
      let taexpr2 = sa2ta env (SAERec (l,t,ebody,e2)) in
      let (e1',e2') = mapT2 (rewriteE env) (taexpr1,taexpr2) in
      SAEDUni (e1',e2')
  | SAEVar n ->
      let (_,setY) = ea2.vtype in
      let env' = intern_lvtype l SLUkn
                (intern_gvtype  t (SetofMarker.singleton "&",setY) env) in
      let ebody' = rewriteE env' ebody in
      SAERec (l,t,ebody',ea2)
  | SAEApnd (e1,e2) ->
      if (dependVarE env (SetofVname.singleton t) (detypeE ebody)) then
	(* we can still rewrite ebody *)
	let (setX,setY) = ea2.vtype in
	let env' = intern_lvtype l SLUkn
	    (intern_gvtype t (SetofMarker.singleton "&",setY) env) in
	let ebody' = rewriteE env' ebody in
	SAERec (l,t,ebody',ea2)
      else
	let taexpr1 = sa2ta env (SAERec (l,t,ebody,e1)) in
	let taexpr2 = sa2ta env (SAERec (l,t,ebody,e2)) in
	let (e1',e2') = mapT2 (rewriteE env) (taexpr1,taexpr2) in
	SAEApnd (e1',e2')
  | SAECyc d ->
      if (dependVarE env (SetofVname.singleton t) (detypeE ebody)) then
	let (setX,setY) = ea2.vtype in
	let env' = intern_lvtype l SLUkn
	    (intern_gvtype t (SetofMarker.singleton "&",setY) env) in
	let ebody' = rewriteE env' ebody in
	SAERec (l,t,ebody',ea2)
      else
	let e' = rewriteE env (sa2ta env (SAERec (l,t,ebody,d))) in 
	SAECyc e'
  | SAEIf  (be,et,ef) ->
      let taexprt = sa2ta env (SAERec (l,t,ebody,et)) in
      let taexprf = sa2ta env (SAERec (l,t,ebody,ef)) in
      let (et',ef') = mapT2 (rewriteE env) (taexprt,taexprf) in
      SAEIf (be,et',ef')
  | SAELet (v,ebind,eb) ->
      (* We could have applied the rule
         rec(e)(let V = e1 in e2) =>
         if e depends on V and rec doesn't bind V then 
           let FreshV = e1 in rec(e[rename V with FreshV])(e2) 
         else
        let V = e1 in rec(e)(e2)  *)
      let (setX,setY) = ea2.vtype in
      let env' = intern_lvtype l SLUkn
		    (intern_gvtype t (SetofMarker.singleton "&",setY) env) in
      let ebody' = rewriteE env' ebody in
      SAERec (l,t,ebody',ea2)
  | SAELLet (lv,be,eb) ->
      (* We could have applied the rule
      rec(e)(llet L = lpat in e1) =>
	 if e depends on L and rec doesn't bind L then
	 llet FreshL = lpat in rec(e[rename L with freshL])(e1)
	 else
	 llet L = lpat in rec(e)(e1) *)
      let (setX,setY) = ea2.vtype in
      let env' = intern_lvtype l SLUkn
	  (intern_gvtype  t (SetofMarker.singleton "&",setY) env) in
      let ebody' = rewriteE env' ebody in
      SAERec (l,t,ebody', ea2)
  | SAERec (l',t',ebody',earg') -> (* Theorem 4 *)
      (*  e0 = earg', e1(l',t')=ebody', e2(l,t)=ebody, 
          rec(\ (l',t').e1(l',t'))(e0)=ea2  *)
      let (setX,setY) = earg'.vtype in
      (* Free variable capture check: to see if e2 includes free l' or t'.
         If so, rename l' and l' in the body of e1  *)
      let (flSebody,fvSebody) = freeVarsE (detypeE ebody) in
      let (nglS,ngvS) = 
	(let (flSebody',fvSebody')=freeVarsE (detypeE ebody') in
	(SetofLname.add l' (SetofLname.union flSebody flSebody'),
	 SetofVname.add t' (SetofVname.union fvSebody fvSebody'))) in
      let ltype_l' = SLUkn in
      let (l',ebody') = 
	(if (SetofLname.mem l' flSebody)
	then (let newl' = genLVar nglS in (newl',lpropE env l' {ltype=ltype_l';alpat=ALVar (None,newl');salpat=(SALVar newl');} ebody'))
	else (l',ebody')) in
      let (t',ebody') = 
	(if (SetofVname.mem t' fvSebody)
	then (let newt' = genVar ngvS in (newt',renameV env t' newt' ebody'))
	else (t',ebody')) in
      let vtype_t' = (SetofMarker.singleton "&",setY) in
      let env' = intern_lvtype l' ltype_l'
	  (intern_gvtype  t' vtype_t' env) in
      if (dependVarE env (SetofVname.singleton t) (detypeE ebody))
      then  (* rule (2) *)
        let ebody'' = sa2ta env' (SAERec(l,t,ebody,sa2ta env' (SAEApnd (ebody',sa2ta env' (SAERec(l',t',ebody',sa2ta env' (SAEVar t'))))))) in
	let ebody''' = rewriteE env'  ebody'' in
	let msg = if (SetofMarker.is_empty (snd ebody'.vtype)) then "(may degenerate to rule (1))" else "" in
	let _ = printf "Fusion_rule (2) applied%s@." msg in
	SAERec (l',t',ebody''',earg')
      else  (* rule (1) *)
	let ebody'' = sa2ta env' (SAERec(l,t,ebody,ebody')) in
	let ebody''' = rewriteE env' ebody'' in
	let _ = printf "%s@." "Fusion_rule (1) applied." in
	SAERec (l',t',ebody''',earg')
  )
and lpropE env (ln:lname) (lpatTo:('a talpat)) taexpr : 'a taexpr  = 
{ taexpr with saexpr=
  match taexpr.saexpr with
    SAETEmp       ->                                                                            SAETEmp
  | SAEGEmp       ->                                                                            SAEGEmp
  | SAEVar      n ->                                                                            SAEVar n
  | SAEOMrk m     ->                                                                            SAEOMrk m
  | SAEIMrk (m,e) -> let e' =                                  lpropE env ln lpatTo     e    in SAEIMrk (m, e')
  | SAECyc      e -> let e' =                                  lpropE env ln lpatTo     e    in SAECyc e'
  | SAEEdg (p,e)  -> let (p',e') = cross (lpropL env ln lpatTo,lpropE env ln lpatTo) (p,e)   in SAEEdg  (p',e')
  | SAEUni (e1,e2)-> let (e1',e2') =                    mapT2 (lpropE env ln lpatTo) (e1,e2) in SAEUni  (e1',e2')
  | SAEDUni (e1,e2)->let (e1',e2') =                    mapT2 (lpropE env ln lpatTo) (e1,e2) in SAEDUni (e1',e2')
  | SAEApnd (e1,e2)->let (e1',e2') =                    mapT2 (lpropE env ln lpatTo) (e1,e2) in SAEApnd (e1',e2')
  | SAEIf  (be,et,ef) -> let be'   =                          lpropB env ln lpatTo be in
                     let (et',ef') =                    mapT2 (lpropE env ln lpatTo) (et,ef) in SAEIf (be',et', ef')
  | SAERec (l,t,ebody,earg) ->
      let earg' = lpropE env ln lpatTo earg in
      let ebody' = if (l = ln) then ebody else (lpropE env ln lpatTo ebody) in
      SAERec (l,t,ebody',earg')
  | SAELet (v,bi,bo) -> let (bi',bo') =                 mapT2 (lpropE env ln lpatTo) (bi,bo) in SAELet (v,bi',bo')
  | SAELLet (lv,lbind,ebody) -> 
      let ebody' = (if lv = ln then ebody else (lpropE env ln lpatTo ebody))                 in SAELLet (lv,lbind,ebody')
}
and lpropL env (ln:lname) (lpatTo:('a talpat)) (talpat: 'a talpat) = 
{ talpat with salpat =
  match talpat.salpat with
    SALVar (ln') when ln = ln' -> lpatTo.salpat
  | (SALVar _) as x            -> x
  | (SALLit _) as x            -> x
  | SALBin (lpat1,op,lpat2)    -> 
      let (lpat1',lpat2') = mapT2 (lpropL env ln lpatTo) (lpat1,lpat2) in
      SALBin (lpat1',op,lpat2')
}
and lpropB env (ln:lname) (lpatTo:('a talpat)) (tabexpr: 'a tabexpr) = 
  { tabexpr with sabexpr =
    match tabexpr.sabexpr with
      (* replace occurrence of ln with lpatTo *)
      SAIsemp e         -> let e'          =        lpropE env ln lpatTo    e       in SAIsemp e'
    | SABisim (e1,e2)   -> let (e1',e2')   = mapT2 (lpropE env ln lpatTo) (e1,e2)   in SABisim (e1',e2')
    | SALcmp (p1,op,p2) -> let (p1',p2')   = mapT2 (lpropL env ln lpatTo) (p1,p2)   in SALcmp (p1',op,p2')
    | SANot be          -> let  be'        =        lpropB env ln lpatTo   be       in SANot be'
    | SAAnd (be1,be2)   -> let (be1',be2') = mapT2 (lpropB env ln lpatTo) (be1,be2) in SAAnd (be1',be2')
    | SAOr  (be1,be2)   -> let (be1',be2') = mapT2 (lpropB env ln lpatTo) (be1,be2) in SAOr (be1',be2')
    | SATrue            ->                                                             SATrue
    | SAFalse           ->                                                             SAFalse
    | SALpred (alpt,p)  -> let p'         =         lpropL env ln lpatTo   p        in SALpred (alpt, p')
  }
and rewriteB env tabexpr = 
  let tabexpr' = 
    { tabexpr with sabexpr=match tabexpr.sabexpr with
      SAIsemp expr      -> let expr'       =        rewriteE env expr       in SAIsemp expr'
    | SABisim (e1,e2)   -> let (e1',e2')   = mapT2 (rewriteE env) (e1,e2)   in SABisim (e1',e2')
    | SALcmp (p1,op,p2) -> let (p1',p2')   = mapT2 (rewriteL env) (p1,p2)   in SALcmp (p1',op,p2')
    | SANot be          -> let be'         =        rewriteB env   be       in SANot be'
    | SAAnd (be1,be2)   -> let (be1',be2') = mapT2 (rewriteB env) (be1,be2) in SAAnd (be1',be2')
    | SAOr  (be1,be2)   -> let (be1',be2') = mapT2 (rewriteB env) (be1,be2) in SAOr  (be1',be2')
    | SATrue            ->                                                     SATrue
    | SAFalse           ->                                                     SAFalse
    | SALpred (alpt,p)  -> let p' = rewriteL env p                          in SALpred (alpt, p')
    }
  in foldB env tabexpr'
and rewriteL env talpat = 
  let talpat' = 
    { talpat with salpat=
      (match talpat.salpat with
	(SALVar _) as x -> x
      | (SALLit _) as x -> x
      | SALBin (lpat1,op,lpat2) ->
	  let (lpat1',lpat2') = mapT2 (rewriteL env) (lpat1,lpat2) in
	  SALBin (lpat1',op,lpat2'))
    }
  in foldL env talpat'
and foldL env talpat =
  { talpat with salpat = 
    let lpat=talpat.salpat in match lpat with 
      SALVar _ -> lpat  (* statically resolved to value? *)
    | SALLit _ -> lpat
    | SALBin (lpat1,op,lpat2) ->
	match (lpat1.salpat,op,lpat2.salpat) with
	  (SALLit (ALStr s1),ALConc,SALLit (ALStr s2)) -> SALLit (ALStr (s1 ^ s2))
	| (SALLit (ALInt i1),op    ,SALLit (ALInt i2)) -> 
	    (match op with 
	      ALAdd -> SALLit (ALInt (i1 + i2))
	    | ALSub -> SALLit (ALInt (i1 - i2))
	    | ALMul -> SALLit (ALInt (i1 * i2))
	    | ALDiv -> SALLit (ALInt (i1 / i2))
	    | ALMod -> SALLit (ALInt (i1 mod i2))
	    | ALConc -> lpat
	    )
	| (SALLit (ALFlt f1),op    ,SALLit (ALFlt f2)) -> 
	    (match op with 
	      ALAdd -> SALLit (ALFlt (f1 +. f2))
	    | ALSub -> SALLit (ALFlt (f1 -. f2))
	    | ALMul -> SALLit (ALFlt (f1 *. f2))
	    | ALDiv -> SALLit (ALFlt (f1 /. f2))
	    | ALMod -> lpat
	    | ALConc -> lpat 
	    )
	| _ -> lpat
  }
and foldB env tabexpr =
  { tabexpr with sabexpr=match tabexpr.sabexpr with
    SAIsemp expr as be  ->
      (match expr.saexpr with
	SAETEmp -> SATrue
      | _      -> be)
  | SABisim (e1,e2) as be ->
      (match (e1.saexpr,e2.saexpr) with
	(SAETEmp,SAETEmp) -> SATrue
      | _      -> be)
  | SALcmp (p1,op,p2) as be -> 
      let oop = (match op with 
	ALOEq -> (=)
      | ALOLt -> (<) 
      | ALOGt -> (>)) in
      (match (p1.salpat,op,p2.salpat) with
	(SALLit l1,_, SALLit  l2)  -> (match (l1,l2) with
	  (ALUkn,_) | (_,ALUkn) -> be
	| _ -> if (oop l1 l2) then SATrue else SAFalse)
      | (SALVar v1,ALOEq,SALVar v2) when v1 = v2 -> SATrue
      |	    _   -> be)
  | SANot be as b0 -> 
      (match be.sabexpr with
	SATrue  -> SAFalse
      | SAFalse -> SATrue
      | _      -> b0)
  | SAAnd (be1,be2) as be ->
      (match (be1.sabexpr,be2.sabexpr) with
        (SATrue,SATrue) -> SATrue
      | (SATrue,se2)    -> se2
      | (se1,SATrue)    -> se1
      |	(SAFalse,_)     -> SAFalse
      | (_,SAFalse)     -> SAFalse
      | _             -> be)
  | SAOr  (be1,be2) as be -> 
      (match (be1.sabexpr,be2.sabexpr) with
        (SAFalse,SAFalse) -> SAFalse
      | (SAFalse,se2)     -> se2
      | (se1,SAFalse)     -> se1
      |	(SATrue,_)        -> SATrue
      | (_,SATrue)        -> SATrue
      | _                 -> be)
  | SATrue  -> SATrue
  | SAFalse -> SAFalse
  | SALpred (alpt,p) as be ->
      match (alpt,p.salpat) with
	(ALPStr,SALLit (ALStr _)) -> SATrue
      | (ALPStr,SALLit _        ) -> SAFalse
      | (ALPLbl,SALLit (ALLbl _)) -> SATrue
      | (ALPLbl,SALLit _        ) -> SAFalse
      | (ALPInt,SALLit (ALInt _)) -> SATrue
      | (ALPInt,SALLit _        ) -> SAFalse
      | (ALPFlt,SALLit (ALFlt _)) -> SATrue
      | (ALPFlt,SALLit _        ) -> SAFalse
      | (ALPBol,SALLit (ALBol _)) -> SATrue
      | (ALPBol,SALLit _        ) -> SAFalse
      | _                         -> be

  }
(* lexical equivalence of two expressions, with alpha-renaming considered *)
and lexeqE env saexpr1 saexpr2 =
  match (saexpr1,saexpr2) with
    (SAETEmp,SAETEmp) -> true
  | (SAEGEmp,SAEGEmp) -> true
  | (SAEEdg (p1,e1), SAEEdg (p2,e2)) -> lexeqL env p1.salpat p2.salpat && lexeqE env e1.saexpr e2.saexpr
  | (SAEOMrk m1,SAEOMrk m2) -> m1 = m2
  | (SAEVar v1,SAEVar v2)   -> v1 = v2
  | (SAEIMrk (m1,e1),SAEIMrk (m2,e2)) -> m1 = m2 && lexeqE env e1.saexpr e2.saexpr
  | (SAEUni (e11,e12),SAEUni (e21,e22)) -> lexeqE env e11.saexpr e21.saexpr && lexeqE env e12.saexpr e22.saexpr
  | (SAEDUni (e11,e12),SAEDUni (e21,e22)) -> lexeqE env e11.saexpr e21.saexpr && lexeqE env e12.saexpr e22.saexpr
  | (SAEApnd (e11,e12),SAEApnd (e21,e22)) -> lexeqE env e11.saexpr e21.saexpr && lexeqE env e12.saexpr e22.saexpr
  | (SAECyc e1,SAECyc e2) -> lexeqE env e1.saexpr e2.saexpr
  | (SAEIf (be1,et1,ef1),SAEIf (be2,et2,ef2)) -> lexeqB env be1.sabexpr be2.sabexpr && lexeqE env et1.saexpr et2.saexpr && 
      lexeqE env ef1.saexpr ef2.saexpr
  | (SAELet (v1,ebind1,ebody1),SAELet (v2,ebind2,ebody2)) ->
      if lexeqE env ebind1.saexpr ebind2.saexpr
      then
	let ebody2 = if v1 = v2 then ebody2 else renameV env v2 v1 ebody2 in
	lexeqE env ebody1.saexpr ebody2.saexpr
      else false
  | (SAELLet (l1,lpat1,expr1),SAELLet (l2,lpat2,expr2)) ->
      if lexeqL env lpat1.salpat lpat2.salpat
      then let expr2 = if l1 = l2 then expr2 else renameL env l2 l1 expr2 in
      lexeqE env expr1.saexpr expr2.saexpr
      else false
  | SAERec (l1,t1,ebody1,earg1),SAERec (l2,t2,ebody2,earg2) ->
      if lexeqE env earg1.saexpr earg2.saexpr
      then 
	let ebody2 = if l1 = l2 then ebody2 else renameL env l2 l1 ebody2 in
	let ebody2 = if t1 = t2 then ebody2 else renameV env t2 t1 ebody2 in
	lexeqE env ebody1.saexpr ebody2.saexpr
      else false
  | (_,_) -> false
and lexeqL env sl1 sl2 = match (sl1,sl2) with
  (SALVar n1,SALVar n2)     ->   n1 = n2
| (SALLit lit1,SALLit lit2) -> 
    (match (lit1,lit2) with
      (ALLbl l1,ALLbl l2) -> l1 = l2
    | (ALStr s1,ALStr s2) -> s1 = s2
    | (ALInt i1,ALInt i2) -> i1 = i2
    | (ALFlt f1,ALFlt f2) -> f1 = f2
    | (ALBol b1,ALBol b2) -> b1 = b2
    | (ALEps,ALEps)       -> true
    | (ALUkn,ALUkn)       -> false (* safe side decision *)
    | (_,_)               -> false)
| (SALBin (l11,op1,l12),SALBin (l21,op2,l22)) ->
    lexeqL env l11.salpat l21.salpat && (op1 = op2) && lexeqL env l12.salpat l22.salpat
| (_,_) -> false
and lexeqB env sabexpr1 sabexpr2 = match (sabexpr1,sabexpr2) with
  (SAIsemp e1,SAIsemp e2) -> lexeqE env e1.saexpr e2.saexpr
| (SABisim (e11,e12),SABisim (e21,e22)) -> lexeqE env e11.saexpr e21.saexpr && lexeqE env e12.saexpr e22.saexpr
| (SALcmp (p11,op1,p12),SALcmp (p21,op2,p22)) -> 
    lexeqL env p11.salpat p21.salpat && (op1 = op2) && lexeqL env p12.salpat p22.salpat
| (SANot b1,SANot b2) -> lexeqB env b1.sabexpr b2.sabexpr
| (SAAnd (be11,be12),SAAnd (be21,be22)) -> lexeqB env be11.sabexpr be21.sabexpr && lexeqB env be12.sabexpr be22.sabexpr
| (SAOr (be11,be12),SAOr (be21,be22)) -> lexeqB env be11.sabexpr be21.sabexpr && lexeqB env be12.sabexpr be22.sabexpr
| (SATrue,SATrue) -> true
| (SAFalse,SAFalse) -> true
| (SALpred (alpt1,p1),SALpred (alpt2,p2)) -> (alpt1 = alpt2) && lexeqL env p1.salpat p2.salpat
| (_,_) -> false
and renameL env (v:lname) (v':lname) taexpr:('a taexpr) = 
  {taexpr with saexpr=match taexpr.saexpr with
    SAETEmp   ->                                                            SAETEmp
  | SAEEdg (lpat,e)  -> let lpat' = renameL_lpat env v v' lpat in 
                        let e'    = renameL      env v v' e              in SAEEdg (lpat',e')
  | SAEGEmp   ->                                                            SAEGEmp
  | SAEOMrk m ->                                                            SAEOMrk m
  | SAEIMrk (m,expr) -> let expr'     =        renameL env v v' expr     in SAEIMrk (m, expr')
  | SAEVar n         ->                                                     SAEVar n
  | SAEUni (e1,e2)   -> let (e1',e2') = mapT2 (renameL env v v') (e1,e2) in SAEUni  (e1',e2')
  | SAEDUni (e1,e2)  -> let (e1',e2') = mapT2 (renameL env v v') (e1,e2) in SAEDUni (e1',e2')
  | SAEApnd (e1,e2)  -> let (e1',e2') = mapT2 (renameL env v v') (e1,e2) in SAEApnd (e1',e2')
  | SAECyc e         -> let   e'      =        renameL env v v'   e      in SAECyc e'
  | SAEIf (be,et,ef) -> let be'       =        renameLB env v v' be in
                        let(et',ef')  = mapT2 (renameL env v v') (et,ef) in SAEIf (be',et', ef')
  | SAERec (l,t,ebody,earg) ->
      let earg'                             =  renameL env v v' earg in
      let ebody' = if (l=v) then ebody else    renameL env v v' ebody    in SAERec (l,t,ebody',earg')
  | SAELet (vlet,ebind,ebody) -> let ebind' =  renameL env v v' ebind in
                                 let ebody' =  renameL env v v' ebody    in SAELet (vlet, ebind',ebody')
  | SAELLet (lv,lbind,ebody) -> let lbind' =   renameL_lpat env v v' lbind in
    let  ebody' = if (lv=v) then ebody else    renameL env v v' ebody   in SAELLet (lv,lbind',ebody')
 }
and renameL_lpat env (v:lname) (v':lname) talpat =
  { talpat with salpat = match talpat.salpat with
    SALVar n -> let n' = (if n = v then v' else n) in SALVar n'
  | SALLit l -> SALLit l
  | SALBin (lpat1,op,lpat2) -> let (lpat1,lpat2) = mapT2 (renameL_lpat env v v') (lpat1,lpat2) in SALBin (lpat1,op,lpat2)
  }
and renameLB env (v:lname) (v':lname) tabexpr:('a tabexpr) = 
  {tabexpr with sabexpr=
  (* replace occurrence of v with v' *)
   match tabexpr.sabexpr with
     SAIsemp e         -> let e'         =         renameL env v v'   e             in SAIsemp e'
   | SABisim (e1,e2)   -> let (e1',e2')  = mapT2  (renameL env v v') (e1,e2)        in SABisim (e1',e2')
   | SALcmp (p1,op,p2) -> let (p1',p2')   = mapT2 (renameL_lpat env v v') (p1,p2)   in SALcmp (p1',op,p2')
   | SANot   be        -> let be'         =        renameLB     env v v'   be       in SANot  be'
   | SAAnd (be1,be2)   -> let (be1',be2') = mapT2 (renameLB     env v v') (be1,be2) in SAAnd (be1',be2')
   | SAOr  (be1,be2)   -> let (be1',be2') = mapT2 (renameLB     env v v') (be1,be2) in SAOr  (be1',be2')
   | SATrue            ->                                                              SATrue
   | SAFalse           ->                                                              SAFalse
   | SALpred (alpt,p)  -> let p'          =        renameL_lpat env v v'   p        in SALpred (alpt, p')
 }

and foldE env taexpr = 
  { taexpr with saexpr=
    let expri = taexpr.saexpr in 
    match expri with
      SAETEmp      
    | SAEOMrk _    
    | SAEEdg (_,_) 
    | SAEGEmp      
    | SAEVar _     -> expri
    | SAEIMrk ("&",e1) -> e1.saexpr (* &:= is idempotent for any graph *)
    | SAEIMrk (m,e1) ->
	(match (e1.saexpr) with
	  SAEDUni (te1,te2) -> 
	    (foldE env (sa2ta env (SAEDUni 
				     (foldE env (sa2ta env (SAEIMrk (m,te1))),
				      foldE env (sa2ta env (SAEIMrk (m,te2))))))).saexpr
	| SAEIMrk (m',e1') ->
	    SAEIMrk ((m &^ m'),e1')
	| _                 -> expri)
    | SAEUni (e1,e2) ->
	(match (e1.saexpr,e2.saexpr) with
	| (SAETEmp,e     ) -> e
	| (     e,SAETEmp) -> e
	| _               -> expri)
    | SAEDUni (e1,e2) ->
	(match (e1.saexpr,e2.saexpr) with
	| (SAEGEmp,e     ) -> e
	| (     e,SAEGEmp) -> e
	| _               -> expri)
    | SAEApnd (e1,e2) -> 
	(match (e1.saexpr,e2.saexpr) with
	| (SAEGEmp,e    ) -> SAEGEmp
	| (SAETEmp,e    ) -> SAETEmp
	| _               ->
	    if (not !optApndStat) then expri else
	    let (setX,setY) = e1.vtype in
	    if (SetofMarker.is_empty setY)  then 
	      (* if the output marker of e1 is empty, then
		 e2 will be completely unreachable, so it can
		 be safely eliminated. Overall output marker
		 will be empty (as is for e1), sinse output nodes
		 in e2 is unreachable *)
              e1.saexpr
	    else
	      if not (SetofMarker.subset setY (fst (e2.vtype))) then expri else
	      let is_candidate = function 
                  SAEIMrk (m,e1') -> ( (* SetofMarker.mem m setY && *) SetofMarker.equal (SetofMarker.singleton "&") (fst (e1'.vtype)))
		| SAEOMrk m       -> true
		| _               -> false in
	      let rec collect_candidate sae = match sae with
		  SAEIMrk (m,e1') -> if is_candidate sae then [(m,e1')] else raise Not_found
	        | SAEOMrk m       -> [("&",e2)]
		| SAEGEmp         -> [] (* allow ()  uint of ++ *)
		| SAEDUni (e1',e2') -> (collect_candidate e1'.saexpr) @ (collect_candidate e2'.saexpr)
		| _                 -> raise Not_found  in
	      match e2.saexpr with
		SAEOMrk m       -> (let pmelist = collect_candidate e2.saexpr in (substE env pmelist e1).saexpr)
	      |	SAEIMrk (m,e1') ->  if is_candidate e2.saexpr
		then (substE env [(m,e1')] e1).saexpr else expri
	      | SAEDUni (e1',e2') ->
                  (*
		    (match e1'.saexpr with
		    SAEIMrk (m,e1') -> (if SetofMarker.mem m setY then 
		    (foldE env (sa2ta env (SAEApnd
		    (substE env e1' m e1,e2')))).saexpr else expri)  
		    | _ -> expri) *)
                  (try (let pmelist = collect_candidate e2.saexpr in (substE env pmelist e1).saexpr)
		  with Not_found -> expri)
	      | _ ->  expri) (* there would be much more rules *)
    | SAECyc e ->
	(match e.saexpr with
	  SAEGEmp -> SAEGEmp
	| SAETEmp -> SAETEmp
	| _      -> 
	    let (setX,setY) = e.vtype in
	    let interM = (SetofMarker.inter setX setY) in
	    if (SetofMarker.is_empty interM) then
	      (* if there are no matching I/O marker set found in e, 
		 you can safely remove cycle operator *)
	      (* this optimization is independent of the
		 value of  !cycleSemanticsOriginal *)
	      e.saexpr
	    else expri
	)
    | SAEIf  (be,et,ef) -> 
	(match be.sabexpr with 
	  SATrue  -> et.saexpr
	| SAFalse -> ef.saexpr
	| _       -> if lexeqE env et.saexpr ef.saexpr then et.saexpr else expri)
    | SAERec  (l,t,ebody,earg) ->  (* Proposition 3 *)
	(match earg.saexpr with
	  SAETEmp -> SAETEmp
	| SAEGEmp -> SAEGEmp
	| _      -> expri)    (* there would be much more rules using Proposition 3 *)
    | SAELet (v,ebind,ebody) -> 
	if (dependVarE env (SetofVname.singleton v) (detypeE ebody))
	then expri
	else ebody.saexpr  (* remove let binding *)
    | SAELLet (l,lpat,expr) ->
	(* if expr doesn't depend on l, then expri can be replaced with expr *)
	if (dependVarLE env (SetofLname.singleton l) (detypeE expr))
	then expri
	else expr.saexpr
  }
(* FIXME: better to work on set of pairs of marker and expression and
   make substitutions happen in parallel *)
(*
and substE env taexpr' (m:marker) taexpr =
  { taexpr with saexpr = 
    let expri = taexpr.saexpr in
   (match expri with
      SAETEmp
    | SAEGEmp         -> expri
    | SAEOMrk m'      -> if m' = m then taexpr'.saexpr else expri
    | SAEUni (e1,e2)  -> let (e1',e2') = mapT2 (substE env taexpr' m) (e1,e2) in
			  SAEUni (e1',e2')
    | SAEDUni (e1,e2) -> let (e1',e2') = mapT2 (substE env taexpr' m) (e1,e2) in
			 SAEDUni (e1',e2')
    | SAEIMrk (m',e1) -> SAEIMrk (m',substE env taexpr' m e1)
    | SAEEdg (p,e)    -> SAEEdg (p,substE env taexpr' m e)
    | SAEApnd (e1,e2) -> SAEApnd (e1,substE env taexpr' m e2)
    | SAEIf (be,et,ef)-> let (et',ef') = mapT2 (substE env taexpr' m) (et,ef) in
			 SAEIf (be,et',ef') 
    | SAELet (v,ebind,ebody) ->
	let tbind = ebind.vtype in
	let env' = intern_gvtype v tbind env in
	SAELet (v,substE env taexpr' m ebind,substE env' taexpr' m ebody)
    | SAELLet (lv,lexpr,ebody) -> 
	let lt = lexpr.ltype in
	let env' = intern_lvtype lv lt env in
	SAELLet (lv,lexpr,substE env' taexpr' m ebody)
    | SAECyc _
    | SAERec _
    | SAEVar _ -> (* just a fallback rule *)
	let (_,setY) = taexpr.vtype in
	if SetofMarker.mem m setY then
	  let setZ = SetofMarker.remove m setY in
	  let em = AEIMrk (None,m,detypeE taexpr') in
	  let e' = AEApnd (None, detypeE taexpr,
			  if SetofMarker.is_empty setZ then em else
			  AEDUni(None, 
				 em,SetofMarker.hom1 (fun e1 e2 -> AEDUni (None,e1,e2))
				   (fun z -> AEIMrk (None,z,AEOMrk (None,z))) setZ
				)) in
	  (augType env e').saexpr
	else expri)}
*)

(* pmelist : list of pair of marker and expression *)
and substE env pmelist taexpr =
  { taexpr with saexpr = 
    let expri = taexpr.saexpr in
   (match expri with
      SAETEmp
    | SAEGEmp         -> expri
    | SAEOMrk m'      -> (try (let taexpr' = (List.assoc m' pmelist) in taexpr'.saexpr)
                          with  Not_found -> expri)
    | SAEUni (e1,e2)  -> let (e1',e2') = mapT2 (substE env pmelist) (e1,e2) in
			  SAEUni (e1',e2')
    | SAEDUni (e1,e2) -> let (e1',e2') = mapT2 (substE env pmelist) (e1,e2) in
			 SAEDUni (e1',e2')
    | SAEIMrk (m',e1) -> SAEIMrk (m',substE env pmelist e1)
    | SAEEdg (p,e)    -> SAEEdg (p,substE env pmelist e)
    | SAEApnd (e1,e2) -> SAEApnd (e1,substE env pmelist e2)
    | SAEIf (be,et,ef)-> let (et',ef') = mapT2 (substE env pmelist) (et,ef) in
			 SAEIf (be,et',ef') 
    | SAELet (v,ebind,ebody) ->
	let tbind = ebind.vtype in
	let env' = intern_gvtype v tbind env in
	SAELet (v,substE env pmelist ebind,substE env' pmelist ebody)
    | SAELLet (lv,lexpr,ebody) -> 
	let lt = lexpr.ltype in
	let env' = intern_lvtype lv lt env in
	SAELLet (lv,lexpr,substE env' pmelist ebody)
    | SAECyc _
    | SAERec _
    | SAEVar _ -> (* just a fallback rule *)
	let (_,setY) = taexpr.vtype in
	let pmelist = List.filter (fun (m,_) -> SetofMarker.mem m setY) pmelist in
	let setM = SetofMarker.fromList (List.map fst pmelist) in
	if (not (SetofMarker.is_empty setM)) then
	  let setZ = SetofMarker.diff setY setM in
	  let em = SetofMarker.hom1 (fun e1 e2 -> AEDUni (None,e1,e2))
	          (fun m -> AEIMrk (None,m,detypeE (List.assoc m pmelist))) setM
	  in
	  let e' = AEApnd (None, detypeE taexpr,
			  if SetofMarker.is_empty setZ then em else
			  AEDUni(None, 
				 em,SetofMarker.hom1 (fun e1 e2 -> AEDUni (None,e1,e2))
				   (fun z -> AEIMrk (None,z,AEOMrk (None,z))) setZ
				)) in
	  (augType env e').saexpr
	else expri)}

let rewriteTE = rewriteE
let qtypeAE = qtype
let qtypeAL = qtype_lpat
(* let freeVarsTE = freeVarsE *)
(* let dependVarTE = dependVarE *)

(* expose old interface *)
let rewriteE env aexpr = 
  let te  = augType env aexpr in
  let te' = rewriteE env te in
  detypeE te'

let freeVarsE (aexpr: 'a aexpr) =
(* can't use augType, since  augType requires
   type environment. *)
  freeVarsE aexpr
(*
let dependVarE env (aexpr: 'a aexpr) =
  dependVarTE env (augType env aexpr)
*)

(* augType is capable of computing type, so you don't have to
   rely on old qtype family anymore *)
let qtype env aexpr =
  (augType env aexpr).vtype
let qtype_lpat env alpat = 
  (augTypeL env alpat).ltype

let fprefix = "$File_" (* prefix for special variable from doc() *)

let rec elimDoc (aexpr:('a UnCAL.aexpr)) : ((vname*string) list) * 'a UnCAL.aexpr =
   match aexpr with
     AETEmp a                   ->                                                      ([],     AETEmp a)
   | AEGEmp a                   ->                                                      ([],     AEGEmp a)
   | AEVar (a,n)                ->                                                      ([],     AEVar (a,n))
   | AEOMrk (a,m)               ->                                                      ([],     AEOMrk (a,m))
   | AEIMrk (a,m,e)             -> let             (ev,e')   =       elimDoc e       in (ev,     AEIMrk (a,m,e'))
   | AECyc (a,e)                -> let             (ev,e')   =       elimDoc e       in (ev,     AECyc (a,e'))
   | AEDoc (a,s)                -> let           n           = (fprefix ^ s)         in ([(n,s)],AEVar (a,n)) (* FIXME: annot. propagation  *)
   | AEDUni (a,e1,e2)           -> let ((ev1,e1'),(ev2,e2')) = mapT2 elimDoc (e1,e2) in (ev1@ev2,AEDUni (a,e1',e2'))
   | AEUni (a,e1,e2)            -> let ((ev1,e1'),(ev2,e2')) = mapT2 elimDoc (e1,e2) in (ev1@ev2,AEUni  (a,e1',e2'))
   | AEApnd (a,e1,e2)           -> let ((ev1,e1'),(ev2,e2')) = mapT2 elimDoc (e1,e2) in (ev1@ev2,AEApnd (a,e1',e2'))
   | AERec (ae,l,al,t,at,eb,ea) -> let ((evb,eb'),(eva,ea')) = mapT2 elimDoc (eb,ea) in (evb@eva,AERec (ae,l,al,t,at,eb',ea'))
   | AELet (ae,v,av,ea,eb)      -> let ((eva,ea'),(evb,eb')) = mapT2 elimDoc (ea,eb) in (eva@evb,AELet (ae,v,av,ea',eb'))
   | AELLet (ae,l,al,ea,eb)     -> let            (evb,eb')  =       elimDoc     eb  in (evb,    AELLet (ae,l,al,ea,eb'))
   | AEEdg (a,l,e)              -> let            (ev,e')    =       elimDoc      e  in (ev,     AEEdg (a,l,e'))
   | AEIf (a,eb,et,ef)          -> let ((evt,et'),(evf,ef')) = mapT2 elimDoc (et,ef) in (evt@evf,AEIf (a,eb,et',ef'))
and elimDocB (abexpr: 'a abexpr) : ((vname*string) list) * 'a UnCAL.abexpr = 
  match abexpr with
    AIsemp (a,e)       -> let (ev,e')                 =       elimDoc e          in (ev,     AIsemp (a,e'))
  | ABisim (a,e1,e2)   -> let ((ev1,e1'),(ev2,e2'))   = mapT2 elimDoc (e1,e2)    in (ev1@ev2,ABisim (a,e1',e2'))
  | ALcmp (_,p1,op,p2) -> ([],abexpr)
  | ATrue _            -> ([],abexpr)
  | AFalse _           -> ([],abexpr)
  | ALpred (_,alpt,p)  -> ([],abexpr)
  | ANot (a,be)        -> let             (ev, be')   =      (elimDocB be)       in (ev,     ANot (a, be'))
  | AAnd (a,be1,be2)   -> let ((ev1,be1'),(ev2,be2')) = mapT2 elimDocB (be1,be2) in (ev1@ev2,AAnd (a,be1',be2'))
  | AOr  (a,be1,be2)   -> let ((ev1,be1'),(ev2,be2')) = mapT2 elimDocB (be1,be2) in (ev1@ev2,AOr  (a,be1',be2'))

let neweid ?(inc=1) () = 
  let c = GenId.next () in
  GenId.set (c + inc - 1); c

(* Do not expand let in the following numberE, since operand should have
   smaller id. SAECyc e -> SAECyc (number e),neweid () is unacceptable
   since cycle() itself reserve number of ids that is equal to the number
   of input markers *)
let rec numberE taexpr:('a taexpr) =
  let (saexpr,expid) = match taexpr.saexpr with
    SAETEmp -> SAETEmp,neweid ()
  | SAEEdg (lpat,expr) ->
      let expr' = numberE expr in
      SAEEdg (lpat,expr'), neweid ()
  | SAEGEmp -> SAEGEmp, neweid ()
  | SAEOMrk m -> SAEOMrk m, neweid ()
  | SAEIMrk (m,expr) -> 
      let expr' = numberE expr in 
      SAEIMrk (m, expr'),neweid ()
  | SAEVar n -> SAEVar n, neweid ()
  | SAEUni (e1,e2) -> 
      let (e1',e2') = mapT2 numberE (e1,e2) 
      in SAEUni (e1',e2'), neweid ~inc:(SetofMarker.cardinal (fst e1.vtype)) ()
  | SAEDUni (e1,e2) ->
      let (e1',e2') = mapT2 numberE (e1,e2)
      in SAEDUni (e1',e2'), neweid ()
  | SAEApnd (e1,e2) ->
     let (e1',e2') = mapT2 numberE (e1,e2) in
      SAEApnd (e1',e2'), neweid ()
  | SAECyc e ->
      let e' = numberE e in
      SAECyc e', neweid ~inc:(if !cycleSemanticsOriginal then SetofMarker.cardinal (fst e.vtype) else 1) ()
  | SAEIf  (be,et,ef) ->
      let (et',ef') = mapT2 numberE (et,ef) in
      let be' = numberEB be in
      SAEIf (be',et', ef'), neweid ()
  | SAERec (l,t,ebody,earg) ->
      let earg' = numberE earg in
      let ebody' = numberE ebody in
      SAERec (l,t,ebody',earg'), neweid ()
  | SAELet (vlet,ebind,ebody) ->
      let ebind' = numberE ebind in
      let ebody' = numberE ebody in
      SAELet (vlet, ebind', ebody'), neweid ()
  | SAELLet (lv,lbind,ebody) ->
      let lbind' = numberE_lpat lbind in
      let ebody' = numberE      ebody in
      SAELLet (lv,lbind',ebody'), neweid ()
  in {taexpr with saexpr=saexpr;expid=expid}
and numberE_lpat = function
    (* currently identity, since no graph expression is possible inside alpat *)
  | x                         -> x
and numberEB tabexpr:('a tabexpr) = 
  {tabexpr with sabexpr=
   match tabexpr.sabexpr with
     SAIsemp e         -> let e'          =       numberE     e          in SAIsemp e'
   | SABisim (e1,e2)   -> let (e1',e2')   = mapT2 numberE     (e1,e2)    in SABisim (e1',e2')  
   | SALcmp (p1,op,p2) -> let (p1',p2')   = mapT2 numberE_lpat (p1,p2)   in SALcmp (p1',op,p2')
   | SANot be          -> let be'         =       numberEB      be       in SANot   be'
   | SAAnd (be1,be2)   -> let (be1',be2') = mapT2 numberEB     (be1,be2) in SAAnd  (be1',be2') 
   | SAOr  (be1,be2)   -> let (be1',be2') = mapT2 numberEB     (be1,be2) in SAOr   (be1',be2')
   | SATrue            ->                                                   SATrue
   | SAFalse           ->                                                   SAFalse
   | SALpred (alpt,p)  -> let p'          =       numberE_lpat  p        in SALpred (alpt, p')
 }

(* rewrite
   &z@rec(ebody)({dummy:{}})
   into
   &z@cycle((ebody))
   for ad-hoc implementation of let rec values (instead of let rec functions
 *)
let rec rec2cycle (aexpr:('a aexpr)) :'a aexpr =
   match aexpr with
     AETEmp a    -> aexpr
   | AEGEmp a    -> aexpr
   | AEVar (a,n) -> aexpr
   | AEDUni (a,e1,e2) -> let (e1',e2') = mapT2 rec2cycle (e1,e2)            in AEDUni (a,e1',e2')
   | AEUni  (a,e1,e2) -> let (e1',e2') = mapT2 rec2cycle (e1,e2)            in AEUni  (a,e1',e2')
   | AEApnd (a,e1,e2) -> let (e1',e2') = mapT2 rec2cycle (e1,e2)            in 
     (match (a,e1',e2') with
       (a,AEOMrk (_,_),AERec (ar,l,al,t,at,ebody,AEEdg (_,ALLit(_,(ALLbl "dummy")),AETEmp _))) ->
	 AEApnd (a,e1',AECyc (ar,ebody))
     | _ ->   AEApnd (a,e1',e2'))
   | AEDoc (a,s) -> aexpr
   | AEEdg (a,l,e)    -> let     e'    =        rec2cycle   e              in AEEdg (a,l,e')
   | AEIMrk (a,m,e)   -> let     e'    =        rec2cycle   e              in AEIMrk (a,m,e')
   | AEOMrk (a,m)     ->                                                        aexpr
   | AECyc (a,e)      -> let     e'    =        rec2cycle   e              in AECyc (a,e')
   | AEIf (a,eb,et,ef)-> let  eb'      =        rec2cycleB  eb in
                         let (et',ef') = mapT2  rec2cycle  (et,ef)         in AEIf (a,eb',et',ef')
   | AERec (ar,l,al,t,at,ebody,earg) ->
       let earg'  = rec2cycle earg  in
       let ebody' = rec2cycle ebody in
       AERec (ar,l,al,t,at,ebody',earg')
  | AELet (a,vname,av,ebind,ebody) ->
      let ebind' = rec2cycle ebind in
      let ebody' = rec2cycle ebody in
      AELet (a,vname,av,ebind',ebody')
  | AELLet (a,lname,al,eb,ebody) ->
      let ebody' = rec2cycle ebody in
      AELLet (a,lname,al,eb,ebody')
and rec2cycleB  (abexpr: 'a abexpr) : 'a abexpr =
    match abexpr with
      AIsemp (a,e)       -> let e'        =       rec2cycle   e        in AIsemp (a,e')
    | ABisim (a,e1,e2)   -> let (e1',e2') = mapT2 rec2cycle  (e1,e2 )  in ABisim (a,e1',e2')
    | ALcmp (a,p1,op,p2) -> abexpr
    | ANot (a,be)        -> let be'        =      rec2cycleB  be       in ANot (a,be')
    | AAnd (a,be1,be2)   -> let (be1',be2')=mapT2 rec2cycleB (be1,be2) in AAnd (a,be1',be2')
    | AOr  (a,be1,be2)   -> let (be1',be2')=mapT2 rec2cycleB (be1,be2) in AOr (a,be1',be2')
    | ATrue a            ->                                                  abexpr
    | AFalse a           ->                                                  abexpr
    | ALpred (a,alpt,p)  -> abexpr
