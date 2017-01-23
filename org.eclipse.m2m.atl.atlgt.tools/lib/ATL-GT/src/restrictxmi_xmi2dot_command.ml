open Fputil
open Format
open Print
open Version
open Xml
open RestrictObject
open Km3
open Km3util
open ObjectGraph
open Xmi2dot_generic
open Dotutil
open G2objectGraph
open Dot2xmi

type config = {
    mutable xmi_file : string ; (* input XMI  file *)
    mutable pxmi_file : string ; (* partial XMI  file *)
    mutable odot_file : string; (* original DOT file *) 
    mutable udot_file : string; (* updated  DOT file *) 
    mutable km3_file : string ; (* relaxed KM3 metamodel *)
    mutable pname    : string ; (* pakage name *)
    mutable vv_level  : int   ; (* verbosity level *)
    mutable validation_flag : bool ; (* validation flag *)
}

let cf = {  xmi_file = "";
            pxmi_file = "";
	    odot_file = "";
	    udot_file = "";
	    km3_file = "";
	    pname    = "";
	    vv_level  = 0;
	    validation_flag = false;
          }

let speclist = 
  Arg.align
    [
     ("-xmi",  Arg.String (fun s->cf.xmi_file   <-s),   " updated XMI file  (INPUT)");
     ("-pxmi", Arg.String (fun s->cf.pxmi_file  <-s),   " partial XMI file  (INPUT)");
     ("-odot", Arg.String (fun s->cf.odot_file  <-s),   " original DOT file (INPUT)");
     ("-udot", Arg.String (fun s->cf.udot_file  <-s),   " updated  DOT file (OUTPUT)");
     ("-km3",  Arg.String (fun s->cf.km3_file   <-s),   " relaxed metamodel KM3 file (INPUT)");
     ("-pkg",  Arg.String (fun s->cf.pname      <-s),   " package name");
     ("-vv",   Arg.Unit   (fun ()->cf.vv_level <- cf.vv_level + 1)," verbosity level");
     ("-validate", Arg.Unit(fun()->cf.validation_flag <-true)," validation flag");
   ]

let speclist = add_version_spec speclist

let usage_msg = 
  "Usage: "^Sys.executable_name^" -xmi supermodel.xmi -odot original.dot -dot output.dot [-km3 metamodel.km3] [-pkg pkgname] [-vv] [-validate]"

let read_args () = 
  let cf = cf in 
  Arg.parse speclist (fun s -> ()) usage_msg; cf

let failwith_msg msg =
  fprintf err_formatter "%s@." msg;
  Arg.usage speclist usage_msg; exit 1

let parseKm3_file = Parse.parse_file ~parse:ParseKm3.entry ~lex:LexKm3.token 

(* execute command *) 
let _ = 
  let cf = read_args () in
  let _ = print_version () in
  (* check arguments *)
  if      cf.xmi_file  = "" then failwith_msg "Source XMI file unspecified."
  else if cf.udot_file = "" then failwith_msg "Output DOT file unspecified."
  else if cf.odot_file = "" then failwith_msg "Original DOT file unspecified."
  else if cf.pxmi_file = "" then failwith_msg "Partial XMI file unspecified."
  else if cf.km3_file  = "" then failwith_msg "KM3 file unspecified."
  else if cf.pname     = "" then failwith_msg "package name unspecified."
  else 
    let _ = if cf.vv_level > 0 then restrictObject_verbose := true in
    let _ = if cf.vv_level > 1 then Km3util.km3util_verbose := true in
    let km3_file = cf.km3_file in
    let pname    = cf.pname  in
    let mm = parseKm3_file km3_file in
    let og2' : xmi_element NameMap.t = 
      let xml = Xml.parse_file cf.xmi_file in
      xmi2objectGraph (Some mm) xml in
(*
    let (root,m) =
      let orig_dot = TestUnCALutil.parseDot_file cf.odot_file in
      let g = dot2g orig_dot in
      g2vtx2xmi_element_Map g pname mm  in
    let og1  : xmi_element NameMap.t =
      let fix_xmi_id = function
	  (* "xmi_id" *) "__xmiID__" -> "xmi:id"
	| s        -> s in
      let m = VMap.map (fun xmi_element ->
	{xmi_element with attrmap=NameMap.endomap_kv fix_xmi_id id xmi_element.attrmap}) m in
      let pp_string fmt = fprintf fmt "%s" in
      let ppr_primset fmt x = match x with
	SetofInt iset -> fprintf fmt "%a" (pr_seq " " pp_int)    (List.map fst (SetofInt.elements iset))
      | SetofStr sset -> fprintf fmt "%a" (pr_seq " " pp_string) (List.map fst (SetofStr.elements sset))
      | SetofFlt fset -> fprintf fmt "%a" (pr_seq " " pp_float)  (List.map fst (SetofFlt.elements fset))
      | SetofBol bset -> fprintf fmt "%a" (pr_seq " " pp_bool)   (List.map fst (SetofBol.elements bset)) in
      VMap.fold (fun key value ->
	 let xmi_id = 
	   if NameMap.mem "xmi:id" value.attrmap 
	   then string_of ppr_primset (snd (NameMap.find "xmi:id" value.attrmap))
	   else failwith "restrictxmi_command.ml: xmi:id not found" in
          NameMap.add xmi_id value) m NameMap.empty in *)
    let og1 : xmi_element NameMap.t = 
      let xml = Xml.parse_file cf.pxmi_file in
      xmi2objectGraph (Some mm) xml in
    let og1' = restrict_object (og1:xmi_element NameMap.t) (og2':xmi_element NameMap.t) in 
    let orig_dot = TestUnCALutil.parseDot_file cf.odot_file in
    let orig_g   = dot2g orig_dot in
    let (root,m) = g2vtx2xmi_element_Map orig_g pname mm in
    let orig_objectGraph = vtx_map_to_xmi_id_map m in
    let updated_objectGraph = put orig_objectGraph og1' in
    let g' = objectGraph2g updated_objectGraph root 100000 (* tentative *) in
    let updated_dot = g2dot g' in
    if cf.validation_flag then
      validate_and_print "Output validation" true g' pname mm;
    dumpDot updated_dot cf.udot_file


