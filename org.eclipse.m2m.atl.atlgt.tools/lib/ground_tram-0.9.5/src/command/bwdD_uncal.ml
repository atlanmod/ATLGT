(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
(** Command-line interface for deletion *)

open Fputil
open Format
open EvalUnCAL
open UnCALdynenv
open UnCALDM
open UnCALDMutil
open Dotutil
open PrintDot
open UnCAL
open Version
open Contraction
open TestUnCALutil
open UnCALSA
open PrintUnCAL (* print_aexpr *)

let parseUnCAL_file   = (map_info (fun _ -> None)) @@ parseUnCAL_file

(** stages *)

(**
  
  1. Normal Foward execution.

   {v % bwdD_uncal -idot  db.dot -q q.uncal -odot output.dot [-opng result.png] v}

  2. User edit the view (deleting edges) and overwrite the output.dot.
     
  3. Perform deletion (updated source is saved in udb.dot). Updated source is displayed.
     If view side-effect is detected, it is also displayed.

   {v % bwdD_uncal -idot  db.dot -q q.uncal -odot output.dot [-opng result.png] \
     -uidot udb.dot (-uodot uoutput.dot) v}
*)

type config = {
    mutable idot_file    : string;      (** input DOT db file *)
    mutable q_file       : string;      (** input UnCAL query file *)
    mutable uq_file      : string;      (** input UnQL  query file *)
    mutable odot_file    : string;      (** output in dot format for user editing *)
    mutable uidot_file   : string;      (** updated DOT db file *)
    mutable uodot_file   : string;      (** updated DOT view file *)
    mutable prt_uncal    : bool;        (** turn on printing source UnCAL expression *)
    mutable su_flag      : bool;        (** show unreachable parts in the view *)
    mutable ge_flag      : bool;        (** glue safe epsilons in the view *)
    mutable lskolem_flag : bool;        (** leave Skolem terms *)
    mutable no_display   : bool;        (** do not display graph difference *)
    mutable opng_file    : string ;     (** output png file *)
    
}

let default_config = {
  idot_file = "";
     q_file = "";
    uq_file = "";
  odot_file = "";
 uidot_file = "";
 uodot_file = "";
  opng_file = "";
  prt_uncal = false;
    ge_flag = false;su_flag = false;lskolem_flag     = false;
 no_display = false;
}

let speclist =
  let cf = default_config in
  Arg.align
    [
     ("-idot", Arg.String (fun s->cf.idot_file<-s),     " source db file (in DOT)"); 
     ("-q",    Arg.String (fun s->cf.q_file<-s),        " source UnCAL file");
     ("-uq",   Arg.String (fun s->cf.uq_file<-s),       " source UnQL file");
     ("-odot", Arg.String (fun s->cf.odot_file<-s),     " target DOT file for editing and backward input");
     ("-opng", Arg.String (fun s->cf.opng_file<-s),     " target PNG file");
     ("-uidot",Arg.String (fun s->cf.uidot_file<-s),    " updated DOT db file ");
     ("-uodot",Arg.String (fun s->cf.uodot_file<-s),    " updated DOT view file (not implemented yet)");
     ("-pa",   Arg.Unit   (fun()->cf.prt_uncal<-true),  " print UnCAL input expression");
     ("-ge",   Arg.Unit   (fun()->cf.ge_flag<-true),    " glue safe epsilons in the view");
     ("-su",   Arg.Unit   (fun()->cf.su_flag<-true),    " show unreachable parts in the view");
     ("-ls",   Arg.Unit   (fun()->cf.lskolem_flag <-true), " leave Skolem terms");
     ("-nd",   Arg.Unit   (fun()->cf.no_display <-true)," do not display graph difference");
   ]

let speclist = add_version_spec speclist

let usage_msg = "Usage: "
  ^Sys.executable_name^ " -idot db.dot (-q query.uncal|-uq query.unql) -odot output.dot [-ge][-su][-pa][-ls][-nd]
        [ -uidot udb.dot -uodot uoutput.dot]"

let read_args () = 
  Arg.parse speclist (fun s -> ()) usage_msg; default_config

let failwith_msg msg =
  fprintf err_formatter "%s@." msg;
  Arg.usage speclist usage_msg; exit 1

(** [get_gEdit_expander ge_flag su_flag lskolem_flag g]
   @param ge_flag       if true, glue epsilon edge together
   @param su_flag       if true, show unreachable parts
   @param lskolem_flag  if true, leave skolem terms
   @param g             input graph
   @return              triple of unflattened and ID-flattened graph of g, and its expander
*)
let get_gEdit_expander ge_flag su_flag lskolem_flag g =
  let sb_flag = true (* don't care *) in
  let sa_flag = true (* don't care *) in
  let ei = make_editinfo ge_flag su_flag g sb_flag
      !escapeApnd !cycleSemanticsOriginal sa_flag in
  let get_flatIdG_expander g =
    if lskolem_flag then (g,id) else
    let (newG,mapV,_) = clean_id_aux g in
    let invm = MapofVtx.invert mapV in
    let lookupMap v = try (MapofVtx.find v invm) with
      Not_found -> failwith "lookupMap: Flat ID not found" in
    (newG, map_VEIO lookupMap) in
  let (gEdit, skolem_expand) = get_flatIdG_expander ei.g_edit in
  let expand newG' =
    let g_edit' = skolem_expand newG' in  (* unflatten node IDs *)
    let g_show' = if ei.glue_eps
    then merge_viewmaps ei.g_edit g_edit' ei.g_show ei.vm (* expand epsilons *)
    else g_edit' in
    let g' = if ei.show_unreachable then g_show' else begin
      let g_unreachable = evalg_simple_diff g ei.g_show in
      evalg_simple_union g_show' g_unreachable end in (g',g_edit') in
  (ei.g_edit,gEdit,expand)

let _ = 
  let cf = read_args () in
  let _ = print_version () in
  (* check arguments *)
  if      cf.idot_file = "" then failwith_msg "Source db file unspecified."
  else if (cf.q_file   = "" && cf.uq_file = "")
                            then failwith_msg "UnCAL source file unspecified."
  else if cf.odot_file = "" then failwith_msg "Result dot file for insertion unspecified."
  else
    let db = loadDot_file ~set_GenId:true ~descend_maxid:true cf.idot_file in
    let dynenv = (intern_gv "$db" db emptyDynEnv) in
    let _ = GenId.reset ()  in
    let ce = if cf.q_file <> "" then parseUnCAL_file cf.q_file 
    else  try (((map_info (fun _ -> None)) @@ unql2uncal @@ parseUnQL_file) cf.uq_file)
    with e -> catch_UnQL_exn e in
    let _ = 
      if cf.prt_uncal 
      then 
	begin 
	  print_endline "(************** begin Submitted Query ****************)";
	  print_aexpr ce;
	  print_endline "(**************  end  Submitted Query ****************)"
	end in
    let idState = GenId.current () in
    (* uncalcmd -dbd *.dot -q *.uncal -dot *.dot -rec -sr -pi *)
    let _ = evalRecRecursive    := true in
    let _ = skolemRec           := true in 
    let _ = optApndRecRecursive := true in
    let _ = escapeApnd          := true in
    let _ = optTCRec            := true in
    let _ = useTransNodeId      := true in
    let is_windows () = Sys.os_type="Win32" || Sys.os_type = "Cygwin" in 
    let get_diffname n = (Filename.chop_extension n) ^ "_diff." ^ (get_suffix n) in
    let g = eval_with_env dynenv ce in
    let get_gEdit_expander = get_gEdit_expander cf.ge_flag cf.su_flag cf.lskolem_flag in
    let (srG,newG,expand) = get_gEdit_expander g in
    let dot = g2dot ~gray_unreachable:true ~cmp_eps:true newG in
    if (cf.uidot_file <> "") then (* backward mode *)
      (* load data from odot_file as an updated view *)
      let newG' = loadDot_file cf.odot_file in
      (* TODO: reject if added edges are detected *)
      let (g',srG') = expand newG' in  (* unflatten node IDs and expand eps,unreach *)
      let gDiff = evalg_simple_diff g g' in (* compute deleted edges *)

(*      let deleS =    SetofEdge.setmap corr_set gDiff.e in
      let remaineS = SetofEdge.setmap corr_set g'.e in
      let deleS = SetofEdge.diff deleS remaineS in        *)
      let corr e = try SetofEdge.singleton (corr e) with _ -> SetofEdge.empty in
      let deleS = SetofEdge.setmap corr gDiff.e in
      let db' = SetofEdge.fold (flip remove_edge) deleS db in
      (* let _ = dispG_gc ~is_raw:true db' in *)
      let _ = 
	if (is_windows () || cf.no_display) then 
	  dumpDot ~prefix_n:false (graph_diff db db') (get_diffname cf.idot_file)
	else 
	  dispD_gc (graph_diff db db') in
      let g'' = 
	let dynenv' = (intern_gv "$db" db' emptyDynEnv) in
	let ()  = GenId.set (idState) in 
	(eval_with_env dynenv' ce) in
      let (srG'',newG'',expand') = get_gEdit_expander g'' in
      if bisimilar_opt srG' srG'' then begin
	fprintf std_formatter "%s@." "Deletion succeeded.";
	g2dot_file ~shape:`ellipse ~gray_unreachable:true
	  ~ops:[ALLbl"src_of"] db' cf.uidot_file; exit 0; end
      else
	begin 
	  fprintf err_formatter "%s@." "Side effect detected.";
	  let (diff_srG,gAdd_v,gDel_v,eSadd,eSdel,eSmod,eSmod_alist) = graph_diff_aux srG' srG'' in
	  let d' = 
	    if cf.lskolem_flag then
	      gdiff2dot (diff_srG,gAdd_v,gDel_v,eSadd,eSdel,eSmod)
	    else
	      let (diff_newG,diff_mapV,_) = clean_id_aux diff_srG in
	      let f v = try (MapofVtx.find v diff_mapV) with
		Not_found -> failwith "lookupMap: Flat ID not found" in
	      gdiff2dot
		(diff_newG,
		 SetofVtx.map f  gAdd_v,
		 SetofVtx.map f  gDel_v,
	         SetofEdge.map (cross3 (f,id,f)) eSadd,
	         SetofEdge.map (cross3 (f,id,f)) eSdel,
	         SetofEdge.map (cross3 (f,id,f)) eSmod)

          in 
	  if (is_windows () || cf.no_display)  then dumpDot ~prefix_n:false d' (get_diffname cf.odot_file) else dispD_gc d';
	  exit 1;
	end
    else (* forward mode *)
      begin 
	dumpDot ~prefix_n:false dot cf.odot_file;
	if cf.opng_file <> "" then dotf2pngf cf.odot_file cf.opng_file
      end

