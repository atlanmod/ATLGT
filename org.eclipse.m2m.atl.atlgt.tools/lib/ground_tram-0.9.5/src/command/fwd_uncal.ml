(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
open UnCALMAST
open G2viz
open Format
open UnCAL
open PrintUnCAL
open UnCALDMutil
open EvalUnCAL
open UnCALdynenv
open UnCALenv
open ECenv
open BiEvalUnCAL
open Dotutil
open PrintDot
open TestUnCALutil
open UnQL2unCAL
open UnCALSA
open Fputil
open Version
open DesugarUnQL

(************************* BEGIN basic definitions *******************************)
let parseUnCAL_file   = (map_info (fun _ -> None)) @@ parseUnCAL_file 
(***************************** END basic definitions *****************************)

(* 
  flow of the demonstration:
  
  Fix simple input graph (with cycles)
  User select forward transformation.
  Selected query is pasted to textbox. 
    ex: let $v = $classDB in {result:$v}
  Editing is disallowed for the moment.
  User issue the (possibly edited) forward transformation.
  The result is marshalled and saved to a file.
  The result is also saved to a dot file.
  Editing of dot file is disallowed at the moment.
     (current limitation should be explained explicitly)
  Edited dot file is loaded to variable g'.
  Result of forward evaluation is ummarshalled to variable xg.
  Graphical representation of g' is displayed to user.
  Backward transformation is executed and gloobal variable $db
  is extracted from environment, and saved to db'.
  Graphical representation of db' is presented to user.
*)


(* forward computation *)
(* 
   Synopsis:
   fwd_uncal  -db (db.uncal|db.dot)  -q query.uncal -png output.png  -xg fwd_result.xg  
*)   
 
type fwd_config = {
    mutable inputdb_file : string ; (* input UnCAL/Dot db file *)
    mutable q_file       : string ; (* input UnCAL query file *)
    mutable uq_file      : string ; (* input UnQL  query file *)
    mutable png_file     : string ; (* output png file *)
    mutable xg_file      : string ; (* output marshalled xg variable *)
    mutable dot_file     : string ; (* output in dot format for user editing *)
    mutable ei_file      : string ; (* editinfo file for backward evaluation *)
    mutable prt_time     : bool   ; (* turn on timing *)
    mutable prt_uncal    : bool   ; (* turn on printing source UnCAL expression *)
    mutable su_flag      : bool   ; (* show unreachable parts in the view *)
    mutable rw_flag      : bool   ; (* appliy rewriting *)
    mutable ge_flag      : bool   ; (* glue safe epsilons in the view *)
    mutable sb_flag      : bool   ; (* skolemBulk *)
    mutable ea_flag      : bool   ; (* escapeApnd *)
    mutable as_flag      : bool   ; (* optApndStat *)
    mutable cs_flag      : bool   ; (* cycle simple semantics (not !cycleSemanticsOriginal) *)
    mutable np_flag      : bool   ; (* do NOT prefix output base node number with n *)
    mutable sa_flag      : bool   ; (* saUnreach *)
    mutable cl_flag      : bool   ; (* simple cleanup after desugaring UnQL *)
    mutable rc_flag      : bool   ; (* transform &z@rec(e)({dummy:{}}) to &z@cycle(e) *)
    mutable zn_flag      : bool   ; (* reset generated node number sequence to zero *)
    mutable fi_flag      : bool   ; (* flatten ID in the view *)
    mutable timeout      : int    ; (* timeout *)
}

let default_config = { inputdb_file = ""; q_file = ""; png_file = ""; xg_file = ""; 
		     dot_file = "";    prt_time  = false;  prt_uncal = false;
		      ei_file = "";
		      uq_file = "";
                      rw_flag = false; 
                      su_flag = false;
                      ge_flag = false;
		      sb_flag = false;
		      ea_flag = false;
		      as_flag = false;
		      cs_flag = false;
		      np_flag = false;
		      sa_flag = false;
		      cl_flag = false;
		      rc_flag = false;
		      zn_flag = false;
		      fi_flag = false;
		      timeout = 0;
                      }

let speclist = 
  let cf = default_config in 
  Arg.align
    [
     ("-db",  Arg.String (fun s->cf.inputdb_file<-s), " source db file (in UnCAL/Dot)");
     ("-q",   Arg.String (fun s->cf.q_file      <-s), " source UnCAL file");
     ("-uq",  Arg.String (fun s->cf.uq_file     <-s), " source UnQL file");
     ("-png", Arg.String (fun s->cf.png_file    <-s), " result PNG file");
     ("-ei",  Arg.String (fun s->cf.ei_file     <-s), " editinfo file for backward evaluation");
     ("-dot", Arg.String (fun s->cf.dot_file    <-s), " result DOT file for editing");
     ("-xg",  Arg.String (fun s->cf.xg_file     <-s), " result file of AST with intermediate results");
     ("-t",   Arg.Unit   (fun()->cf.prt_time <-true), " print timing information");
     ("-pa",  Arg.Unit   (fun()->cf.prt_uncal<-true), " print UnCAL input expression");
     ("-rw",  Arg.Unit   (fun()->cf.rw_flag  <-true), " turn on rewriting optimization");
     ("-su",  Arg.Unit   (fun()->cf.su_flag  <-true), " show unreachable parts in the view");
     ("-ge",  Arg.Unit   (fun()->cf.ge_flag  <-true), " glue safe epsilons in the view");
     ("-sb",  Arg.Unit   (fun()->cf.sb_flag  <-true), " set skolemBulk");
     ("-ea",  Arg.Unit   (fun()->cf.ea_flag  <-true), " set escapeApnd");
     ("-as",  Arg.Unit   (fun()->cf.as_flag  <-true), " set optApndStat");
     ("-cs",  Arg.Unit   (fun()->cf.cs_flag  <-true), " unset cycleSemanticsOriginal");
     ("-np",  Arg.Unit   (fun()->cf.np_flag  <-true), " do NOT prefix output base node number with n");
     ("-sa",  Arg.Unit   (fun()->cf.sa_flag  <-true), " set saUnreach");
     ("-cl",  Arg.Unit   (fun()->cf.cl_flag  <-true), " simple cleanup after desugaring UnQL");
     ("-rc",  Arg.Unit   (fun()->cf.rc_flag  <-true), " transform &z@rec(e)({dummy:{}}) to &z@cycle(e)");
     ("-zn",  Arg.Unit   (fun()->cf.zn_flag  <-true), " reset generated node number sequence to zero");
     ("-fi",  Arg.Unit   (fun()->cf.fi_flag  <-true), " flatten ID in the view");
     ("-to",  Arg.Int    (fun i->cf.timeout     <-i), " timeout[sec]");

   ]

let speclist = add_version_spec speclist

let usage_msg = 
  "Usage: "^Sys.executable_name^" -db db.uncal  (-q query.uncal|-uq query.unql)  \r
      -dot output.dot [-png output.png]  -xg fwd_result.xg -ei fwd_result.ei \r
      [-t] [-pa] [-rw] [-su] [-ge] [-sb] [-ea] [-cs] [-np] [-sa] [-as] [-cl] [-rc] [-zn] [-fi] [-to] [-v]"

let read_args () = 
  let cf = default_config in 
  Arg.parse speclist (fun s -> ()) usage_msg; cf 

let failwith_msg msg =
  fprintf err_formatter "%s@." msg;
  Arg.usage speclist usage_msg; exit 1

(* execute query *) 
let _ = 
  let cf = read_args () in
  let _ = print_version () in
  (* check arguments *)
  if      cf.inputdb_file = "" then failwith_msg "Source db file unspecified."
  else if (cf.q_file = "" && cf.uq_file = "")
                               then failwith_msg "UnCAL source file unspecified."
  else if cf.ei_file      = "" then failwith_msg "Editinfo file unspecified."
  else if cf.xg_file      = "" then failwith_msg "AST with intermediate result unspecified."
  else if cf.dot_file     = "" then failwith_msg "Result dot file for editing unspecified."
  else 
    (if cf.rc_flag           then (fprintf err_formatter "%s@." 
				       "special treatment of rec for cycle formation activated"; 
				     if (not cf.cl_flag) then
				       (fprintf err_formatter "%s@." "-cl flag added";
					cf.cl_flag <- true);
				     if cf.cs_flag then
				       (fprintf err_formatter "%s@." "-cs flag turned off";
					cf.cl_flag <- false)));
    let _ = GenId.reset ()  in
    let rec2cycle ce  = if cf.rc_flag then rec2cycle ce else ce in
    let unql2uncal ce = if cf.cl_flag then unQL2unCAL_cleanup ce else unql2uncal ce in
    let db = 
      let suffix = get_suffix cf.inputdb_file in
      if (suffix = "dot") then loadDot_file ~set_GenId:true cf.inputdb_file
      else (* defaults to UnCAL *)
       (* (clean_id (remove_eps (reachableGI (load_db (parseUnCAL_file cf.inputdb_file))))) *)
      (clean_id (reachableGI (remove_eps (load_db (parseUnCAL_file cf.inputdb_file))))) in
    let ce = if   cf.q_file <> "" then parseUnCAL_file cf.q_file
      else  try (((map_info (fun _ -> None)) @@ rec2cycle @@ unql2uncal @@ parseUnQL_file) cf.uq_file)
      with e -> catch_UnQL_exn e in
    let _ = 
      if cf.prt_uncal 
      then 
	begin 
	  print_endline "(************** begin Submitted Query ****************)";
	  print_aexpr ce;
	  print_endline "(**************  end  Submitted Query ****************)"
	end in
    let rho = (intern_gv "$db" db emptyDynEnv) in
    let ecenv = create_initenv_from_db db in
    let _ = GenId.set (if cf.zn_flag then 0 else bd_start_id) in
    let _ = skolemBulk             :=     cf.sb_flag in
    let _ = escapeApnd             :=     cf.ea_flag in
    let _ = optApndStat            :=     cf.as_flag in (* no effect  unless -rw is on *)
    let _ = cycleSemanticsOriginal := not cf.cs_flag in
    let _ = saUnreach              :=     cf.sa_flag in
    let id x = x in
    let rw : ('a aexpr -> 'a aexpr) = 
      if cf.rw_flag then
	let stEnv = dynenv2stenv rho in rewriteE stEnv
      else id in
    let ce = 
      let lce = lazy(rw ce) in
      if (cf.prt_time && cf.rw_flag) then print_time ~prefix:"Rewriting" lce
      else Lazy.force lce in
    let _ = if (cf.prt_uncal && cf.rw_flag) then
      begin
	print_endline "(************** begin rewritten Query ****************)";
  	print_aexpr ce;
	print_endline "(**************  end  rewritten Query ****************)";
      end in
    let _ = if (cf.timeout <> 0) then TestUnCALutil.set_timeout cf.timeout else 0 in
    let xg = 
      let lxg = lazy(bd_fwd ecenv rho ce) in
      if cf.prt_time then print_time ~prefix:"Forward Evaluation" lxg
      else Lazy.force lxg in
    (* let g' = edit_g xg.graph *)
    let _ = ma2file xg cf.xg_file in
    let ei = make_editinfo ~cln_id:cf.fi_flag cf.ge_flag cf.su_flag xg.graph !skolemBulk
	!escapeApnd !cycleSemanticsOriginal !saUnreach in
    let dot = g2dot ~gray_unreachable:true ~ops:[ALLbl "src_of"] ~cmp_eps:true ei.g_edit in
    let _ = dumpDot ~prefix_n:(not cf.np_flag) ~shape:`ellipse dot cf.dot_file  in
    edinfo2file ei cf.ei_file;
    if cf.png_file <> "" then dotf2pngf cf.dot_file cf.png_file
