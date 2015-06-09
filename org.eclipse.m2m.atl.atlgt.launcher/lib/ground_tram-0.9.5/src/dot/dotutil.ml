(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
open Fputil
open UnCALDM
open UnCALDMutil
open Dot
open PrintDot


(* set att=value to nodes in set s *)
let add_attr (att:string) (value:string) (al: attr list) : attr list =
  let dattr = DAttr (att, value) in
  let to_be_kept = function
      DAttr (att',_) when att'=att           -> false
    | DAttr (_,   _) | DELabel _ | DNLabel _ -> true in
  dattr :: (List.filter to_be_kept al)
    
let addAttrToNodeSet (dot:dot) (vS:SetofVtx.t) (att:string) (value:string) : dot =
  let repl stmt =
    match stmt with
      DAGraph _  | DANode  _ | DAEdge  _ | DEdge _ | DNode(DRaw _,_) | DGroup _ -> stmt
    | DNode(DVtx v,al)  ->
	let al' =
	  if SetofVtx.mem v vS then add_attr att value al else al
        in DNode(DVtx v,al')
  in { dot with stmt_list =  List.map repl dot.stmt_list ; }

let addAttrToNodeAttr (dot:dot) (att:string) (value:string) : dot =
  let repl stmt (flag,ss) =
      match stmt with
      DAGraph _  | DNode  _ | DAEdge  _ | DEdge _ | DGroup _ -> (flag,(stmt::ss))
    | DANode al  -> let al' = add_attr att value al in (true,(DANode al'::ss)) in
  let (foundp,newstmt) = List.fold_right repl  dot.stmt_list (false,[]) in
  { dot with stmt_list =
    if foundp then newstmt else (DANode (add_attr att value []))::newstmt; }

let rec find_elabel = function
    [] -> failwith "find_elabel: not found"
  | (DAttr (_,_))::xs    -> find_elabel xs
  | (DNLabel (_ ,_))::xs -> failwith "find_elabel: node label in edge"
  | (DELabel al)::_      -> al

let find_attr (attr:string) (al:attr list) : attr_value option =
  let rec fa = function
      []     -> None
    | at::xs -> match at with
	DAttr (a,v) when attr = a       -> Some v
      | DAttr _ | DNLabel _ | DELabel _ -> fa xs
  in fa al

let addAttrToEdgeSet (dot:dot) (eS:SetofEdge.t) (att:string) (value:string) : dot =
  let repl stmt =
    match stmt with
      DAGraph _  | DANode  _ | DAEdge  _ | DNode _ | DGroup _ -> stmt
    | DEdge(DVtx vs,al,DVtx vt) ->
	let e = (vs,find_elabel al,vt) in
	let al' =
	  if SetofEdge.mem e eS then add_attr att value al else al
        in DEdge(DVtx vs,al',DVtx vt)
    | DEdge _ -> stmt
  in { dot with stmt_list =  List.map repl dot.stmt_list ; }

(* convert graph to dot *)
(* cmp_eps : compress epsilon edges and nodes that is connected only to epsilon edges *)
let g2dot ?(gray_unreachable = false) ?(cmp_eps=false) ?(ops = []) (g:graph) : dot =
  let vtx2dot_id v = DVtx v in
  let (oEdgeS,iEdgeS) = build_ioedge_map g in
  let to_be_compressed_v =
    let p (v:vtx) = SetofEdge.for_all isEpsEdge (SetofEdge.union (oEdgeS v) (iEdgeS v)) in
    let cmpvs = if cmp_eps then SetofVtx.filter p g.v else SetofVtx.empty in
    fun (v:vtx) -> SetofVtx.mem v cmpvs in
  let to_be_compressed_e = isEpsEdge in
  let cmpvattr_list =
    List.fold_right (uncurry add_attr) [("style","dotted");("fontsize","10");("width","0.3");("height","0.25")] [] in
  let vtx2stmt (v:vtx) : stmt =
    let vattr_list = if to_be_compressed_v v then cmpvattr_list else []  in
    let (ims,oms) = markersV g v in
    let (iml,oml) = mapT2 SetofMarker.elements (ims,oms) in
    DNode(vtx2dot_id v, (DNLabel (iml, oml))::vattr_list) in
  let cmpeattr_list = List.fold_right (uncurry add_attr) [("style","dotted")] [] in
  let opvs =
    maps_Edge2Vtx (fun (_,l,v) -> v) (SetofEdge.filter (fun (_,l,v) -> List.mem l ops) g.e) in
  let edge2stmt ((u,a,v) as e :edge) : stmt =
    let eattr_list = if to_be_compressed_e e then cmpeattr_list else []  in
    let (du,da,dv) = (vtx2dot_id u,DELabel a,vtx2dot_id v) in
    if ((SetofVtx.mem u opvs) || (SetofVtx.mem v opvs)) then
      let dir_attr = add_attr "dir" "back" eattr_list in DEdge (dv,da::dir_attr,du)
    else DEdge (du,da::eattr_list,dv) in
  let d0 = { graph_id = "g";
    stmt_list = 
    (SetofVtx.fold (fun v -> cons (vtx2stmt v)) g.v 
      (SetofEdge.maptoList edge2stmt g.e)  );} in
  if gray_unreachable
  then
    let dv = reachableGI g in
    let vS = SetofVtx.diff  g.v dv.v  in
    let eS = SetofEdge.diff g.e dv.e  in
    (* color name can be obtained in <graphviz-src>/lib/common/colortbl.h *)
    let gray = "gray" (* "lightgray" *) in
    let d1 = addAttrToNodeSet d0 vS "color"     gray in
    let d1 = addAttrToNodeSet d1 vS "fontcolor" gray in
    let d1 = addAttrToEdgeSet d1 eS "color"     gray in
    let d1 = addAttrToEdgeSet d1 eS "fontcolor" gray in d1
  else d0

let dot2g (d:dot) : graph =
  let (vS,eS,iS,oS) =
  List.fold_right (fun s ((vS,eS,iS,oS) as r) ->
    match s with
      DAGraph _ | DANode  _ | DAEdge _ | DGroup _ -> r
    | DNode(DVtx v,al)  -> 
       let (irs,ors) = 
      (List.fold_right (fun a ((iSv,oSv) as mr) ->
	match a with
	  DAttr (_,_) | DELabel _  -> mr
	| DNLabel (iml,oml) ->
	    ((List.fold_right (fun m -> 
	      SetofInodeR.add (m,v)) iml iSv),
	     (List.fold_right (fun m ->
	       SetofOnodeR.add (v,m)) oml oSv)
            )
	      )  al (iS,oS)
      ) in
       (SetofVtx.add v vS, eS, 
	SetofInodeR.union irs iS,
	SetofOnodeR.union ors oS)
    | DEdge(DVtx vs,al,DVtx vt) ->
	let l = find_elabel al in
	let e = match (find_attr "dir" al) with
	  None | Some "forward" -> (vs,l,vt)
	| Some "back"           -> (vt,l,vs)
	| Some x                -> failwith ("dot2g: unsupported direction" ^ x) in
	(vS,SetofEdge.add e eS,iS,oS)
    | DNode _ | DEdge _ -> r
    ) d.stmt_list
     (SetofVtx.empty,SetofEdge.empty,SetofInodeR.empty,SetofOnodeR.empty)
  in { v=vS; e=eS; i=iS; o=oS; }

(* visualizing difference *)

(*  mcol  color for modified parts *)
(*  acol  color for added    parts *) 
(*  dcol  color for deleted  parts *) 
let gdiff2dot ?(mcol=("red":string)) ?(acol=("purple":string))
   ?(dcol=("lightpink":string)) (g,gAdd_v,gDel_v,eSadd,eSdel,eSmod) = 
  let d    = g2dot g  in
  let d    = addAttrToNodeSet d gAdd_v "fontcolor" acol in
  let d    = addAttrToNodeSet d gAdd_v "color"     acol in
  let d    = addAttrToNodeSet d gDel_v "fontcolor" dcol in
  let d    = addAttrToNodeSet d gDel_v "color"     dcol in
  let d    = addAttrToEdgeSet d eSadd  "fontcolor" acol in
  let d    = addAttrToEdgeSet d eSadd  "color"     acol in
  let d    = addAttrToEdgeSet d eSdel  "fontcolor" dcol in
  let d    = addAttrToEdgeSet d eSdel  "color"     dcol in
  let d    = addAttrToEdgeSet d eSmod  "fontcolor" mcol in
  d

let graph_diff (gOrg:graph) (gMod:graph) : dot =
 let (g',gAdd_v,gDel_v,eSadd,eSdel,eSmod,_) = graph_diff_aux gOrg gMod in
   gdiff2dot (g',gAdd_v,gDel_v,eSadd,eSdel,eSmod)

let dumpDot ?(shape=(`ellipse:shape)) ?prefix_n ?expnl (d:dot) (file:string) : unit =
  let d = addAttrToNodeAttr d "shape" (shape2str shape) in
  let oc = open_out file in
  let fmt = Format.formatter_of_out_channel oc in
  pp_dot ~shape ?prefix_n ?expnl fmt d;
  close_out oc

let g2dot_file ?(shape=(`record:shape)) ?prefix_n ?(gray_unreachable = false)
    ?(ops = []) ?(cmp_eps = false) ?(expnl = false) (g:graph) (file:string) = 
  dumpDot ~shape ?prefix_n ~expnl:expnl (g2dot ~gray_unreachable:gray_unreachable ~ops:ops ~cmp_eps:cmp_eps g) file

let dot2imagef (format:string) ?(remove_dot_file = true) ?(dot_file = "")
    ?(shape = (`record:shape)) ?prefix_n dot (image_file:string) : unit =
  let dot_file = if (dot_file = "") then gtm_temp_file "dot2imagef" ".dot" else dot_file in
  let _ = dumpDot ~shape ?prefix_n dot dot_file in
  let _ = dotf2imagef format dot_file image_file in
  if remove_dot_file then
    Sys.remove dot_file

let g2image (format:string) ?remove_dot_file ?dot_file ?(gray_unreachable = false) 
    ?shape ?prefix_n ?(ops = [])
    ?(cmp_eps = false) (g:graph) (image_file:string) : unit = 
  let dot = g2dot ~gray_unreachable:gray_unreachable ~ops:ops ~cmp_eps:cmp_eps g in
  dot2imagef format ?remove_dot_file ?dot_file ?shape ?prefix_n dot image_file

(*
  let dot_file = if (dot_file = "") then Filename.temp_file "g2image" ".dot" else dot_file in
  let _ = dumpDot ~shape ?prefix_n dot dot_file in
  let _ = dotf2imagef format dot_file image_file in
  if remove_dot_file then
    Sys.remove dot_file
*)

let g2png = g2image "png"

  
    
