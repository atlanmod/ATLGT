open Format
open Version
(* open Xmi2dot *)
open AtlMin2unql
open PrintUnQL


type config = {
    mutable atl_file : string ; (* input ATL  file *)
    mutable uq_file  : string ; (* output UnQL file *)
    mutable ikm3_file : string ; (* input metamodel KM3 file *)
    mutable ikm3_pkg  : string ; (* input pakage name *)
    mutable okm3_file : string ; (* output metamodel KM3 file *)
    mutable okm3_pkg  : string ; (* output pakage name *)

}

let cf = {  atl_file  = "";
	    uq_file   = "";
	    ikm3_file = ""; 
	    okm3_file = "";
	    ikm3_pkg  = "";
	    okm3_pkg  = ""; 
          }

let speclist = 
  Arg.align
    [
     ("-atl",  Arg.String (fun s->cf.atl_file <-s),   " source ATL file");
     ("-uq",   Arg.String (fun s->cf.uq_file  <-s),   " output UnQL file");
     ("-ikm3", Arg.String (fun s->cf.ikm3_file<-s),   " input metamodel KM3 file");
     ("-ipkg", Arg.String (fun s->cf.ikm3_pkg <-s),   " input package");
     ("-okm3", Arg.String (fun s->cf.okm3_file<-s),   " output metamodel KM3 file");
     ("-opkg", Arg.String (fun s->cf.okm3_pkg <-s),   " output package");
   ]

let speclist = add_version_spec speclist

let usage_msg = 
  "Usage: "^Sys.executable_name^" -atl input.atl -uq output.unql -ikm3 input.km3 -ipkg Ipkg -okm3 output.km3 -opkg Opkg"

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
  if      cf.atl_file = "" then failwith_msg "Source ATL file unspecified."
  else if cf.uq_file  = "" then failwith_msg "Output UnQL file unspecified."
  else if cf.ikm3_file = "" then failwith_msg "Input KM3 file unspecified."
  else if cf.okm3_file = "" then failwith_msg "Output KM3 file unspecified."
  else if cf.ikm3_pkg = "" then failwith_msg "Package name in input metamodel KM3 file unspecified."
  else if cf.okm3_pkg = "" then failwith_msg "Package name in output metamodel KM3 file unspecified."
  else
     let unql = atlMin2unql_driver cf.atl_file cf.ikm3_file cf.ikm3_pkg cf.okm3_file cf.okm3_pkg in
     let oc = open_out cf.uq_file in
     let fmt = formatter_of_out_channel oc in
     pp_expr fmt unql;
     close_out oc

