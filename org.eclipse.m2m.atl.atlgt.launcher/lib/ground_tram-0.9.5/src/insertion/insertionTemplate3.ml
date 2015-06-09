(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
(** 
    Refactored Imprementation of Insertion Template Generation
    
    This module provides:
*)


open PrintUnCALDM   

open Fputil
open UnCALMAST
open EvalUnCAL
open UnCALdynenv
open UnCALSAST
open UnCALSA
open UnCAL
open PrintUnCAL
open UnCALDM
open UnCALDMutil

open Dotutil

open List
open BiEvalUnCAL

open Format
open TestUnCALutil

open Lazy      
open Scc       
open ExtSetMap 

let not_expected fname fmt =
  kfprintf (fun _ -> failwith(flush_str_formatter ())) str_formatter 
              ("InsertionTemplate3.%s: "^^fmt^^" is not expected.") fname

(** Useful function (NB: undefined has type "'a") *)
let undefined = lazy (failwith "Undefined")


(*
 NB: we assume that "and", "or", and "not" in if-expressions is 
 already unfolded, as 
   if b1 and b2 then           if b1 then 
     e1                           if b2 then e1 
   else                ===>       else       e2
     e2                        else e2
*)

(* Should we introduce expressions like SaveMemo and SaveEnv? *)
(** expression with ID. label, graph and boolean expressions are mixed *)
type  simple_exp = 
  | S_TEmp of (expid * vtype) (* {} *)
  | S_GEmp of (expid * vtype) (* () *)
  | S_IMrk of (expid * vtype * marker * simple_exp)
  | S_OMrk of (expid * vtype * marker)
  | S_Edg  of (expid * vtype * simple_exp * simple_exp)
  | S_Uni  of (expid * vtype * simple_exp * simple_exp)
  | S_DUni of (expid * vtype * simple_exp * simple_exp)
  | S_Apnd of (expid * vtype * simple_exp * simple_exp)
  | S_LVar of (expid * ltype * lname)
  | S_GVar of (expid * vtype * vname)
  | S_If   of (expid * vtype * simple_exp * simple_exp * simple_exp)
  | S_LLet of (expid * vtype * lname * simple_exp * simple_exp)
  | S_GLet of (expid * vtype * vname * simple_exp * simple_exp)
  | S_LLit of (expid * ltype * allit)
  | S_Eq   of (expid * simple_exp * simple_exp)
  | S_Cyc  of (expid * vtype * simple_exp)
      (* Values *)
  | S_LVal of allit (** Label Value *)
  | S_GVal of graph (** Graph Value *)
  | S_BVal of bool  (** Boolean Value *) 
      (* Internal Use: Traversing a node *)
  | S_NodeAt  of ( vtx * graph )               (** Traversing a vertex in a graph *)
      (* Internal Use: Recursive Escaping by FrE *)
  | S_Esc     of ( expid * edge * simple_exp ) (** Escaping **)
  | S_EscEnd  of simple_exp                                 
  | S_ConnEsc of ( expid * vtx * edge * marker list * simple_exp list * allit list ) 
      (* Internal Use: Recursive Map (rec) *) 
  | S_Rec  of (expid * vtype * marker list * lname * vname * simple_exp * simple_exp)
  | S_RecEnd  of simple_exp 
  | S_ConnRec of ( expid * vtx * marker list * marker list * simple_exp list )


(*   | S_RecC of (expid * vtype * SetofMarker.t * lname * vname * simple_exp * simple_exp) *)
(*     (\* Rec Call: Recursive call of rec without encoding of nodes *\) *)
(*     (\**H S_Rec: for redex in the second operand of @ in recursive call of rec in S_RecB *\) *)
(*   | S_RecB of (expid * SetofMarker.t * vtx * simple_exp list)  *)
(*     (\* Rec Body: recursive calls in Rec/for do connect *\) *)
(*   | S_Enc  of (expid * edge * simple_exp)  (\**H to be escaped by FrE *\) *)
(*     (\* Encode: *\) *)
(*   | S_EncC of (expid * edge * simple_exp)  (\* recursive call of FrE *\) *)
(*   | S_EncB of (expid * edge * vtx * simple_exp list) *)


(* (\* Escaping Function *\) *)
(* let frE x l e = FrE (x,l,e) *)
(* let frE_g l e g = (\**H escape result of the body of rec *\) *)
(*   let f v = frE v l e in  *)
(*     { v = SetofVtx.map f g.v; *)
(*       e = SetofEdge.map (fun (u,a,v) -> (f u, a, f v)) g.e; *)
(*       i = SetofInodeR.map (fun (m,u)  -> (m,f u)) g.i; *)
(*       o = SetofOnodeR.map (fun (u,m)  -> (f u,m)) g.o; *)
(*     }  *)



(* for each marker in markers, construct graph of Hub nodes only,
   having the I/O marker *)
let makeHub eid markers root = 
  let vs = 
    SetofMarker.fold (fun m r ->
		  SetofVtx.add (Hub (root,m,eid)) r) 
      markers SetofVtx.empty in 
  let is =
    SetofMarker.fold (fun m r ->
			 SetofInodeR.add (m,Hub (root,m,eid)) r)
      markers SetofInodeR.empty in
  let os =
    SetofMarker.fold (fun m r ->
			 SetofOnodeR.add (Hub (root,m,eid),m) r)
      markers SetofOnodeR.empty in
  let os = SetofOnodeR.empty in
    { v = vs; e = SetofEdge.empty; i = is; o = os }


let rec to_simple_exp (taexpr: 'a taexpr) : simple_exp =
  let eid = taexpr.expid in
  let vt  = taexpr.vtype in
    match taexpr.saexpr with 
	SAETEmp -> 
	  S_TEmp (eid,vt)
      | SAEGEmp ->
	  S_GEmp (eid,vt)
      | SAEIMrk (m,e) ->
	  S_IMrk (eid,vt, m, to_simple_exp e)
      | SAEOMrk m ->
	  S_OMrk (eid,vt, m)
      | SAEEdg (l,e) ->
	  S_Edg (eid,vt, to_simple_exp_L l, to_simple_exp e)
      | SAEUni (e1,e2) ->
	  S_Uni  (eid,vt, to_simple_exp e1, to_simple_exp e2)
      | SAEDUni (e1,e2) -> 
	  S_DUni (eid,vt, to_simple_exp e1, to_simple_exp e2)
      | SAEApnd (e1,e2) ->
	  S_Apnd (eid,vt, to_simple_exp e1, to_simple_exp e2)
      | SAEVar x ->
	  S_GVar (eid,vt,x)
      | SAEIf (be,e1,e2) ->
	  S_If (eid,vt, to_simple_exp_B be, to_simple_exp e1, to_simple_exp e2)
      | SAERec (l,g,e_body,e_arg) ->
	  let setZ = uncurry (SetofMarker.union) e_body.vtype in 
	    S_RecEnd ( S_Rec (eid,vt, SetofMarker.elements setZ, l,g,to_simple_exp e_body, to_simple_exp e_arg) )
      | SAELet (x,e1,e2) ->
	  S_GLet (eid,vt, x, to_simple_exp e1, to_simple_exp e2)
      | SAELLet (x,e1,e2) ->
	  S_LLet (eid,vt, x, to_simple_exp_L e1, to_simple_exp e2)
      | SAECyc e -> (* failwith "to_simple_exp: not implemented." (**H *) *)
	  S_Cyc  (eid,vt, to_simple_exp e)

and to_simple_exp_L (e:'a talpat) = 
    match e.salpat with 
	SALVar x -> 
	  S_LVar (-1,e.ltype,x) (**H eid=-1 because label expression doesn't have it *)
      | SALLit l ->
	  S_LLit (-1,e.ltype,l) (**H eid=-1 because label expression doesn't have it *)
      | SALBin (_, _, _) ->
	  failwith "to_simple_exp: not implemented." (**H *)

and to_simple_exp_B (e:'a tabexpr) = 
  match e.sabexpr with  (**H eid=-1 because boolean expression doesn't have it *)
      SALcmp (e1,ALOEq,e2)
 (* | SALeq (e1,e2) DEPRECATED *) ->
	S_Eq (-1,to_simple_exp_L e1, to_simple_exp_L e2)
    | _ ->
	failwith "Unsupported Expression Found!" 

type memo = vtx list (* list of already traversed nodes *)
    
let memoTraversed vtx ls = (vtx::ls)

let rec isTraversed vtx = function 
    []     ->
      false
  | (a::x) -> 
      if a = vtx then 
	true 
      else 
	isTraversed vtx x
	  

type eval_context =
  | C_LeftUni   of (expid * simple_exp)  (* _ U e  *)
  | C_RightUni  of (expid * graph)       (* G U _  *)
  | C_LeftDUni  of (expid * simple_exp)  (* _ ++ e *) 
  | C_RightDUni of (expid * graph)       (* G ++ _ *)
  | C_LeftApnd  of (expid * simple_exp)  (* _ @  e *)
  | C_RightApnd of (expid * graph)       (* G @  _ *)
  | C_LeftEq    of (expid * simple_exp)  (* _ =  e *)
  | C_RightEq   of (expid * allit)       (* l =  _ *)
  | C_LeftEdg   of (expid * simple_exp)  (* {_ : e} *)
  | C_RightEdg  of (expid * allit)       (* {l : _} *)
  | C_AddIMrk   of (expid * marker)      (* &m := _ *)
  | C_Cyc       of (expid)               (* cycle(_) *)
  | C_IfCond    of (simple_exp * simple_exp)  (* if (_) e1 e2 *)
  | C_LetToL    of (lname * simple_exp)       (*  let $g = _ in e *)
  | C_LetToG    of (vname * simple_exp)       (* llet $l = _ in e *)
  | C_RecArg    of (expid * marker list * lname * vname * simple_exp) (* rec(\ ($l,$t).e)(_) *)
  | C_RecEnd    of memo                                                        (* entire return value of rec *)
  | C_ConnRec   of (expid * vtx * marker list * marker list * graph list * simple_exp list) (* args of doConnect *)
  | C_EscArg    of (expid * edge)             (* FrE (_,edge,expid) *)
  | C_EscEnd    of memo             (* FrE (_,edge,expid) *)
  | C_ConnEsc   of (expid * vtx * edge * marker list *  graph list * simple_exp list * allit list ) (* for doConnectEnc *)

type eval_stack    = (eval_context * dynenv) list
type configuration = 
    ( eval_stack     (* Evaluation Stack  *)
      * dynenv       (* Current Environment *)
      * memo         (* Moization Table *)
      * simple_exp ) (* Redex *)


(* let makeFrENode eid edge root g = *)
(*   let newRoot  = FrE (root,edge,eid) in  *)
(*     { v = SetofVtx.singleton newRoot; *)
(*       e = SetofEdge.empty; *)
(*       i = SetofInodeR.fold (fun (i,v) r -> *)
(* 			      if v = root then  *)
(* 				SetofInodeR.add (i,newRoot) r *)
(* 			      else  *)
(* 				r) g.i SetofInodeR.empty; *)
(*       o = SetofOnodeR.fold (fun (v,o) r -> *)
(* 			      if v = root then  *)
(* 				SetofOnodeR.add (newRoot,o) r *)
(* 			      else  *)
(* 				r) g.o SetofOnodeR.empty;} *)
  

(* let doConnectEnc eid edge vtx gs =  *)
(* (\*   let _     = print_string (string_of_int (length gs)) in  *\) *)
(* (\*   let _     = print_string "<<<\n" in *\) *)
(* (\*   let _     = map (fun g -> print_string (graph2str g)) gs in *\) *)
(* (\*   let _     = print_string ">>>\n" in  *\) *)
(*   let roots = map (fun g -> lookupI g "&") gs in  *)
(*   let root  = FrE (vtx,edge,eid) in  *)
(*   let repl r v = if v = r then root else v in *)
(*   let gs_v  = map (fun x -> x.v) gs in  *)
(*   let gs_e  = map (fun x -> x.e) gs in  *)
(*   let gs_o  = map (fun x -> x.o) gs in  *)
(*   let gs_i  = map (fun x -> x.i) gs in *)
(*   let vs    =  *)
(*     fold_right *)
(*       (fun (nodes,r) res -> *)
(* 	 SetofVtx.fold  *)
(* 	   (fun v res -> *)
(* 	      SetofVtx.add (repl r v) res) *)
(* 	   nodes res) *)
(*       (combine gs_v roots) SetofVtx.empty in  *)
(*   let es    = *)
(*     fold_right *)
(*       (fun (edges,r) res -> *)
(* 	 SetofEdge.fold  *)
(* 	   (fun (u,a,v) res ->  *)
(* 	      SetofEdge.add (repl r u, a,  v) res) *)
(* 	   edges res 	    *)
(*       ) (combine gs_e roots) SetofEdge.empty in  *)
(*   let os    = *)
(*     fold_right  *)
(*       (fun (onodes,r) res -> *)
(* 	 SetofOnodeR.fold *)
(* 	   (fun (u,o) res -> *)
(* 	      SetofOnodeR.add (repl r u,o) res) *)
(* 	   onodes res) *)
(*       (combine gs_o roots) SetofOnodeR.empty in  *)
(*   let is    = *)
(*     fold_right *)
(*       (fun (inodes,r) res -> *)
(* 	 SetofInodeR.fold *)
(* 	   (fun (i,u) res -> *)
(* 	      SetofInodeR.add (i, repl r u) res) *)
(* 	   inodes res) *)
(*       (combine gs_i roots) SetofInodeR.empty in  *)
(*   let graph =  *)
(*     { v = SetofVtx.add root vs; *)
(*       e = es; *)
(*       i = SetofInodeR.add ("&",root) is; *)
(*       o = os; } in  *)
(* (\*  let _ = print_string (graph2str graph) in  *)
(*     let _ = print_string "\n\n" in *\) *)
(*     graph  *)



(* let makeEncExp eid edge graph = *)
(*   let root = lookupI graph "&"  in  *)
(*   let graphAt vtx =  *)
(*     reachableG {v = graph.v;  *)
(* 		e = graph.e;  *)
(* 		i = SetofInodeR.singleton ("&",vtx); *)
(* 		o = graph.o } in *)
(* (\*   let _    = print_string "__<<<<\n" in *\) *)
(* (\*   let _    = print_string (graph2str graph) in  *\) *)
(* (\*   let _    = print_string (graph2str (graphAt root)) in      *\) *)
(* (\*   let _    = print_string "__>>>>\n\n" in  *\) *)
(*   let landv =  *)
(*     SetofEdge.fold (fun (u,a,v) r -> *)
(* 		      if (u = root)  then  *)
(* 			  (a,v)::r *)
(* 		      else  *)
(* 			r) graph.e [] in *)
(*   let ecall g   = S_EncC (eid,edge,S_GVal g) in *)
(*   let emp_mark  = (SetofMarker.empty,SetofMarker.empty) in *)
(*   let eedge a v = (\* computation for edge (root,a,v) *\) *)
(*     S_Edg(-1,emp_mark,S_LVal a, *)
(* 	  ecall (graphAt v)) in *)
(*     match landv with *)
(*       | [] -> *)
(* 	  S_GVal (makeFrENode eid edge root	   *)
(* 		    { emptyGraph with  *)
(* 			i = SetofInodeR.singleton ("&",root);  *)
(* 		        o = SetofOnodeR.filter (fun (v,o) -> v = root) graph.o}) *)
(*       | _  -> *)
(* 	  S_EncB(eid,edge,root, *)
(* 		 map (fun (a,v) -> eedge a v) landv) *)

	
(* (\* construct hubs from root for markers, and connect  *\) *)
(* (\* them to matching input nodes for each graph in gs  *\) *)
(* let doConnect eid markers root gs =  *)
(*   let vsH =  *)
(*     SetofMarker.fold (fun m r -> *)
(* 			SetofVtx.add (Hub (root,m,eid)) r)  *)
(*       markers SetofVtx.empty in  *)
(*   let gs_v = map (fun x -> x.v) gs in *)
(*   let gs_e = map (fun x -> x.e) gs in  *)
(*   let gs_o = map (fun x -> x.o) gs in  *)
(*   let vs =  *)
(*     fold_right  *)
(*       SetofVtx.union gs_v SetofVtx.empty in *)
(*   let es = *)
(*     fold_right *)
(*       SetofEdge.union gs_e SetofEdge.empty in *)
(*   let is =  *)
(*     SetofMarker.fold (fun m r -> *)
(* 			 SetofInodeR.add (m,Hub (root,m,eid)) r) *)
(*       markers SetofInodeR.empty in *)
(*   let os =  *)
(*     fold_right *)
(*       SetofOnodeR.union gs_o SetofOnodeR.empty in  *)
(*   let internal_es =  *)
(*     SetofMarker.fold  *)
(*       (fun m r -> *)
(* 	 SetofEdge.union *)
(* 	   (fold_right  *)
(* 	      (fun g r ->  *)
(* 		 try  *)
(* 		   let v = lookupI g m in *)
(* 		     SetofEdge.add (Hub (root,m,eid), ALEps, v) r *)
(* 		 with _ -> r *)
(* 	      ) gs SetofEdge.empty) r)   *)
(*       markers (SetofEdge.empty) in *)
(*     { v = SetofVtx.union vsH vs; *)
(*       e = SetofEdge.union es internal_es ; *)
(*       i = is; *)
(*       o = os } *)


(* (\**H BEGIN code by Hidaka  *\) *)
(* let rec_base_case setZ u sid d = *)
(*   (\* let _  = print_string "rec base-case\n" in *\) *)
(*   (\**H from recursive semantics implementation *\) *)
(*   let s1 =  fun (u,z) -> Hub (u,z,sid) (\* S1 (u,z) *\) in *)
(*   let base_s1 (u:vtx) =  *)
(*     { v = maps_Marker2Vtx    (fun z -> s1 (u,z))      setZ; *)
(*       i = maps_Marker2InodeR (fun z -> (z, s1 (u,z))) setZ; *)
(*       e = SetofEdge.empty; o = SetofOnodeR.empty; } in *)
(*   let omark_s1 (u:vtx) omS =  *)
(*     { v = maps_Marker2Vtx    (fun z ->  s1 (u,z))     setZ; *)
(*       i = maps_Marker2InodeR (fun z -> (z, s1 (u,z))) setZ; *)
(*       e = SetofEdge.empty;  *)
(*       o = setmap_Marker2OnodeR (fun z ->  *)
(* 	maps_Marker2OnodeR (fun y -> (s1 (u,z), (y &^ z))) omS) setZ ; } in *)
(*   let (_,omS) = markersV d u in *)
(*   if SetofMarker.is_empty omS then  (\* case u of {} *\) *)
(*     base_s1 u *)
(*   else  (\* case u of &y1 U &y2 U ...  *\) *)
(*     omark_s1 u omS *)
(* (\**H  END  code by Hidaka  *\) *)


(* (\* Construction of loop expression *\) *)

    

(* let isEpsilon l =  *)
(*   match l with  *)
(*       ALEps -> true  *)
(*     | _     -> false *)

let dummy_id    = -1
let dummy_vtype = (SetofMarker.empty,SetofMarker.empty)

(* let makeRecExp eid markers l g ebody graph =  *)
(*   let root = lookupI graph "&"  in  *)
(*   let (landv,epsTo) = (\* collect (label,node) pairs by 1-step traversal from the root *\) *)
(*     SetofEdge.fold (fun (u,a,v) (r1,r2) -> *)
(* 		      if (u = root)  then  *)
(* 			if isEpsilon a then  *)
(* 			  (r1,v::r2) *)
(* 			else *)
(* 			  ((a,v)::r1,r2) *)
(* 		      else  *)
(* 			(r1,r2)) graph.e ([],[]) in *)
(* (\*  let _ = printf "<<%i>>\n" (length landv) in *)
(*     let _ = print_string (graph2str graph) in  *\) *)
(*   let ecall gf  = S_RecC (eid,(markers,markers),markers,l,g,ebody,S_GVal gf) in  *)
(*   let elet a v gf =  *)
(*     (\* *)
(*       computation for edge (root,a,v) *)

(*       llet $l = a  in *)
(*       let $g = gf in  *)
(*          enc_{root,a,v}(ebody) *)
(*     *\) *)
(*     let edge = (root,a,v) in  *)
(*       S_LLet (dummy_id,dummy_vtype,l,S_LVal a,            (\* bind $l by llet expression *\) *)
(* 	      S_GLet(dummy_id,dummy_vtype,g,S_GVal gf,    (\* bind $g by let expression  *\) *)
(* 		     S_Enc(eid,edge,ebody))) in (\* to be wraped with FrE *\) *)
(*   let graphAt vtx =  *)
(*     reachableG {v = graph.v;  *)
(* 		e = graph.e;  *)
(* 		i = SetofInodeR.singleton ("&",vtx); *)
(* 		o = graph.o } in *)
(*   let ap  e1 e2 = S_Apnd (dummy_id,dummy_vtype,e1,e2) in (\**H emp_mark seems to be unused anywhere *\) *)
(*   let ex = *)
(*     match landv, epsTo with *)
(* 	[],[] ->  *)
(* 	  (\* emptyGraph *\)  *)
(* 	  S_GVal (rec_base_case markers root eid graph)  *)
(*       | _  ->  *)
(* 	  (\* initial state for doConnect redex *\) *)
(* 	  S_RecB (eid,markers,root,  *)
(* 		  rev_append  *)
(* 		    (rev_map  *)
(* 		       (fun v -> ecall (graphAt v)) epsTo) *)
(* 		    (rev_map *)
(* 		       (fun (a,v) -> *)
(* 			  let gr = graphAt v in  *)
(*                             (\* llet $l=a in let $g=gr in esc(ebody) @ rec(ebody)(gr) *\) *)
(* 			    ap (elet a v gr) (ecall gr)) landv))  in *)
(*     ex *)


(* Function outMarkers v G returns 
   the output markers put on vertex v in graph G. *)
let outMarkers vtx graph =
  SetofOnodeR.fold (fun (x,o) r -> if x = vtx then o::r else r) (graph.o) []


let doConnectRec eid root recM outM gs =
  let (>>=) m f = concatMap f m in
(*   let _ = print_string ("outM :: [" ^ String.concat ";" outM ^ "]\n") in  *)
(*   let _ = print_string ("recM :: [" ^ String.concat ";" recM ^ "]\n") in  *)
  let vRecN = 
    SetofVtx.fromList (map (fun m -> Hub (root,m,eid)) recM) in 
  let eRecN =
    SetofEdge.fromList (
      gs >>= (fun g -> 
		recM >>= (fun m -> 
			    try 
			      [ (Hub (root,m,eid), ALEps, lookupI g m) ]
			    with _ ->
			      [])
	     )) in
  let oRecN = 
    SetofOnodeR.fromList (
      recM >>= (fun m ->
	  outM >>= (fun n -> 
	      [ (Hub (root,m,eid), n &^ m) ]))
    ) in 
    (* iRecN is empty *) 
  let vv = 
    SetofVtx.union vRecN (List.fold_left 
			    (fun r g -> SetofVtx.union g.v r) SetofVtx.empty gs) in
  let ee =
    SetofEdge.union eRecN (List.fold_left 
			     (fun r g -> SetofEdge.union g.e r) SetofEdge.empty gs) in 
  let oo =
    SetofOnodeR.union oRecN (List.fold_left 
			       (fun r g -> SetofOnodeR.union g.o r) SetofOnodeR.empty gs) in 
  let ii =
    SetofInodeR.fromList 
      (map (fun m -> (m,Hub (root,m,eid))) recM) in 
    { v = vv; e = ee; i = ii; o = oo }

				      

		  				   
let doConnectEsc eid root edge outM gs ls =
  let newRoot = FrE (root,edge,eid) in
  let vv = 
    SetofVtx.add newRoot 
      (List.fold_left 
	 (fun r g -> SetofVtx.union g.v r) SetofVtx.empty gs) in
  let ee = 
    SetofEdge.union 
      (List.fold_left 
	 (fun r (lab,g) ->	    
	    SetofEdge.add (newRoot,lab,lookupI g "&") r) 
	 SetofEdge.empty (List.combine ls gs))
      (List.fold_left
	 (fun r g -> SetofEdge.union g.e r) SetofEdge.empty gs) in
  let ii = 
    SetofInodeR.singleton ("&",newRoot) in 
  let oo =
    SetofOnodeR.union
      (List.fold_left 
	 (fun r m -> 
	    SetofOnodeR.add (newRoot,m) r)
	 SetofOnodeR.empty outM)
      (List.fold_left
	 (fun r g -> SetofOnodeR.union g.o r) SetofOnodeR.empty gs) in 
    { v = vv; e = ee; i = ii; o = oo }
      
    
    

let makeRecExp eid recM varl varg ebody vtx graph =
  let makeExpFromEdge edge =
    let (_,lab,dst) = edge in 
    let recExp = S_Rec (eid,dummy_vtype,recM,varl,varg,ebody,S_NodeAt (dst,graph)) in
      match lab with 
	  ALEps -> (* rec(ebody)(dst|G) *)
	    recExp
	| _     -> (* esc( ebody[lab/$l,subG/$g] ) @ rec(ebody)(dst|G) *)
	    let subG = reachableG {graph with i = SetofInodeR.singleton ("&",dst)} in 
	    let letExp = 
	      S_LLet (dummy_id,dummy_vtype,varl,S_LVal lab,
		      S_GLet (dummy_id,dummy_vtype,varg,S_GVal subG,ebody)) in
	    let escExp =
	      S_EscEnd (S_Esc (eid, edge, letExp)) in 
	      S_Apnd (dummy_id, dummy_vtype, escExp, recExp) in
  let outEdges = 
    SetofEdge.fold (fun (src,lab,dst) r ->
		      if src = vtx then (src,lab,dst)::r else r) graph.e [] in
    S_ConnRec (eid,vtx,recM,outMarkers vtx graph, map makeExpFromEdge outEdges)

			    
let makeEscExp eid edge vtx graph = 
  let (labs,vtxs) = 
    SetofEdge.fold (fun (src,lab,dst) (labs1,vtxs1) ->
		       if vtx = src then
			 (lab::labs1, dst::vtxs1)
		       else
			 (labs1,vtxs1)) graph.e ([],[])  in
  let makeEscExpFromVtx v =
    S_Esc (eid,edge, S_NodeAt (v, graph)) in 
    S_ConnEsc (eid,vtx,edge,outMarkers vtx graph, 
	       map makeEscExpFromVtx vtxs, labs)

    

(* small step evaluation rule 
   S;\theta;N;e --> S';\theta';N';e' *)

let small_step 
    ((stack, env, memo, ev):configuration) : configuration =
  match ev with 
      (* Values *) 
    | S_BVal v -> (* S[ true ] or S[ false ] *)
	(* let _ = print_string "BValue\n" in *)
	(match stack with
	   | (C_IfCond (exp_t,exp_f), env)::stack ->
	       (stack,env,memo, (if v then exp_t else exp_f))
	   | _ -> failwith "small_step: Invalid context"   ) 
    | S_LVal v -> (* S[ label ] *)
	(* let _ = print_string "Label Value\n" in *)
	(match stack with
	   | (C_LeftEdg (eid,exp), env)::stack -> (* S,{ _ : e }[ lab ] *) 
	       ((C_RightEdg (eid,v),env)::stack,env,memo, exp)
	   | (C_LeftEq  (eid,exp), env)::stack -> (* S, _ = e [ lab ] *)
	       ((C_RightEq  (eid,v),env)::stack,env,memo, exp)
	   | (C_RightEq (_,lab), env)::stack ->   (* S, lab = _ [ lab' ] *)
	       (stack, env, memo, S_BVal (lab = v))
	   | (C_LetToL  (x,exp),env)::stack  ->   (* S, let $l = _ in e [ lab ] *)
	       (stack, intern_lv x v env, memo, exp)
	   | _ -> failwith "small_step: Invalid context in stack" 
	)
    | S_GVal v ->
	(* let _ = print_string "Graph Value\n" in *)
	(match stack with
	   | (C_AddIMrk (eid,marker), env)::stack -> (* S, $m := _[ G ] *) 
	       (stack, env, memo, S_GVal ((^:=) marker v))
	   | (C_RightEdg (eid,lab), env)::stack ->   (* S, {lab: _} [ G ] *)
	       (stack, env, memo, S_GVal ( (/:) ~expid:eid lab v))
	   | (C_LeftUni  (eid,exp),   env)::stack -> (* S, _ U e [ G ] *)
	       ((C_RightUni  (eid,v),env)::stack,env, memo, exp)
	   | (C_RightUni (eid,graph), env)::stack -> (* S, G U _ [ G' ] *)
	       (stack, env, memo, S_GVal ((+|) ~expid:eid graph v))
	   | (C_LeftDUni (eid,exp),   env)::stack -> (* S, _ (+) e [ G ] *)
	       ((C_RightDUni (eid,v),env)::stack,env,memo, exp)
	   | (C_RightDUni (eid,graph),env)::stack -> (* S, G (+) _ [ G' ] *)
	       (stack, env, memo, S_GVal ((|++) graph v))
	   | (C_LeftApnd (eid,exp), env)::stack ->   (* S, _ @ e [ G ] *)
	       ((C_RightApnd (eid,v),env)::stack, env, memo, exp)
	   | (C_RightApnd (exp,graph), env)::stack -> (* S, G @ _ [ G' ]*) 
	       (stack, env, memo, S_GVal ((@&) graph v))
	   | (C_LetToG (x,exp), env)::stack ->        (* S, let $g = _ in e [ G ]  *)
	       (stack,intern_gv x v env, memo, exp)
(* 	   | (RecArg (eid,markers,l,g,ebody),env)::stack -> (\**H pop for rec *\) *)
(* 	       let root = lookupI v "&" in *)
(* 		 if isTraversed root memo then  *)
(* 		   (stack, env,memo, S_GVal (makeHub eid markers root)) *)
(* 		 else   *)
(* 		   let memo' = memoTraversed root memo in *)
(* 		   let ex    = makeRecExp eid markers l g ebody v in *)
(* 		     (stack, env, memo', ex) *)
	   | (C_RecArg (eid, recM, varl, varg, ebody),env)::stack ->
	       let exp = 
		 SetofInodeR.fold 
		   (fun (i,vtx) r ->
		      let e = (* &i := rec(...)(vtx of G) *)
			S_IMrk (dummy_id, dummy_vtype, i, 
				S_Rec (eid, dummy_vtype, recM, varl, varg, ebody, 
				       S_NodeAt (vtx,v))) in 
			S_DUni (dummy_id, dummy_vtype, e, r))
		   v.i
		   (S_GEmp (dummy_id, dummy_vtype))  in 
		 (stack, env, memo, exp)
	   | (C_ConnRec (eid, root, recM, outM, proced, pend),env)::stack ->
	       (match pend with 
		  | [] ->
		      let gs = List.rev (v::proced) in 
			(stack, env, memo, S_GVal (doConnectRec eid root recM outM gs))
		  | e::es ->
		      ((C_ConnRec (eid,root,recM,outM,v::proced,es),env)::stack,env,memo,e))
	   | (C_RecEnd memo,env)::stack ->
	       (stack, env, memo, S_GVal v)    (* saved memo in context is restored *)
	   | (C_EscArg (eid,edge),env)::stack ->
	       let exp = 
		 SetofInodeR.fold 
		   (fun (i,vtx) r ->
		      let e = (* &i := esc(vtx of G) *)
			S_IMrk (dummy_id, dummy_vtype, i, 
				S_Esc (eid, edge, 
				       S_NodeAt (vtx,v))) in 
			S_DUni (dummy_id, dummy_vtype, e, r))
		   v.i
		   (S_GEmp (dummy_id, dummy_vtype))  in 
		 (stack, env, memo, exp)
	   | (C_ConnEsc (eid,root,edge,outM,proced,pend,ls),env)::stack ->
	       (match pend with 
		  | [] ->
		      let gs = List.rev (v::proced) in 
			(stack, env, memo, S_GVal (doConnectEsc eid root edge outM gs ls))
		  | e::es ->
		      ((C_ConnEsc (eid,root,edge,outM,v::proced,es,ls),env)::stack,env,memo,e))
	   | (C_EscEnd memo,env)::stack ->
	       (stack, env, memo, S_GVal v) (* restoring memo *) 
(* 	   | (EncArg (eid,edge),env)::stack -> (\**H pop rule for esc *\) *)
(* 	       let root = lookupI v "&" in *)
(* 		 if isTraversed root memo then  *)
(* 		   (stack, env, memo, S_GVal (makeFrENode eid edge root v)) *)
(* 		 else 		    *)
(* 		   (\* (stack, env, memo, S_GVal (frE_g edge eid v)) *\) *)
(* 		   (stack, env, memo, makeEncExp eid edge v) *)
(* 	   | (EncBody (eid,edg,root,proced,pend),env)::stack -> *)
(* 	       (match pend with *)
(* 		  | [] -> *)
(* 		      let gs = List.rev (v::proced) in  *)
(* 			(stack, env, memo, S_GVal (doConnectEnc eid edg root gs)) *)
(* 		  | e::es -> *)
(* 		      ((EncBody (eid,edg,root,v::proced,es),env)::stack,env,memo,e)) *)
(* 	   | (RecBody (eid,markers,root,proced,pend),env)::stack -> (\**H doConnect *\) *)
(* 		      (match pend with (\**H no further pending expr. *\) *)
(* 		  | [] -> (\**H pop rule *\) *)
(* 		      let gs = List.rev (v::proced) in *)
(* 			(stack,env,memo,S_GVal (doConnect eid markers root gs)) *)
(* 		  | e::es -> (\**H pop & push rule *\) *)
(* 		      ((RecBody (eid,markers,root,v::proced,es),env)::stack,env,memo,e)) *)
	   | (C_Cyc eid,env)::stack ->
	       (stack,env,memo, S_GVal ((!!<>) v))
	   | ((C_LetToL _|C_IfCond _|C_LeftEdg _|C_RightEq _|C_LeftEq _), _)::_ -> 
	       failwith "small_step: Graph value in the non-graph hole" (**H *)
	   | [] -> failwith "small_exp: empty stack." (**H *)
	)
	  (* for interal traversing *) 
    | S_NodeAt (vtx, graph) ->
	(match stack with 
	   | (C_RecArg (eid, recM, varl, varg, ebody),env)::stack ->
	       if isTraversed vtx memo then 
		 (stack, env, memo, S_ConnRec(eid,vtx,recM,outMarkers vtx graph,[]))
	       else 
		 let memo = memoTraversed vtx memo in 
		   (stack, env, memo, makeRecExp eid recM varl varg ebody vtx graph)
	   | (C_EscArg (eid,edge),env)::stack ->
	       if isTraversed vtx memo then 
		 (stack, env, memo, S_ConnEsc(eid,vtx,edge,outMarkers vtx graph,[],[])) 
	       else
		 let memo = memoTraversed vtx memo in 
		   (stack, env, memo, makeEscExp eid edge vtx graph)
	   | _ -> failwith "small_step: A graph is traversed by a non-recrusive function."
	)
	  (* for Expressions *)
    | S_TEmp (eid,_) ->
        let emptyTree = (!<>) ~expid:eid () in
	  (stack, env, memo, S_GVal emptyTree)
    | S_GEmp (eid,_) ->
	(stack, env, memo, S_GVal emptyGraph)
    | S_IMrk (eid,_,m,e) -> (**H push for &m := e *)
	((C_AddIMrk (eid,m), env)::stack, env, memo, e)
    | S_OMrk (eid,_,m)   ->
	(stack, env, memo, S_GVal ((!&) ~expid:eid m))
    | S_Edg  (eid,_,e1,e2) ->  (* push for {e1:e2} *)
	((C_LeftEdg (eid,e2),env)::stack,env,memo,e1)
    | S_Uni  (eid,_,e1,e2) ->  (* push for e1 U e2 *)
	((C_LeftUni (eid,e2),env)::stack,env,memo,e1)
    | S_DUni (eid,_,e1,e2) ->  (* push for e1 ++ e2 *)
	((C_LeftDUni (eid,e2),env)::stack,env,memo,e1)
    | S_Apnd (eid,_,e1,e2) ->  (* push for e1 @ e2 *)
	((C_LeftApnd (eid,e2),env)::stack,env,memo,e1)
    | S_LVar (eid,_,x) -> (**H just lookup label variable environment *)
	(stack,env,memo, S_LVal (lookupLVar env x))
    | S_GVar (eid,_,x) -> (**H just lookup graph variable environment *)
	(stack,env,memo, S_GVal (lookupVar env x))
    | S_If (eid,_,e1,e2,e3) ->
	((C_IfCond (e2,e3),env)::stack,env,memo,e1)
(*     | S_Rec (eid,_,markers,l,g,ebody,earg) ->   (\**H pushing rule for initial raw rec *\) *)
(* 	((RecArg (eid,markers,l,g,ebody),env):: *)
(* 	   (RecReturn (eid,memo),env)::stack, *)
(* 	 env,[],earg) *)
(*     | S_RecC (eid,_,markers,l,g,ebody,earg) -> (\**H from @ expr operand. earg is S_GVal *\) *)
(* 	((RecArg (eid,markers,l,g,ebody),env)::stack, *)
(* 	 env,memo,earg) (\**H just push *\) *)
(*     | S_RecB (eid,markers,root,exps) ->  (\**H doConnect *\) *)
(* 	(\*	let _ = print_string "YYYY\n" in *\) *)
(* 	(match exps with *)
(* 	     [] ->                           (\**H  emptyGraph seems incorrect but *\) *)
(* 	       (stack,env,memo,S_GVal emptyGraph) (\**H never reached by def. of makeRecExpsN ?! *\) *)
(* 	   | e::es ->  (\**H push rule with expression arguments *\) *)
(* 	       ((RecBody (eid,markers,root,[],es),env)::stack,env,memo,e)) *)
(*     | S_Enc  (eid,edg,ex) -> (\**H push for esc *\) *)
(* 	((EncArg (eid,edg),env):: *)
(* 	   (EncReturn (eid,memo),env)::stack,env,[],ex) *)
(*     | S_EncC (eid,edg,ex) -> (\**H push for esc *\) *)
(* 	((EncArg (eid,edg),env)::stack,env,[],ex) *)
(*     | S_EncB (eid,edg,root,exps) -> *)
(* 	(match exps with *)
(* 	   | e::es -> *)
(* 	       ((EncBody (eid,edg,root,[],es),env)::stack,env,memo,e) *)
(*            | [] -> not_expected "small_step" "S_EncB(_,_,_,[])") *)
    | S_Rec (eid,_,recM,varl,varg,ebody,earg) ->
	((C_RecArg (eid,recM,varl,varg,ebody),env)::stack,env,memo,earg)
    | S_RecEnd exp ->
	((C_RecEnd memo,env)::stack, env, memo, exp ) 
    | S_ConnRec (eid, vtx, recM, outM, es) ->
	(match es with 
	   | [] -> 
	       (stack, env, memo, S_GVal (doConnectRec eid vtx recM outM []))
	   | e::es ->
	       ((C_ConnRec (eid,vtx,recM,outM,[],es),env)::stack,env,memo,e)
	)
    | S_Esc (eid,edge,ex) -> 
	((C_EscArg (eid, edge),env)::stack,env,memo,ex)
    | S_EscEnd ex ->
	((C_EscEnd memo,env)::stack,env,memo,ex)
    | S_ConnEsc (eid, vtx, edge, outM, es, ls) ->
	(match es with 
	   | [] -> 
	       (stack, env, memo, S_GVal (doConnectEsc eid vtx edge outM [] []))
	   | e::es ->
	       ((C_ConnEsc (eid,vtx,edge,outM,[],es,ls),env)::stack,env,memo,e)	
	)   
    | S_LLet (eid,_,x,e1,e2) -> (**H push rule for llet *)
	((C_LetToL (x,e2),env)::stack,env,memo,e1)
    | S_GLet (eid,_,x,e1,e2) -> (**H push rule for let *)
	((C_LetToG (x,e2),env)::stack,env,memo,e1)
    | S_LLit (_,_,l) -> (**H just extract label value *)
	(stack,env,memo,S_LVal l)
    | S_Eq (eid,e1,e2) -> (**H push for e1 == e2 *)
	((C_LeftEq (eid,e2),env)::stack,env,memo,e1)
    | S_Cyc (eid,_,e) ->
	((C_Cyc eid,env)::stack,env,memo,e)
    | S_Cyc _ -> not_expected "small_step" "S_Cyc _"
        


(**H interpreter using small steps (for test only. not directly used for narrowing) *)
let small_step_eval env ex =
  let init_memo    = [] in
  let init_stack   = [] in 
  let rec fix (s,e,m,v) = (**H loop until all steps done *)
    let (s',e',m',v') = small_step (s,e,m,v) in
      match s',v' with
	  ([],S_GVal g) -> g  (**H all contexts consumed and graph value is left *)
	| _             -> fix (s',e',m',v') in  (**H otherwise continue *)
    fix (init_stack,env,init_memo,ex)


(**H test harness for small-step evaluator *)
let test_eval_small uncal db =
  let idState = GenId.current () in
  let ()      = GenId.set 0 in
  let _ = skolemBulk := true in
  let _ = escapeApnd := false in
  let rho = (intern_gv "$db" db emptyDynEnv) in
  let stEnv = dynenv2stenv rho in 
  let texpr = augType stEnv uncal in 
  let nexpr = numberE texpr in 
  let e = to_simple_exp nexpr in
  let g = small_step_eval rho e in 
  let ()  = GenId.set (idState) in 
    g

(**H reference test harness for bidirectional large-step evaluator *)
let test_eval_big uncal db =
  let idState = GenId.current () in
  let ()      = GenId.set 0 in
  let _ = skolemBulk := true in
  let _ = escapeApnd := false in
  let rho = (intern_gv "$db" db emptyDynEnv) in
  let stEnv = dynenv2stenv rho in 
  let texpr = augType stEnv uncal in 
  let nexpr = numberE texpr in 
  let (g,_) = bd_eval rho nexpr in 
  let ()  = GenId.set (idState) in 
    g

(* ignore info slot and fill None *)
let parseUnCAL_file   = (map_info (fun _ -> None)) @@ parseUnCAL_file 
let parseUnCAL_string = (map_info (fun _ -> None)) @@ parseUnCAL_string 

let test_uncal0 =
  parseUnCAL_string
    "rec(\\ ($l,$g).{$l:&} )( $db )"

(* a2d_xc *)
let test_uncal1 =
   parseUnCAL_string 
    "rec(\\ ($l,$g).if $l = a then {d: &} else if $l = c then & else {$l: &})($db)" 

(* consecutive a *)
let test_uncal2 =
 parseUnCAL_string
   "rec(\\ ($l,$g).if $l = a then rec(\\ ($l',$g').if $l' = a then $g' else {})($g) else {})($db)"

let test_uncal3 =
  parseUnCAL_string
    "&m1 @ rec(\\ ($l,$g).(&m1 := &m2, &m2 := {$l : &m1}))($db)"

let test_uncal4 = 
  parseUnCAL_string 
  "(&m1 @ rec(\\ ($l,$g).(&m1 := &m2, &m2 := {$l : &m1}))({test:&x} U {test2 : { test3 : &y }}))" (* " @ (&x&m1 := {rest:{}})" *)



let test_db0 = 
  let idState = GenId.current () in
  let ()      = GenId.set 0 in
  let _ = skolemBulk := true in
(* HIDAKA inlined access to file depends current workin directory 
   let d       = (clean_id @@ remove_eps @@ load_db @@ parseUnCAL_file) "../examples/bd_db.uncal" in *)
  let d       = (clean_id @@ remove_eps @@ load_db @@ parseUnCAL_string) 
      "{}" in 
  let ()     =  GenId.set (idState) in
    d


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

let save_graph graph filename =
  g2dot_file ~shape:`ellipse graph filename

let checkBS uncal db =
  let is_componentwise_eq g1 g2 =
    (SetofVtx.equal  g1.v g1.v)
    && (SetofEdge.equal g1.e g1.e)
    && (SetofInodeR.equal g1.i g2.i)
    && (SetofOnodeR.equal g1.o g2.o) in 
    is_componentwise_eq 
      (reachableG (test_eval_big uncal db)) 
      (reachableG (test_eval_small uncal db))

let checkBS_file uncal_file db_file =
  let idState =  GenId.current () in 
  let ()      =  GenId.set 0 in 
  let _ = skolemBulk := true in
  let db    = clean_id (remove_eps (load_db (parseUnCAL_file ~~db_file))) in 
  let uncal = parseUnCAL_file ~~uncal_file in 
  let ()      = GenId.set idState in 
    checkBS uncal db 

let test_eval_small_file uncal_file db_file = 
  let idState =  GenId.current () in 
  let ()      =  GenId.set 0 in 
  let _ = skolemBulk := true in
  let db    = clean_id (remove_eps (load_db (parseUnCAL_file ~~db_file))) in 
  let uncal = parseUnCAL_file ~~uncal_file in 
  let ()      = GenId.set idState in 
    test_eval_small uncal db

let mycheck s b = 
  let _ = 
    print_string s;
    print_string " :: " in 
    if b then 
      print_string "OK \n"
    else 
      print_string "NG \n"

let runTestSmallEval ()  = 
  print_string "-----------------------\n";
  print_string "Check for small_eval...\n";
  mycheck "  ID         " (checkBS test_uncal0 test_db);
  mycheck "  a2d_xc     " (checkBS test_uncal1 test_db);
  mycheck "  consecutive" (checkBS test_uncal2 test_db);
  mycheck "  multi-markR" (checkBS test_uncal3 test_db);
  mycheck "  multi-markO" (checkBS test_uncal4 test_db);
  print_string "-----------------------\n" 


		  
(* type nbn_subst = *)
(*     vtx * ( vtx * graph ) *)
      
(* type nbn_subst = nbn_single_subst list  *)

(* let apply_nbn_single_subst (v1 (v2,g2)) graph  *)
(*     =  *)
(*   let renameVtx  v = if v = v1 then v2 else v in *)
(*   let renameEdge (src,lab,dst) = (renameVtx src, lab, renameVtx dst) in  *)
(*     { v = SetofVtx.union g2 (SetofVtx.remove v1 graph.v); *)
(*       e =  *)
(* 	SetofEdge.union  *)
(* 	  (SetofEdge.fold  *)
(* 	     (fun edge r -> SetofEdge.add (renameEdge edge) r) *)
(* 	     g2.e SetofEdge.empty) *)
(* 	  (SetofEdge.fold  *)
(* 	     (fun edge r -> SetofEdge.add (renameEdge edge) r)  *)
(* 	     graph.e SetofEdge.empty); *)
(*       i =  *)
(* 	SetofInodeR.union *)
(* 	  (SetofInodeR.fold  *)
(* 	     (fun (m,x) r ->  *)
(* 		if m = "&" then r else SetofInodeR.add (m,renameVtx x) r) *)
(* 	     g2.i SetofInodeR.empty) *)
(* 	  (SetofInodeR.fold  *)
(* 	     (fun (m,x) r -> SetofInodeR.add (m,renameVtx x) r) *)
(* 	     graph.i SetofInodeR.empty); *)
(*       o =  *)
(* 	SetofOnodeR.union *)
(* 	  (SetofOnodeR.fold *)
(* 	     (fun (x,m) r ->  *)
(* 		SetofOnodeR.add (renameVtx x,m) r) *)
(* 	     g2.o SetofOnodeR.empty)  *)
(* 	  (SetofOnodeR.fold *)
(* 	     (fun (x,m) r ->  *)
(* 		SetofOnodeR.add (renameVtx x,m) r) *)
(* 	     graph.o SetofOnodeR.empty) } *)
	  
(* let apply_nbs_subst subst graph =  *)
(*   List.fold_right apply_nbn_single_subst subst graph *)
	
 

(*
 Implemenation of Narrowing Evaluation
*)
type label_restriction = 
    { eqL:   (allit * allit) list ;  (**H $l_1 =l_1, $l_2 =l_2, .... *)
      neqL:  (allit * allit) list  } (**H $l_1!=l_1, $l_2!=l_2, .... *)


type restriction =
    { label : label_restriction;
      count : int ;   (* For narrowing variables *)
      deact : SetofVtx.t;
      graph : graph   (* For graph to be inserted *)  }


let show_allit = function
  | ALLbl l -> l
  | ALStr s -> "\"" ^ s ^ "\""
  | ALInt i ->
      if i < 0 then "$l_" ^ string_of_int i
      else          string_of_int i
  | ALFlt f -> sprintf "%f" f
  | ALBol b ->
      if b then "true" else "false"
  | ALEps   -> "!"
  | ALUkn -> not_expected "show_allit" "ALUkn"
      
let show_restriction_eq eqs =
  fold_right (fun (l,r) res ->
		show_allit l ^ " = " ^ show_allit r ^ ",  " ^ res)
    eqs ""
    
let show_restriction_neq neqs =
  fold_right (fun (l,r) res ->
		show_allit l ^ " != " ^ show_allit r ^ ",  " ^ res)
    neqs ""

let show_restriction l =
  "[" ^ (show_restriction_eq l.eqL) ^ "]\n"
  ^ "[" ^ (show_restriction_neq l.neqL) ^ "]\n"



(* let ppr_allit ppf = function *)
(*     ALLbl (l) -> fprintf ppf "%s" l *)
(*   | ALStr (s) -> fprintf ppf "%S" s *)
(*   | ALInt (i) ->  *)
(*       if i < 0 then fprintf ppf "$l_%i" (0 - i) *)
(*                else fprintf ppf "%i"     i *)
(*   | ALFlt (f) -> fprintf ppf "%f" f *)
(*   | ALBol (b) -> fprintf ppf "%B" b *)
(*   | ALUkn     -> fprintf ppf "%s" "?" *)
(*   | ALEps     -> fprintf ppf "%s" "!" *)


 
(* (\* Node representing narrowing variable $(nv) *\) *)
(* let isActive  (Bid nv) = (nv < 0) && (nv mod 2 != 0) *)
(* (\* Node obtained from narrowing variable $(nv-1) *\) *)
(* let isPassive (Bid nv) = (nv < 0) && (nv mod 2 = 0) *)
(* let isActive (g:graph) (r:restriction) = *)
(*   let root = lookupI g "&" in *)
(*     match root with *)
(* 	Bid nv -> *)
(* 	  if (nv >= 0) || SetofVtx.mem (Bid nv) r.deact then *)
(* 	    false *)
(* 	  else *)
(* 	    true *)
(*       | _ -> *)
(* 	  false *)
let isActive root r = 
  match root with 
      Bid nv -> 
	if (nv >= 0) || SetofVtx.mem (Bid nv) r.deact then
	  false
	else
	  true 
    | _ -> 
	false


let newNVar r =
  let nv = r.count - 2 in
  let r' = { r with count = r.count - 2 } in
    (nv,r')


(* [FIXME] Instead of using ALInt, we must introduce
   new constructor to allit, like ALTBD (To Be Determined) *)
let newGNVar r = let (nv,r') = newNVar r in (Bid nv,r')
let newLNVar r = let (nv,r') = newNVar r in (ALInt nv,r')

(* let inValidateGVar = function (Bid nv) -> (Bid (nv-1)) *)
let inValidate var r =
  { r with
      deact = SetofVtx.add var r.deact ;
      graph = { r.graph with
		  v = SetofVtx.add var r.graph.v };
  }

let init_restriction =
  { label = { eqL = []; neqL = []};
    count = -1001;
    deact = SetofVtx.empty;
    graph = emptyGraph  }

let isNarrowingLVar l r =
  match l with
      ALInt i ->
	  (i < 0)
    | _       -> false

(* let isNarrowingGVar g r = *)
(*   try let root = lookupI g "&" in *)
(*     match root with *)
(* 	(Bid i) -> isActive g r *)
(*       | _       -> false *)
(*   with e -> *)
(*     false *)

let isNarrowingGVar root r =
  match root with
      (Bid i) -> isActive root r
    | _       -> false

(* let performSubstitutionG g (r:restriction) : graph = *)
(*   let gr = r.graph in *)
(*   let nv = lookupI g "&" in *)
(*     if SetofVtx.mem nv gr.v then *)
(*       let gr = { gr with *)
(* 		   v = SetofVtx.union  (g.v) gr.v; *)
(* 		   e = SetofEdge.union (g.e) gr.e; *)
(* 		   i = SetofInodeR.singleton("&",nv) } in *)
(* 	reachableG gr *)
(*     else *)
(*       g *)

let performSubstitutionG g (r:restriction) : graph = 
  let gr = r.graph in 
  let gr = { gr with 
	       v = SetofVtx.union (g.v) gr.v;
	       e = SetofEdge.union (g.e) gr.e } in 
    gr 

let performSubstitutionN ((nv:vtx),(g:graph)) (r:restriction) : vtx * graph = 
  let gr = r.graph in
    if SetofVtx.mem nv gr.v then
      let gr = { gr with
		   v = SetofVtx.union  (g.v) gr.v;
		   e = SetofEdge.union (g.e) gr.e; } in
	(nv, gr)
    else
      (nv,g)



type narrowing_configuration =
     (eval_stack * dynenv * memo * simple_exp * restriction)



(* Stream, or Lazy List *)
type 'a stream =
  | Next of ('a * ('a stream Lazy.t))
  | SEnd

let rec list2stream = function
    [] -> SEnd
  | x::y -> Next (x, lazy (list2stream y))

let hd_stream = function
  | Next (x,y) -> x
  | SEnd -> not_expected "hd_stream" "SEnd"
let tl_stream = function
    Next (x,y) -> force y
  | SEnd -> not_expected "hd_stream" "SEnd"

let rec map_stream f s =
  match s with
    Next (x,y) ->
	Next (f x,lazy (map_stream f (force y)))
  | SEnd -> SEnd

let rec filter_stream p s =
  match s with
    Next (x,y) ->
      if p x then
	Next (x,lazy (filter_stream p (force y)))
      else
	filter_stream p (force y)
  | SEnd -> SEnd

let rec merge_stream s1 s2 =
  match s1 with
      Next (x,y) ->
	Next(x, lazy (merge_stream s2 (force y)))
    | SEnd ->
	s2

type weight = int


type 'a narrowing_branch =
  | NIf   of ( 'a * 'a  )
  | NRec  of ( 'a stream )
  | NNext of ( 'a )
  | NStop

type narrowing_tree =
    NT of (narrowing_configuration * (narrowing_tree Lazy.t) narrowing_branch)

let unwrapNT = function NT x -> x


(* let rec s2l = function  *)
(*     | Next (x,y) -> x :: s2l (force y)  *)
(*     | SEnd       -> []  *)
  
(* let (<.>) f g x = f (g (x)) *)

(* let show_nt dep nt = *)
(*   let rec take n l = *)
(*     if n = 0 then [] *)
(*     else match l with  *)
(*       | [] -> [] *)
(*       | x::xs -> x::take (n-1) xs in *)
(*   let str = print_string in  *)
(*   let rec nspace n =  *)
(*     if n = 0 then () else (print_string " "; nspace (n-1)) in  *)
(*   let rec show_nt_impl ind n (t:narrowing_tree Lazy.t) =  *)
(*     if n >= dep then  *)
(*       () *)
(*     else *)
(*       let (cf,br) = unwrapNT (force t) in *)
(* 	match br with  *)
(* 	  | NIf (t1,t2) -> *)
(* 	      (nspace ind; str "NIF [\n" ; *)
(* 	       show_nt_impl (ind+2) (n+1) t1 ; str ",\n" ; *)
(* 	       show_nt_impl (ind+2) (n+1) t2 ; str "]") *)
(* 	  | NRec ts -> *)
(* 	      (nspace ind ; str "REC [\n" ; *)
(* 	       fold_right (fun t r ->  *)
(* 			     (show_nt_impl (ind+2) (n+1) t) ; str "\n" ; r) *)
(* 		 ((s2l ts)) (str "]")) *)
(* 	  | NStop -> (nspace ind; str "_") *)
(* 	  | NNext t ->   *)
(* 	      (show_nt_impl (ind) (n+1) t) in *)
(*     show_nt_impl 0 0 (lazy nt)  *)
      

  

type weighted_lazy_2tree =
  | BinLeaf
  | BinNode of ( narrowing_configuration
		 * (weight * weighted_lazy_2tree Lazy.t)
		 * (weight * weighted_lazy_2tree Lazy.t) )
  | UniNode of ( narrowing_configuration
		 * (weight * weighted_lazy_2tree Lazy.t) )

(*
  Assigning Weight Function according to branching structure
  of narrowing.

  [FIXME]: Users should be able to give such kind of functions
           when insertion.
*)
let rec assign_weight
    (nt:narrowing_tree) : (weighted_lazy_2tree Lazy.t) =
  let (conf,branch) = unwrapNT nt in
  lazy ( BinNode (conf,
		  (1,  assign_weight_b branch ),
		  (0,  lazy  BinLeaf) ))
and assign_weight_b br =
  match br with
    | NIf (t1,t2) ->
	let (cf1,br1) = unwrapNT (force t1) in
	let (cf2,br2) = unwrapNT (force t2) in
	  lazy ( BinNode (cf1,
			  (1,assign_weight_b br1),
			  (0, lazy (UniNode (cf2,
					     (1, assign_weight_b br2)
					    )))))
    | NNext t1 ->
	let (cf,br) = unwrapNT (force t1) in
	  (match br with
	     | NStop ->
	       lazy ( UniNode (cf,
			       (1, assign_weight_b br)) )
	     | _ -> (* short cut *) assign_weight_b br)
    | NRec s ->
	assign_weights 1 s
    | NStop ->
	lazy (BinLeaf)
and assign_weights
    (i  : int)
    (st : (narrowing_tree Lazy.t) stream) : weighted_lazy_2tree Lazy.t =
  match st with
    | Next (a,st) ->
	let (cf,br) = unwrapNT (force a) in
	  lazy ( BinNode (cf,
			  (1,    assign_weight_b br),
			  (100*i, assign_weights (i+1) (force st)) ))
    | SEnd ->
	(* Never Reached *)
	lazy (BinLeaf)
		
			            
(* Work as priority queue used in Dijkstra search *)
module SetOfWBT = Set.Make (
  struct
    type t = (weight * int * weighted_lazy_2tree Lazy.t)
    let  compare (w1,i1,_) (w2,i2,_) =
      let c = Pervasives.compare w1 w2 in
	if c = 0 then
	  compare i1 i2
	else
	  c
  end
)

(* [FIXME] I should use binary heap instead of Set *)
let dijkstra_search wbt =
  let rec ds cnt q =
    (* let _ = printf "<<queue: %i>>\n" (SetOfWBT.cardinal q) in *)
    if SetOfWBT.is_empty q then
      SEnd
    else
      let (w,i,nt) = SetOfWBT.min_elt q in
      (* let _ = printf "#depth: %i, #visited: %d\n" w i in *)
      let q        = SetOfWBT.remove (w,i,nt) q in
	match force nt with
	  | BinNode (c,(wl,l),(wr,r)) ->
	      let q = SetOfWBT.add (w+wl,cnt,l) q in
	      let q = SetOfWBT.add (w+wr,cnt+1,r) q in
		Next (c, lazy (ds (cnt+2) q))
	  | UniNode (c,(wl,l)) ->
	      let q = SetOfWBT.add (w+wl,cnt,l) q in
		Next (c, lazy (ds (cnt+1) q))
	  | BinLeaf ->
	      ds cnt q in
    ds 1 (SetOfWBT.singleton (0,0,lazy wbt))

let dijkstra_search_nt nt =
  dijkstra_search (force (assign_weight nt))


let filter_results st =
  filter_stream (fun (s,_,_,g,r) ->
		   match s,g with
		       [],S_GVal g ->
			 true (* ( not (evalg_AIsemp g) ) *)
		     | _ ->
			 false) st

let enumerate_it_p p st =
  let f = function
    | (_,_,_,S_GVal g,r) ->
        (g,r.label,r.graph)
    | _ -> not_expected "enumerate_it_p" "(_,_,_,not S_GVal _,_) for f"
  in  filter_stream p
	(map_stream f (filter_results st))

let enumerate_it st =
  enumerate_it_p (fun _ -> true) st

let has_next x = match x with
  | SEnd   -> false
  | Next _ -> true

let rec nth_stream n st =
    if n = 0 then
      hd_stream st
    else
      nth_stream (n-1) (tl_stream st)

let replaceList l1 l2 eqS =
  let f l = if l = l1 then l2 else l in
    map (fun (lv1,lv2) -> (f lv1, f lv2)) eqS


let substituteNeqs eqS neqS =
  let rec repl neqS eqS =
    match eqS with
	[] -> neqS
      | (l1,l2)::eqS  ->
	  match l1,l2 with
	      ALInt i, _ ->
		let neqS = replaceList l1 l2 neqS in
		let eqS  = replaceList l1 l2 eqS in
		  repl neqS eqS
	    | _, ALInt i ->
		let neqS = replaceList l2 l1 neqS in
		let eqS  = replaceList l2 l1 eqS in
		  repl neqS eqS
            | _, _ -> not_expected "substituteNeqs" "(%a,%a) for repl"
                PrintUnCAL.pr_allit l1 PrintUnCAL.pr_allit l2 in
  repl neqS eqS
    
let substituteG eqS g =
  let rec replaceID l1 l2 v =
    let f l = if l = l1 then l2 else l in
      match v with
	| Bid i       ->
	    Bid i
	| Hub (i,m,c) ->
	    Hub (replaceID l1 l2 i, m, c)
	| FrE (i,(u,l,v),c) ->
	    FrE (replaceID l1 l2 i, (u, f l, v), c)
	| InT c -> InT c
	| ImT (c,m) -> ImT (c,m)
	| IaT (c,i) -> IaT (c,replaceID l1 l2 i)
        | S2 _ | S1 _ -> not_expected "substituteG" "(S1 _|S2 _) for replaceID" in
  let replaceGraph l1 l2 g =
    { g with
	v = SetofVtx.fold
	(fun v vertices ->
	   SetofVtx.add (replaceID l1 l2 v) vertices) g.v SetofVtx.empty;
	e = SetofEdge.fold
	(fun (u,l,v) edges ->
	   if l = l1 then SetofEdge.add (replaceID l1 l2 u,l2,replaceID l1 l2 v) edges
	   else           SetofEdge.add (replaceID l1 l2 u,l, replaceID l1 l2 v) edges) g.e SetofEdge.empty; } in
  let rec repl g eqS =
    match eqS with
	[] -> g
      | (l1,l2)::eqS  ->
	  match l1,l2 with
	      ALInt i, _ ->
		let g   = replaceGraph l1 l2 g in
		let eqS = replaceList  l1 l2 eqS in
		  repl g eqS
	    | _, ALInt i ->
		let g   = replaceGraph l2 l1 g in
		let eqS = replaceList  l2 l1 eqS in
		  repl g eqS
            | _, _ -> not_expected "substituteG" "(%a,%a) for repl"
                PrintUnCAL.pr_allit l1 PrintUnCAL.pr_allit l2 in
  repl g eqS
		  


(* [FIXME] *)
let addLeq (l1,l2) r =
  let _ = "---- addLeq ----\n" in
    { r with label = {r.label with eqL = (l1,l2)::r.label.eqL } }

let addLneq (l1,l2) r =
  let _ = "---- addLneq ----\n" in
    { r with label = {r.label with neqL = (l1,l2)::r.label.neqL; } }






let isValid r =
  let neqs = substituteNeqs r.label.eqL r.label.neqL in
  let res  = not (exists (fun (l1,l2) -> l1 = l2) neqs) in
    res



let upto n =
  let rec up n r  =
    if n <= 0 then
      r
    else
      up (n-1) (n::r) in
    up n []

(*
(* replace node v1 with v2 *)
let replaceNode v1 v2 graph =
  let change v1 v2 v =
    if v1 = v then
      v2
    else
      v in
  if SetofVtx.mem v1 graph.v then
    { v = SetofVtx.add v2 (SetofVtx.remove v1 graph.v);
      e = SetofEdge.fold (fun (u,l,v) e ->
			    let u' = change v1 v2 u in
			    let v' = change v1 v2 v in
			      SetofEdge.add (u',l,v') e)
	graph.e (SetofEdge.empty);
      i = SetofInodeR.fold (fun (m,v) i ->
			      SetofInodeR.add (m,change v1 v2 v) i)
	graph.i (SetofInodeR.empty);
      o = SetofOnodeR.fold (fun (v,m) o ->
			      SetofOnodeR.add (change v1 v2 v,m) o)
	graph.o (SetofOnodeR.empty); }
  else
    graph

let replaceNodeEnv v1 v2 rho =
  { gvenv = map (fun (v,g) -> (v,replaceNode v1 v2 g)) rho.gvenv;
    lvenv = rho.lvenv;
  }
*)

let addEdge (u,l,v) graph =
  if SetofVtx.mem u (graph.v) then
    { graph with
	v = SetofVtx.add u (SetofVtx.add v (graph.v));
	e = SetofEdge.add (u,l,v) (graph.e);
    }
  else
    graph

let addEdgeR (u,l,v) r =
  let g = { r.graph with
	      v = SetofVtx.add v (r.graph.v);
	      e = SetofEdge.add (u,l,v) (r.graph.e) } in
    { r with graph = g }
  

(*
let addEdgeEnv edge rho =
  { gvenv = map (fun (v,g) -> (v,addEdge edge g)) rho.gvenv;
    lvenv = rho.lvenv;
  }
*)



let addNEdgesEsc n eid edge (nv,graph) r =
  let var    = nv in 
  let r      = inValidate var r   in
  let r =
    fold_right (fun _ r ->
		  let (lv,r) = newLNVar r in
		  let (gv,r) = newGNVar r in
		  let r      = addEdgeR   (var, lv, gv) r in
		    r) (upto n) r in
(*  let _     = print_string ("n: " ^ string_of_int n) in *)
  let (nv,graph) = performSubstitutionN (nv,graph) r in
    (makeEscExp eid edge nv graph, r )

let loopEdgeEsc v eid edge (nv,graph) r =
  let var    = nv  in
  let r      = inValidate var r  in
  let r =
    addEdgeR (var, ALEps, v) r in
  let (nv,graph) = performSubstitutionN (nv,graph) r in
    (makeEscExp eid edge nv graph, r)

let makeEscExpsN eid edge (nv,graph) memo r =
  let rec nats i = Next (i,lazy (nats (i+1))) in
    merge_stream
      (list2stream (map (fun v -> loopEdgeEsc  v eid edge (nv,graph) r) memo))
      (map_stream (fun i -> addNEdgesEsc i eid edge (nv,graph) r) (nats 0))
  

let addNEdgesRec n eid markers l g ebody (nv,graph) r =
  let var    = nv in 
  let r      = inValidate var r   in
  let r =
    fold_right (fun _ r ->
		  let (lv,r) = newLNVar r in
		  let (gv,r) = newGNVar r in
		  let r      = addEdgeR   (var, lv, gv) r in
		    r) (upto n) r in
(*  let _     = print_string ("n: " ^ string_of_int n) in *)
  let (nv,graph) = performSubstitutionN (nv,graph) r in
(*   let _     = print_string (graph2str graph) in
  let _     = print_string (graph2str r.graph) in *)
    (makeRecExp eid markers l g ebody nv graph, r )

let loopEdgeRec v eid markers l g ebody (nv,graph) r =
  let var    = nv in 
  let r      = inValidate var r  in
  let r =
    addEdgeR (var, ALEps, v) r in
  let (nv,graph) = performSubstitutionN (nv,graph) r in
    (makeRecExp eid markers l g ebody nv graph, r )

let makeRecExpsN eid markers l g ebody (nv,graph) memo r =
  (* Whenever this function is called, the root of the graph is
     narrowing variable *)
  let rec nats i = Next (i,lazy (nats (i+1))) in
  (* let rec nats () = Next (0, lazy (Next (1, lazy SEnd ))) in *)
    merge_stream
      (list2stream (map  (fun v -> loopEdgeRec  v eid markers l g ebody (nv,graph) r) memo))
      (map_stream (fun i -> addNEdgesRec i eid markers l g ebody (nv,graph) r) (nats 0))

let narrowing_step
    ((stack,env,memo,exp,r):narrowing_configuration)
    : narrowing_configuration narrowing_branch =
  let by_small_step (s,e,m,x) =
    let (s',e',m',x') = small_step (s,e,m,x) in
      NNext (s',e',m',x',r) in
    match exp with
      (* For Values *)
      | S_LVal nv ->
	  if isNarrowingLVar nv r then
	    (match stack with
	       | (C_RightEq (_,lab), env)::rest_stack ->
		   (* lab == _ *)
		   let r_true  = addLeq  (lab,nv) r in
		   let r_false = addLneq (lab,nv) r in
		     (match (isValid r_true, isValid r_false) with
			  true, true  -> NIf ( (rest_stack,env,memo,S_BVal true,  r_true),
					       (rest_stack,env,memo,S_BVal false, r_false) )
			| true, false -> NNext ( (rest_stack,env,memo,S_BVal true, r_true) )
			| false,true  -> NNext ( (rest_stack,env,memo,S_BVal false, r_false) )
			| false,false -> NStop)
	       | _ ->
		   by_small_step (stack,env,memo,exp))
	  else
	    (match stack with
	       | (C_RightEq (_,lab), env)::rest_stack ->
		   if isNarrowingLVar lab r then
		     let r_true  = addLeq  (lab,nv) r in
		     let r_false = addLneq (lab,nv) r in
		       (match (isValid r_true, isValid r_false) with
			    true, true  -> NIf ( (rest_stack,env,memo,S_BVal true,  r_true),
						 (rest_stack,env,memo,S_BVal false, r_false) )
			  | true, false -> NNext ( (rest_stack,env,memo,S_BVal true, r_true) )
			  | false,true  -> NNext ( (rest_stack,env,memo,S_BVal false, r_false) )
			  | false,false -> NStop)
		   else
		     by_small_step (stack,env,memo,exp)
	       | _ ->
		   by_small_step (stack,env,memo,exp))
      | S_GVal nv ->
	  by_small_step (stack,env,memo,exp)
(* 	  let nv = performSubstitutionG nv r in *)
(* 	    if isNarrowingGVar nv r then *)
(* 	      (match stack with *)
(* 		 | (C_LeftApnd _,_)::stack -> *)
(* 		     failwith "Graph with markers are not supported." *)
(* 		 | (C_RecArg (eid,markers,l,g,ebody),env)::stack -> *)
(* 		     let root = lookupI nv "&" in *)
(* 		       if isTraversed root memo then *)
(* 			 NNext (stack, env, memo, S_GVal (makeHub eid markers root),r) *)
(* 		       else *)
(* 			 let memo' = memoTraversed root memo in *)
(* 			 let er_s  = makeRecExpsN eid markers l g ebody nv memo r (\* memo instead of memo' is intentional *\)  in *)
(* 			   NRec ( map_stream  (fun (e,r) -> (stack,env,memo',e,r)) er_s ) *)
(* 		 | (C_EscArg (eid,edge),env)::stack -> *)
(* 		     let root = lookupI nv "&" in *)
(* 		       if isTraversed root memo then *)
(* 			 NNext (stack, env, memo, S_GVal (makeFrENode eid edge root nv), r) *)
(* 		       else *)
(* 			 let memo'  = memoTraversed root memo in *)
(* 			 let er_s  = makeEncExpsN eid edge nv memo r (\* memo instead of memo' is intentional *\)  in *)
(* 			   NRec ( map_stream  (fun (e,r) -> (stack,env,memo',e,r)) er_s ) *)
(* 		 | _ -> *)
(* 		     by_small_step (stack,env,memo,exp)) *)
(* 	    else *)
(* 	      by_small_step (stack,env,memo,exp) *)
      | S_NodeAt (nv,graph) ->
	  let (nv,graph) = performSubstitutionN (nv,graph) r in 
	    if isNarrowingGVar nv r then 
	      (match stack with 
		 | (C_RecArg (eid,recM,varl,varg,ebody),env)::stack ->
		     if isTraversed nv memo then 
		       NNext (stack, env, memo, S_ConnRec(eid,nv,recM,outMarkers nv graph,[]),r)
		     else
		       let memo' = memoTraversed nv memo in 
		       let er_s  = makeRecExpsN eid recM varl varg ebody (nv,graph) memo r (* memo instead of memo' is intentional *) in 
                         NRec ( map_stream  (fun (e,r) -> (stack,env,memo',e,r)) er_s )
		 | (C_EscArg (eid,edge),env)::stack ->
		     if isTraversed nv memo then 
		       NNext (stack, env, memo, S_ConnEsc(eid,nv,edge,outMarkers nv graph,[],[]),r) 
		     else 
		       let memo'  = memoTraversed nv memo in
		       let er_s  = makeEscExpsN eid edge (nv,graph) memo r (* memo instead of memo' is intentional *)  in
			 NRec ( map_stream  (fun (e,r) -> (stack,env,memo',e,r)) er_s )
		 | _ -> 
		     by_small_step (stack,env,memo,exp))
	    else
	      by_small_step (stack,env,memo,exp)
      | _ ->
	  by_small_step (stack,env,memo,exp)
	    

let narrow rho e r =
  let init_conf = ([],rho,[],e,r) in (**H initial configuration *)
  let rec makeNt (conf:narrowing_configuration)
      : narrowing_tree =
    let (s,_,_,e,_) = conf in
      match (s,e) with
	| ([], S_GVal g) ->
	    NT (conf, NStop )
	| _ ->
	    match narrowing_step conf with
	      | NIf (c1,c2) ->
		  let l1 = lazy (makeNt c1) in
		  let l2 = lazy (makeNt c2) in
		    NT (conf,NIf (l1,l2) )
	      | NNext c   ->
		  (* NT (conf,NNext (lazy (makeNt c))) *)
		  makeNt c (* NB: UnCAL always terminates! *)
	      | NRec st   ->
		  let n = map_stream (fun c -> lazy (makeNt c)) st in
		    NT (conf,NRec n)
	      | NStop     ->
		  NT (conf,NStop) in
    makeNt init_conf




let test_eval_narrow uncal db =
  let idState = GenId.current () in
  let ()      = GenId.set 0 in
  let _ = skolemBulk := true in
  let _ = escapeApnd := false in
  let rho = (intern_gv "$db" db emptyDynEnv) in
  let stEnv = dynenv2stenv rho in
  let texpr = augType stEnv uncal in
  let nexpr = numberE texpr in
  let e = to_simple_exp nexpr in
  let nt = narrow rho e init_restriction in
  let wt = assign_weight nt in
  let s  = enumerate_it (dijkstra_search (force wt)) in
  let ()  = GenId.set (idState) in
    s

let takeNodeName g =
  let nv = lookupI g "&" in
    nv

let test_insert node uncal db p =
  let r      = init_restriction in
  let sv     = trace node in
  let (nv,r) = newGNVar r in
  let db     = addEdge (sv, ALEps, nv) db in
  let idState = GenId.current () in
  let ()      = GenId.set 0 in
  let _ = skolemBulk := true in
  let _ = escapeApnd := false in
  let rho = (intern_gv "$db" db emptyDynEnv) in
  let stEnv = dynenv2stenv rho in
  let texpr = augType stEnv uncal in
  let nexpr = numberE texpr in
  let e     = to_simple_exp nexpr in
  let nt = narrow rho e r in
  let wt = assign_weight nt in
  let s  = enumerate_it (dijkstra_search (force wt)) in
  let s  =
    filter_stream
      (fun (gOut,constr,gIn) ->
	 if (SetofVtx.mem node gOut.v) then
	   true (* FIXME: Filter out the case that
		   inserted graph is empty. *)
	 else
	   false) s in
  let s  = map_stream (fun (gOut,constr,gIn) ->
			 let gIn = { db with
				       v = SetofVtx.union db.v gIn.v;
				       e = SetofEdge.union db.e gIn.e; } in
			 let gOut = substituteG    constr.eqL gOut in
			 let gIn  = substituteG    constr.eqL gIn  in
			 let neqL = substituteNeqs constr.eqL constr.neqL in
			   (gOut,neqL,gIn)) s in
  let s  = filter_stream (fun x -> p x) s in
  let () = GenId.set idState in 
    s

(* Interfaces *)
let do_insert_p =
  test_insert
let do_insert node uncal db =
  do_insert_p node uncal db (fun _ -> true)

let do_insert_p_k node uncal db p k =
  nth_stream k (do_insert_p node uncal db p)

let do_insert_k node uncal db k =
  nth_stream k (do_insert node uncal db)

    
let test_eval_narrow_k1 k =
  let db    = test_db in
  let uncal = test_uncal1 in
  let s     = test_insert (Hub (Bid 5,"&",9)) uncal db (fun _ -> true) in
    nth_stream k s

let test_eval_narrow_k1' k =
  let db    = test_db in
  let uncal = test_uncal1 in
  let s     = test_insert (Hub (Bid 0,"&",9)) uncal db (fun _ -> true) in
    nth_stream k s

let test_eval_narrow_k2 k =
  let db    = test_db in
  let uncal = test_uncal2 in
  let s     = test_insert (Hub (Bid 5,"&",9)) uncal db (fun _ -> true) in
    nth_stream k s

let save_triple basename (graphOut,constr,graphIn) = 
  let inName  = basename ^ "_i.dot" in
  let outName = basename ^ "_o.dot" in 
  let conName = basename ^ "_c.txt" in 
  let _       = save_graph graphIn  inName in 
  let _       = save_graph graphOut outName in
  let ch      = open_out conName in
  let _       = output_string ch (show_restriction_neq constr) in 
  let _       = close_out ch in 
    ()

    

