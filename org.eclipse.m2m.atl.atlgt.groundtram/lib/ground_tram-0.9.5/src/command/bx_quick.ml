(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
(*************************************************************
 * A cheap and quick way to reflect view updates
 * based on analysis of tracing information.
 * We assume that insertion does not happen together
 * with other updates such as inplace update and deletion.
 * Note that backward transformation here may be unsafe
 * in the sense that some unpermitted view updates may
 * be reflected to the source. However, for the permitted
 * view updates, they can be correctly reflected to the 
 * source.
 *************************************************************)

open Fputil
open Format
open EvalUnCAL
open UnCALdynenv
open UnCALDM
open UnCALDMutil
open Dotutil
open PrintDot
open UnCAL
open Version
open Km3
open Km3util
open Contraction
open TestUnCALutil
open UnCALSA
open PrintUnCAL 
open PrintUnCALDM 

let parseUnCAL_file   = (map_info (fun _ -> None)) @@ parseUnCAL_file
let parseKm3_file = Parse.parse_file ~parse:ParseKm3.entry ~lex:LexKm3.token 
let (~~) filename = "/Users/hu/top/work/workInProgress/bidirectionalTransformation/tree/c2o_quick/"^filename

(** usages *)

(**
  
  1. Foward execution
   
     {v % bx_quick -f -uq q.unql -idot db.dot -odot output.dot \
          [-ikm3_file db.km3 -km3_pkg name1 -okm3_file output.km3 -okm3_pkg name2] v}

  2. Backward execution

     {v % bx_quick -b -uq q.unql -idot db.dot -odot output.dot -uidot udb.dot -uodot uoutput.dot \
          [-tdot_file template.doc -ikm3_file db.km3 -km3_pkg name1 -okm3_file output.km3 -okm3_pkg name2] v}
   
     Perform update reflection (updated source is saved in udb.dot). Updated source is displayed.
     If view side-effect is detected, it is also displayed.

  ** You can find the detailed usage in ~/examples/c2o_quick/README.txt

*)

type config = {
  mutable fwd          : bool;        (** forward transformation *)
  mutable bwd          : bool;        (** backward transformation *)
  mutable prt_uncal    : bool;        (** turn on printing source UnCAL expression *)
  mutable uq1pass      : bool;        (** one pass optimization of UnQL (experimental) *)
  mutable no_display   : bool;        (** do not display graph difference *)
  mutable idot_file    : string;      (** input DOT db file *)
  mutable uq_file      : string;      (** input UnQL query file *)
  mutable odot_file    : string;      (** output in dot format for user editing *)
  mutable tdot_file    : string;      (** input template DOT file *)
  mutable uidot_file   : string;      (** updated DOT db file *)
  mutable uodot_file   : string;      (** updated DOT view file *)
  mutable ikm3_file    : string;      (** km3 file for input  validatin *)
  mutable okm3_file    : string;      (** km3 file for output validatin *)
  mutable ikm3_pkg     : string;      (** km3 package for input  validatin *)
  mutable okm3_pkg     : string;      (** km3 package for output validatin *)
}

(* for insertion testing *)
let cf = {
  fwd        = true;
  bwd        = false;
  uq1pass    = false;
  prt_uncal  = false;
  no_display = false;
  idot_file  = "";
  uq_file    = "";
  odot_file  = "";
  tdot_file  = "";
  uidot_file = "udb.dot";
  uodot_file = "uout.dot";
  ikm3_file  = "";
  okm3_file  = "";
  ikm3_pkg   = "";
  okm3_pkg   = "";
}

let speclist =
  let cf = cf in
  Arg.align
    [
      ("-f",   Arg.Unit  (fun()->cf.fwd <-true),         " forward transformation (default)");
      ("-b",   Arg.Unit  (fun()->cf.bwd <-true),         " backward transformation");
      ("-u1p", Arg.Unit  (fun()->cf.uq1pass <-true),     " one pass optimization of UnQL (experimental)");
      ("-pa",  Arg.Unit  (fun()->cf.prt_uncal<-true),    " print internal UnCAL expression (for demonstration)");
      ("-nd",  Arg.Unit  (fun()->cf.no_display <-true),  " do not display graph difference");
      ("-idot", Arg.String (fun s->cf.idot_file<-s),     " source db file (in DOT)"); 
      ("-uq",   Arg.String (fun s->cf.uq_file<-s),       " source UnQL file");
      ("-odot", Arg.String (fun s->cf.odot_file<-s),     " target DOT file for editing and backward input");
      ("-tdot", Arg.String (fun s->cf.tdot_file<-s),     " template input dot file");
      ("-uidot",Arg.String (fun s->cf.uidot_file<-s),    " updated DOT db file ");
      ("-uodot",Arg.String (fun s->cf.uodot_file<-s),    " updated DOT view file ");
      ("-ikm3",   Arg.String (fun s->cf.ikm3_file<-s),   " input validation KM3 file ");
      ("-okm3",   Arg.String (fun s->cf.okm3_file<-s),   " output validation KM3 file ");
      ("-ip",  Arg.String (fun s->cf.ikm3_pkg <-s),      " input validation package");
      ("-op", Arg.String  (fun s->cf.okm3_pkg <-s),      " output validation package");
   ]

let speclist = add_version_spec speclist

let usage_msg = "Usage: "
  ^Sys.executable_name^ " [-f | -b] -uq query.unql -idot db.dot -odot output.dot "^
        "[ -uidot udb.dot -uodot uoutput.dot -ikm3 db.km3 -ip ipackage -okm3 output.km3 -tdot tempalte.dot ]"

let read_args () = 
  Arg.parse speclist (fun s -> ()) usage_msg; cf

let failwith_msg msg =
  fprintf err_formatter "%s@." msg;
  Arg.usage speclist usage_msg; exit 1

(* copied from bwdD_uncal.ml *)
let get_gEdit_expander ge_flag su_flag lskolem_flag g =
  let sb_flag = true (* don't care *) in
  let sa_flag = true (* don't care *) in
  let ei = make_editinfo ge_flag su_flag g sb_flag
      !escapeApnd !cycleSemanticsOriginal sa_flag in
  let get_flatIdG_expander g =
    if lskolem_flag then (g,id) else
    let (newG,mapV,_) = clean_id_aux g in
    let invm = MapofVtx.invert mapV in
    let lookupMap v = try (MapofVtx.find v invm) with
                      Not_found -> 
			let _ = print_endline ("Node "^ vtx2str v^" was inserted.") in 
			v in
    (newG, map_VEIO lookupMap) in
  let (gEdit, skolem_expand) = get_flatIdG_expander ei.g_edit in
  let expand newG' =
    let g_edit' = skolem_expand newG' in  (* unflatten node IDs *)
    let g_show' = if ei.glue_eps
    then merge_viewmaps ei.g_edit g_edit' ei.g_show ei.vm (* expand epsilons *)
    else g_edit' in
    let g' = if ei.show_unreachable then g_show' else begin
      let g_unreachable = evalg_simple_diff g ei.g_show in
      evalg_simple_union g_show' g_unreachable end in (g',g_edit') in
  (ei.g_edit,gEdit,expand)

exception Trace of string

(* Find possible (not necessary to be exact) corresponding edges 
 * from the tracing information. *)
let rec possible_corr ((u,l,v) as edg:edge) = 
  let rec pcr v = match v with 
      | FrE(v1,(u2,l2,v2),p) -> 
	if l=l2 then possible_corr (u2,l2,v2)
	else pcr v1
      | _ -> raise (Trace "no traversal on the edge") in
  let (u1,l1,v1) = try corr edg with Trace _ -> pcr v in 
  if l=l1 then (u1,l1,v1) else pcr v

(* Calculate deleted edges and inserted edges (caused by modification).
 * We assume that gNew does not contain new nodes. *)
let g_diff_o2i (gOri:graph) (gNew:graph) = 
  let gDel = evalg_simple_diff gOri gNew in
  let gAdd = evalg_simple_diff gNew gOri in 
  let (deleEs,addEs) = SetofEdge.fold
    (fun e (dEs, aEs) -> 
      let (u,l,v) = e in 
      let (su,sl,sv) = try possible_corr e with 
	  _ -> failwith ("Bwd: eEdge "^ allit2str l ^ " should not be deleted or modified\n.") in
      let es = SetofEdge.filter (fun (u',_,v') -> u=u' && v=v') gAdd.e in
      if SetofEdge.is_empty es then (SetofEdge.add (su,sl,sv) dEs, aEs)
      else let (_,sl',_) = SetofEdge.choose es in 
	   (SetofEdge.add (su,sl,sv) dEs,SetofEdge.add (su,sl',sv) aEs))
    gDel.e (SetofEdge.empty, SetofEdge.empty)  in
  (deleEs,addEs)

(* return the root of a graph *)
let get_root g = 
  let root =
    try lookupI g "&" with
      Not_found -> failwith "reachableG: no root marker"
    | e         -> raise e in
  root

let print_known_vtx_classifier = fprintf std_formatter "%a@." pp_known_vtx_classifier
let known_vtx_classifier_to_string arg = fprintf str_formatter "%a" pp_known_vtx_classifier arg;flush_str_formatter ()

(* This definition is copied from unqlplus.ml *)
let validate_and_print (prefix:string) (prt_time:bool) (g:graph) (pname:name) (mm:metamodel) : unit =
  begin 
    print_endline ("********* begin " ^ prefix ^ " message *************");
    let msg =
      try ("Validation succeeded.\n" ^ (known_vtx_classifier_to_string 
					  (let lcls = (lazy (validate g pname mm)) in
					  if prt_time 
					  then print_time ~prefix:prefix lcls
					  else Lazy.force lcls)
				       ))
      with 
	e -> ("Validation failed.\n" ^ (Printexc.to_string e)) in
    print_endline msg;
    print_endline ("********** end " ^ prefix ^ " message **************")
  end

(* check if the only edge in es (|es|=1) is a lable *)
let has_insertion_label es =
  match SetofEdge.choose es with
    | (_, ALLbl l, _) -> if String.get l 0 = '_' then true else false
    | _ -> false

(* Insert a subgraph obtained from
 *      select $d where {_*.l1.l2: $d } in template
 * to db so that the subgraph is pointed through an edge l2 from node v1 *)
let ins_src l1 v1 l2 template db =
  let uq = "select $d where {_*." ^l1^ "." ^l2^ ": $d} in $db" in
  let ce = ((map_info (fun _ -> None)) @@ unql2uncal @@ parseUnQL_string) uq in 
  let maxid = SetofVtx.cardinal db.v in 
  let _ = GenId.set maxid  in
  let dynenv = (intern_gv "$db" template emptyDynEnv) in
  let _ = evalRecRecursive    := true in
  let _ = skolemRec           := false in 
  let incBid v = match v with
    | Bid n -> Bid (n+maxid)
    | _ -> failwith "node in the source should be of the form of Bid n." in 
  let gAdd = map_VEIO incBid (clean_id (reachableGI (remove_eps (eval_with_env dynenv ce)))) in 
  let db' = { v = SetofVtx.union db.v gAdd.v;
	      e = SetofEdge.add (v1,ALLbl l2,get_root gAdd) (SetofEdge.union db.e gAdd.e);
	      i = db.i;
	      o = db.o
	    } in
  db'
     
(* forward computation *)
let fwd () =
    (* load and validate the input graph *)
    let _ = print_endline ("Loading DB from " ^ cf.idot_file ^ " ...") in 
    let db = loadDot_file ~set_GenId:true ~descend_maxid:true cf.idot_file in
    let _ = if cf.ikm3_file <> "" then
	let input_km3 = parseKm3_file cf.ikm3_file in 
	let _ = print_endline ("Validating DB against the schema defined in " ^cf.ikm3_file) in
	validate_and_print "Input validation" true db cf.ikm3_pkg input_km3 in

    (* generate the view from the input graph by forward transformation *)
    let _ = print_endline ("Loading transformation code from " ^cf.uq_file ^ " ...") in
    let dynenv = (intern_gv "$db" db emptyDynEnv) in
    let _ = GenId.reset ()  in
    let rw_unql = if cf.uq1pass then DesugarUnQL.one_pass_expr else id in
    let ce = try (((map_info (fun _ -> None)) @@ unql2uncal @@ rw_unql @@ parseUnQL_file) cf.uq_file)
      with e -> catch_UnQL_exn e in
    let _ = if cf.prt_uncal 
      then
	begin 
	  print_endline "(************** begin Executed UnCAL expr. ****************)";
	  print_aexpr ce;
	  print_endline "(**************  end  Executed UnCAL expr. ****************)"
	end in
    let idState = GenId.current () in
    let _ = evalRecRecursive    := true in
    let _ = skolemRec           := true in 
    let _ = optApndRecRecursive := true in
    let _ = optApndStat         := true in (* no effect  unless -rw is on *)
    let _ = escapeApnd          := true in
    let _ = optTCRec            := true in
    let _ = useTransNodeId      := true in
    let view = eval_with_env dynenv ce in
    (ce,db,view,idState)

(******************)
(* main procedure *)
(******************)
let _ = 
  let cf = read_args () in
  let _ = print_version () in

  (* check arguments *)
  if cf.idot_file = "" then failwith_msg "Source db file unspecified."
  else if (cf.uq_file = "")
  then failwith_msg "Transformation file unspecified."
  else if cf.odot_file = "" then failwith_msg "Result dot file unspecified."
  else if not cf.bwd then 

  (* forward transformation *)
    let (ce,db,g,idState) = fwd () in 
    let dot_g = g2dot (clean_id (reachableGI (remove_eps g))) in 
    begin
      print_endline ("Saving the forward computation result to "^cf.odot_file^ " ...");
      dumpDot ~prefix_n:false dot_g cf.odot_file;
    end

  else
    (* backward transformation *)
    let (ce,db,g,idState) = fwd () in 
    let is_windows () = Sys.os_type="Win32" || Sys.os_type = "Cygwin" in 
    let get_diffname n = (Filename.chop_extension n) ^ "_diff." ^ (get_suffix n) in

    (* calculate the correspondence between graphs with and without tracing information *)
    let get_gEdit_expander = get_gEdit_expander true false false in
    let (srG,newG,expand) = get_gEdit_expander g in
    (* let dot = g2dot ~gray_unreachable:true ~cmp_eps:true newG in *)

    (* load and validate an updated view *)
    let _ = print_endline ("Loading an updated view from " ^ cf.odot_file ^ " ...") in
    let newG' = loadDot_file cf.odot_file in
    let _ = if cf.okm3_file <> "" then
      let output_km3 = parseKm3_file cf.okm3_file in
      let _ = print_endline ("Validating updated view against the schema defined in " ^cf.okm3_file) in
      validate_and_print "Updated view validation" true newG' cf.okm3_pkg output_km3 in
    let (g',srG') = expand newG' in  (* unflatten node IDs ande xpand eps,unreach *)
    
    (* calculate the updates on the input from those on the output view 
       (we assume that insertion is not mixed with other updates on the view) *)
    let db' = 
      let (deleEs,addEs) = g_diff_o2i g g' in

      if (SetofEdge.cardinal deleEs = 1 && SetofEdge.cardinal addEs = 1 && has_insertion_label addEs) then
	(* reflection of insertion *)
	match (SetofEdge.choose deleEs, SetofEdge.choose addEs) with
	  | ((u1,ALLbl l1,v1), (u2,ALLbl l2,v2)) -> 
	    if u1=u2 && v1=v2 then 
	      let gTemp = loadDot_file cf.tdot_file in
	      ins_src l1 v1 (String.sub l2 1 (String.length l2 - 1)) gTemp db
	    else
	      failwith "This branch will not be executed." 
	  | _ -> failwith "An insertion is incorrectly indicated."

      else 
	(* reflection of inplace modification and deletion *)
	let (deleEs,addEs) = g_diff_o2i g g' in
	let db1 = SetofEdge.fold (flip remove_edge) deleEs db in
	SetofEdge.fold (flip add_edge) addEs db1 in

    (* display the source updates *)
    let _ = 
      if (is_windows () || cf.no_display) then 
	dumpDot ~prefix_n:false (graph_diff db db') (get_diffname cf.idot_file)
      else 
	begin 
	  dumpDot ~prefix_n:false (g2dot db') cf.uidot_file;
	  dispD_gc (graph_diff db db') 
	end in
	
    (* compute and save an updated view from the updated input *)
    let g'' = 
      let dynenv' = (intern_gv "$db" db' emptyDynEnv) in
      let ()  = GenId.set (idState) in 
      (eval_with_env dynenv' ce) in
    let (srG'',newG'',expand') = get_gEdit_expander g'' in
    let _ = print_endline ("Saving updated source to the file "^cf.uidot_file) in
    let _ = g2dot_file ~shape:`ellipse ~gray_unreachable:true ~ops:[ALLbl"src_of"] db' cf.uidot_file in 
    let _ = print_endline ("Saving updated view to the file "^cf.uodot_file) in
    let _ = g2dot_file ~shape:`ellipse ~gray_unreachable:true ~ops:[ALLbl"src_of"] 
      (clean_id (reachableGI (remove_eps g''))) cf.uodot_file in 

    (* check the putget property *)
    if bisimilar_opt srG' srG'' then 
      begin
	fprintf std_formatter "%s@." "Deletion/updates succeeded.";
	exit 0; (* return status code of scucess *)
      end
    else
      begin 
	fprintf err_formatter "%s@." "Side effect detected.";
	let (diff_srG,gAdd_v,gDel_v,eSadd,eSdel,eSmod,_) = graph_diff_aux srG' srG'' in
	let d' = 
	  let (diff_newG,diff_mapV,_) = clean_id_aux diff_srG in
	  let f v = try (MapofVtx.find v diff_mapV) with
	      Not_found -> failwith "lookupMap: Flat ID not found" in
	  gdiff2dot
	    (diff_newG,
	     SetofVtx.map f  gAdd_v,
	     SetofVtx.map f  gDel_v,
	     SetofEdge.map (cross3 (f,id,f)) eSadd,
	     SetofEdge.map (cross3 (f,id,f)) eSdel,
	     SetofEdge.map (cross3 (f,id,f)) eSmod)
        in 
	if (is_windows () || cf.no_display) then dumpDot ~prefix_n:false d' (get_diffname cf.odot_file) else dispD_gc d';
	exit 1; (* return status code of failure *)
      end

