(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
(* shortest path using Dijkstra search *)
open ExtSetMap
open Print
open UnCALDM
open UnQL
open UnCAL
open Format
open PrintUnCALDM
open PrintUnCAL
open Fputil
open UnCALDMutil
open PrintUnQL
open EvalUnCAL
open UnCALSA

type priQ_ent = float * vtx * ((vtx * allit) option)

module PriQ = Set.Make (
  struct
    type t = priQ_ent
    let compare = Pervasives.compare
  end
)

let pp_xint fmt i = 
  if      (i = max_int) then fprintf fmt "%s" "inf"
  else if (i = min_int) then fprintf fmt "%s" "-inf"
  else                       fprintf fmt "%d" i

let pp_triple pp_a pp_b pp_c fmt (x,y,z) =
  fprintf fmt "@[<1>(%a,@,%a,@,%a)@]" pp_a x pp_b y pp_c z

let pp_priQ_ent = pp_triple pp_print_float pr_vtx (pp_option (pp_pair pr_vtx pr_allit))
let pr_PriQ = PriQ.pp_t "PriQ" pp_priQ_ent
(*
#install_printer pr_PriQ
*)
let lookupV v q =
  let (entS,_) = PriQ.partition (fun (_,v1,_) -> v = v1) q in
  match PriQ.cardinal entS with
    1 -> PriQ.choose entS
  | 0 -> raise Not_found
  | _ -> failwith "PriQ(lookupV): More than one entry found." 

let initq (g:graph) = SetofVtx.fold (fun v -> PriQ.add (infinity,v,None)) g.v PriQ.empty

let update_PriQ_ent new_ent old_ent = (PriQ.add new_ent) @@ (PriQ.remove old_ent)

let default_weight (l:allit) : float = 1.0 (* weight function *) (* parameterized later *)

let shortest_path_aux ?(weight=default_weight) (g:graph) (origin:vtx) (dest:vtx) = 
  (* input sanity check *)
  (* if origin and dest is not included in the graph,  then there is no solution *)
  if (not (SetofVtx.mem origin g.v)) then failwith "origin not included in the input graph";
  if (not (SetofVtx.mem dest   g.v)) then failwith "destination not included in the input graph";
  let compute_q workV dist1 q =
    (* lookup adjacenet nodes *)
    let eS = incomEdgeS g workV in
    (* sanity check *)
    if SetofEdge.is_empty eS then failwith "No solution (node without incoming edge reached)" else
    SetofEdge.fold (fun (u,l,_) q0 ->
      try
	let ent = lookupV u q0 in
	let (dist,_,next) = ent in
	let dist1 = dist1 +. weight(l) in
	if dist1 < dist then
	  update_PriQ_ent (dist1,u,Some (workV,l)) ent q0
	else q0
      with Not_found -> q0 (* incoming from already traversed nodes *)
		   ) eS q in
  let rec ds q = 
    (* functional implementation strategy:
       Return value is PriQ type, holding the out entries holding
       shortest path information.
       Returnes exception if sanity check fails.
       The function as a unit of loop takes input as a current PriQue,
       and returns new PriQue end OutPriQue.    *)
    let ent  = PriQ.min_elt q in
    let (dist1,workV,next) = ent in
    (* remove working node *)
    let q = PriQ.remove ent q in
    PriQ.add ent
      (if workV = dest then PriQ.empty
      else  ds (compute_q workV dist1 q)) in
  (* initialization *)
  let q = initq g in
  let workV = origin in
  let ent = lookupV workV q in
  let q = update_PriQ_ent (0.0,workV,None) ent q  in
  ds q


let shortest_path ?weight g origin dest =
  let outQ = shortest_path_aux ?weight g origin dest in
  let rec er w =
    let ent = lookupV w outQ in
    let (_,workV,next) = ent in
    match next with
      None       -> []
    | Some (v,l) -> l::(er v)
  in er dest

let path2rpp path = 
  let f = function
    ALLbl a -> `label (None,a)
(* | ALEps   -> `label "!" *) (* temporary store to dummy label *)
  | _       -> failwith "Non-symbolic label is not supported in rpp" in
  let c a b = (`concat(a,b)) in
 fold_left1  c  (List.map f path)

(* interfaces *)
(* given a node and return a path from the root as AST of the RPP *)

let extract_rpp ?weight g origin =
  let dest = 
    try lookupI g "&" with
      Not_found -> failwith "extract_rpp: no root marker"
    | e         -> raise e in
  let p = shortest_path ?weight g origin dest in
  if p = [] then `label (None,"!") else
  path2rpp p

let rpp2str p = toStr pp_rpp p

let lookupO g m = 
  let omr = SetofOnodeR.filter (fun (_,m') -> (m' = m)) g.o in
  match SetofOnodeR.cardinal omr with
    0 -> raise Not_found (* ("no such output node marked with " ^ m) *)
  | 1 -> fst (SetofOnodeR.choose omr)
  | _ -> failwith ("lookupO: Multiple or negative number of output nodes marked with " ^ m)

let has_eps g = SetofEdge.exists isEpsEdge g.e

let invert_viewmap = (* invert_MapofVtx2SVtx *) 
  MapofVtx.invert_m2s (module SetofVtx : Set.S with type elt = vtx and type t = SetofVtx.t)

(* a code useful just for open-nii project *)

let extract_tripezoid (cq:('a aexpr)) = 
    match cq with
      (AEApnd (_,AEOMrk (_, projmark),
	       AECyc (_,tu))) -> (projmark,tu)
    | _ -> failwith "unsupported UnCAL expression"

(* We don't have to search input markers, because if an input marker
   is not dangling, then there should be a corresponding  output marker.
   If an input marker is the one that is selected by @, then it is
   the root node, so the path is empty. If the input marker is dangling,
   then it is unreachable, so there is no route to the root. *)
   
let omarker2vtx (omarker:marker) (cq:('a aexpr)) = 
  let (projmark,tripezoid_uncal) = extract_tripezoid cq in
  let g = load_db tripezoid_uncal in
  let v = lookupO g omarker in
  let g0 = (!& projmark) @& (!!<> g) in
  let (g1,vm) = viewmaps_glue_safe_eps g0 in
  if has_eps g1 then failwith "omarker2vtx: unsafe eps found" else
  let vim = invert_viewmap vm.mapV in
  let vS1 = MapofVtx.find v vim in (g1,
  match SetofVtx.cardinal vS1 with
    0 -> failwith ("viewmap: No corresponding node found")
  | 1 ->  SetofVtx.choose vS1 
  | _ -> failwith ("viewmap: Multiple or negative number of corresponding node"))

let parseUnCAL_file = Parse.parse_file ~parse:ParseUnCAL.entry ~lex:LexUnCAL.token 
let elim_info i = None
let parseUnCAL_file f = map_info elim_info (parseUnCAL_file f)
    
let omarker2path omarker uncal_file =
  let cq = parseUnCAL_file uncal_file in
  let (g1,v0) = omarker2vtx omarker cq in
  extract_rpp g1 v0
