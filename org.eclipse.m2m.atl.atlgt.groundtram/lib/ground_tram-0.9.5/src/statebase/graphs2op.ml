(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
(*********** editing detection *************************)
open UnCALDM
open Fputil
open UnCALDMutil
open Dotutil
open Scc
open UnCALDMutil_scc
open Format
open PrintUnCALDM


(*****  extracting deletion ********)

let extract_deletedstate eSdel gOrg dotfile_deleted = 
  let g' = SetofEdge.fold (flip remove_edge) eSdel  gOrg in
(* let d_diff = Dotutil.graph_diff gOrg g' in
  let _ = dispD_gc d_diff in *)
  g2dot_file ~shape:`ellipse g' dotfile_deleted; g'


(* DOT file dotfile_deleted can be fed to bwdD_uncal *)


(**** extracting edge-renamings *****)
(* apply edge-renaming *)
let extract_renamedstate eSmod g' dotfile_renamed =
  let g'' =
    let mPVtx = setofEdge2mapofPVtx eSmod in
    let lookup_e (((vs,_,vt) as e):edge) : edge = 
      try (SetofEdge.choose (MapofPVtx.find (vs,vt) mPVtx)) with  Not_found -> e in
    {g' with e = SetofEdge.map lookup_e g'.e} in
  (* let d_diff = Dotutil.graph_diff g' g'' in
  let _ = dispD_gc d_diff in *)
  g2dot_file ~shape:`ellipse g'' dotfile_renamed

(* extracting non-intelligent insertions [TBD] *)


(* extracting intelligent insertions [TBD] *)
(* detection of markers shold also be done by looking for associated markers 
   at added nodes gAdd_v  *)
(* extract as a form of subgraph by taking reachable parts, and 
   extract connecting points as roots  *)
(* using strongly-connected components detection to extract list 
   of inserted subgraphs (reverse-edge should be added during preprocessing  *)


module UnlabeledGraph =
  struct
    module SVtx = struct
      include SetofVtx
    end
    module SEdge = struct 
      include SetofPVtx
    end
    module MVtx = struct
      include MapofVtx
    end
    let getEnds (vs,vt) = (vs,vt)
    let mapEnds (f,g) (vs,vt) = (f vs,g vt)
end

module ULGSCC = SCC(UnlabeledGraph)

let make_gscc_from_eS eS =
  let vS = setofEdge_collectNodes eS in
  let pvS = setmap_Edge2PVtx (fun (u,_,v) -> SetofPVtx.fromList [(u,v);(v,u)]) eS in
  let sccMapV = ULGSCC.make_scc vS pvS in
  let ((nSin, nEin), sccMapVE, v2repr) = ULGSCC.make_gscc pvS sccMapV in
  ((nSin, nEin), sccMapVE, v2repr)
  
let make_UnCAL_gscc vS eS =
  let sccMapV = USCC.make_scc vS eS in
  let ((nSin, nEin), sccMapVE, v2repr) = USCC.make_gscc eS sccMapV in
  ((nSin, nEin), sccMapVE, v2repr)

let root_USCC nSin nEin sccMapVE =
  let (oEdgeS_scc,iEdgeS_scc) = USCC.build_ioedge_map nSin nEin in
  let rootVS = (* nodes that have no incoming edges *)
    MapofVtx.fold (fun v _ ->
      if (SetofEdge.is_empty (iEdgeS_scc v)) then SetofVtx.add v else id) sccMapVE SetofVtx.empty in
  if SetofVtx.cardinal rootVS = 1 then SetofVtx.choose rootVS 
  else failwith "root_USCC: multiple roots for Gscc" 
  
let gscc_list eSadd gOrg =
  let ((nSin, nEin), sccMapVE, v2repr) = make_gscc_from_eS eSadd in
  let mPVtx = setofEdge2mapofPVtx eSadd in
  let lookupPVtx p = try (MapofPVtx.find p mPVtx) with Not_found->SetofEdge.empty in
   (* nEin should be empty *)
   SetofVtx.fold (fun vGscc ->
     (* collect edges matching endpoints *)
       let (sccVS,sccEIS,sccEOS) = MapofVtx.find vGscc  sccMapVE in
       let (vS,eS) = (sccVS,setmap_PVtx2Edge lookupPVtx sccEIS) in
       let ((nSin', nEin'), sccMapVE',_) = make_UnCAL_gscc vS eS in
       let rootGscc = root_USCC nSin' nEin' sccMapVE' in
       let (rootVscc,_,_) = MapofVtx.find rootGscc sccMapVE' in
       let rootVS = SetofVtx.inter gOrg.v rootVscc in
       let root = if SetofVtx.cardinal rootVS = 1 
       then SetofVtx.choose rootVS 
       else failwith "more than one inserting points" in
       cons { v = vS; e = eS; i=SetofInodeR.singleton ("&",root); o=SetofOnodeR.empty; (* FIXME *) }) 
    nSin []
     

(*  list of graphs *)
(* the ID of the root is the insertion point to give to insertion reflection algorithm *)
let extract_Gins eSadd gOrg dotfile_Gins =
  let glist = gscc_list eSadd gOrg in
  let prefix = Filename.chop_extension dotfile_Gins in
  let suffix = get_suffix dotfile_Gins in
  let cnt = ref 0 in
  List.iter (fun g -> 
    let dotfile = prefix ^ "_" ^ string_of_int !cnt  ^  "." ^ suffix in
    let root = lookupI g "&" in
    cnt := !cnt + 1;
    fprintf std_formatter "insertion point #%d = %a@." !cnt pr_vtx root;
    g2dot_file ~shape:`ellipse g dotfile) glist

let graphs2op gOrg gMod dotfile =
  let prefix = Filename.chop_extension dotfile in
  let suffix = get_suffix dotfile in
  let dotfile_deleted = prefix ^ "_deleted." ^ suffix in
  let dotfile_renamed = prefix ^ "_renamed." ^ suffix in
  let dotfile_Gins    = prefix ^ "_inserted." ^ suffix in
  let (g,gAdd_v,gDel_v,eSadd,eSdel,eSmod,_) = graph_diff_aux gOrg gMod in
  (* let _ = dispG_gc ~is_raw:true g in *)
  let g' = 
    if SetofEdge.is_empty eSdel then gOrg else  
    extract_deletedstate eSdel gOrg dotfile_deleted in
  if (not (SetofEdge.is_empty eSmod)) then 
    extract_renamedstate eSmod g' dotfile_renamed;
  extract_Gins eSadd gOrg dotfile_Gins

