(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
(* Mostly verbatim copy of doc/kztk/insertion-handling/testInsert.ml *)
(* Commented out codes are removed *)

open PrintUnCALDM   (* open TestUnCALutil *)  open Fputil
open UnCALMAST
open EvalUnCAL
open UnCALdynenv
open UnCALenv
open ECenv
open UnCALSAST
open UnCALSA
open UnCAL
open PrintUnCAL
open UnCALDM
open UnCALDMutil

open Dotutil

open BiEvalUnCAL

(**
   Test file for insertion handling.
*)



let liftOption (f: 'a -> 'b) (a: 'a option) : 'b option
    = match a with 
      | Some x -> Some (f x)
      | None   -> None

let liftOption2 (f:'a -> 'b -> 'c) (a:'a option) (b:'b option) : 'c option
    = match a,b with
      | Some x, Some y ->
	  Some (f x y)
      | _,_ ->
	  None

let fromSome x =
  match x with 
    | Some a  -> a 
    | None    -> failwith "fromSome: None"

let bindOption (a : 'a option) (f : 'a -> 'b option) : 'b option =
  match a with 
    | Some x -> f x 
    | None   -> None 

let curry f a b     = f (a,b)
let uncurry f (a,b) = f a b 


type ins_unit = 
    {
      dst   : SetofVtx.t; (* dst *)
      src   : SetofVtx.t; (* src *)
      graph : graph;      (* graph to be inserted *)
    }


let insEmpty = 
    { dst   = SetofVtx.empty ;
      src   = SetofVtx.empty ;
      graph = emptyGraph ; }



(* ------------------------------------------ *)
(* From biEvalUnCAL.ml *)

let parseUnCAL_file   = Parse.parse_file   ~parse:ParseUnCAL.entry ~lex:LexUnCAL.token
let parseUnCAL_string = Parse.parse_string ~parse:ParseUnCAL.entry ~lex:LexUnCAL.token
let parseUnCAL_file   = (map_info (fun _ -> None)) @@ parseUnCAL_file 
let parseUnCAL_string = (map_info (fun _ -> None)) @@ parseUnCAL_string 

(* ------------------------------------------ *)

(****************** HIDAKA *********************
module SetofAllit = Set.Make (
  struct 
    type t = allit 
    let compare = Pervasives.compare 
  end 
) *********************************************)

type guess_result =
  | GR_In    of SetofAllit.t
  | GR_NotIn of SetofAllit.t


let rec collectVarsInBExp be =
  match be with
(*  | ALeq  (e1,e2)   ->
        collectVarsInLPat e1 @ collectVarsInLPat e2 *) (* DEPRECATED *)
    | ANot (_,e) ->
        collectVarsInBExp e
    | AAnd (_,e1,e2) ->
        collectVarsInBExp e1 @ collectVarsInBExp e2
    | AOr  (_,e1,e2) ->
        collectVarsInBExp e1 @ collectVarsInBExp e2
    | ALcmp (_,e1,_,e2) ->
        collectVarsInLPat e1 @ collectVarsInLPat e2
    | ALpred (_,_,e1) ->
        collectVarsInLPat e1
    | _ ->
        []
and collectVarsInLPat e =
  match e with
    | ALVar (_,v) ->
        [v]
    | ALBin (_,e1,_,e2) ->
        collectVarsInLPat e1 @ collectVarsInLPat e2
    | _ -> []


let containsUnknownVar rho be = 
  let vs = collectVarsInBExp be.abexpr in
    List.exists (fun v -> 
                   match (lookupLVar rho v) with 
                       ALUkn -> true
                     | _     -> false) vs


let rec guess_variable v be = 
  let s = SetofAllit.singleton in
  let e = SetofAllit.empty in 
  match be with 
(*  | ALeq (p1,p2) ->
	(match p1,p2 with 
	     ALLit a, ALVar v' ->
	       if v = v' then GR_In (s a) else GR_NotIn e
	   | ALVar v', ALLit a ->
	       if v = v' then GR_In (s a) else GR_NotIn e
	   | _ -> failwith "???")  *) (* DEPRECATED *)
    | ANot (_,abe) ->
	(match (guess_variable v abe) with 
	   | GR_In    x -> GR_NotIn x
	   | GR_NotIn x -> GR_In    x) 
    | AAnd (_,abe1,abe2) ->
	let r1 = guess_variable v abe1 in
	let r2 = guess_variable v abe2 in
	  (match r1,r2 with 
	       GR_In x,    GR_In y    -> GR_In (SetofAllit.inter x y)
	     | GR_NotIn x, GR_In y    -> GR_In (SetofAllit.diff y x)
	     | GR_In x,    GR_NotIn y -> GR_In (SetofAllit.diff x y)
	     | GR_NotIn x, GR_NotIn y -> GR_NotIn (SetofAllit.union x y))
    | AOr (_,abe1,abe2) ->
	let r1 = guess_variable v abe1 in
	let r2 = guess_variable v abe2 in
	  (match r1,r2 with 
	       GR_In x,    GR_In y    -> GR_In (SetofAllit.union x y)
	     | GR_NotIn x, GR_In y    -> GR_NotIn (SetofAllit.diff x y)
	     | GR_In x,    GR_NotIn y -> GR_NotIn (SetofAllit.diff y x)
	     | GR_NotIn x, GR_NotIn y -> GR_NotIn (SetofAllit.inter x y))	
    | ALcmp (_,p1,ALOEq ,p2) ->
	(match p1,p2 with
	     ALLit (_,a), ALVar (_,v') ->
	       if v = v' then GR_In (s a) else GR_NotIn e
	   | ALVar (_,v'), ALLit (_,a) ->
	       if v = v' then GR_In (s a) else GR_NotIn e
	   | _ ->
	       failwith "???")
    | _ -> failwith "guess_variable: not implemented" 
	  
let rec remove_irrelevent v be =
  let irrelevent be =
    let vs = collectVarsInBExp be in
      not (List.mem v vs) in
    match be with
      | ANot (a,e) -> 
	  ANot (a,remove_irrelevent v be)
      | AOr (a,e1,e2) ->
	  if irrelevent e1 then
	    remove_irrelevent v e2
	  else if irrelevent e2 then 
	    remove_irrelevent v e1
	  else
	    AOr (a,remove_irrelevent v e1, remove_irrelevent v e2)
      | AAnd (a,e1,e2) ->
	  if irrelevent e1 then
	    remove_irrelevent v e2
	  else if irrelevent e2 then 
	    remove_irrelevent v e1
	  else
	    AAnd (a,remove_irrelevent v e1, remove_irrelevent v e2)
      | _ -> be 
	  


let rec remove_unsupported_constraint be =
  let rec removable be =
    match be with
      | ANot (_,e)        -> removable be
      | AOr  (_,e1,e2)    -> removable e1 && removable e2
      | AAnd (_,e1,e2)    -> removable e1 && removable e2
      | ALcmp (_,e1,c,e2) ->
	  (match c with
	       ALOLt -> true 
	     | ALOGt -> true
	     | _     -> false)
      | ALpred _ ->
	  true
      | AIsemp _ -> 
	  true
      | _ -> false in     
  match be with
    | ANot (a,e) ->
	ANot (a,remove_unsupported_constraint e)
    | AOr (a,e1,e2) ->
	if removable e1 then
	  remove_unsupported_constraint e2
	else if removable e2 then
	  remove_unsupported_constraint e1
	else	    
	  AOr (a,remove_unsupported_constraint e1, 
	         remove_unsupported_constraint e2)
    | AAnd (a,e1,e2) ->
	if removable e1 then 
	  remove_unsupported_constraint e2 
	else if removable e2 then
	  remove_unsupported_constraint e1
	else
	  AAnd (a,remove_unsupported_constraint e1, 
		  remove_unsupported_constraint e2)
    | _ -> be 
	


let rec substitute_abexpr_by rho abe =
  match abe with
    | AIsemp (a,e) -> 
	AIsemp (a,e)
    | ABisim (a,e1,e2) ->
	ABisim (a,e1,e2)
    | ANot (a,abe) ->
	ANot (a,substitute_abexpr_by rho abe)
    | AAnd (a,abe1,abe2) ->
	AAnd (a,substitute_abexpr_by rho abe1, substitute_abexpr_by rho abe2)
    | AOr (a,abe1,abe2) ->
	AOr (a,substitute_abexpr_by rho abe1, substitute_abexpr_by rho abe2)
    | ALcmp (a,p1,c,p2) ->
	ALcmp (a,substitute_alpat_by rho p1, c, substitute_alpat_by rho p2)
    | ATrue a ->
	ATrue a
    | AFalse a ->
	AFalse a
    | ALpred (a,pt,p)->
	ALpred (a,pt, substitute_alpat_by rho p)
and substitute_alpat_by rho p =
  match p with
    | ALVar (a,l) ->
	(match lookupLVar rho l with
	     ALUkn -> ALVar (a,l)
	   | v     -> ALLit (a,v))
    | ALLit (a,l) ->
	ALLit (a,l)
    | ALBin (a,p1,b,p2) ->
	ALBin (a,substitute_alpat_by rho p1, b, substitute_alpat_by rho p2)
	
	
let rec evaluate_partially_abexpr be =
    match be with 
(*    | ALeq (_,p1,p2) ->
	  let p1 = evaluate_partially_alpat p1 in
	  let p2 = evaluate_partially_alpat p2 in
	    (match p1,p2 with
		 ALLit (_,l1), ALLit (_,l2) ->
		   if l1 = l2 then ATrue None else AFalse None
	    | _ -> failwith "evaluate_partially_abexpr: not implemented" 	    ) *) (* DEPRECATED *)
      | ANot (a,abe) ->
	  (match (evaluate_partially_abexpr abe) with
	       ATrue a  -> AFalse a
	     | AFalse a -> ATrue a
	     | x      -> ANot (a,x))
      | AAnd (a,abe1,abe2) ->
	  (match (evaluate_partially_abexpr abe1,evaluate_partially_abexpr abe2) with
	       ATrue _, y   -> y
	     | x, ATrue _   -> x
	     | AFalse a,_   -> AFalse a
	     | _,AFalse a   -> AFalse a
	     | x,y          -> AAnd (a,x,y))
      | AOr (a,abe1,abe2) ->
	  (match (evaluate_partially_abexpr abe1,evaluate_partially_abexpr abe2) with
	       ATrue a, _   -> ATrue a
	     | _, ATrue a   -> ATrue a
	     | AFalse _,y   -> y
	     | x,AFalse _   -> x
	     | x,y          -> AAnd (a,x,y))
      | ALcmp (a,p1,c,p2) ->
	  let p1 = evaluate_partially_alpat p1 in
	  let p2 = evaluate_partially_alpat p2 in
	    (match p1,p2 with
		 ALLit (_,l1), ALLit (_,l2) -> 
		   if evall_cmp l1 c l2 then ATrue None else AFalse None
	       | _, _ ->
		   ALcmp (a,p1,c,p2))
      | ALpred (a,pt,p) ->
	  (match evaluate_partially_alpat p with
	       ALLit (_,l) ->
		 (match pt,l with 
		      ALPLbl, ALLbl _ -> ATrue None
		    | ALPStr, ALStr _ -> ATrue None
		    | ALPInt, ALInt _ -> ATrue None
		    | ALPFlt, ALFlt _ -> ATrue None
		    | ALPBol, ALBol _ -> ATrue None
		    | _,_             -> AFalse None)
	     | x ->
		 ALpred (a,pt,x))
      | x -> x 
and evaluate_partially_alpat = function
    ALVar (a,l) -> ALVar (a,l)
  | ALLit (a,l) ->
      ALLit (a,l)
  | ALBin (a,p1,b,p2) ->
      let p1 = evaluate_partially_alpat p1 in
      let p2 = evaluate_partially_alpat p2 in
	(match p1,p2 with
	     ALLit (_,l1), ALLit (_,l2) ->
	       ALLit (None,evall_bin l1 b l2)
	   | _,_ ->
	       ALBin (a,p1,b,p2))

    
  
	
	
	
let list_minus l1 l2 =
  List.filter (fun x -> not (List.mem x l2)) l1 


let bwd_Bexp_impl rho be = 
  if containsUnknownVar rho be then
    let abe  = be.abexpr in
    let cabe = evaluate_partially_abexpr (substitute_abexpr_by rho abe) in
    let cabe = remove_unsupported_constraint cabe in
    let vs  = (collectVarsInBExp cabe) in
      try (let ls  = List.map (fun v -> guess_variable v (remove_irrelevent v cabe)) vs in
	   let vls = List.combine vs ls in
	   let rho' = 
	     List.fold_left (fun r -> fun (v,l) ->
			       match l with 
				   GR_In x ->
				     if SetofAllit.cardinal x = 1 then 
				       replace_bindingL v (SetofAllit.choose x) r
				     else 
				       r
				 | _ -> r 
			    ) rho vls in
	     rho')
      with _ ->
	rho 
  else
    if eval_Bexp rho be then
      rho 
    else
      failwith "Condition cannot be true"

let bwd_Bexp rho be b =
  if b then 
    bwd_Bexp_impl rho be 
  else
    bwd_Bexp_impl rho {abexpr  = ANot (None,be.abexpr); 
		       sabexpr = SANot be }

      
  



  

let stripHub v = 
  match v with
      Hub (v,_,_) -> v 
    | v           -> v 


let stripFrE_iu iu =
  { dst   = SetofVtx.map stripFrE iu.dst;
    src   = SetofVtx.map stripFrE iu.src;
    graph = map_VEIO stripFrE iu.graph }


let bdIverbose = ref false

let print_string : (string -> unit) = fun arg ->
  if !bdIverbose then Pervasives.print_string arg

let ppr_aexpr (fmt:Format.formatter)  (exp:'a aexpr) =
  if !bdIverbose then ppr_aexpr fmt exp

let pr_dynenv (fmt:Format.formatter)  (env:dynenv) =
  if !bdIverbose then pr_dynenv fmt env

(* must be called under skolemBulk = true *)
let rec bd_evalI 
    (rho : dynenv)
    (taexpr : 'a taexpr)
    : ( graph option * ( graph -> ins_unit list -> dynenv ) ) = 
  let eid = taexpr.expid in
  match taexpr.saexpr with 
    | SAETEmp ->
	let _ = print_string "enter {} Fwd\n" in 
        let emptyTree = (!<>) ~expid:eid () in
	  (Some emptyTree, fun g' -> fun ins -> 
	     if g' = emptyTree then 
	       let _ = print_string "enter {} Bwd\n" in 
	       rho 
	     else
	       let _ = print_string "-----------------------------------------\n" in
	       let _ = print_string (graph2str g') in 
	       raise (Eval_Bwd "bd_evalI: no modifications allowed for empty trees."))
    | SAEGEmp -> 
	(Some emptyGraph, fun g' -> fun ins ->
	   if g' = emptyGraph then
	     rho
	   else 
	     raise (Eval_Bwd "bd_evalI: no modifications allowed for empty graphs."))
    | SAEOMrk m -> 
	let _ = print_string "enter &MRK Fwd\n" in 
        let g = (!&) ~expid:eid m in
	  (Some g, fun g' -> fun ins -> 
	     let _ = print_string "enter &MRK Bwd\n" in 
	     if g' = g then
	       rho
	     else
	       let s1 = graph2str g  in
	       let s2 = graph2str g' in 
	       raise (Eval_Bwd ("bd_evalI: no modifications allowed for output nodes." ^ s1 ^ " <> " ^ s2)))
    | SAEEdg (lpat,expr) ->
	let _ = print_string "enter {_:_} Fwd\n" in
        let (l,bfL) = bd_evalL rho lpat in
        let (t,bf)  = bd_evalI rho expr in
        let g       = liftOption2 ((/:) ~expid:eid) (Some l) t in
	  (g, fun g' -> fun ins -> 
	     let _ = print_string "enter {_:_} Bwd\n" in
	     (* let _ = print_string (graph2str g') in  *)
	     let (l',t') = decompose_AEEdg l (fromSome t) (fromSome g) g' in
	     (* let _ = print_string (graph2str t') in  *)
	       uplus_cmp (bfL l') (bf t' ins) rho)
    | SAEVar v -> 
	let _ = print_string "enter $VAR Fwd\n" in
        let g = lookupVar rho v in
	  (Some g, fun g' -> fun ins -> 
	     let _ = print_string "enter $VAR Bwd\n" in
	       replace_bindingG v g' rho)
    | SAEApnd (e1,e2) -> (* @ *)
        let (g1,bf1) = bd_evalI rho e1 in
        let (g2,bf2) = bd_evalI rho e2 in
        let g        = liftOption2 ((@&) ~expid:eid) g1 g2 in
	  (g, fun g' -> fun ins -> 
	     let (g1',g2') = decompose_AEApnd eid (fromSome g1) (fromSome g2) (fromSome g) g' in
	       uplus_cmp (bf1 g1' ins) (bf2 g2' ins) rho)
    | SAECyc e -> (* cycle *)
        let (g0,bf0) = bd_evalI rho e in
        let g        = liftOption ((!!<>) ~expid:eid) g0 in
	  (g, fun g' -> fun ins -> 
	     let g0' = decompose_AECyc (fromSome g0) (fromSome g) g' in 
	       bf0 g0' ins)
    | SAEUni (e1,e2) -> (* U *)
        let (g1,bf1) = bd_evalI rho e1 in
        let (g2,bf2) = bd_evalI rho e2 in 
        let g        = liftOption2 ((+|) ~expid:eid) g1 g2 in
	  (g, fun g' -> fun ins -> 
	     let (g1',g2') = decompose_AEUni (fromSome g1) (fromSome g2) (fromSome g) g' in
	       uplus_cmp (bf1 g1' ins) (bf2 g2' ins) rho)
    | SAEDUni (e1,e2) -> (* (+) *)
        let (g1,bf1) = bd_evalI rho e1 in
        let (g2,bf2) = bd_evalI rho e2 in 
        let g        = liftOption2 (|++) g1 g2 in
	  (g, fun g' -> fun ins ->
	     let (g1',g2') = decompose_AEDUni (fromSome g1) (fromSome g2) (fromSome g) g' in
	       uplus_cmp (bf1 g1' ins) (bf2 g2' ins) rho)
    | SAEIMrk (m,expr) ->
	let _ = print_string "enter IMrk Fwd\n" in 
        let (g1,bf1) = bd_evalI rho expr in
        let g        = liftOption2 (^:=) (Some m) (g1) in
	  (g, fun g' -> fun ins ->
	     let _ = print_string "enter IMrk Bwd\n" in 
	     let g1' = decompose_AEIMrk m (fromSome g1) (fromSome g) g' in
	       bf1 g1' ins)
    | SAEIf (be,et,ef) -> (* FIXME: consider "$a = v or true" *)
        if containsUnknownVar rho be then
	  let _ = print_string "enter if Fwd w/ Unk\n" in
	  (None, fun g' -> fun ins ->
	     let _ = print_string "enter if w/ Unk\n" in	  
	       try (let _       = ppr_aexpr Format.std_formatter taexpr.aexpr in		  
		    let _       = print_string "\n" in
	            let (_,bft) = bd_evalI rho et in
		    let _       = print_string "Hello Unk?\n" in
(* 		    let _       = pr_dynenv Format.std_formatter rho in *)
		    let rho'    = bft g' ins in
 		    let _       = print_string "Unk Yeah T!\n" in 
		    let rho''   = bwd_Bexp rho' be true in
		    let _       = print_string "rho'' from true \n" in 
		    let _       = pr_dynenv Format.std_formatter rho'' in
		    let rho''   = uplus_cmp rho' rho'' rho in
		      if eval_Bexp rho'' be then
			rho''
		      else 
			failwith "Failed to make true")
	       with _ ->
		 let _ = print_string "examining false...\n" in
	       (* let _ = print_string (graph2str g') in *)
		 let (_, bff) = bd_evalI rho ef in
		 let _        = print_string "Unk Year F!" in 
		 let rho'     = bff g' ins in
		 let rho''    = bwd_Bexp rho' be false in
		 let rho''   = uplus_cmp rho' rho'' rho in
		   if not (eval_Bexp rho'' be) then
		     rho''
		   else 
		     failwith "Failed to make false")
        else
	  let _ = print_string "enter if Fwd w/o Unk\n" in
	  let flag = eval_Bexp rho be in (* normal forward evaluation *)
	  let (g,bf) = bd_evalI rho (if flag then et else ef) in
	    (g, fun g' -> fun ins ->
	       let _ = print_string "enter if w/o Unk\n" in
	       try (
		 let _       = print_string "Hello If?\n" in
		 let _       = ppr_aexpr Format.std_formatter taexpr.aexpr in
		 let _       = print_string "\n" in
		 let _       = pr_dynenv Format.std_formatter rho in
 		 let _       = print_string (graph2str g') in
		 let rho'  = bf g' ins in
		 let _       = print_string "If? Year!\n" in 
		 let flag' = eval_Bexp rho' be (* check for branching *) in
	           if flag = flag' then rho'
	           else failwith "Branching mismatch")
	       with _ -> (* branching behavior changed *)
		   (Printf.fprintf stdout  "bd_eval(if): branch behavior changed \n%!";
		    if (flag = true) then
		      let _ = Printf.fprintf stdout  "bd_eval(if): trying false branch \n%!" in
		      let (_,bf) = bd_evalI rho ef in bf g' ins
		    else (*  ((flag = false) && (flag' = true)) *)
		      let _ = Printf.fprintf stdout  "bd_eval(if): trying true branch \n%!" in
		      let (_,bf) = bd_evalI rho et in bf g' ins))
    | SAELet (v,ebind,ebody) -> (* FIXME:gbin can be none *)
        let (gbin,bfbin) = bd_evalI rho ebind in
	let (gbod,bfbod) = bd_evalI (intern_gv v (fromSome gbin) rho) ebody in
	  (gbod, fun g' -> fun ins ->
	     let rho1' = bfbod g' ins in
	     let rho'  = bfbin (lookupVar rho1' v) ins in
	     let rho1' = unintern_gv v rho1' in
	       uplus_cmp rho1' rho' rho)
    | SAELLet (v,lbind,ebody) -> (* FIXME? *)
        let (llbin,bfL) = bd_evalL rho lbind in
        let (gbod,bf)   = bd_evalI (intern_lv v llbin rho) ebody in
	  (gbod, fun g' -> fun ins ->
	     let rho1' = bf g' ins in
	     let rho'  = bfL (lookupLVar rho1' v) in
	     let rho1' = unintern_lv v rho1' in
	       uplus_cmp rho1' rho' rho)
    | SAERec (l,t,ebody,earg) ->
	let _ = print_string "enter rec Fwd \n" in
        let (d,bfa) = bd_evalI rho earg in
	let _ = print_string "before fromSome of arg\n" in
        let d = fromSome d in
	let _ = print_string "after  fromSome of arg\n" in
        let setZ = uncurry (SetofMarker.union) ebody.vtype in	
(* 	let _ = print_string (graph2str d) in  *)
        let (outgoEdgeS_d,incomEdgeS_d,_,_) = build_ioedge_ionode_map d in
(* 	let _ = print_string "!\n" in  *)
	let (epsEdgS,nonEpsEdgS) = SetofEdge.partition isEpsEdge d.e in
        let ebodyEps = ebodyEpsExpr setZ in
        let mapE =
	  (SetofEdge.fold (fun (u,a,v) mE ->
	                     if MapofEdge.mem (u,a,v) mE then mE else 
	                       MapofEdge.add (u,a,v)				 
	                         (let dv   = make_dv_with_oEmap outgoEdgeS_d d v in
		                  let rho1 = intern_gv t dv (intern_lv l a rho)  in
		                    bd_evalI rho1 ebody) mE) d.e MapofEdge.empty) in
        let pmapE = MapofEdge.map (fun (gi,_) -> fromSome gi) mapE in
	  
        (************** (4) compose g according to mapE *****************)
        let (g,hubV,spokeEps,s1s1Eps) 
	    = dfwd_AERec eid setZ (epsEdgS,nonEpsEdgS) pmapE incomEdgeS_d outgoEdgeS_d d in
        let bf = fun g' -> fun ins ->
	  let _ = print_string "enter rec\n" in
	  let hasInsertionHappened iu hubV = 
	    SetofVtx.subset (iu.dst) hubV
	    && SetofVtx.subset (iu.src) hubV
	    && not (SetofVtx.is_empty (iu.dst))
	    && not (SetofVtx.is_empty (iu.src)) in
	  let orgVertexSrc iu =
	    let u = stripHub (SetofVtx.choose (iu.src)) in u in
	  let orgVertexDst iu =
	    let v = stripHub (SetofVtx.choose (iu.dst)) in v in 
	  let insGraph iu = 
	    let g = stripFrE_VEIO iu.graph in g in

	  let mapE' = decompose_AERec eid pmapE hubV spokeEps s1s1Eps g' in
	    
	  (******** (3)' recursively evaluate the body backwards **********)
	  let lookupMEbody u a v = try (MapofEdge.find (u,a,v) mapE) with
	      Not_found -> failwith ("lookupMEbody(bd_eval_AERec): not found.") in
	    (* backward transformation along non-epsilon edges *)
	  let insBody =
	    List.fold_right
	      (fun iu -> fun r ->
		 if hasInsertionHappened iu hubV then
		   r
		 else 
		   stripFrE_iu iu::r) ins [] in 
	    
	  let d = 
	    let e' =
	      List.fold_right (fun iu -> fun r ->
		 if hasInsertionHappened iu hubV then 
		   let u   = orgVertexSrc iu in
		   let v   = orgVertexDst iu in 
		     SetofEdge.add (u,ALUkn,v) r
		 else
		   r) ins d.e in
	      {v = d.v; e = e'; i = d.i; o = d.o} in 

	  let _ = print_string "--------------------\n" in 
	  let _ = print_string "d = " in 
	  let _ = print_string (graph2str d) in 
	  let _ = print_string "\n" in
	  let _ = print_string "--------------------\n" in 
	    

          let (outgoEdgeS_d,incomEdgeS_d,_,_) = build_ioedge_ionode_map d in
	  
	    
	  let mapRho' = 
	    MapofEdge.fold 
	      (fun (u,a,v) gi' m ->
	         if (a <> ALEps) then
		   ((* let (_,bfi) = (lookupMEbody u a v) in *)
		     let (_,bfi) = 
		       let dv   = make_dv_with_oEmap outgoEdgeS_d d v in
		       let rho1 = intern_gv t dv (intern_lv l a rho)  in
			 bd_evalI rho1 ebody in		     		     
		     let rho' = bfi gi' insBody in 
		       MapofEdge.add (u,a,v) rho') m
	         else m) mapE' MapofEdge.empty in
	  let mapRho' =
	    List.fold_right 
	      (fun iu -> fun r ->
		 if hasInsertionHappened iu hubV then 
		   let u   = orgVertexSrc iu in
		   let v   = orgVertexDst iu in 
(* 		   let _ = pr_vtx Format.std_formatter u  in  *)
(* 		   let _ = pr_vtx Format.std_formatter v  in  *)
		   let gi' = insGraph iu in
		   let (_,bfi) = 
		     let dv   = make_dv_with_oEmap outgoEdgeS_d d v in
		     let rho1 = intern_gv t dv (intern_lv l ALUkn rho)  in
		       bd_evalI rho1 ebody in		     
		   let rho' = bfi gi' insBody in 
(* 		   let _ = print_string "Hello!!!!!" in *)
(* 		   let _ = print_string (graph2str gi') in *)
(* 		   let _ = pr_dynenv Format.std_formatter rho' in *)
		     MapofEdge.add (u, ALUkn, v) rho' r		       
		 else
		   r		   
	      ) ins mapRho' in 
	    
	  (*          let d' = restore_input_AERecI l t mapRho' d g' uvrho_Ins in *)

	  let d' = restore_input_AERec l t mapRho' d g' in
	  let _ = print_string "--------------------\n" in 
	  let _ = print_string "d' = \n" in 
	  let _ = print_string (graph2str d') in 
	  let _ = print_string "\n" in 
	  let _ = print_string "--------------------\n" in 

	  let v =
	    SetofEdge.fold (fun (u,a,v) -> fun r ->
			      SetofVtx.add u (SetofVtx.add v r)) d'.e d'.v  in
	  let d' = {d' with v = v; } in

	  let _ = print_string (graph2str d') in 
	  let _ = print_string "\n" in 

	    
	    
	  (******** (1)' backwared evaluation of the argument **************)
	  let rho'' = bfa d' [] in (* FIXME: ins should be insEmpty? *)

	  (******** (0)' merge rho'', rho and each member of mapRho' *******) 
	  (* remove bindings of l and t from mapRho' entries *)
	  let mapRho' = MapofEdge.map 
	    (fun env -> unintern_gv t (unintern_lv l env)) mapRho' in
	    (* merge rho and each member of mapRho' *)
	  let mgrho''  = biguplus_cmp mapRho' rho in
(*           let mgrho'' = *)
(*             match uvrho_Ins with *)
(*               | Some (_,_,r) -> uplus_cmp mgrho'' (unintern_gv t (unintern_lv l r)) rho *)
(*               | None         -> mgrho'' in *)
	    (* merge mgrho'' and rho'' *)
	  let rho''' = uplus_cmp mgrho'' rho'' rho in
	  let _     = print_string "leave rec\n" in
	    rho''' in
          (Some g,bf)
		  
		  
		  
and bd_eval_topI rho aexpr = 
  let stEnv = dynenv2stenv rho in
  let texpr = augType stEnv aexpr in
  let nexpr = numberE texpr in 
    bd_evalI rho nexpr


type test_mode = 
  | TestExp 
  | TestFwd
  | TestBwd

		  
let test_db = 
  let idState = GenId.current () in
  let ()      = GenId.set 0 in
  let _ = skolemBulk := true in
(* HIDAKA inlined access to file depends current workin directory 
   let d       = (clean_id @@ remove_eps @@ load_db @@ parseUnCAL_file) "../examples/bd_db.uncal" in *)
  let d       = (clean_id @@ remove_eps @@ load_db @@ parseUnCAL_string) 
      "cycle((
         &  := {a:{a:&z1},b:{a:&z1},c:&z2},
         &z1:= {d:{}},
         &z2:= {c:&z2}
  ))" in 
  let ()     =  GenId.set (idState) in
    d
  
let test ?(fwd_dot_file="") ?(bwd_dot_file="") ?(write_dot=false) ?(out_graph) ?(insertion_units=[]) uncal db =
  let idState = GenId.current () in
  let ()      = GenId.set 0 in
  let _ = skolemBulk := true in
  let rho = (intern_gv "$db" db emptyDynEnv) in
  let (g,bf) = bd_eval_topI rho uncal in 
    fun m ->
      match m with
	  TestExp ->
	    let stEnv = dynenv2stenv rho in
	    let texpr = augType stEnv uncal in
	    let nexpr = numberE texpr in 
	      `TestExp nexpr 
	| TestFwd ->
	    begin
	      match g with
		  Some graph ->
		    let _ = if write_dot then g2dot_file ~shape:`ellipse (graph) fwd_dot_file else () in 
		    let ()     =  GenId.set (idState) in
		      `TestFwd graph
		| _ ->
		    failwith "Error"
	    end
	| TestBwd ->
	    let rho' = bf (fromSome out_graph) insertion_units in
	    let ()  =  GenId.set (idState) in
	      (* rho *)
	    let db' = lookupVar rho' "$db" in 
	    let _ = print_string "PUTTING is DONE\n" in
	    let _ = if write_dot then g2dot_file ~shape:`ellipse (db') bwd_dot_file else () in
	      `TestBwd db'
	      
	    


	
	  
let test_ev uncal db_file =
  let db      = (clean_id @@ remove_eps @@ load_db @@ parseUnCAL_file) db_file in
  let rho = (intern_gv "$db" db emptyDynEnv) in
  let (g,bf) = bd_eval_topI rho uncal in
    (g,bf)

      
let test_exp1 () =
  let idState = GenId.current () in
  let ()      = GenId.set 0 in
  let uncal = parseUnCAL_string 
    "rec(\\ ($l,$g).if $l = a then {d: &} else if $l = c then & else {$l: &})($db)" in
  let db_file  = "../examples/bd_db.uncal" in
  let db      = (clean_id @@ remove_eps @@ load_db @@ parseUnCAL_file) db_file in
  let rho = (intern_gv "$db" db emptyDynEnv) in
  let stEnv = dynenv2stenv rho in
  let texpr = augType stEnv uncal in
  let nexpr = numberE texpr in
    nexpr 
      
let test_get1 () =
  let idState = GenId.current () in
  let ()      = GenId.set 0 in
  let _ = skolemBulk := true in
  let db_file  = "../examples/bd_db.uncal" in
  let dot_file = "./test.dot" in
  let uncal = parseUnCAL_string 
    "rec(\\ ($l,$g).if $l = a then {d: &} else if $l = c then & else {$l: &})($db)" in
  let (g,bf) = test_ev uncal db_file in
    match g with
	Some graph ->
	  let _ = g2dot_file ~shape:`ellipse (graph) dot_file in 
	  let ()     =  GenId.set (idState) in
	    g
      | _ ->
	  failwith "Error"
 
		  
    
let test_put1 () =
  let idState = GenId.current () in
  let ()      = GenId.set 0 in
  let _ = skolemBulk := true in
  let db_file  = "../examples/bd_db.uncal" in
  let dot_file_in  = "./test_in.dot" in
  let dot_file_out = "./test_out.dot" in
  let uncal = parseUnCAL_string 
    "rec(\\ ($l,$g).if $l = a then {d: &} else if $l = c then & else {$l: &})($db)" in
  let ins = 
    let vertex1 = Hub (Bid 2, "&", 43) in
    let vertex2 = Hub (Bid 3, "&", 43) in
    let edge    = (Bid 2, ALUkn, Bid 3) in
      { src = SetofVtx.fromList [vertex1];
	dst = SetofVtx.fromList [vertex2];
	graph = 
	  let v1 = FrE(InT 37, edge, 43) in
	  let v2 = FrE(InT 36, edge, 43) in 
	    {
	      v = SetofVtx.fromList  [v1;v2];
	      e = SetofEdge.fromList [(v1,ALLbl "e",v2)];
	      i = SetofInodeR.singleton ("&",v1);
	      o = SetofOnodeR.singleton (v2,"&");
	    };
      } in
  let ins' =
    let vertex1 = Hub (Bid 5, "&", 43) in
    let vertex2 = Hub (Bid 2, "&", 43) in
    let edge    = (Bid 5, ALUkn, Bid 2) in
    { src = SetofVtx.fromList [vertex1];
      dst = SetofVtx.fromList [vertex2];
      graph = 
	let v1 = FrE(InT 41, edge, 43) in
	let v2 = FrE(InT 40, edge, 43) in 
	  {
	    v = SetofVtx.fromList  [v1;v2];
	    e = SetofEdge.fromList [(v1,ALLbl "d",v2)];
	    i = SetofInodeR.singleton ("&",v1);
	    o = SetofOnodeR.singleton (v2,"&");
	  };
    } in
  let ins'' = (* Fails *)
    let vertex1 = Hub (Bid 2, "&", 43) in
    let vertex2 = Hub (Bid 3, "&", 43) in
    let edge    = (Bid 2, ALUkn, Bid 3) in
    { src = SetofVtx.fromList [vertex1];
      dst = SetofVtx.fromList [vertex2];
      graph = 
	let v1 = FrE(InT 38, edge, 43) in
	  {
	    v = SetofVtx.fromList  [v1];
	    e = SetofEdge.fromList [];
	    i = SetofInodeR.singleton ("&",v1);
	    o = SetofOnodeR.singleton (v1,"&");
	  };
    } in
  let (g,bf) = test_ev uncal db_file in
    match g with
	Some graph ->
	  (* let _ = g2dot_file ~elliptic:true (graph) dot_file_in in *)
	  let rho = bf graph [ins''] in
	  let ()     =  GenId.set (idState) in
	    (* rho *)
	  let db' = lookupVar rho "$db" in 
	  let _ = g2dot_file ~shape:`ellipse (db') dot_file_out in
	    db'
      | _ ->
	  failwith "Error"
    
		  
let test_uncal2 =
  parseUnCAL_string 
    "rec(\\ ($l,$g).if $l = a then rec(\\($l',$g').if $l' = a then $g' else {})($g) else {})($db)"
		  

let test_exp2 () =
  test test_uncal2 test_db TestExp

let test_fwd2 () =
  let dot_file = "./test_out2.dot" in
    test ~fwd_dot_file:dot_file ~write_dot:true test_uncal2 test_db TestFwd
	
let test_fwd2b () =
  let test_db' = (clean_id @@ remove_eps @@ load_db @@ parseUnCAL_file) "./bd_db___.uncal" in 
  let dot_file = "./test_out2b.dot" in
    test ~fwd_dot_file:dot_file ~write_dot:true test_uncal2 test_db' TestFwd
      
      
let test_bwd2a () =
  let g = match test test_uncal2 test_db TestFwd with
      `TestFwd g -> g 
    | _        -> failwith "Hello?" in
  let dot_file = "./test_put2-a.dot" in
  let v1 =  FrE (FrE (Bid 3, (Bid 4, ALLbl "a", Bid 3), 7), (Bid 5, ALLbl "a", Bid 4), 9) in
  let v2 =  FrE (FrE (Bid 0, (Bid 4, ALLbl "a", Bid 3), 7), (Bid 5, ALLbl "a", Bid 4), 9) in
  let g' = { v=g.v;
	     e=SetofEdge.add (v1, ALLbl "e", v2) g.e;
	     i=g.i;
	     o=g.o; } in
    test ~bwd_dot_file:dot_file ~write_dot:true ~out_graph:g' test_uncal2  test_db TestBwd 

let test_bwd2b () =
  let g = match test test_uncal2 test_db TestFwd with
      `TestFwd g -> g 
    | _        -> failwith "Hello?" in
  let dot_file = "./test_put2-b.dot" in
  let ins = 
    let vertex1 = Hub (Bid 5,"&",9) in
    let vertex2 = Hub (Bid 2,"&",9) in 
    let vsrc    = SetofVtx.fromList [vertex1] in 
    let vdst    = SetofVtx.fromList [vertex2] in
    let edge1   = (Bid 5, ALUkn, Bid 2) in
    let edge2   = (Bid 2, ALLbl "a", Bid 3) in 
    let edge3   = (Bid 3, ALLbl "d", Bid 0) in 
    let v0 = FrE (Hub (Bid 2, "&", 7), edge1, 9) in 
    let v1 = FrE (FrE (Bid 3, edge2, 7), edge1, 9) in
    let v2 = FrE (FrE (Bid 0, edge2, 7), edge1, 9) in
    let v3 = FrE (Hub (Bid 3, "&", 7), edge1, 9) in 
    let v4 = FrE (FrE (InT 4, edge3, 7), edge1, 9) in 
    let v5 = FrE (Hub (Bid 0, "&", 7), edge1, 9) in 
    let vs = SetofVtx.fromList    [v0;v1;v2;v3;v4;v5] in
    let es = SetofEdge.fromList   [(v0,ALEps,v1);(v3,ALEps,v4);(v1,ALLbl "d",v2)] in 
    let is = SetofInodeR.fromList [("&",v0)] in
    let os = SetofOnodeR.fromList [] in
      { src = vsrc;
	dst = vdst;
	graph = { v = vs; e = es; i = is; o = os; }; } in 
    test ~bwd_dot_file:dot_file ~write_dot:true ~out_graph:g ~insertion_units:[ins] test_uncal2 test_db TestBwd 




let test_bwd2c () =
  let test_db = (clean_id @@ remove_eps @@ load_db @@ parseUnCAL_file) "../examples/bd_db.uncal" in
  let g = match test test_uncal2 test_db TestFwd with
      `TestFwd g -> g 
    | _        -> failwith "Hello?" in
  let dot_file = "./test_put2-c.dot" in
  let ins = (* 5 -a-> 1 *)
    let vertex1 = Hub (Bid 5,"&",9) in
    let vertex2 = Hub (Bid 1,"&",9) in 
    let vsrc    = SetofVtx.fromList [vertex1] in 
    let vdst    = SetofVtx.fromList [vertex2] in
    let edge1   = (Bid 5, ALUkn, Bid 1) in
    let edge2   = (Bid 1, ALLbl "c", Bid 1) in  
    let edge3   = (Bid 1, ALLbl "a", Bid 0) in 
    let v1 = FrE (Hub (Bid 1, "&", 7), edge1, 9) in 
    let v2 = FrE (FrE (InT 4, edge2, 7), edge1, 9) in 
    let v3 = FrE (FrE (Bid 0, edge3, 7), edge1, 9) in
    let v4 = FrE (Hub (Bid 0, "&", 7), edge1, 9) in 
    let vs = SetofVtx.fromList    [v1;v2;v3;v4] in
    let es = SetofEdge.fromList   [(v1,ALEps,v2);(v1,ALEps,v3)] in 
    let is = SetofInodeR.fromList [("&",v1)] in
    let os = SetofOnodeR.fromList [] in
      { src = vsrc;
	dst = vdst;
	graph = { v = vs; e = es; i = is; o = os; }; } in 
(*   let ins = (\* 5 -a-> 1 *\) *)
(*     let vertex1 = Hub (Bid 5,"&",9) in *)
(*     let vertex2 = Hub (Bid 1,"&",9) in  *)
(*     let vsrc    = SetofVtx.fromList [vertex1] in  *)
(*     let vdst    = SetofVtx.fromList [vertex2] in *)
(*     let edge1   = (Bid 5, ALUkn, Bid 1) in *)
(*     let edge2   = (Bid 1, ALLbl "c", Bid 1) in  *)
(*     let v1 = FrE (Hub (Bid 1, "&", 7), edge1, 9) in  *)
(*     let v2 = FrE (FrE (InT 4, edge2, 7), edge1, 9) in *)
(*     let vs = SetofVtx.fromList    [v1;v2] in *)
(*     let es = SetofEdge.fromList   [(v1,ALEps,v2)] in  *)
(*     let is = SetofInodeR.fromList [("&",v1)] in *)
(*     let os = SetofOnodeR.fromList [] in *)
(*       { src = vsrc; *)
(* 	dst = vdst; *)
(* 	graph = { v = vs; e = es; i = is; o = os; }; } in  *)
  let ins2 =  (* 1 -a-> 0 *)
    let vertex1 = Hub (Bid 1,"&",9) in
    let vertex2 = Hub (Bid 0,"&",9) in 
    let vsrc    = SetofVtx.fromList [vertex1] in 
    let vdst    = SetofVtx.fromList [vertex2] in
    let edge1   = (Bid 1, ALUkn, Bid 0) in
    let v1 = FrE (Hub (Bid 1, "&", 7), edge1, 9) in 
    let vs = SetofVtx.fromList    [v1] in
    let es = SetofEdge.fromList   [] in 
    let is = SetofInodeR.fromList [("&",v1)] in
    let os = SetofOnodeR.fromList [] in
      { src = vsrc;
	dst = vdst;
	graph = { v = vs; e = es; i = is; o = os; }; } in     
  let test_db = (clean_id @@ remove_eps @@ load_db @@ parseUnCAL_file) "../examples/bd_db.uncal" in
    match test ~write_dot:false ~out_graph:g ~insertion_units:[ins2] test_uncal2 test_db TestBwd with
	`TestBwd test_db' ->
	  let g = (match test test_uncal2 test_db' TestFwd with
		       `TestFwd g -> g
		     | _        -> failwith "Hello?") in
	    test ~write_dot:false ~out_graph:g ~insertion_units:[ins] test_uncal2 test_db' TestBwd
      | _ -> failwith "Hello"

let test_bwd2d () = (* 2 -a-> 1 <-b- 0 *)
  let test_db = (clean_id @@ remove_eps @@ load_db @@ parseUnCAL_string) "cycle((& := {a:&z1}, &z1 := {}, &z2 := {b:&z1}))" in
  let g = match test test_uncal2 test_db TestFwd with
      `TestFwd g -> g 
    | _        -> failwith "Hello?" in
  let dot_file = "./test_put2-d.dot" in
  let ins = (* 2 -a-> 1 *)
    let vertex1 = Hub (Bid 2,"&",9) in
    let vertex2 = Hub (Bid 1,"&",9) in
    let vsrc    = SetofVtx.fromList [vertex1] in
    let vdst    = SetofVtx.fromList [vertex2] in
    let edge1   = (Bid 2, ALUkn, Bid 1) in
    let edge2   = (Bid 1, ALUkn, Bid 0) in
    let v1 = FrE (Hub (Bid 1, "&", 7), edge1, 9) in
    let v2 = FrE (FrE (Bid 1, edge2, 7), edge1, 9) in
    let v3 = FrE (FrE (Bid 0, edge2, 7), edge1, 9) in
    let vs = SetofVtx.fromList    [v1;v2;v3] in      let es = SetofEdge.fromList   [(v1,ALEps,v2);(v2,ALLbl "a",v3)] in
    let is = SetofInodeR.fromList [("&",v1)] in
    let os = SetofOnodeR.fromList [] in
      { src = vsrc;
	dst = vdst;
	graph = { v = vs; e = es; i = is; o = os; }; } in
  let ins2 = (*  1 -a-> 0 *)
    let vertex1 = Hub (Bid 1,"&",9) in
    let vertex2 = Hub (Bid 0,"&",9) in
    let vsrc    = SetofVtx.fromList [vertex1] in
    let vdst    = SetofVtx.fromList [vertex2] in
    let edge1   = (Bid 1, ALUkn, Bid 0) in
    let v1 = FrE (Hub (Bid 1, "&", 7), edge1, 9) in
    let vs = SetofVtx.fromList    [v1] in
    let es = SetofEdge.fromList   [] in
    let is = SetofInodeR.fromList [("&",v1)] in
    let os = SetofOnodeR.fromList [] in
      { src = vsrc;
	dst = vdst;
	graph = { v = vs; e = es; i = is; o = os; }; } in
    test ~out_graph:g ~insertion_units:[ins;ins2] test_uncal2 test_db TestBwd 
		
		     
	  
	  
(*********** HIDAKA **************)
let liftOptionM f g1  = 
  match g1 with
    Some x         -> Some (x,f x.UnCALMAST.graph)
  | _              -> None
let liftOptionM2 f g1 g2 = 
  match g1,g2 with
    Some x, Some y -> Some (x,y,f x.UnCALMAST.graph y.UnCALMAST.graph)
  | _     , _      -> None

(* FIXME: ecmap here is just a dummy for compatibility *)
let ecmap = MapofEdge.empty 
(* FIXME: ecenv here is just a dummy for compatibility *)
let ecenv = emptyEnv_aux
(* FIXME: reach of value true is just a dummy for compativility *)
let rec eval_fwdI (rho:dynenv) (taexpr: ('a taexpr)) : (('a maexpr) option) = 
  let eid = taexpr.expid in
  match taexpr.saexpr with 
  | SAETEmp ->
      let emptyTree = (!<>) ~expid:eid () in
      Some { UnCALMAST.graph = emptyTree ;taexpr=taexpr; daexpr=DAETEmp;ecmap=ecmap;ecenv;reach=true;}
  | SAEGEmp -> 
      Some { UnCALMAST.graph = emptyGraph;taexpr=taexpr; daexpr=DAEGEmp;ecmap=ecmap;ecenv;reach=true;}
  | SAEOMrk m -> 
      let g = (!&) ~expid:eid m in
      Some { UnCALMAST.graph = g;         taexpr=taexpr; daexpr=DAEOMrk m;ecmap=ecmap;ecenv;reach=true;}
  | SAEEdg (lpat,expr) ->
        let l = eval_fwdL rho lpat in
        let t = eval_fwdI rho expr in
	liftOption (fun (t,g) -> { UnCALMAST.graph=g;taexpr=taexpr; daexpr=DAEEdg (l,t);ecmap=ecmap;ecenv;reach=true;})
	(liftOptionM ((/:) ~expid:eid l.allit) t)
  | SAEVar v ->
      let g = lookupVar rho v in
      Some { UnCALMAST.graph = lookupVar rho v; taexpr=taexpr; daexpr= DAEVar v;ecmap=ecmap;ecenv;reach=true; }
  | SAEApnd (e1,e2) -> (* @ *)
      let g1 = eval_fwdI rho e1 in
      let g2 = eval_fwdI rho e2 in
      liftOption (fun (g1,g2,g) -> { UnCALMAST.graph=g;taexpr=taexpr;daexpr=DAEApnd (g1,g2);ecmap=ecmap;ecenv;reach=true;})
	(liftOptionM2 ((@&) ~expid:eid) g1 g2)
  | SAEUni (e1,e2) -> (* U *)
      let g1 = eval_fwdI rho e1 in
      let g2 = eval_fwdI rho e2 in 
      liftOption (fun (g1,g2,g) -> { UnCALMAST.graph=g;taexpr=taexpr;daexpr=DAEUni (g1,g2);ecmap=ecmap;ecenv;reach=true;})
	(liftOptionM2 ((+|) ~expid:eid) g1 g2)
  | SAEDUni (e1,e2) -> (* (+) *)
      let g1 = eval_fwdI rho e1 in
      let g2 = eval_fwdI rho e2 in 
      liftOption (fun (g1,g2,g) -> { UnCALMAST.graph=g;taexpr=taexpr;daexpr=DAEDUni (g1,g2);ecmap=ecmap;ecenv;reach=true;})
	(liftOptionM2 (|++) g1 g2)
  | SAECyc e -> (* cycle *)
      let g0 = eval_fwdI rho e in
      liftOption (fun (g1,g) -> { UnCALMAST.graph=g;taexpr=taexpr;daexpr=DAECyc(g1);ecmap=ecmap;ecenv;reach=true;})
	(liftOptionM ((!!<>) ~expid:eid) g0)
  | SAEIMrk (m,expr) ->
      let g1 = eval_fwdI rho expr in
      liftOption (fun (g1,g) -> { UnCALMAST.graph=g; taexpr=taexpr; daexpr=DAEIMrk (m,g1); ecmap=ecmap;ecenv;reach=true;})
	(liftOptionM ((^:=) m)  g1)
  | SAEIf (be,et,ef) -> (* FIXME: consider "$a = v or true" *)
      if containsUnknownVar rho be then None
      else 
	let flag = eval_Bexp rho be in (* normal forward evaluation *)
	let g = eval_fwdI rho (if flag then et else ef) in
	liftOption (fun (g1,g) -> { UnCALMAST.graph=g; taexpr=taexpr; daexpr=DAEIf (flag,g1); ecmap=ecmap;ecenv;reach=true;})
	  (liftOptionM id g)
  | SAELet (v,ebind,ebody) -> (* FIXME:gbin can be none *)
      (let gbin = eval_fwdI rho ebind in bindOption gbin (fun gbin ->
       let gbod = eval_fwdI (intern_gv v gbin.UnCALMAST.graph rho) ebody in 
       liftOption (fun (gbod,g) -> {UnCALMAST.graph=g;taexpr=taexpr;daexpr=DAELet (v,gbin,gbod); ecmap=ecmap;ecenv;reach=true;})
           (liftOptionM id gbod)))
  | SAELLet (v,lbind,ebody) ->
      let llbin = eval_fwdL rho lbind in
      let gbod = eval_fwdI (intern_lv v llbin.allit rho) ebody in
      liftOption (fun (g1,g) -> { UnCALMAST.graph=g; taexpr=taexpr; daexpr=DAELLet (v,llbin,g1);ecmap=ecmap;ecenv;reach=true;})
      (liftOptionM id gbod)
  | SAERec (l,t,ebody,earg) ->
      let xd = eval_fwdI rho earg in
      let xd = fromSome xd in
      let d = xd.UnCALMAST.graph in
      let setZ = uncurry (SetofMarker.union) ebody.vtype in
      let (outgoEdgeS_d,incomEdgeS_d,_,_) = build_ioedge_ionode_map d in
      let (epsEdgS,nonEpsEdgS) = SetofEdge.partition isEpsEdge d.e in
      let mapE =
	(SetofEdge.fold (fun (u,a,v) mE ->
	  if MapofEdge.mem (u,a,v) mE then mE else 
	  MapofEdge.add (u,a,v)				 
	    (let dv   = make_dv_with_oEmap outgoEdgeS_d d v in
	    let rho1 = intern_gv t dv (intern_lv l a rho)  in
	    eval_fwdI rho1 ebody) mE) d.e MapofEdge.empty) in
	let  mapE = MapofEdge.map (fun xg -> (fromSome xg)) mapE in
        let pmapE = MapofEdge.map (fun xg -> xg.UnCALMAST.graph) mapE in
        (************** (4) compose g according to mapE *****************)
        let (g,hubV,spokeEps,s1s1Eps) 
	    = dfwd_AERec eid setZ (epsEdgS,nonEpsEdgS) pmapE incomEdgeS_d outgoEdgeS_d d in
	let (g,cmpl) = if !saUnreach then split_reachableGI g else (g,emptyGraph) in
	Some { UnCALMAST.graph=g; taexpr=taexpr; daexpr=DAERec (l,t,mapE,hubV,spokeEps,s1s1Eps,xd,cmpl); ecmap=ecmap;ecenv;reach=true;}
let rec bd_bwdI (rho:dynenv) (maexpr: 'a maexpr) (g':graph) (ins:ins_unit list) : dynenv =
  match maexpr.daexpr with
    DAETEmp ->
      if g' = maexpr.UnCALMAST.graph then 
	rho
      else raise (Eval_Bwd "bd_bwdI: no modifications allowed for empty trees.")
  | DAEGEmp ->
      if  g' = emptyGraph then
	rho
      else raise (Eval_Bwd "bd_bwdI: no modifications allowed for empty graphs.")
  | DAEOMrk m -> 
      if  maexpr.UnCALMAST.graph = g'
      then rho
      else 
	let s1 = graph2str maexpr.UnCALMAST.graph in
	let s2 = graph2str g'                     in 
	raise (Eval_Bwd ("bd_evalI: no modifications allowed for output nodes." ^ s1 ^ " <> " ^ s2))
  | DAEEdg (mlpat,mexpr) -> 
      let (l',t') = decompose_AEEdg mlpat.allit mexpr.UnCALMAST.graph maexpr.UnCALMAST.graph g' in
      let rhoL' = bd_bwdL rho mlpat l'     in
      let rho'  = bd_bwdI rho mexpr t' ins in
      uplus_cmp rhoL' rho' rho
  | DAEVar v -> replace_bindingG v g' rho
  | DAEApnd (e1,e2) ->
      let g1 = e1.UnCALMAST.graph in
      let g2 = e2.UnCALMAST.graph in
      let (g1',g2') = decompose_AEApnd maexpr.taexpr.expid g1 g2 maexpr.UnCALMAST.graph g' in
      let rho1' = bd_bwdI rho e1 g1' ins in
      let rho2' = bd_bwdI rho e2 g2' ins in
      uplus_cmp rho1' rho2' rho
  | DAECyc e -> 
      let g0 = e.UnCALMAST.graph in
      let g0'= decompose_AECyc g0 maexpr.UnCALMAST.graph g' in
      bd_bwdI rho e g0' ins
  | DAEUni (e1,e2) ->
      let g1 = e1.UnCALMAST.graph in
      let g2 = e2.UnCALMAST.graph in
      (* decompose g' into g1' and g2' *)
      let (g1',g2') = decompose_AEUni g1 g2 maexpr.UnCALMAST.graph g' in
      let rho1' = bd_bwdI rho e1 g1' ins in
      let rho2' = bd_bwdI rho e2 g2' ins in 
      uplus_cmp rho1' rho2' rho
  | DAEDUni (e1,e2) ->
      let g1 = e1.UnCALMAST.graph in
      let g2 = e2.UnCALMAST.graph in
      let (g1',g2') = decompose_AEDUni g1 g2 maexpr.UnCALMAST.graph g' in
      let rho1' = bd_bwdI rho e1 g1' ins in
      let rho2' = bd_bwdI rho e2 g2' ins in 
      uplus_cmp rho1' rho2' rho
  | DAEIMrk (m,e) ->
      let g1 = e.UnCALMAST.graph in
      let g1' = decompose_AEIMrk m g1 maexpr.UnCALMAST.graph g' in
      bd_bwdI rho e g1' ins
  | DAEIf (flag,e1) ->
     (let g = e1.UnCALMAST.graph in
      let (tecond,tet,tef) = match maexpr.taexpr.saexpr with 
	SAEIf(be,et,ef) -> (be,et,ef)
      | _               -> failwith "bd_bwd(DAEIf: not mach)" in
      if containsUnknownVar rho tecond then
	try (let oxg   = eval_fwdI rho tet in
             let rho'  = bd_bwdI rho (fromSome oxg) g' ins in
             let rho'' = bwd_Bexp rho' tecond true in
	     let rho'' = uplus_cmp rho' rho'' rho in
	     if eval_Bexp rho'' tecond then
			rho''
	     else 
	       failwith "Failed to make true")
	with _ ->
	  let oxg   = eval_fwdI rho tef in
	  let rho'  = bd_bwdI rho (fromSome oxg) g' ins in
	  let rho'' = bwd_Bexp rho' tecond false in
	  let rho'' = uplus_cmp rho' rho'' rho in
	  if not (eval_Bexp rho'' tecond) then
	    rho''
	  else 
	    failwith "Failed to make false"
      else
	try (
	  let rho'  = bd_bwdI rho e1 g' ins in
	  let flag' = eval_Bexp rho' tecond (* check for branching *) in
	  if flag = flag' then rho'
	  else failwith "Branching mismatch")
	with _ -> (* branching behavior changed *)
	  if (flag = true) then
	    let oxg = eval_fwdI rho tef in
	    bd_bwdI rho (fromSome oxg) g' ins
	  else (*  ((flag = false) && (flag' = true)) *)
	    let oxg = eval_fwdI rho tet in
	    bd_bwdI rho (fromSome oxg) g' ins)
  | DAERec (l,t,mbody,hubV,spokeEps,s1s1Eps,garg,cmpl) ->
      let d = garg.UnCALMAST.graph in
          let g' = if !saUnreach then evalg_simple_union g' cmpl else g' in
      	  let hasInsertionHappened iu hubV = 
	    SetofVtx.subset (iu.dst) hubV
	    && SetofVtx.subset (iu.src) hubV
	    && not (SetofVtx.is_empty (iu.dst))
	    && not (SetofVtx.is_empty (iu.src)) in
	  let orgVertexSrc iu =
	    let u = stripHub (SetofVtx.choose (iu.src)) in u in
	  let orgVertexDst iu =
	    let v = stripHub (SetofVtx.choose (iu.dst)) in v in 
	  let insGraph iu = 
	    let g = stripFrE_VEIO iu.graph in g in
	  let pmapE = MapofEdge.map (fun xg -> xg.UnCALMAST.graph) mbody in
	  let mapE' = decompose_AERec maexpr.taexpr.expid pmapE hubV spokeEps s1s1Eps g' in
	  	  (******** (3)' recursively evaluate the body backwards **********)
	    (* backward transformation along non-epsilon edges *)
	  let insBody =
	    List.fold_right
	      (fun iu r ->
		 if hasInsertionHappened iu hubV then
		   r
		 else 
		   stripFrE_iu iu::r) ins [] in 
	    
	  let d = 
	    let e' =
	      List.fold_right (fun iu r ->
		 if hasInsertionHappened iu hubV then 
		   let u   = orgVertexSrc iu in
		   let v   = orgVertexDst iu in 
		     SetofEdge.add (u,ALUkn,v) r
		 else
		   r) ins d.e in
	      {v = d.v; e = e'; i = d.i; o = d.o} in 

          let (outgoEdgeS_d,incomEdgeS_d,_,_) = build_ioedge_ionode_map d in
	  
	  let tebody = match maexpr.taexpr.saexpr with 
	    SAERec (_,_,ebody,_) -> ebody
	  | _               -> failwith "bd_bwdI(DAERec: not mach)" in
	  
	  let mapRho' = 
	    MapofEdge.fold 
	      (fun (u,a,v) gi' m ->
	         if (a <> ALEps) then
		   ((* let (_,bfi) = (lookupMEbody u a v) in *)
		       let dv   = make_dv_with_oEmap outgoEdgeS_d d v in
		       let rho1 = intern_gv t dv (intern_lv l a rho)  in
		       let oxg = eval_fwdI rho1 tebody in
		       let rho' = bd_bwdI rho1 (fromSome oxg) gi' insBody in
		       MapofEdge.add (u,a,v) rho') m
	         else m) mapE' MapofEdge.empty in
	  let mapRho' =
	    List.fold_right 
	      (fun iu r ->
		 if hasInsertionHappened iu hubV then 
		   let u   = orgVertexSrc iu in
		   let v   = orgVertexDst iu in 
		   let gi' = insGraph iu in
		   let dv   = make_dv_with_oEmap outgoEdgeS_d d v in
		   let rho1 = intern_gv t dv (intern_lv l ALUkn rho)  in
		   let oxg = eval_fwdI rho1 tebody in
		   let rho' = bd_bwdI rho1 (fromSome oxg) gi' insBody in 
		   MapofEdge.add (u, ALUkn, v) rho' r		       
		 else
		   r		   
	      ) ins mapRho' in 
	    
	  let d' = restore_input_AERec l t mapRho' d g' in

	  let v =
	    SetofEdge.fold (fun (u,a,v) r ->
			      SetofVtx.add u (SetofVtx.add v r)) d'.e d'.v  in
	  let d' = {d' with v = v; } in

	    
	  (******** (1)' backwared evaluation of the argument **************)
	  let rho'' = bd_bwdI rho garg d' [] in (* FIXME: ins should be insEmpty? *)

	  (******** (0)' merge rho'', rho and each member of mapRho' *******) 
	  (* remove bindings of l and t from mapRho' entries *)
	  let mapRho' = MapofEdge.map 
	    (fun env -> unintern_gv t (unintern_lv l env)) mapRho' in
	  let mgrho''  = biguplus_cmp mapRho' rho in
	  uplus_cmp mgrho'' rho'' rho 
  | _ -> failwith "not implemented"
	
  
 
let eval_fwd_topI rho aexpr = 
  let stEnv = dynenv2stenv rho in
  let texpr = augType stEnv aexpr in
  let nexpr = numberE texpr in 
    eval_fwdI rho nexpr


(* non-closure version *)
let test_nc ?(fwd_dot_file="") ?(bwd_dot_file="") ?(write_dot=false) ?(out_graph) ?(insertion_units=[]) uncal db =
  let idState = GenId.current () in
  let ()      = GenId.set 0 in
  let _ = skolemBulk := true in
  let rho = (intern_gv "$db" db emptyDynEnv) in
  let (g,bf) = bd_eval_topI rho uncal in 
  let oxg = eval_fwd_topI rho uncal in
    fun m ->
      match m with
	  TestExp ->
	    let stEnv = dynenv2stenv rho in
	    let texpr = augType stEnv uncal in
	    let nexpr = numberE texpr in 
	      `TestExp nexpr 
	| TestFwd ->
	    begin
	      match oxg with
		  Some graph ->
		    let _ = if write_dot then g2dot_file ~shape:`ellipse (graph.UnCALMAST.graph) fwd_dot_file else () in 
		    let ()     =  GenId.set (idState) in
		      `TestFwd graph
		| _ ->
		    failwith "Error"
	    end
	| TestBwd ->
	    let rho' = bd_bwdI rho (fromSome oxg) (fromSome out_graph) insertion_units in
	    let ()  =  GenId.set (idState) in
	      (* rho *)
	    let db' = lookupVar rho' "$db" in 
	    let _ = print_string "PUTTING is DONE\n" in
	    let _ = if write_dot then g2dot_file ~shape:`ellipse (db') bwd_dot_file else () in
	      `TestBwd db'

let test_ev_nc uncal db_file =
  let db      = (clean_id @@ remove_eps @@ load_db @@ parseUnCAL_file) db_file in
  let rho = (intern_gv "$db" db emptyDynEnv) in
  let oxg = eval_fwd_topI rho uncal in
    (oxg,rho)

let test_nc_get1 () =
  let idState = GenId.current () in
  let ()      = GenId.set 0 in
  let _ = skolemBulk := true in
  let db_file  = "../examples/bd_db.uncal" in
  let dot_file = "./test.dot" in
  let uncal = parseUnCAL_string 
    "rec(\\ ($l,$g).if $l = a then {d: &} else if $l = c then & else {$l: &})($db)" in
  let (oxg,rho) = test_ev_nc uncal db_file in
    match oxg with
	Some graph ->
	  let g = (graph.UnCALMAST.graph) in
	  let _ = g2dot_file ~shape:`ellipse g dot_file in 
	  let ()     =  GenId.set (idState) in
	    oxg
      | _ ->
	  failwith "Error"

let test_nc_put1 () =
  let idState = GenId.current () in
  let ()      = GenId.set 0 in
  let _ = skolemBulk := true in
  let db_file  = "../examples/bd_db.uncal" in
  let dot_file_in  = "./test_in.dot" in
  let dot_file_out = "./test_out.dot" in
  let uncal = parseUnCAL_string 
    "rec(\\ ($l,$g).if $l = a then {d: &} else if $l = c then & else {$l: &})($db)" in
  let ins = 
    let vertex1 = Hub (Bid 2, "&", 43) in
    let vertex2 = Hub (Bid 3, "&", 43) in
    let edge    = (Bid 2, ALUkn, Bid 3) in
      { src = SetofVtx.fromList [vertex1];
	dst = SetofVtx.fromList [vertex2];
	graph = 
	  let v1 = FrE(InT 37, edge, 43) in
	  let v2 = FrE(InT 36, edge, 43) in 
	    {
	      v = SetofVtx.fromList  [v1;v2];
	      e = SetofEdge.fromList [(v1,ALLbl "e",v2)];
	      i = SetofInodeR.singleton ("&",v1);
	      o = SetofOnodeR.singleton (v2,"&");
	    };
      } in
  let ins' =
    let vertex1 = Hub (Bid 5, "&", 43) in
    let vertex2 = Hub (Bid 2, "&", 43) in
    let edge    = (Bid 5, ALUkn, Bid 2) in
    { src = SetofVtx.fromList [vertex1];
      dst = SetofVtx.fromList [vertex2];
      graph = 
	let v1 = FrE(InT 41, edge, 43) in
	let v2 = FrE(InT 40, edge, 43) in 
	  {
	    v = SetofVtx.fromList  [v1;v2];
	    e = SetofEdge.fromList [(v1,ALLbl "d",v2)];
	    i = SetofInodeR.singleton ("&",v1);
	    o = SetofOnodeR.singleton (v2,"&");
	  };
    } in
  let ins'' = (* Fails *)
    let vertex1 = Hub (Bid 2, "&", 43) in
    let vertex2 = Hub (Bid 3, "&", 43) in
    let edge    = (Bid 2, ALUkn, Bid 3) in
    { src = SetofVtx.fromList [vertex1];
      dst = SetofVtx.fromList [vertex2];
      graph = 
	let v1 = FrE(InT 38, edge, 43) in
	  {
	    v = SetofVtx.fromList  [v1];
	    e = SetofEdge.fromList [];
	    i = SetofInodeR.singleton ("&",v1);
	    o = SetofOnodeR.singleton (v1,"&");
	  };
    } in
  let (oxg,rho0) = test_ev_nc uncal db_file in
    match oxg with
	Some graph ->
	  (* let _ = g2dot_file ~elliptic:true (graph) dot_file_in in *)
	  let rho = bd_bwdI rho0 graph graph.UnCALMAST.graph [ins''] in
	  let ()     =  GenId.set (idState) in
	    (* rho *)
	  let db' = lookupVar rho "$db" in 
	  let _ = g2dot_file ~shape:`ellipse (db') dot_file_out in
	    db'
      | _ ->
	  failwith "Error"

(* loading and storing insertion units using Marshal standard library *)
(* insertion unit to file *)
let ins2file (ins:ins_unit) (file:string) : unit = 
  let oc = open_out file  in
  Marshal.to_channel oc ins [];
  close_out oc
(* file to insertion unit *)
let file2ins (file:string) : ins_unit = 
  let is = open_in file in
  let  ins = (Marshal.from_channel is : ins_unit) in
  close_in is;
  ins

(* imported from *)
(* doc/kztk/insertion_template/insertionTemplate.ml by Matsuda-san *)

(**
This module is to calculate insertion template when two have nodes are specified.
The computation is done basically by the following two steps:
 1. First, for given have nodes "Hub (x,_,_)" and "Hub (y,_,_)", 
    we add edge "(x,???,y)" to the source graph.
 2. Second, by evaluating forward transformation, 
    we obtain the set of insertion templates.

Since to find insertion template sound & complete way is difficult, 
we try to "complete"; a sould solution would be more desirable 
however it is more difficult because "if" introduces intervaliable 
dependencies.


Different from usual semantics which calculates qa graph from an enrionment, 
the insertion template version calculates the set of graphs called insertion templates.
Only different parts in from the usual one in semantics is 
"let" and "if".

For "let $x in e in e'", we evaluate e first, 
and then, for each results of e, we bind it to "$x" and then evaluate "e".
For "if", we can do narrowing, i.e., 
we can narrow ??? so that condition to be true/false.

However, current implementation does nothing for "if",
it just take both branches unless the condition can be evaluated to true or false 
without knowing the unknown variable.

*)

open UnCAL

open List

let concatMap f xs = concat (map f xs)
  

let rec productList ls rs =
  match ls with 
      []     -> []
    | (a::x) -> 
        let rec aux a xs r = match xs with 
            []     -> r
          | (b::y) -> (a,b)::aux a y r in
          aux a rs (productList x rs)


let narrow rho be b = rho (* FIXME *)

let frE x l e = FrE (x,l,e)

let frE_g l e g = 
  let f v = frE v l e in 
    { v = SetofVtx.map f g.v;
      e = SetofEdge.map (fun (u,a,v) -> (f u, a, f v)) g.e;
      i = SetofInodeR.map (fun (m,u)  -> (m,f u)) g.i;
      o = SetofOnodeR.map (fun (u,m)  -> (f u,m)) g.o;
    } 


let rec insertion_template 
    (rho:dynenv) 
    (taexpr:'a taexpr) : graph list =
  let eid = taexpr.expid in
  match taexpr.saexpr with 
    | SAETEmp ->   (* {} *)
        let emptyTree = (!<>) ~expid:eid () in
          [ emptyTree ]
    | SAEGEmp ->   (* () *)
        [ emptyGraph ]
    | SAEOMrk m -> (* &m *)
        let g = (!&) ~expid:eid m in 
          [ g ]
    | SAEEdg (lpat,expr) -> (* {l:e} *)
        let ls  = insertion_template_L rho lpat in 
        let vs  = insertion_template   rho expr in 
        let lvs = productList ls vs in 
          map (uncurry ((/:) ~expid:eid)) lvs
    | SAEVar x -> (* v *)
        let g = lookupVar rho x in 
          [ g ] 
    | SAEApnd (e1,e2) -> (* @ *)
        let v1  = insertion_template rho e1 in 
        let v2  = insertion_template rho e2 in 
        let v12 = productList v1 v2 in 
          map (uncurry ((@&) ~expid:eid)) v12 
    | SAECyc e -> (* cycle e *)
        let vs = insertion_template rho e  in 
          map ((!!<>) ~expid:eid) vs 
    | SAEUni (e1,e2) -> (* e1 U e2 *)
        let v1  = insertion_template rho e1  in 
        let v2  = insertion_template rho e2  in 
        let v12 = productList v1 v2 in 
          map (uncurry ((+|) ~expid:eid)) v12
    | SAEDUni (e1,e2) -> (* e1 (+) e2 *)
        let v1  = insertion_template rho e1  in 
        let v2  = insertion_template rho e2  in 
        let v12 = productList v1 v2 in 
          map (uncurry (|++)) v12
    | SAEIMrk (m,expr) -> (* &m := e *) 
        let v   = insertion_template rho expr  in
          map ((^:=) m) v
    | SAEIf (be,et,ef) -> (* if be then et else ef *)
        if containsUnknownVar rho be then 
          let rhot = narrow rho be true in 
          let rhof = narrow rho be false in
            (insertion_template rhot et) @
              (insertion_template rhof ef)
        else
	  (* let _ = print_string "insertion_template:not containsUnknownVar" in *)
          let flag = eval_Bexp rho be in 
          let ex   = if flag then et else ef in 
            insertion_template rho ex  
    | SAELet (x,ebind,ebody) -> (* let v = ebind in ebody *) 
        let vbind = insertion_template rho ebind  in 
        let rhos  = map (fun g -> intern_gv x g rho) vbind in
        let vss   = map (fun r -> insertion_template rho ebody) rhos in
          concat vss
    | SAELLet (x,ebind,ebody) -> (* llet x = ebind in ebody *)
        let vbind = insertion_template_L rho ebind in  
        let rhos  = map (fun l -> intern_lv x l rho) vbind in
        let vss   = map (fun r -> insertion_template rho ebody) rhos in
          concat vss
    | SAERec (l,t,ebody,earg) -> (* rec(\(l,t).ebody)(earg) *)        
        let varg = insertion_template rho earg in
        let setZ = uncurry (SetofMarker.union) ebody.vtype in 
          concatMap (fun d -> 
             let (outgoEdgeS_d,incomEdgeS_d,_,_) = 
               build_ioedge_ionode_map d in
             let (epsEdgS,nonEpsEdgS) = 
               SetofEdge.partition isEpsEdge d.e in
             let ebodyEps = ebodyEpsExpr setZ in
             let mapE =
               (SetofEdge.fold (fun (u,a,v) mE ->
                    if MapofEdge.mem (u,a,v) mE then mE else 
                      MapofEdge.add (u,a,v)                              
                        (let dv   = make_dv_with_oEmap outgoEdgeS_d d v in
                         let rho1 = intern_gv t dv (intern_lv l a rho)  in
                           insertion_template rho1 ebody) mE) d.e MapofEdge.empty) in
             let pmapEs = 
               MapofEdge.fold (fun k v r ->
                                 let vr = productList v r in
                                   map (fun (v,mp) -> MapofEdge.add k v mp) vr)
                 mapE [ MapofEdge.empty ]  in
               map (fun pmapE -> 
                   let (g,hubV,spokeEps,s1s1Eps) 
                     = dfwd_AERec eid setZ (epsEdgS,nonEpsEdgS) 
                                   pmapE incomEdgeS_d outgoEdgeS_d d in
                     g) pmapEs 
              ) varg 
    
and insertion_template_L rho lpat = 
  [ let (l,_) =  bd_evalL rho lpat in l ]

type ins_between = 
    {
      ib_dst   : SetofVtx.t; (* dst *)
      ib_src   : SetofVtx.t; (* src *)
    }

let stripHub v = 
  match v with
      Hub (v,_,_) -> v 
    | v           -> v 


let stripFrE_ib ib =
  { ib_dst   = SetofVtx.map stripFrE ib.ib_dst;
    ib_src   = SetofVtx.map stripFrE ib.ib_src }

(* We only assume that ins is singleton or empty *)
let rec make_insertion_template 
    (rho:dynenv) 
    (taexpr:'a taexpr) 
    (ins: ins_between list) : graph list =
  let eid = taexpr.expid in
  match taexpr.saexpr with 
    | SAEEdg (_,ex) ->
        make_insertion_template rho ex ins 
    | SAEApnd (e1,e2) -> 
         (make_insertion_template rho e1 ins)
       @ (make_insertion_template rho e2 ins)
    | SAECyc e ->
        make_insertion_template rho e ins
    | SAEUni (e1,e2) ->
         (make_insertion_template rho e1 ins)
       @ (make_insertion_template rho e2 ins)
    | SAEDUni (e1,e2) ->
         (make_insertion_template rho e1 ins)
       @ (make_insertion_template rho e2 ins)
    | SAEIMrk (_,e) -> 
        make_insertion_template rho e ins
    | SAEIf(be,et,ef) ->
        if containsUnknownVar rho be then 
          let rhot = narrow rho be true in 
          let rhof = narrow rho be false in
              (make_insertion_template rho et ins)
            @ (make_insertion_template rho ef ins)
        else
	  (* let _ = print_string "make_insertion_template:not containsUnknownVar" in *)
          if eval_Bexp rho be then 
            make_insertion_template rho et ins
          else
            make_insertion_template rho ef ins
    | SAELet (v,ebind,ebody) -> 
        let (g,_) = bd_eval rho ebind in 
        let rho'  = intern_gv v g rho in
          make_insertion_template rho' ebody ins
    | SAELLet (v,ebind,ebody) -> 
        let (l,_) = bd_evalL rho ebind in 
        let rho'  = intern_lv v l rho in 
          make_insertion_template rho' ebody ins 
    | SAERec (l,t,ebody,earg) -> 
	let hasInsertionHappened iu hubV = 
	  SetofVtx.subset (iu.ib_dst) hubV
	  && SetofVtx.subset (iu.ib_src) hubV
	  && not (SetofVtx.is_empty (iu.ib_dst))
	  && not (SetofVtx.is_empty (iu.ib_src)) in
	let orgVertexSrc iu =
	  let u = stripHub (SetofVtx.choose (iu.ib_src)) in u in
	let orgVertexDst iu =
	  let v = stripHub (SetofVtx.choose (iu.ib_dst)) in v in 
        let setZ  = uncurry (SetofMarker.union) ebody.vtype in 
        let (d,_) = bd_eval rho earg in 
        let (outgoEdgeS_d,incomEdgeS_d,_,_) = build_ioedge_ionode_map d in
	let (epsEdgS,nonEpsEdgS) = SetofEdge.partition isEpsEdge d.e in
        let mapE =
	  (SetofEdge.fold (fun (u,a,v) mE ->
	         if MapofEdge.mem (u,a,v) mE then mE else 
	           MapofEdge.add (u,a,v)				 
	             (let dv   = make_dv_with_oEmap outgoEdgeS_d d v in
		      let rho1 = intern_gv t dv (intern_lv l a rho)  in
		        bd_eval rho1 ebody) mE) d.e MapofEdge.empty) in
        let pmapE = MapofEdge.map (fun (gi,_) -> gi) mapE in
        let (_,hubV,_,_) 
	    = dfwd_AERec eid setZ (epsEdgS,nonEpsEdgS) pmapE incomEdgeS_d outgoEdgeS_d d in
        let insBody =
	    List.fold_right
	      (fun iu -> fun r ->
		 if hasInsertionHappened iu hubV then
		   r
		 else 
		   stripFrE_ib iu::r) ins [] in 
        
	let d = (* Insertion Happend *)
	  let e' =
	    List.fold_right (fun iu -> fun r ->
		 if hasInsertionHappened iu hubV then 
		   let u   = orgVertexSrc iu in
		   let v   = orgVertexDst iu in 
		     SetofEdge.add (u,ALUkn,v) r
		 else
		   r) ins d.e in
	    {v = d.v; e = e'; i = d.i; o = d.o} in 

        let (outgoEdgeS_d,incomEdgeS_d,_,_) = build_ioedge_ionode_map d in
        let insertion_templates_direct = 
          SetofEdge.fold (fun (u,a,v) ts -> 
            match a with 
                ALUkn ->  
(*                  let _    = print_string "Hello" in  *)
                  let dv   = make_dv_with_oEmap outgoEdgeS_d d v in
                  let rho1 = intern_gv t dv (intern_lv l a rho) in
                  let gs   = map (frE_g (u,a,v) eid)
                                  (insertion_template rho1 ebody) in    
                    gs @ ts 
              | _ -> ts) d.e [] in 
        let insertion_templates_subsequent =
	  let d = { d with e = SetofEdge.filter (fun (_,l,_) -> not (l=ALUkn)) d.e;} in
	  let (outgoEdgeS_d,incomEdgeS_d,_,_) = build_ioedge_ionode_map d in
          SetofEdge.fold (fun (u,a,v) ts ->
             let dv   = make_dv_with_oEmap outgoEdgeS_d d v in
             let rho1 = intern_gv t dv (intern_lv l a rho) in 
               make_insertion_template rho1 ebody insBody @ ts) d.e [] in
            insertion_templates_direct 
          @ insertion_templates_subsequent 
    | _ ->
        []


let make_insertion_template_top rho aexpr = 
  let stEnv = dynenv2stenv rho in
  let texpr = augType stEnv aexpr in
  let nexpr = numberE texpr in 
    make_insertion_template rho nexpr 

type it_test_mode = 
  | ITTestExp 
  | ITTestFwd
  | ITTestBwd
  | ITTestTmp

let it_test ins uncal db =
  let _ = print_string "Hello___" in
  let _ = print_string (string_of_int (GenId.current ()) ) in
  let idState = GenId.current () in
  let ()      = GenId.set 0 in
  let _ = skolemBulk := true in
  let rho = (intern_gv "$db" db emptyDynEnv) in
    fun m -> 
      match m with 
          ITTestExp -> 
            let stEnv = dynenv2stenv rho in
	    let texpr = augType stEnv uncal in
	    let nexpr = numberE texpr in 
	    let e = `TestExp nexpr  in 
            let ()  = GenId.set (idState) in 
              e 
        | ITTestTmp -> 
            let ts  = make_insertion_template_top rho uncal ins in 
            let ()  = GenId.set (idState) in 
              `TestTmp ts
        | ITTestFwd ->
            let (g,_) = bd_eval_top rho uncal in 
            let ()  = GenId.set (idState) in 
              `TestFwd g
	| ITTestBwd -> failwith "it_test: not implemented for ITTestBwd"


