open Format
open Version
open Xml
open Dot2xmi
open DispdotXMI

type config = {
    mutable dot_file : string ; (* input DOT file *)
    mutable km3_file : string ; (* input KM3 file *)
    mutable pkg_name : string ; (* package name in KM3 file *)
    mutable xmi_file : string ; (* output XMI file *)
    mutable dgm_file : string ; (* output DOT file (diagram) *)
    mutable vv_level  : int   ; (* verbosity level *)
}

let cf = {  dot_file = "";
	    km3_file = "";
	    pkg_name = "";
	    xmi_file = "";
	    dgm_file = "";
	    vv_level  = 0;
          }

let speclist = 
  Arg.align
    [
     ("-dot",  Arg.String (fun s->cf.dot_file  <-s),   " source DOT file");
     ("-km3",  Arg.String (fun s->cf.km3_file  <-s),   " input KM3 file");
     ("-pkg",  Arg.String (fun s->cf.pkg_name  <-s),   " package name in KM3 file");
     ("-xmi",  Arg.String (fun s->cf.xmi_file  <-s),   " output XMI file");
     ("-dgm",  Arg.String (fun s->cf.dgm_file  <-s),   " output DOT file (diagram)");
     ("-vv",   Arg.Unit   (fun ()->cf.vv_level <- cf.vv_level + 1)," verbosity level");
   ]

let speclist = add_version_spec speclist

let usage_msg = 
  "Usage: "^Sys.executable_name^" -dot input.dot -km3 input.km3 -pkg pkg_name \
   [-xmi output.xmi|-dgm output.dot]  [-vv]"

let read_args () =
  let cf = cf in 
  Arg.parse speclist (fun s -> ()) usage_msg; cf

let failwith_msg msg =
  fprintf err_formatter "%s@." msg;
  Arg.usage speclist usage_msg; exit 1

let _ = 
  let cf = read_args () in
  let _ = print_version () in
  (* check arguments *)
  if      cf.dot_file = "" then failwith_msg "Input DOT file unspecified."
  else if cf.km3_file = "" then failwith_msg "Input KM3 file unspecified."
  else if cf.pkg_name = "" then failwith_msg "Package name in KM3 file unspecified."
  else begin
    let _ = if cf.vv_level > 0 then Km3util.km3util_verbose := true in
    if cf.xmi_file <> "" then
       dot2xmi cf.dot_file cf.km3_file cf.pkg_name cf.xmi_file;
    if cf.dgm_file <> "" then 
      dot2dot_diagram cf.dot_file cf.km3_file cf.pkg_name cf.dgm_file;
    end
