open Format
open Version
open Xml
open Xmi2dot

type config = {
    mutable xmi_file : string ; (* input XMI  file *)
    mutable dot_file : string ; (* output DOT file *)
    mutable sample_flag : bool   ; (* sample flag *)
}

let cf = {  xmi_file = "";
	    dot_file = "";    
	    sample_flag = false;
          }

let speclist = 
  Arg.align
    [
     ("-xmi",  Arg.String (fun s->cf.xmi_file  <-s),   " source XMI file");
     ("-dot",  Arg.String (fun s->cf.dot_file  <-s),   " output DOT file");
     ("-flag", Arg.Unit   (fun()->cf.sample_flag <-true)," turn on flag");
   ]

let speclist = add_version_spec speclist

let usage_msg = 
  "Usage: "^Sys.executable_name^" -xmi  -dot output.dot [-flag]"

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
  else
    xmi2dot cf.xmi_file cf.dot_file
