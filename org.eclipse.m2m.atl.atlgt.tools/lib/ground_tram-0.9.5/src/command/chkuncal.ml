(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
open Version
open MonaOut
open Format
open EvalUnCAL
open UnCALDM
open UnCALDMutil
open G2UnCAL
open Dot
open UnCALSA


let usage_msg =
	 "Usage:\n"
	^"  "^Sys.argv.(0)^" in.km3 transform.(unql|uncal) out.km3\n"
	^"\n"
	^"  Verify type-correctness of transformation with respect to the given schemas.\n"
	^"  If it is type-correct, it sais 'Success!'; otherwise 'Failure!'.\n"
	^"  You need MONA mso-processor to be installed.\n"
	^"\n"
	^"Options:"

let anons      = ref []
let anon_fun s = anons := !anons @ [s]

let p_mode = ref false
let c_mode = ref false
let q_mode = ref false
let g_file = ref ""
let o_file = ref ""
let paths  = ref []
let specs  = add_version_spec (Arg.align
[
  "-c", Arg.Set c_mode,
  " Compilation to MSO formula only";
  "-p", Arg.Set p_mode,
  " (Debug) print desugared UnCAL program";
  "-q", Arg.Set q_mode,
  " Quiet mode";
  "-o", Arg.Set_string o_file,
  " Filename of the output MSO formula (\"-o -\" for stdout)";
  "-I", Arg.String(fun path -> paths := path :: !paths),
  " Path to find given files";
  "-g", Arg.Set_string g_file,
  " Print counter-example input/output graphs (only when failure)";
])

let parseArgv () = Arg.parse specs anon_fun usage_msg
let usage     () = Arg.usage specs usage_msg






(** Read KM3 metamodel from a file *)
let loadKM3
	(filename: string)
	: MsoTcSchema.internal_schema
=
	MsoTcSchema.load_schema_from_file filename


(** Read UnQL/UnCAL file in non-normalized and normalized form *)
let loadUnQLorUnCAL
	(filename: string)
	: ('a UnCAL.aexpr * 'a UnCAL.aexpr)
=
	let loadUnQL   = Parse.parse_file ~parse:ParseUnQL.entry  ~lex:LexUnQL.token
	and loadUnCAL  = Parse.parse_file ~parse:ParseUnCAL.entry ~lex:LexUnCAL.token
	and q2c      e = map_info (fun _ -> {UnCAL.annot=None}) (UnQL2unCAL.unQL2unCAL e)
	and q2c_norm e = 
		let e1 = DesugarUnQL.desugar_letrec e in
		let e2 = UnQL2unCAL.flatten e1 in
		let e3 = match e2.UnQL.action with
			| `query (_,t) -> UnQL2unCAL.qlx2cal [] t
			| _            -> failwith "unQL2unCAL: fatal error" in
		map_info (fun _ -> {UnCAL.annot=None}) e3
	and c_norm e = e (* If further normalization is needed, like: UnCALcase.lift_conditional_branches.
	                    Current version does not require such. *)
	in
		if Filename.check_suffix filename "unql" then
			let e = loadUnQL filename in
				(q2c e, c_norm (q2c_norm e))
		else
		if Filename.check_suffix filename "uncal" then
			let e = loadUnCAL filename in
				(e, c_norm e)
		else
			failwith "[ERROR] Cannot determine the language: .unql or .uncal file required."







let output_counter_example_dot oc input_graph output_graph uncal_e =
  let fmt = formatter_of_out_channel oc in
  let text_attr text = [ DAttr("shape", "plaintext"); DAttr("label", text) ] in
  let r_title    = DRaw"title"
  and r_input    = DRaw"input"
  and r_produces = DRaw"produces"
  and r_output   = DRaw"output" in
  let s_invis    = DAttr("style","invis") in
  let connext_text_with_root r_text graph =
    SetofInodeR.fold
      (fun (_,v) stmt_list -> DEdge(r_text,[s_invis],DVtx v) :: stmt_list) graph.i [] in
  let dot = {
    graph_id = "chkuncal_counter_example";
    stmt_list = [
      DAGraph[ DAttr("center","true");
               DAttr("size","7.5, 10.5")];
      DANode[ DAttr("shape","point");
              DAttr("fontname","Courier")];
      DAEdge[ DAttr("arrowhead","open");
              DAttr("fontname","Courier")];
      DNode(r_title, text_attr "Chkuncal: a counter-example");
      DNode(r_input, text_attr "A valid input tree");
      DNode(r_produces, text_attr "produces");
      DNode(r_output, text_attr "an invalid output tree.");
      DEdge(r_title, [ s_invis ], r_input);
      DEdge(r_title, [ s_invis ], r_produces);
      DEdge(r_title, [ s_invis ], r_output);
      DGroup([ DAttr("rank","same") ],
             [ DEdge(r_input,[ s_invis ],r_produces);
               DEdge(r_produces,[ s_invis ],r_output) ]);
    ] @ connext_text_with_root r_input input_graph
      @ connext_text_with_root r_output output_graph
      @ (Dotutil.g2dot input_graph).stmt_list
      @ (Dotutil.g2dot output_graph).stmt_list
  } in
  PrintDot.pp_dot ~is_uncal:false ~shape:`point fmt dot

let invokeMona uncal_e monafilename =
  (* ignore (Unix.system ("mona " ^ Filename.quote monafilename)) *)
  let mona_out = 
    Parse.parse_command_out ("mona -q " ^ Filename.quote monafilename)
      ~parse:ParseMonaOut.entry ~lex:LexMonaOut.token in
  if mona_out.is_valid then
    (eprintf "Success!@."; 0)
  else (begin
    eprintf "Failure!@.";
    match mona_out.cnt_example with
      | None -> eprintf "No counter-example found.@."
      | Some ce ->
          let cet = try List.assoc "<univ>" ce.univ
          with Not_found -> failwith "fatal error: unsupported mona output." in
          let input_uncal = bt2uncal mona_out.free_vars cet in
	  let epr ?pp_a e = eprintf "For a valid input@.  @[%a,@]@." (PrintUnCAL.ppr_aexpr ?pp_a) e in 
		  epr (bt2uncal mona_out.free_vars cet);
          let input_graph = remove_eps(load_db (map_info (fun _ -> None) input_uncal)) in
          let output_graph = remove_eps(eval_unCAL input_graph uncal_e) in
	  let epr ?pp_a e = eprintf "the UnCAL program will produce an invalid output@.  @[%a.@]@."
            (PrintUnCAL.ppr_aexpr ?pp_a) e in
	  epr (g2uncalT output_graph);
          if !g_file <> "" then
            let oc, close =
              if !g_file = "-" then stdout, ignore else open_out !g_file, close_out in
            output_counter_example_dot oc input_graph output_graph uncal_e;
            close oc
  end; 1)









let progress s =
	if not !q_mode then (prerr_string s; flush stderr)

let _ = try
	parseArgv     ();
	print_version ();
	c_mode := !c_mode || (!o_file = "-"); (* stdout-mode is compilation only *)
	match !anons with
	| [ikm3_file; tran_file; okm3_file] ->
		(* prepare inputs *)
		progress "...Loading Schema and UnCAL files...\n";
		MsoTcSchema.global_config_paths := !paths;
		let iKm3             = loadKM3         ikm3_file in
		let (tUcl_orig,tUcl) = loadUnQLorUnCAL (FileUtil.find_file !paths tran_file) in
		let oKm3             = loadKM3         okm3_file in
		let fpa ?pp_a e      = fprintf (formatter_of_out_channel stderr)
		                "%a@." (PrintUnCAL.ppr_aexpr ?pp_a) e in
		(if !p_mode then fpa tUcl; flush stderr);

		(* prepare the output *)
		let outname =
			if !o_file="" then (Filename.chop_extension tran_file)^".mona"
			              else !o_file
		in
		let outchan, outclose =
			if !o_file = "-"
		      then (stdout, fun ()->())
			  else let oc = open_out outname in (oc, fun ()->close_out oc)
		in

		(* generate MSO *)
		begin try
			Format.set_margin 120;
			progress "...Converting UnCAL to MSO...\n";
			let mso = MsoFromUnCAL.generate_type_validity_formula iKm3 tUcl oKm3 progress in
			progress "...Dumping MSO to tmp file...\n";
			PrintMona.msoprogram_to_channel (fun ppf -> Format.fprintf ppf "%s") outchan mso;
			outclose ()
		with
			e -> outclose (); raise e
		end;
	
		(* pass to MONA *)
		if not !c_mode then begin
			progress "...Validation process is running (may take time)...\n";
			exit (invokeMona (map_info (fun _ -> None) tUcl_orig) outname)
		end
	| _ ->
		usage ();
		exit (-1)
with Failure msg ->
	progress (sprintf "Error: %s\n" msg);
	exit (-2)
