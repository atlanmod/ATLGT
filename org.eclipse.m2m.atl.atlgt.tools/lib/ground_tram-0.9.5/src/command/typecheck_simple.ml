(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
(* *)

let input_type = ref ""
let output_type = ref ""
let output_root = ref ""
let query_file = ref ""
let output_png = ref ""
let output_dot = ref ""
let paths = ref []

open UnQL
open UnCALDM
open UnCALDMutil
open EvalUnCAL
open Format
open Version
open FileUtil

let parseUnCAL_file =
  Parse.parse_file ~parse:ParseUnCAL.entry ~lex:LexUnCAL.token 
let parseKm3_file =
  Parse.parse_file ~parse:ParseKm3.entry ~lex:LexKm3.token
let parseUnQL_file =
  Parse.parse_file ~parse:ParseUnQL.entry ~lex:LexUnQL.token

let apply_unql ifile query =
  let igraph =
    clean_id(remove_eps(load_db(UnCALSA.map_info (fun _ -> None) (parseUnCAL_file ifile)))) in
  evalRecRecursive := true;
  optApndRecRecursive := false;
  skolemRec := false;
  escapeApnd := false;
  useTransNodeId := false;
  let q = parseUnQL_file query in
  let dq = DesugarUnQL.desugar_i q in
  match (UnQL2unCAL.flatten dq).action with
    | `query (_,qt) -> 
        let cq = UnQL2unCAL.qlx2cal [] qt in
	let cq = UnCALSA.map_info (fun _ -> None) cq in
        clean_id (reachableGI (remove_eps (eval_unCAL igraph cq)))
    | _ -> failwith "not query in e2qt"
  
let usage_msg =
  "Usage: "^Sys.argv.(0)^
    " -it input_type.uncal -ot output_type.km3 -or root_class_of_output query.unql"

let rec add_spec keys spec doc speclist = match keys with
  | [] -> speclist
  | key::keys' -> add_spec keys' spec doc ((key,spec," "^doc)::speclist)
let rec add_speclist ks_spcl spcl = match ks_spcl with
  | [] -> Arg.align spcl
  | (keys,spec,doc)::rest -> add_speclist rest (add_spec keys spec doc spcl)
let make_speclist ks_spcl = add_speclist ks_spcl []

let speclist = make_speclist [
  ["-it";"-input-type"], Arg.Set_string input_type,
  "input type declaration (in UnCAL)";
  ["-ot";"-output-type"], Arg.Set_string output_type,
  "output type declaration (in KM3)";
  ["-or";"-output-root"], Arg.Set_string output_root,
  "root class name of output type in KM3";
  ["-op";"-output-png"], Arg.Set_string output_png,
  "png file of output type";
  ["-od";"-output-dot"], Arg.Set_string output_dot,
  "dot file of output type";
  ["-I"], Arg.String(fun path -> paths := path :: !paths),
  "path to find given files";
]

let speclist = add_version_spec speclist

let usage() = Arg.usage speclist usage_msg

let anon_fun str = query_file := str

let _ =
  Arg.parse speclist anon_fun usage_msg;
  print_version ();
  if List.exists (fun refstr -> !refstr = "" )
    [input_type; output_type; query_file; output_root] then usage ()
  else
    let itype = find_file !paths !input_type in
    let qfile = find_file !paths !query_file in
    let otype = find_file !paths !output_type in
    let ograph = Contraction.contract(apply_unql itype qfile) in
    let out_km3 = parseKm3_file otype in
    if !output_dot = "" then output_dot := Filename.temp_file "unqldot" "";
    G2viz.g2viz ograph !output_dot;
    if !output_png <> "" then
      ignore (Unix.system
                (sprintf "dot -T png %s -o %s" !output_dot !output_png));
    ignore (Km3util.validate ograph !output_root out_km3);
    printf "Success!@."
