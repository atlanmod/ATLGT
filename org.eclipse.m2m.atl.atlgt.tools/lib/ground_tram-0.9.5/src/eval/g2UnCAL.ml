(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
(*    g2uncal.ml: output a graph as a simple UnCAL expression *)
open UnCALDMutil
open UnCALDM
open UnCAL
open UnCALSA

let g2uncal (g:graph) : 'a option aexpr =
  (* naive implementation in Section 4.2 of the paper, plus 
     proper handling of input markers other than root *)
  (* what if g already has marker &znn?
      if marker exists in g.i or g.o such that
         the name of the marker matches pattern znnn
      if SetofMarker.exists 
	  (fun m -> Str.string_match (Str.regexp "&z[0-9]+") m 0) 
	  (SetorMarker.union g.i g.o) then  ... *)
  let g = clean_id g  in (* normalize edge id to Bid of int *)
  let prefix = (* take marker that is largest in dictionary order *)
    let mS = SetofMarker.union (inputMarkers g) (outputMarkers g) in
    if SetofMarker.is_empty mS  then "z"
    else 
      let inhabi = SetofMarker.max_elt mS in
      String.sub inhabi 1 ((String.length inhabi)-1) in
  let prefix = if prefix = "" then "z" else prefix in
  let v2m = function
      (Bid i) as v -> "&" ^ prefix ^ (string_of_int i)
(*	let imS = fst (markersV g v) in 
	if SetofMarker.is_empty imS
	then "&" ^ prefix ^ (string_of_int i)
	else SetofMarker.choose imS *)
    | _       -> failwith "g2uncal: normalize vtx id first" in
  let e =
   (* &z2 := { b: &z2, c: &z3} *)
   (* nodes with no outgoing edge:    &z3 := {} *)
   (* nodes with output markers: &z2 := { b : &z2 } U &y *)
   SetofVtx.fold (fun v ae ->
      AEDUni (None,
        AEIMrk (None,v2m v,
           SetofEdge.fold (fun (_,l,vd) ae'  -> 
	     AEUni (None,AEEdg (None,ALLit (None,l),(AEOMrk (None,v2m vd))), ae')) 
		  (outgoEdgeS g v)
		  (SetofMarker.fold (fun m ae'' ->
		    AEUni (None, AEOMrk (None,m),ae'')
		    ) (snd (markersV g v)) (AETEmp None))),ae)) g.v (AEGEmp None)
  in 
  let e = 
   (* handles self cycle input nodes *)
    AECyc (None,AEDUni (None,
	   (SetofMarker.fold (fun m es ->
	     AEDUni (None,
             AEIMrk (None,m, AEOMrk (None,v2m (lookupI g m))),es))
              (inputMarkers g) (AEGEmp None)), e)) in
  if !cycleSemanticsOriginal 
  then 
  (* pickup input markers *)
    AEApnd (None,
    SetofMarker.fold (fun m es ->
      AEDUni (None,
        AEIMrk (None,m, AEOMrk (None,v2m (lookupI g m))),es))
                (inputMarkers g) (AEGEmp None)
       ,e)
  else e

(** Another reifier using tree with pointer representation.
    Input graph is first decomposed at concluent points,
    and then each component is recursively translated to UnCAL constructor
    expression. Memoization is not necessary. *)
let g2uncalT (g:graph) : 'a option aexpr =
  let prefix = (* take marker that is largest in dictionary order *)
    let mS = SetofMarker.union (inputMarkers g) (outputMarkers g) in
    if SetofMarker.is_empty mS  then "z"
    else
      let inhabi = SetofMarker.max_elt mS in
      String.sub inhabi 1 ((String.length inhabi)-1) in
  let prefix = if prefix = "" then "z" else prefix in
  let (g,mapV,end_id) = clean_id_aux g in
  let gid = GenId.current () in
  (*let genMarker () : marker = Gensym.next ("&" ^ prefix) in *)
  let incomBranches (g:graph) (v:vtx) = 
    let (imS,_) = markersV g v   in (* set of input markers *)
    let ieS     = incomEdgeS g v in (* set of incoming edges *)
    (imS,ieS) in
  let confluent (g:graph) (v:vtx) : bool =
    let (imS,ieS) = incomBranches g v in
    let nib = SetofMarker.cardinal imS + SetofEdge.cardinal ieS in (* incoming branches *)
    (nib > 1) in
  let v2m = function
      (Bid i) -> "&" ^ prefix ^ (string_of_int i)
    | _       -> failwith "g2uncalT: normalize vtx id first" in
  (* shift the id sequence *)
  let _ = GenId.set end_id in
  (* split graph at confluent nodes *)
  let imS_orig = inputMarkers g in
  let g = SetofVtx.fold (fun v g_acc ->
    if confluent g v then
      let m' = v2m v in
      let v' = newnode () in
      split_graph g_acc v v' m'
    else g_acc) g.v g in
  let an = None in (* default annotation *)
  let marker2u m     = AEOMrk (an,m) in
  let rec v2u (v:vtx) =
    (* branches *) (* no revisiting happen after graph split *)
    let oeS = outgoEdgeS g v in      (* ougoing edges *)
    let omS = snd (markersV g v) in  (* output markers *)
    let edge2u (_,l,v) = AEEdg (an,ALLit (an,l), v2u v) in
    let uni e1 e2      = AEUni (an, e1, e2) in
    let eS2u oeS =   SetofEdge.hom1 uni   edge2u oeS in
    let mS2u omS = SetofMarker.hom1 uni marker2u omS in
    match (SetofEdge.cardinal oeS,SetofMarker.cardinal omS) with
      0,0 -> AETEmp an 
    | 0,_ -> mS2u omS 
    | _,0 -> eS2u oeS
    | _,_ -> AEUni (an, eS2u oeS, mS2u omS) in
  let g2u (g:graph) =
    let irS = g.i in
    match (SetofInodeR.cardinal irS) with
      0 -> AEGEmp an 
    | _ ->
	let ir2u (m,v) = AEIMrk (an,m, v2u v) in
	let duni e1 e2 = AEDUni (an, e1,e2) in
	let e = SetofInodeR.hom1 duni ir2u irS in
	let e = AECyc (an, e) in
	if !cycleSemanticsOriginal then 
	  let project_e = SetofMarker.hom1 duni marker2u imS_orig in
	  AEApnd (an,project_e,e)
        else e in
  let e = g2u g in
  (* restore id sequence *)
  let _ = GenId.set gid in
  e

(* dump graph to file in *.uncal format 
  eg: dumpG db "db.uncal" *)
let dumpG (g:graph) (file:string) : unit = 
  let e = g2uncal g in
  let oc = open_out file in
  let fmt = Format.formatter_of_out_channel oc in
  let pp_a fmt a = Format.fprintf fmt "" in (* FIXME: do nothing, tentatively *)
  PrintUnCAL.ppr_aexpr fmt e;
  Format.pp_print_flush fmt (); (* flush buffer of pretty printer *)
  close_out oc

(** works like dumpG except that it generates tree-like form
   with revisited node marked with markers *)
let dumpGT (g:graph) (file:string) : unit = 
  let e = g2uncalT g in
  let oc = open_out file in
  let fmt = Format.formatter_of_out_channel oc in
  let pp_a fmt a = Format.fprintf fmt "" in (* FIXME: do nothing, tentatively *)
  PrintUnCAL.ppr_aexpr fmt e;
  Format.pp_print_flush fmt (); (* flush buffer of pretty printer *)
  close_out oc

