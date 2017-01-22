open Format
open Version
open Dotutil
open TestUnCALutil
open UnCAL
open UnCALDM
open Dot

type config = {
    mutable idot_file : string ; (* input DOT file *)
    mutable odot_file : string ; (* output DOT file *)
}

let cf = { 
	    idot_file = "";
	    odot_file = "";
          }

let speclist = 
  Arg.align
    [
     ("-idot",  Arg.String (fun s->cf.idot_file  <-s),   " input DOT file");
     ("-odot",  Arg.String (fun s->cf.odot_file  <-s),   " output DOT file");
   ]

let speclist = add_version_spec speclist

let usage_msg = 
  "Usage: "^Sys.executable_name^" -idot iput.dot  -odot output.dot"

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
  if      cf.idot_file = "" then failwith_msg "Input DOT file unspecified."
  else if cf.odot_file = "" then failwith_msg "Output DOT file unspecified."
  else
    let g = loadDot_file ~set_GenId:true cf.idot_file in
    let re = Str.regexp ":" in
    let col2ub s = Str.global_replace re "_" s in
    let fixlabel l = match l with
      ALLbl l -> ALLbl (col2ub l) 
    |  _ ->    l in
    let g = {g with e = SetofEdge.map (fun (u,l,v) -> (u,fixlabel l,v)) g.e } in
    g2dot_file ~shape:`ellipse g cf.odot_file
