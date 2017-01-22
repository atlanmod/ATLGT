open Format
open Version
open Xml
open Xmi2dot_generic

type config = {
    mutable xmi_file : string ; (* input XMI  file *)
    mutable dot_file : string ; (* output DOT file *)
    mutable odot_file : string ; (* original DOT file *)
    mutable km3_file : string ; (* output DOT file *)
    mutable pname    : string ; (* pakage name *)
    mutable vv_level  : int   ; (* verbosity level *)
    mutable validation_flag : bool ; (* validation flag *)
}

let cf = {  xmi_file = "";
	    dot_file = "";
	    odot_file = "";
	    km3_file = "";
	    pname    = "";
	    vv_level  = 0;
	    validation_flag = false;
          }

let speclist = 
  Arg.align
    [
     ("-xmi",  Arg.String (fun s->cf.xmi_file  <-s),   " source XMI file");
     ("-dot",  Arg.String (fun s->cf.dot_file  <-s),   " output DOT file");
     ("-odot", Arg.String (fun s->cf.odot_file <-s),   " original DOT file");
     ("-km3",  Arg.String (fun s->cf.km3_file  <-s),   " metamodel KM3 file");
     ("-pkg",  Arg.String (fun s->cf.pname     <-s),   " package name");
     ("-vv",   Arg.Unit   (fun ()->cf.vv_level <- cf.vv_level + 1)," verbosity level");
     ("-validate", Arg.Unit(fun()->cf.validation_flag <-true)," validation flag");
   ]

let speclist = add_version_spec speclist

let usage_msg = 
  "Usage: "^Sys.executable_name^" -xmi input.xmi [-odot original.dot] -dot output.dot -km3 metamodel.km3 -pkg pkgname [-vv] [-validate]"

let read_args () = 
  let cf = cf in 
  Arg.parse speclist (fun s -> ()) usage_msg; cf

let failwith_msg msg =
  fprintf err_formatter "%s@." msg;
  Arg.usage speclist usage_msg; exit 1

(* execute query *) 
let _ = 
  let cf = read_args () in
  let _ = print_version () in
  (* check arguments *)
  if      cf.xmi_file = "" then failwith_msg "Source XMI file unspecified."
  else if cf.dot_file = "" then failwith_msg "Output DOT file unspecified."
(*
  else if cf.km3_file = "" then failwith_msg "KM3 file unspecified."
  else if cf.pname    = "" then failwith_msg "package name unspecified."
*)
  else 
    let _ = if cf.vv_level > 0 then xmi2dot_generic_verbose := true in
    let _ = if cf.vv_level > 1 then Km3util.km3util_verbose := true in
    let km3_file = if cf.km3_file = "" then None else Some (cf.km3_file) in
    let pname    = if cf.pname    = "" then None else Some (cf.pname) in
    let odot_file = if cf.odot_file="" then None else Some (cf.odot_file) in
    Xmi2dot_generic.xmi2dot odot_file pname km3_file cf.validation_flag cf.xmi_file  cf.dot_file

