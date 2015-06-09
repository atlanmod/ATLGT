(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
(*
  if you just want to convert from/to UnCAL and DOT file, do the following
  a.uncal -> a.dot:   uncalcmd -q a.uncal -dot a.dot
  a.dot   -> a.uncal: uncalcmd -dbd a.dot -q examples/UnCAL/identity.uncal -cal a.uncal

  if you want to generate PNG from UnCAL file or DOT file, do the following:
  a.uncal -> a.png:   uncalcmd -q a.uncal -png a.png
  a.dot   -> a.png    uncalcmd -dbd a.dot -q examples/UnCAL/identity.uncal -png a.uncal
    (Or you can directly use dot command by  dot -Tpng -o a.png a.dot)
*)
open Fputil
open Format
open EvalUnCAL
open UnCALdynenv
open UnCALDM
open UnCALDMutil
open G2UnCAL
open Dotutil
open UnCAL
open PrintUnCAL
open UnCALSA
open Version
open Contraction
open TestUnCALutil

(************************* BEGIN basic definitions *******************************)
let parseUnCAL_file   = (map_info (fun _ -> None)) @@ parseUnCAL_file
(***************************** END basic definitions *****************************)

type config =  {
    mutable inputdb_file:     string; (* input UnCAL db file *)
    mutable inputdb_dotfile:  string; (* input DOT db file *)
    mutable uncal_file:       string; (* input UnCAL file *)
    mutable png_file:         string; (* output PNG file *)
    mutable output_imagefile: string; (* output image file *)
    mutable output_dotfile:   string; (* output DOT file (optional) *)
    mutable output_uncalfile: string; (* output UnCAL file (optional) *)
    mutable prt_time:      bool;      (* turn on timing *)
    mutable prt_uncal:     bool;      (* turn on printing source UnCAL expression *)
    mutable prt_runcal:    bool;      (* turn on printing rewritten UnCAL expression *)
    mutable rewrite_flag:  bool;      (* turn on rewriting optimization *)
    mutable apnd_flag:     bool;      (* optimize @ *)
    mutable holtc_flag:    bool;      (* holistic TC computation (may slowdown) *)
    mutable prune_flag:    bool;      (* pruning of input graph in bulk semantics *)
    mutable cab_flag:      bool;      (* remove eps edge and unreachables after rec in bulk semantics *)
    mutable esca_flag:     bool;      (* escape first operand of @ *)
    mutable loma_flag:     bool;      (* leave omarker of first operand of @ (experimental) *)
    mutable rec_flag:      bool;      (* use recursive semantics for rec() *)
    mutable lunreach_flag: bool;      (* leave unreachable part *)
    mutable lepsilon_flag: bool;      (* leave epsilon edges *)
    mutable lskolem_flag:  bool;      (* leave Skolem terms *)
    mutable record_flag:   bool;      (* output with record node *)
    mutable srec_flag:     bool;      (* use Skolem term in rec() *) 
    mutable tnid_flag:     bool;      (* use node id based on lexical position *)
    mutable pn_flag:       bool;      (* prefix output base node number with n *)
    mutable cont_flag:     bool;      (* contract result graph *)
    mutable as_flag:       bool;      (* set optApndStat *)
    mutable cs_flag:       bool;      (* cycle simple semantics (not !cycleSemanticsOriginal) *)
  }


let default_config = { uncal_file = ""; png_file = ""; output_dotfile = "";
		       output_imagefile = "";
		       output_uncalfile = "";
		       prt_time         = false; 
		       prt_uncal        = false;
		       prt_runcal       = false;
		       rewrite_flag     = false;
		       inputdb_file     = "";
		       inputdb_dotfile  = "";
		       rec_flag         = false;
		       apnd_flag        = false;
		       holtc_flag       = false;
		       prune_flag       = false;
		       cab_flag         = false;
		       esca_flag        = false;
		       loma_flag        = false;
		       lunreach_flag    = false;
		       lepsilon_flag    = false;
                       lskolem_flag     = false;
		       record_flag      = false;
		       srec_flag        = false;
		       tnid_flag        = false;
		       pn_flag          = false;
		       cont_flag        = false;
		       as_flag          = false;
		       cs_flag          = false;
		     }

let speclist =
  let cf = default_config in
  Arg.align
    [("-db", Arg.String (fun s->cf.inputdb_file    <-s), " source db file (in UnCAL)");
     ("-dbd",Arg.String (fun s->cf.inputdb_dotfile <-s), " source db file (in DOT)"); 
     ("-q",  Arg.String (fun s->cf.uncal_file      <-s), " source UnCAL file");
     ("-png",Arg.String (fun s->cf.png_file        <-s), " result PNG file");
     ("-oi", Arg.String (fun s->cf.output_imagefile<-s), " result image file"); (* fmt determined by extension *)
     ("-dot",Arg.String (fun s->cf.output_dotfile  <-s), " result DOT file");
     ("-cal",Arg.String (fun s->cf.output_uncalfile<-s), " result UnCAL file");
     ("-t",  Arg.Unit   (fun()->cf.prt_time     <-true), " print timing information");
     ("-rw", Arg.Unit   (fun()->cf.rewrite_flag <-true), " turn on rewriting optimization");
     ("-rec",Arg.Unit   (fun()->cf.rec_flag     <-true), " use recursive semantics instead of bulk");
     ("-oa", Arg.Unit   (fun()->cf.apnd_flag    <-true), " optimize @");
     ("-ht", Arg.Unit   (fun()->cf.holtc_flag   <-true), " holistic TC computation (may slowdown) ");
     ("-pb", Arg.Unit   (fun()->cf.prune_flag   <-true), " pruning of input graph in bulk semantics");
     ("-cb", Arg.Unit   (fun()->cf.cab_flag     <-true), " remove eps edge and unreachables after rec in bulk semantics");
     ("-ea", Arg.Unit   (fun()->cf.esca_flag    <-true), " escape first operand of @");
     ("-lo", Arg.Unit   (fun()->cf.loma_flag    <-true), " leave omarker of first operand of @ (experimental)");
     ("-lu", Arg.Unit   (fun()->cf.lunreach_flag<-true), " leave unreachable part");
     ("-le", Arg.Unit   (fun()->cf.lepsilon_flag<-true), " leave epsilon edges");
     ("-ls", Arg.Unit   (fun()->cf.lskolem_flag <-true), " leave Skolem terms");
     ("-pa", Arg.Unit   (fun()->cf.prt_uncal    <-true), " print UnCAL input expression");
     ("-pr", Arg.Unit   (fun()->cf.prt_runcal   <-true), " print UnCAL expression after rewriting");
     ("-rc", Arg.Unit   (fun()->cf.record_flag  <-true), " output with record node (default is elliptic)");
     ("-sr", Arg.Unit   (fun()->cf.srec_flag    <-true), " use Skolem term in rec()");
     ("-pi", Arg.Unit   (fun()->cf.tnid_flag    <-true), " use node id based on lexical position");
     ("-pn", Arg.Unit   (fun()->cf.pn_flag      <-true), " prefix output base node number with n");
     ("-cg", Arg.Unit   (fun()->cf.cont_flag    <-true), " contract result graph");
     ("-as", Arg.Unit   (fun()->cf.as_flag      <-true), " set optApndStat");
     ("-cs", Arg.Unit   (fun()->cf.cs_flag      <-true), " set cycleSemanticsOriginal");
   ]

let speclist = add_version_spec speclist 

let usage_msg = "Usage: "^Sys.executable_name^" [-db file | -dbd file] -q file [-png file|-oi file] [-dot file]\
      [-cal file] [-t][-pa][-pr][-rw][-rec][-oa][-ht][-pb][-ea][-lu][-le][-ls][-rc][-sr][-pi][-pn][-cg][-cs]"

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
  if      cf.uncal_file = ""   then failwith_msg "UnCAL source file unspecified."
  else if ((cf.inputdb_file <> "") && (cf.inputdb_dotfile <> "")) then 
    failwith_msg "source DB file is specified in both UnCAL and DOT format."
  else
    let dynenv = 
      if ((cf.inputdb_file <> "") || (cf.inputdb_dotfile <> "")) then
	let db = 
	  if (cf.inputdb_file <> "") then clean_id (remove_eps (load_db (parseUnCAL_file  cf.inputdb_file)))
	  else
	    loadDot_file ~set_GenId:true ~descend_maxid:true cf.inputdb_dotfile in
	(intern_gv "$db" db emptyDynEnv)
      else emptyDynEnv in
    let q = parseUnCAL_file cf.uncal_file in
    let _ = 
      if cf.prt_uncal 
      then 
	begin 
	  print_endline "(************** begin Submitted Query ****************)";
	  print_aexpr q;
	  print_endline "(**************  end  Submitted Query ****************)"
	end in
    let id x = x in
    let rw : ('a aexpr -> 'a aexpr) = 
      if cf.rewrite_flag 
      then let stEnv = dynenv2stenv dynenv in rewriteE stEnv
      else id in
    let rg : graph -> graph = if cf.lunreach_flag then id else reachableGI           in
    let re : graph -> graph = if cf.lepsilon_flag then id else remove_eps            in
    let ci : graph -> graph = if cf.lskolem_flag  then id else clean_id ~start_id:0  in
    let lcq = lazy(rw q) in
    let cq = if (cf.prt_time && cf.rewrite_flag) then print_time ~prefix:"Rewriting" lcq
      else Lazy.force lcq in
    let _ =
      if cf.prt_runcal
      then
	begin
	  print_endline "(************** begin Executed UnCAL expr. ****************)";
	  print_aexpr cq;
	  print_endline "(**************  end  Executed UnCAL expr. ****************)"
	end in
    let _ = GenId.set UnCALMAST.bd_start_id  in
    let _ = evalRecRecursive    := cf.rec_flag   in
    let _ = skolemRec           := cf.srec_flag  in 
    let _ = optApndRecRecursive := cf.apnd_flag  in
    let _ = optApndStat         := cf.as_flag    in (* no effect  unless -rw is on *)
    let _ = cycleSemanticsOriginal := cf.cs_flag in
    let _ = escapeApnd          := cf.esca_flag  in
    let _ = leaveOMrkApnd       := cf.loma_flag  in
    let _ = optTCRec            := cf.holtc_flag in
    let _ = useTransNodeId      := cf.tnid_flag  in
    let _ = pruneBulk           := cf.prune_flag in 
    let _ = cleanAfterBulk      := cf.cab_flag   in
    let _ = if !skolemRec && (not (!escapeApnd || !useTransNodeId)) then
      fprintf err_formatter "Warning: -sr option must be accompanied by -pi or -ea@. " in
    let _ = if !evalRecRecursive && cf.prune_flag then
      fprintf err_formatter "Warning: -pb option has no effect under -rec option@." in
    let _ = if !evalRecRecursive && cf.cab_flag then
      fprintf err_formatter "Warning: -cb option has no effect under -rec option@." in
      
    let g =
      let lg = lazy(ci (rg (re (eval_with_env dynenv cq)))) in
      if cf.prt_time then print_time ~prefix:"Evaluation" lg
      else Lazy.force lg in

    let g = 
      if cf.cont_flag then
	let lg = lazy(contract_opt g) in
	if cf.prt_time then print_time ~prefix:"Contraction" lg
	else Lazy.force lg 
      else g in

    let remove_dot_file = (cf.output_dotfile = "") in
    let shape = if cf.record_flag then `record else `ellipse in
    if (cf.output_uncalfile <> "") then dumpG g cf.output_uncalfile;
    (* g2png_light ~remove_dot_file:false ~dot_file:cf.output_dotfile g cf.png_file *)
    if (cf.png_file = "" && cf.output_imagefile = "") then
      (if (cf.output_dotfile = "") then () else g2dot_file ~shape ~gray_unreachable:true
	~ops:[ALLbl"src_of"] ~prefix_n:cf.pn_flag g cf.output_dotfile)
    else
      let (format,fname) = 
	if cf.png_file <> "" then ("png",cf.png_file) else fsplit (get_suffix,id) cf.output_imagefile in
      g2image format ~remove_dot_file:remove_dot_file ~dot_file:cf.output_dotfile ~gray_unreachable:true 
	~ops:[ALLbl"src_of"] ~shape ~prefix_n:cf.pn_flag
	g fname
