(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
open Fputil
open G2viz
open Format
open UnCALDMutil
open G2UnCAL
open EvalUnCAL
open UnCALdynenv
open UnQL
open Km3util  (* for validation on input and output graph *)
open UnCALDM
open Km3
open UnCAL
open PrintUnCAL
open PrintUnQL
open Dotutil
open Version
open Contraction
open UnCALSA (* map_info *)

(************************* BEGIN basic definitions *******************************)
let parseUnQL_file = Parse.parse_file ~parse:ParseUnQL.entry ~lex:LexUnQL.token 
let parseUnCAL_file = Parse.parse_file ~parse:ParseUnCAL.entry ~lex:LexUnCAL.token 
let parseUnCAL_file = (map_info (fun _ -> None)) @@ parseUnCAL_file
let parseKm3_file = Parse.parse_file ~parse:ParseKm3.entry ~lex:LexKm3.token 
let e2qt (e:'a UnQL.expr) = 
  match e.action with
    | `query (_,t) -> t
    | _ -> failwith "not query in e2qt"

(***************************** END basic definitions *****************************)

type config =  {
    mutable inputdb_file     : string; (* input UnCAL/Dot db file *)
    mutable inputdb_flist    : string list; (* binding of global variables (var=file.uncal) *)
    mutable unql_file        : string; (* input UnQL+ file *)
    mutable png_file         : string; (* output PNG file *)
    mutable output_imagefile : string; (* output image file *)
    mutable output_dotfile   : string; (* output DOT file (optional) *)
    mutable output_uncalfile : string; (* output UnCAL file (optional) *)
    mutable ikm3_file        : string; (* km3 file for input  validatin *)
    mutable okm3_file        : string; (* km3 file for output validatin *)
    mutable ikm3_pkg         : string; (* km3 package for input  validatin *)
    mutable okm3_pkg         : string; (* km3 package for output validatin *)
    mutable prt_time         : bool  ; (* turn on timing *)
    mutable prt_uncal        : bool  ; (* turn on printing UnCAL expression *)
    mutable prt_unql         : bool  ; (* turn on printing UnQL  expression *)
    mutable bulk_flag        : bool  ; (* use bulk semantics for rec() *)
    mutable apnd_flag        : bool  ; (* optimize @ *)
    mutable holtc_flag       : bool  ; (* holistic TC computation (may slowdown) *)
    mutable esca_flag        : bool  ; (* escape first operand of @ *)
    mutable loma_flag        : bool  ; (* leave omarker of first operand of @ (experimental) *)
    mutable expm_flag        : bool  ; (* explicit marker provision in rec() *)
    mutable srec_flag        : bool  ; (* use Skolem term in rec() *) 
    mutable tnid_flag        : bool  ; (* use node id based on lexical position *)
    mutable pn_flag          : bool;   (* prefix output base node number with n *)
    mutable cont_flag        : bool;   (* contract result graph *)
    mutable as_flag          : bool  ; (* optApndStat *)
  }

let default_config = { unql_file = ""; png_file = ""; 
		       output_dotfile = "";
		       output_imagefile = "";
		       output_uncalfile = "";
		       ikm3_file = ""; okm3_file = "";
		       ikm3_pkg = ""; okm3_pkg = ""; 
		       prt_time = false; 
		       prt_uncal = false; prt_unql = false; 
		       inputdb_file = "";inputdb_flist = [];
(* -var vn1=fn1 -var vn2=fn2 ... -var vn_n=fn_n 
  -> inputdb_flist=["vn_n=fn_n";"vn_n-1=fn_n-1"; ... ; "vn1=fn1"]  *)
		       bulk_flag = false;
		       apnd_flag = false;
		       holtc_flag =false;
		       esca_flag = false;
		       loma_flag = false;
		       expm_flag = false;
		       srec_flag = false;
		       tnid_flag = false;
		       pn_flag   = false;
		       cont_flag = false;
                       as_flag   = false;
		     }

let speclist =
  let cf = default_config in 
  Arg.align
    [("-db",  Arg.String (fun s->cf.inputdb_file<-s),    " source db file (in UnCAL/Dot)");
     ("-var", Arg.String (fun s->cf.inputdb_flist<-s::cf.inputdb_flist),
                                                         " bind global variable to db (in UnCAL)");
     ("-q",   Arg.String (fun s->cf.unql_file<-s),       " source UnQL+ file");
     ("-png", Arg.String (fun s->cf.png_file <-s),       " result PNG file");
     ("-oi",  Arg.String (fun s->cf.output_imagefile<-s)," result image file"); (* fmt determined by extension *)
     ("-dot", Arg.String (fun s->cf.output_dotfile  <-s)," result DOT file");
     ("-cal", Arg.String (fun s->cf.output_uncalfile<-s)," result UnCAL file");
     ("-iv",  Arg.String (fun s->cf.ikm3_file<-s),       " input validation KM3 file");
     ("-ip",  Arg.String (fun s->cf.ikm3_pkg <-s),       " input validation package");
     ("-bulk", Arg.Unit  (fun()->cf.bulk_flag<-true),    " use bulk semantics instead of rec");
     ("-ov", Arg.String  (fun s->cf.okm3_file<-s),       " output validation KM3 file");
     ("-op", Arg.String  (fun s->cf.okm3_pkg <-s),       " output validation package");
     ("-t",  Arg.Unit    (fun()->cf.prt_time <-true),    " print timing information");
     ("-oa", Arg.Unit    (fun()->cf.apnd_flag<-true),    " optimize @");
     ("-ht", Arg.Unit    (fun()->cf.holtc_flag<-true),   " holistic TC computation (may slowdown) ");
     ("-ea", Arg.Unit    (fun()->cf.esca_flag<-true),    " escape first operand of @");
     ("-lo", Arg.Unit    (fun()->cf.loma_flag<-true),    " leave omarker of first operand of @ (experimental)");
     ("-pa", Arg.Unit    (fun()->cf.prt_uncal<-true),    " print UnCAL expression after desugaring");
     ("-m",  Arg.Unit    (fun()->cf.expm_flag<-true),    " Each UnCAL rec has marker");
     ("-pu", Arg.Unit    (fun()->cf.prt_unql <-true),    " print UnQL expression before desugaring");
     ("-sr", Arg.Unit    (fun()->cf.srec_flag<-true),    " use Skolem term in rec()");
     ("-pi", Arg.Unit    (fun()->cf.tnid_flag<-true),    " use node id based on lexical position");
     ("-pn", Arg.Unit    (fun()->cf.pn_flag  <-true),    " prefix output base node number with n");
     ("-cg", Arg.Unit    (fun()->cf.cont_flag<-true),    " contract (normalize) output graph");
     ("-as", Arg.Unit    (fun()->cf.as_flag  <-true),    " set optApndStat");
]

let speclist = add_version_spec speclist

let usage_msg = 
"Usage: "^Sys.executable_name^" -db file [-var v=file]* -q file [-png file|-oi file]
     [-dot file][-cal file][-iv file -op package][-ov file -op package]
     [-t][-pu][-pa][-bulk][-oa][-ht][-ea][-as][-m][-sr][-pi][-cg]" 

let read_args () = 
  let cf = default_config in 
  Arg.parse speclist (fun s -> ()) usage_msg; cf 

let failwith_msg msg =
  fprintf err_formatter "%s@." msg;
  Arg.usage speclist usage_msg; exit 1

let print_known_vtx_classifier = fprintf std_formatter "%a@." pp_known_vtx_classifier
let known_vtx_classifier_to_string arg = fprintf str_formatter "%a" pp_known_vtx_classifier arg;flush_str_formatter ()

let validate_and_print (prefix:string) (prt_time:bool) (g:graph) (pname:name) (mm:metamodel) : unit =
  begin 
    print_endline ("********* begin " ^ prefix ^ " message *************");
    let msg =
      try ("Validation succeeded.\n" ^ (known_vtx_classifier_to_string 
					  (let lcls = (lazy (validate g pname mm)) in
					  if prt_time 
					  then print_time ~prefix:prefix lcls
					  else Lazy.force lcls)
				       ))
      with 
	e -> ("Validation failed.\n" ^ (Printexc.to_string e)) in
    print_endline msg;
    print_endline ("********** end " ^ prefix ^ " message **************")
  end
(* execute query *)  
let _ = 
  let cf = read_args () in
  let _ = print_version () in
  (* check arguments *)
  if      cf.inputdb_file = "" then failwith_msg "source db file unspecified."
  (* else if cf.png_file = "" then failwith "Target png file unspecified." *)
  else if (cf.ikm3_file <> "") && (cf.ikm3_pkg = "") then failwith_msg "Package for input validation unspecified."
  else if (cf.okm3_file <> "") && (cf.okm3_pkg = "") then failwith_msg "Package for output validation unspecified."
  else 
    let db = TestUnCALutil.loadDotUnCAL_file ~set_GenId:true cf.inputdb_file in
    let env = (intern_gv "$db" db emptyDynEnv) in
    let al = List.map (fun a -> Scanf.sscanf a "%s@=%s" (fun vn fn ->(vn,fn))) cf.inputdb_flist in
    (* -var vn1=fn1 -var vn2=fn2 ... -var vn_n=fn_n 
     -> al=[("vn_n","fn_n");("vn_n-1","fn_n-1"); ... ; ("vn1","fn1")] *)
    let env = List.fold_right (fun (vn,fn) -> 
      intern_gv ("$" ^ vn) (remove_eps (load_db (parseUnCAL_file fn)))) al env in 
    (* -var vn1=fn1 -var vn2=fn2 ... -var vn_n=fn_n 
     -> dynenv.gvenv=[("$vn_n",g_n);("$vn_n-1",g_n-1); ... ; ("$vn1",g_1)] 
      If the same variable is bound by -var parameter, then previously bound 
      variable is shadowed *)
    let _ = if cf.ikm3_file <> "" then
      let input_km3 = parseKm3_file cf.ikm3_file in 
      validate_and_print "Input validation" cf.prt_time db cf.ikm3_pkg input_km3 in
    if cf.unql_file <> "" then
    let q = parseUnQL_file cf.unql_file in
    let _ = 
      if cf.prt_unql 
      then 
	begin 
	  print_endline "(************** begin Submitted Query ****************)";
	  print_expr q;
	  print_endline "(**************  end  Submitted Query ****************)"
	end in
    let lcq = lazy(
      let ds = if cf.expm_flag then DesugarUnQL.desugar_letrec else DesugarUnQL.desugar_i in
      let dq = ds q in
      let fq = UnQL2unCAL.flatten dq in
      UnQL2unCAL.qlx2cal [] (e2qt fq)) in
    let cq = if cf.prt_time then print_time ~prefix:"Desugaring" lcq
      else Lazy.force lcq in
    let cq = (map_info (fun _ -> None)) cq in
    let _ = 
      if cf.prt_uncal 
      then
	begin 
	  print_endline "(************** begin Executed UnCAL expr. ****************)";
	  print_aexpr cq;
	  print_endline "(**************  end  Executed UnCAL expr. ****************)"
	end in
    let _ = evalRecRecursive    := not cf.bulk_flag  in
    let _ = optApndRecRecursive :=     cf.apnd_flag  in
    let _ = skolemRec           :=     cf.srec_flag  in 
    let _ = escapeApnd          :=     cf.esca_flag  in
    let _ = leaveOMrkApnd       :=     cf.loma_flag  in
    let _ = optApndStat         :=     cf.as_flag    in (* no effect  unless -rw is on *)
    let _ = optTCRec            :=     cf.holtc_flag in
    let _ = useTransNodeId      :=     cf.tnid_flag  in
    let _ = if !skolemRec && (not (!escapeApnd || !useTransNodeId)) 
	then print_endline "Warning: -sr option must be accompanied by -pi or -ea " in
    let g = 
      let lg = lazy(clean_id (reachableGI (remove_eps (eval_with_env env cq)))) in
      if cf.prt_time then print_time ~prefix:"Evaluation" lg
      else Lazy.force lg in
    let g = 
      if cf.cont_flag then
	let lg = lazy(contract_opt g) in
	if cf.prt_time then print_time ~prefix:"Contraction" lg
	else Lazy.force lg 
      else g in
    let _ = if cf.okm3_file <> "" then
      let output_km3 = parseKm3_file cf.okm3_file in 
      validate_and_print "Output validation" cf.prt_time g cf.okm3_pkg output_km3 in
    let remove_dot_file = (cf.output_dotfile = "") in
    if (cf.output_uncalfile <> "") then
      (let _ = cycleSemanticsOriginal := false in dumpG g cf.output_uncalfile);
    if (cf.png_file = "" && cf.output_imagefile = "") then
      (if (cf.output_dotfile = "") then () else g2dot_file ~shape:`ellipse ~gray_unreachable:true
	~ops:[ALLbl"src_of"] ~prefix_n:cf.pn_flag g cf.output_dotfile)
    else
      let (format,fname) = 
	if cf.png_file <> "" then ("png",cf.png_file) else fsplit (get_suffix,id) cf.output_imagefile in
      g2image format ~remove_dot_file:remove_dot_file ~dot_file:cf.output_dotfile ~gray_unreachable:true
	~ops:[ALLbl"src_of"] ~shape:`ellipse ~prefix_n:cf.pn_flag
	g fname
	
