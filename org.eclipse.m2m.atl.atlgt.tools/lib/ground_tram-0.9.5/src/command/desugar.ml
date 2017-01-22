(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
(*
Usage: desugar [-m] UnQLfilename
 when -m specified, all UnCAL exp. have markers 
*)

open UnQL
open PrintUnQL
open UnCAL
open DesugarUnQL
open PrintUnCAL
open UnQL2unCAL
open Version

let e2qt (e:'a UnQL.expr) = 
  match e.action with
    | `query (_,t) -> t
    | _ -> failwith "not query in e2qt"

let parseUnQL_string =
  Parse.parse_string ~parse:ParseUnQL.entry ~lex:LexUnQL.token 
let parseUnQL_file = Parse.parse_file ~parse:ParseUnQL.entry ~lex:LexUnQL.token 

let qfile = ref ""
let all_marker = ref false

let specs = Arg.align
    [
      ("-m",Arg.Set all_marker, "Each UnCAL rec has marker");
    ] 
let specs = add_version_spec specs
let usage = "Usage: desugar [-m] UnQLfilename"
let failwith_msg msg =
  Format.fprintf Format.err_formatter "%s@." msg;
  Arg.usage specs usage; exit 1

let _ =
   (Arg.parse specs (fun s -> qfile:=s) usage); 
  let _ = print_version () in
  if !qfile = "" then failwith_msg "UnQL file unspecified.";
  let q = try (parseUnQL_file !qfile) with 
    Sys_error s -> failwith_msg s in
    if !all_marker then
      print_aexpr (qlx2cal [] (e2qt (flatten (desugar_letrec q)))) 
    else 
      print_aexpr (qlx2cal [] (e2qt (flatten (desugar_i q))))

  
    
      
