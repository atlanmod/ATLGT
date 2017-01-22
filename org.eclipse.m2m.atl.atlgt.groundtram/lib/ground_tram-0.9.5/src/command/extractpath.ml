(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
(* extract a path to the root from a given marker in uncal file of the form &xxx@cycle(...)  *)
open Version
open Format
open UnCALDMpath

type config = {
    mutable uncal_file : string;      (* uncal file [INPUT] *)
    mutable omarker    : string;      (* output marker [INPUT] *)
}

let default_config = {
  uncal_file = "";
  omarker    = "";
}

let speclist =
  let cf = default_config in
  Arg.align
    [
     ("-om",    Arg.String (fun s->cf.omarker<-s),   " marker [INPUT]");  
     ("-uncal", Arg.Rest   (fun s->cf.uncal_file<-s), " uncal file [INPUT]"); 
   ]

let speclist = add_version_spec speclist

let usage_msg = "Usage: "
  ^Sys.executable_name^ " -om marker -uncal uncal_file"

let read_args () = 
  Arg.parse speclist (fun s -> ()) usage_msg; default_config

let failwith_msg msg =
  fprintf err_formatter "%s@." msg;
  Arg.usage speclist usage_msg; exit 1

let print_rpp p = fprintf std_formatter "%a@." PrintUnQL.pp_rpp p

let _ = 
  let cf = read_args () in
  let _ = print_version () in
  (* check arguments *)
  if  cf.uncal_file = "" then failwith_msg "UnCAL file unspecified." else
  if  cf.omarker    = "" then failwith_msg "marker unspecified." else
  print_rpp (omarker2path cf.omarker cf.uncal_file)

  

