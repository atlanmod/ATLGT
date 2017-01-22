(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
(* backward computation *)
(* Synopsis:
  bwd_uncal -db (db.uncal|db.dot) -png db.png  -xg fwd_result.xg  -udot udb.dot
   db.uncal: input database file to produce default environment.
   db.png:   graphical representation of updated database.
   udb.dot   dot representation of updated database.
  
   fwd_result.xg:  marshalled output file of forward computation.
*)

open UnCALMAST
open G2viz
open Format
open UnCAL
open UnCALDMutil
open G2UnCAL
open EvalUnCAL
open UnCALdynenv
open BiEvalUnCAL
open Dotutil
open ParseDot
open UnCALSA
open TestUnCALutil
open Version
open Fputil

(************************* BEGIN basic definitions *******************************)
(*
let parseDot_file = Parse.parse_file ~parse:ParseDot.entry ~lex:LexDot.token 
*)
let parseUnCAL_file   = (map_info (fun _ -> None)) @@ parseUnCAL_file 
let print_taexpr ?pp_a = fprintf std_formatter "%a@." (ppr_taexpr ?pp_a)

(***************************** END basic definitions *****************************)


type bwd_config =  {
    mutable inputdb_file   : string; (* input db UnCAL/Dot file for restoring rho *)
    mutable inputdot_file  : string; (* dot file of modified target *)
    mutable ei_file        : string; (* editinfo file *)
    mutable db_png_file    : string; (* output rho($db) file in PNG format *)
    mutable udb_dot_file   : string; (* output rho($db) file in DOT format *)
    mutable udb_cal_file   : string; (* output rho($db) file in UnCAL format *)
    mutable input_xg_file  : string; (* marshalled variable xg *)
    mutable prt_time       : bool;   (* turn on timing *)
    mutable prt_uncal      : bool;   (* turn on printing source UnCAL expression *)
    mutable cm_flag        : bool;   (* color modification to source DB in output PNG *)
    mutable np_flag        : bool;   (* do NOT prefix output base node number with n *)
    mutable rdi_flag       : bool;   (* reflect deletion and insertion *)
    mutable digvu_flag     : bool;   (* detectInConsistentGVarUpdateInRec *)
    mutable vv_flag        : bool;   (* turn on debug writing *)

  }

let default_config = { inputdb_file = "";inputdot_file = ""; db_png_file = ""; 
		       input_xg_file = ""; prt_uncal = false; udb_dot_file = "";
		       udb_cal_file = ""; prt_time  = false; 
		       ei_file = ""; cm_flag = false; np_flag = false;
		       rdi_flag = false; digvu_flag = false; vv_flag = false;
		     }

let speclist = 
  let cf = default_config in 
  Arg.align
    [
     ("-db" , Arg.String (fun s->cf.inputdb_file <-s), " source db file (UnCAL/Dot)");
     ("-dot", Arg.String (fun s->cf.inputdot_file<-s), " dot file of modified target");
     ("-ei",  Arg.String (fun s->cf.ei_file      <-s), " editinfo produced by forward trans.");
     ("-udot",Arg.String (fun s->cf.udb_dot_file <-s), " dot file of modified source db");
     ("-ucal",Arg.String (fun s->cf.udb_cal_file <-s), " UnCAL file of modified source db");
     ("-png", Arg.String (fun s->cf.db_png_file  <-s), " png view of modified source db");
     ("-xg",  Arg.String (fun s->cf.input_xg_file<-s), " result file of AST with intermediate results in fwd comp.");
     ("-t",   Arg.Unit   (fun()->cf.prt_time  <-true), " print timing information");
     ("-pa",  Arg.Unit   (fun()->cf.prt_uncal <-true), " print UnCAL input expression");
     ("-np",  Arg.Unit   (fun()->cf.np_flag   <-true), " do NOT prefix output base node number with n");
     ("-cm",  Arg.Unit   (fun()->cf.cm_flag   <-true), " color modification to source DB in output PNG");
     ("-rdi", Arg.Unit   (fun()->cf.rdi_flag  <-true), " reflect deletion and insertion");
     ("-dig", Arg.Unit   (fun()->cf.digvu_flag<-true), " detect inconsistency updates via graph variable in rec");
     ("-vv",  Arg.Unit   (fun()->cf.vv_flag   <-true), " turn on debug writing (verbose)");
     
   ]

let speclist = add_version_spec speclist

let usage_msg = "Usage: "^Sys.executable_name^" -dot xxx.dot [-png modsrc.png] -ei fwd_result.ei \r
      [-udot modsrc.dot] [-ucal modsrc.uncal] -xg fwd_result.xg [-t][-pa][-cm][-rdi][-dig][-vv]"

let read_args () = 
  let cf = default_config in 
  Arg.parse speclist (fun s -> ()) usage_msg; cf 

let failwith_msg msg =
  fprintf err_formatter "%s@." msg;
  Arg.usage speclist usage_msg; exit 1

let _ = 
  let cf = read_args () in
  let _ = print_version () in
  (* check arguments *)
  if      cf.inputdb_file  = "" then failwith_msg "Source db file unspecified."
  else if cf.inputdot_file = "" then failwith_msg "Modified dot file unspecified."
  else if cf.ei_file       = "" then failwith_msg "editinfo file unspecified."
  else if cf.input_xg_file = "" then failwith_msg "AST with intermediate result unspecified."
  else 
    let db = 
      let suffix = get_suffix cf.inputdb_file in
      if (suffix = "dot") then loadDot_file ~set_GenId:true cf.inputdb_file
      else (* defaults to UnCAL *)
	(*  (clean_id (remove_eps (reachableGI (load_db (parseUnCAL_file cf.inputdb_file))))) *)
	(clean_id (reachableGI (remove_eps (load_db (parseUnCAL_file cf.inputdb_file)))))
    in
    (* let _ = display_cg db "xxx.dot"  *)
    let rho = (intern_gv "$db" db emptyDynEnv) in
    let xg = file2ma cf.input_xg_file in
    let ei = file2edinfo cf.ei_file in
    let _ = skolemBulk             := ei.sbulk   in
    let _ = escapeApnd             := ei.eapnd   in
    let _ = cycleSemanticsOriginal := ei.cycorig in
    let _ = saUnreach              := ei.saunrch in
    let _ = detectInConsistentGVarUpdateInRec := cf.digvu_flag in
    let _ = biEvalUnCAL_verbose    := cf.vv_flag in
    let g_edit' = dot2g (parseDot_file cf.inputdot_file) in
    let g_show' = if (ei.glue_eps||ei.cln_id) then merge_viewmaps ei.g_edit g_edit' ei.g_show ei.vm else g_edit' in
    let g' = if ei.show_unreachable then g_show' else begin
      let g_unreachable = evalg_simple_diff xg.graph ei.g_show in
      evalg_simple_union g_show' g_unreachable end in
    let _ = GenId.set bd_start_id in 
    let cte = xg.taexpr in
    let _ = 
      if cf.prt_uncal 
      then 
	begin 
	  print_endline "(************** begin Submitted Query ****************)";
	  print_taexpr cte;
	  print_endline "(**************  end  Submitted Query ****************)"
	end in
    let rho' = 
      let lrho' = lazy(bd_bwd rho xg g') in
      if cf.prt_time then print_time ~prefix:"Backward Evaluation" lrho'
      else Lazy.force lrho' in
    (* extract source database from modified environment *)
    let db' = lookupVar rho' "$db" in
    let pn_flag = not cf.np_flag in
    if cf.udb_dot_file <> "" then g2dot_file ~prefix_n:pn_flag ~shape:`ellipse
	~ops:[ALLbl "src_of" (* ;ALLbl "order_of" *)] db' cf.udb_dot_file;
    if cf.udb_cal_file <> "" then 
      begin
        (* load_db is still called in legacy (!cycleSemanticsOriginal = false) mode *)
	let _ = cycleSemanticsOriginal := false in 
	dumpG db' cf.udb_cal_file  
      end;
    if cf.db_png_file <> "" then 
      begin
	if cf.cm_flag then
	  let d = graph_diff db db' in
	  dot2imagef "png" ~shape:`ellipse ~prefix_n:pn_flag d cf.db_png_file
	else 
	  g2png ~prefix_n:pn_flag ~shape:`ellipse ~ops:[ALLbl "src_of"] 
	    db' cf.db_png_file
      end


