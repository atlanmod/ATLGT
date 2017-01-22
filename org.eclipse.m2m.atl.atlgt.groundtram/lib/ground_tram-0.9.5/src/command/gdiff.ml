(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
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
open Graphs2op

(* stages *)

(* *)

type config = {
    mutable orgdot_file    : string;      (* original dot file [INPUT]  *)
    mutable moddot_file    : string;      (* modified dot file [INPUT]  *)
    mutable difdot_file    : string;      (* diff     dot file [OUTPUT] *)
    mutable difimg_file    : string;      (* diff   image file [OUTPUT] *)
    mutable prmdot_file    : string;      (* params   dot file [OUTPUT] *)
    mutable pv_flag        : bool;        (* preview diff      [FLAG]   *)
    mutable bisim_flag     : bool;        (* check bisimilarity [FLAG]  *)
}

let default_config = {
  orgdot_file = "";
  moddot_file = "";
  difdot_file = "";
  difimg_file = "";
  prmdot_file = "";
  pv_flag = false;
  bisim_flag = false;
}

let speclist =
  let cf = default_config in
  Arg.align
    [
     ("-org", Arg.String (fun s->cf.orgdot_file<-s),  " original  dot file [INPUT]"); 
     ("-mod", Arg.String (fun s->cf.moddot_file<-s),  " modified  dot file [INPUT]");
     ("-prm", Arg.String (fun s->cf.prmdot_file<-s),  " parameter dot file [INPUT]");
     ("-dif", Arg.String (fun s->cf.difdot_file<-s),  " diff      dot file [OUTPUT]");
     ("-dim", Arg.String (fun s->cf.difimg_file<-s),  " diff    image file [OUTPUT]");
     ("-pv",  Arg.Unit   (fun()->cf.pv_flag<-true),   " preview diff [FLAG]");
     ("-bis", Arg.Unit   (fun()->cf.bisim_flag<-true)," check bisimilarity [FLAG]");
   ]

let speclist = add_version_spec speclist

let usage_msg = "Usage: "
  ^Sys.executable_name^ " -org org.dot -mod mod.dot [-bis][-dif dif.dot] [-dim imagefile][-pv]
     [-prm prm.dot]"

let read_args () = 
  Arg.parse speclist (fun s -> ()) usage_msg; default_config

let failwith_msg msg =
  fprintf err_formatter "%s@." msg;
  Arg.usage speclist usage_msg; exit 1

let _ = 
  let cf = read_args () in
  let _ = print_version () in
  (* check arguments *)
  if      cf.orgdot_file = "" then failwith_msg "Original dot file unspecified."
  else if cf.moddot_file = "" then failwith_msg "Modified dot file unspecified."
  else
    let gOrg = loadDot_file cf.orgdot_file in
    let gMod = loadDot_file cf.moddot_file in
    if cf.bisim_flag then 
       (fprintf std_formatter "%s" "checking bisimilarity ...";
        let result = if (bisimilar_opt gOrg gMod) then "bisimilar" else "not bisimilar" in
        fprintf std_formatter "%s@." result)
    else
    let diff = graph_diff gOrg gMod in
    if cf.pv_flag then dispD_gc diff;
    if cf.difdot_file <> "" then (
      dumpDot ~prefix_n:false diff cf.difdot_file;
      if cf.difimg_file <> "" then
	let format = get_suffix cf.difimg_file in
	dot2imagef format ~shape:`ellipse ~prefix_n:true diff cf.difimg_file);
    if cf.prmdot_file <> "" then graphs2op gOrg gMod cf.prmdot_file
      
	
	

