(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
(* backward driver of testInsert.ml 
   forward evaluation is conducted again to produce backward transformation *)
open G2viz
open Format
open UnCAL
open PrintUnCAL

open UnCALDMutil
open EvalUnCAL
open UnCALdynenv
open Dotutil
open PrintDot
open TestInsert
open Fputil
open Version
open UnCALSA

(************************* BEGIN basic definitions *******************************)
let parseUnCAL_file = Parse.parse_file ~parse:ParseUnCAL.entry ~lex:LexUnCAL.token 
let parseUnCAL_file   = (map_info (fun _ -> None)) @@ parseUnCAL_file
let parseDot_file = Parse.parse_file ~parse:ParseDot.entry ~lex:LexDot.token 
(***************************** END basic definitions *****************************)

(* backward computation *)
(* 
   Synopsis:
   bwdI_uncal  -db db.dot  -q query.uncal ...
*)   
 
type bwd_config = {
    mutable inputdb_file : string ; (* input DOT db file *)
    mutable q_file       : string ; (* input UnCAL query file *)
    mutable inputdot_file : string; (* input DOT view file *)
    mutable db_png_file  : string; (* output rho($db) file in PNG format *)
    mutable udb_dot_file : string; (* output rho($db) file in DOT format *)
    mutable iu_file      : string ; (* marshalled insertion unit *)
    mutable prt_uncal    : bool   ; (* turn on printing source UnCAL expression *)
    mutable v_flag       : bool   ; (* turn on debug writing *)
    mutable cm_flag      : bool;    (* color modification to source DB in output PNG *)
}

let default_config = { inputdb_file = ""; q_file = ""; inputdot_file = ""; 
                       db_png_file = ""; udb_dot_file = ""; 
		       iu_file = "";   prt_uncal = false; v_flag = false;
		       cm_flag = false;}

let speclist = 
  let cf = default_config in 
  Arg.align [
    ("-db",  Arg.String (fun s->cf.inputdb_file <-s), " source db file (in DOT)");
    ("-q",   Arg.String (fun s->cf.q_file       <-s), " source UnCAL file");
    ("-dot", Arg.String (fun s->cf.inputdot_file<-s), " dot file of modified target (in DOT)");
    ("-iu",  Arg.String (fun s->cf.iu_file      <-s), " insertion unit file");
    ("-udot",Arg.String (fun s->cf.udb_dot_file <-s), " dot file of modified source db");
    ("-png", Arg.String (fun s->cf.db_png_file  <-s), " png view of modified source db");
    ("-pa",  Arg.Unit   (fun()->cf.prt_uncal<-true),  " print UnCAL input expression");
    ("-vv",  Arg.Unit   (fun()->cf.v_flag   <-true),  " turn on debug writing (verbose)");
    ("-cm",  Arg.Unit   (fun()->cf.cm_flag  <-true),  " color modification to source DB in output PNG");
   ]

let speclist = add_version_spec speclist

let usage_msg = "usage: "^Sys.executable_name^" -db db.dot  -q query.uncal -dot modview.dot \r
      -iu ins.iu -udot moddb.dot -png moddb.png [-pa] [-v] [-cm]"

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
  if      cf.inputdb_file  = "" then failwith_msg "Source db file unspecified."
  else if cf.q_file        = "" then failwith_msg "UnCAL source file unspecified."
  else if cf.inputdot_file = "" then failwith_msg "Modified dot file unspecified."
  else if cf.db_png_file   = "" then failwith_msg "Missing PNG file to store modified source view."
  else 
    let _ = GenId.reset ()  in
    let db = (dot2g @@ parseDot_file) cf.inputdb_file in
    let ce = parseUnCAL_file cf.q_file in
    let g' = dot2g (parseDot_file cf.inputdot_file) in
    let iul = if cf.iu_file = "" then [] else [file2ins cf.iu_file] in
    let _ = 
      if cf.prt_uncal 
      then 
	begin 
	  print_endline "(************** begin Submitted Query ****************)";
	  print_aexpr ce;
	  print_endline "(**************  end  Submitted Query ****************)"
	end in
    let _ = bdIverbose := cf.v_flag in
    let db' = match test  ~out_graph:g' ~insertion_units:iul ce db TestBwd with
      `TestBwd db' -> db'
    | _ -> failwith "Backward Evaluation failed." in
    if cf.udb_dot_file <> "" then g2dot_file ~shape:`ellipse ~prefix_n:true db' cf.udb_dot_file;
    if cf.cm_flag then
      let d = graph_diff db db' in
      dot2imagef "png" ~shape:`ellipse ~prefix_n:true d cf.db_png_file
    else 
      g2png ~prefix_n:true ~shape:`ellipse db' cf.db_png_file


