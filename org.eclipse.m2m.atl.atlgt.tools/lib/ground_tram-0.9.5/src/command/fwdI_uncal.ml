(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
(* forward driver of testInsert.ml  *)
open G2viz
open Format
open UnCAL
open PrintUnCAL

open UnCALDMutil
open EvalUnCAL
open UnCALdynenv
open Dotutil
open PrintDot
open TestInsert
open Fputil
open UnCALDM
open Version
open UnCALSA

(************************* BEGIN basic definitions *******************************)
let parseUnCAL_file = Parse.parse_file ~parse:ParseUnCAL.entry ~lex:LexUnCAL.token 
let parseUnCAL_file   = (map_info (fun _ -> None)) @@ parseUnCAL_file
let parseDot_file = Parse.parse_file ~parse:ParseDot.entry ~lex:LexDot.token 
(***************************** END basic definitions *****************************)

(* forward computation *)
(* 
   Usage for insertion:

   
   1. Normal forward execution and probe insertion unit candidates
   % fwdI_uncal -db db.dot -q q.uncal -png result.png -dot result.dot

   2. Select insertion endpoints (ex: "Hub(2,&,9)" and "Hub(3,&,9)") by 
   viewing result.{png,dot}

   3. Generate insertion unit file for backward transformation 
   % fwdI_uncal -db db.dot -q q.uncal -png result.png -dot result.dot \
      -src "Hub(2,&,9)" -dst "Hub(3,&,9)" -iu result.iu -in 1 -id iu.dot 

   4. Execute backward transformation
   % bwdI_uncal -db bd_db.dot -q q.uncal -png dbprime.png -dot result.dot \
      -iu result.iu

*)   
 

let inputdb_file = ref ""    (* input DOT db file *)
let q_file       = ref ""    (* input UnCAL query file *)
let  png_file    = ref ""    (* output png file *)
let dot_file     = ref ""    (* output in dot format for user editing *)
let prt_uncal    = ref false (* turn on printing source UnCAL expression *)
let iu_file      = ref ""    (* marshalled insertion unit *)
let src_node     = ref ""    (* source of insertion unit *)
let dst_node     = ref ""    (* destination of insertion unit *)
let iu_index     = ref (-1)  (* index of insertion unit to marshal *)
let iudot_file   = ref ""    (* dot representation of target with chosen insertion unit *)
let vv_flag      = ref false (* turn on debug writing *)

(* let set_inputdb_file cf fn = cf := {!cf with inputdb_file = fn ; } *)

let speclist = Arg.align
    [
(*     ("-db", Arg.String (set_inputdb_file cf), " source db file (in DOT)"); *)
     ("-db", Arg.Set_string inputdb_file, " source db file (in DOT)"); 
     ("-q",  Arg.Set_string q_file,       " source UnCAL file");
     ("-png",Arg.Set_string png_file,     " result PNG file");
     ("-dot",Arg.Set_string dot_file,     " result DOT file for editing and backward input");
     ("-pa", Arg.Set        prt_uncal,    " print UnCAL input expression");
     ("-iu", Arg.Set_string iu_file,      " insertion unit file");
     ("-id", Arg.Set_string iudot_file,   " dot representation of target with chosen insertion unit");
     ("-src",Arg.Set_string src_node,     " source of insertion unit");
     ("-dst",Arg.Set_string dst_node,     " destination of insertion unit");
     ("-in", Arg.Set_int    iu_index,     " index of insertion unit to marshal");
     ("-vv", Arg.Set        vv_flag,      " turn on debug writing (verbose)");
   ]

let speclist = add_version_spec speclist 

let usage_msg = "usage: "^Sys.executable_name^" -db db.dot  -q query.uncal -dot output.dot \r
      -png output.png  [-iu ins.iu -src node -dst node -id n] [-v] [-pa]"

let read_args () = 
  Arg.parse speclist (fun s -> ()) usage_msg

let failwith_msg msg =
  fprintf err_formatter "%s@." msg;
  Arg.usage speclist usage_msg; exit 1

(* execute query *) 
let _ = 
  let _ = read_args () in
  let _ = print_version () in
  (* check arguments *)
  if      !inputdb_file = "" then failwith_msg "Source db file unspecified."
  else if !q_file       = "" then failwith_msg "UnCAL source file unspecified."
  else if !png_file     = "" then failwith_msg "Target png file unspecified."
  else if !dot_file     = "" then failwith_msg "Result dot file for editing unspecified."
  else 
    let _ = bdIverbose := !vv_flag in
    let _ = GenId.reset ()  in
    let db = (dot2g @@ parseDot_file) !inputdb_file in
    let ce = parseUnCAL_file !q_file in
    let _ = 
      if !prt_uncal 
      then 
	begin 
	  print_endline "(************** begin Submitted Query ****************)";
	  print_aexpr ce;
	  print_endline "(**************  end  Submitted Query ****************)"
	end in
    let g = match test ce db TestFwd with
      `TestFwd g -> g
    | _          -> failwith "Forward Evaluation failed."  in
    let dot = g2dot ~gray_unreachable:true g in
    let _ = dumpDot ~prefix_n:true dot !dot_file  in
    let _ = dotf2pngf !dot_file !png_file in
    if !iu_file <> "" && !src_node <> "" && !dst_node <> "" then
      let v1 = TestUnCALutil.parseVtx_string !src_node 
      and v2 = TestUnCALutil.parseVtx_string !dst_node in
      let ib = { ib_src = SetofVtx.fromList [v1]; ib_dst = SetofVtx.fromList [v2] } in
      let iulist = match (it_test [ib] ce db ITTestTmp) with (`TestTmp t) -> t | _ -> failwith "" in
      let l = List.length iulist in
      let _ = Format.fprintf Format.std_formatter "Total number of insertion units: %d@." l in
      if l = 0 then failwith "No insertion template available" 
      else if !iu_index >= l || !iu_index < 0 then failwith "Illegal index of insertion unit"
      else let ig = List.nth iulist !iu_index in
      let iu = { src = SetofVtx.fromList [v1]; dst = SetofVtx.fromList [v2] ; graph = ig; } in
      let _ = ins2file iu  !iu_file in
      if !iudot_file <> "" then 
	let d = TestUnCALutil.gIlist2dot g [iu] in dumpDot ~prefix_n:true d !iudot_file

