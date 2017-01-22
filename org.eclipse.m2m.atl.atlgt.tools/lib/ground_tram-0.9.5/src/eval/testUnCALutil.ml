(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
open UnCAL
open ParseUnCAL
open LexUnCAL
open UnCALDM
open PrintUnCALDM
open UnCALDMutil
open EvalUnCAL
open UnCALdynenv
open UnCALenv
open ECenv
open BiEvalUnCAL
open G2viz
open Dotutil
open Dot
open PrintDot
open UnQL
open ParseUnQL
open LexUnQL
open UnCALSAST
open UnCALSA
open UnCALMAST
open Parse
open UnQL2unCAL
open Format
open PrintUnQL
open PrintUnCAL
open Fputil

(************************* BEGIN basic definitions *******************************)
let parseUnQL_file = Parse.parse_file ~parse:ParseUnQL.entry ~lex:LexUnQL.token 
let (~~) filename = "../examples/"^filename
let parseUnQL_string =
                   Parse.parse_string ~parse:ParseUnQL.entry ~lex:LexUnQL.token 
let readq_e = parseUnQL_string

let print_graph = fprintf std_formatter "%a@." pr_graph
(* #install_printer pr_graph;; *)
(* print_aexpr moved to printUnCAL.ml *)
(* #install_printer ppr_aexpr;; *)
let print_template = fprintf std_formatter "%a@." pp_template
(* #install_printer pp_template;; *)

let _ = set_margin 100     (* defer folding of standard formatter (default is 78) *) 
let _ = set_max_indent 100 (* default is 68 *)

let e2qt (e:'a UnQL.expr) = 
  match e.action with
    | `query (_,t) -> t
    | _ -> failwith "not query in e2qt"

(* since exception can't be polymorphic, UnQL.expr annotation is 
   tentatively stripped before being passed to the argument of exception *)
exception UnQL_expr of (unit UnQL.expr) * string * exn
exception UnQL_template of (unit UnQL.template) * string * exn

let strip_annot_expr     e = WalkUnQL.mpifo_expr     (fun _ -> ()) e
let strip_annot_template t = WalkUnQL.mpifo_template (fun _ -> ()) t

let unQL_expr_try name f x =
  try f x with exn -> raise(UnQL_expr(strip_annot_expr x,name,exn))
let unQL_template_try name f x =
  try f x with exn -> raise(UnQL_template(strip_annot_template x,name,exn))

(* catch and print UnQL_expr and UnQL_template exceptions *)
let catch_UnQL_exn (e:exn) = 
  let ss = function (* explain function by name *)
      "desugar" -> "desugaring actions to sfun"
    | "flatten" -> "flattening (removing letrec)"
    | "e2qt"    -> "extracting template from expression"
    | "qlx2cal" -> "UnCAL code generation" 
    | ""        -> "" 
    | s         -> "stage" ^ s in
  match e with
  UnQL_template(x,name,exn) -> (
    fprintf err_formatter "While %s for template@.%a@." (ss name) PrintUnQL.pp_template x;
    fprintf err_formatter "%s@." (Printexc.to_string exn); exit 1)
| UnQL_expr(x,name,exn) -> (
    fprintf err_formatter "While %s for expression@.%a@." (ss name) PrintUnQL.pp_expr x;
    fprintf err_formatter "%s@." (Printexc.to_string exn); exit 1)
| e -> raise e

let unql_g2g (file:string) (db:graph) =
  let q = parseUnQL_file file in
  let dq = DesugarUnQL.desugar q in
  let fq = UnQL2unCAL.flatten dq in
  let cq = UnQL2unCAL.qlx2cal [] (e2qt fq) in
  let cq = map_info (fun _ -> None) cq in
  (* let _  = print_aexpr cq in *)(* for debug *)
  reachableGI (remove_eps (eval_unCAL db cq))


let unqlrw_g2g (file:string) (db:graph) =  (* rewriting version *)
  let q = parseUnQL_file file in
  let dq = DesugarUnQL.desugar q in
  let fq = UnQL2unCAL.flatten dq in
  let cq = UnQL2unCAL.qlx2cal [] (e2qt fq) in
  let cq = map_info (fun _ -> None) cq in
  (* let _  = print_aexpr cq in *) (* for debug *)
  let stEnv = make_defaultEnv db in
  let rcq = rewriteE stEnv cq in
  reachableGI (remove_eps (eval_unCAL db rcq))
    
let parseUnCAL_file = Parse.parse_file ~parse:ParseUnCAL.entry ~lex:LexUnCAL.token 
(* let parseUnCAL_file = Parse.parse_file ~parse:PUnCAL.entry ~lex:LUnCAL.token  *)
let parseUnCAL_string = Parse.parse_string ~parse:ParseUnCAL.entry ~lex:LexUnCAL.token 
(* let parseUnCAL_string = Parse.parse_string ~parse:PUnCAL.entry ~lex:LUnCAL.token *)
let read_e = parseUnCAL_string

let display_g (g:graph) (file:string) =
  let _ = g2dot_file_light g file in
  let com = "dot -Teps -O " ^ file in
  let status = Sys.command com in 
  if status <> 0 then print_string ("command " ^ com ^ " failed.");
  let com = "ghostview " ^ file ^ ".eps &" in
  let status = Sys.command com in 
  if status <> 0 then print_string ("command " ^ com ^ " failed.")

let dispG g = 
  let dot_file = Filename.temp_file "dispG" ".dot" in
  display_g (reachableGI (remove_eps g)) dot_file

(* Non-blocking invocation of command. file tmpfile (assumed to be
  a temporary file) is removed. *)
let fork_rmtmp (tmpfile:string) (com:string) : unit =
  if (0 = (Unix.fork ()))
  then
    let status = Sys.command com in
    if status <> 0 then print_string ("command " ^ com ^ " failed.") else
    Sys.remove tmpfile;
    exit 0

(* for Win *)
let fork_rmtmp_win (tmpfile:string) (com:string) : unit =
  let split_commandline commandline = 
    let len = String.length commandline in
    let n = String.index commandline ' ' in
    (String.sub commandline 0 n,String.sub commandline (n+1) (len - n -1)) in
  let (com,arg) = split_commandline com in
  Format.printf "%s@." ("Starting command " ^ com ^ " " ^ arg ^ "\n");
  try 
    (if (0 = Unix.create_process com [|com;arg|] Unix.stdin Unix.stdout Unix.stderr)
    then
      let status = Sys.command com in
      if status <> 0 then print_string ("command " ^ com ^ " failed.") else
      let _ = Format.printf "Removing tmpfile: %s@." tmpfile in
      Sys.remove tmpfile;
      exit 0)
  with Unix.Unix_error(en,cmd,arg) -> 
    print_string ("Error: " ^ (Unix.error_message en) ^ " Function:" ^ cmd ^ " Arg:" ^ arg  ^ "\n")

let fork_rmtmp = 
  if Sys.os_type="Win32" || Sys.os_type = "Cygwin" then fork_rmtmp_win else fork_rmtmp


(* Non-blocking invocation of graph viewer. temporary files are removed. *)
let dispG_gc ?(is_raw = false) g =
  let g = if is_raw then g else reachableGI (remove_eps g) in
  let dot_file = Filename.temp_file "dispG" ".dot" in
  let _ = g2dot_file_light ~noclean:is_raw g dot_file in
  let eps_file = dot_file ^ ".eps" in
  let com = "dot -Teps " ^ dot_file ^ " -o " ^ eps_file in
  let status = Sys.command com in
  let _ = Sys.remove dot_file in
  if status <> 0 then print_string ("command " ^ com ^ " failed.") 
  else 
    let com = "ghostview " ^ eps_file in
    fork_rmtmp eps_file com


let dotty_prog = ref "dotty"

let dispD_gc ?shape ?prefix_n ?expnl (dot:dot) = 
  (* Format.printf "dispD_gc@."; *)
  let dot_file = gtm_temp_file "display_cg" ".dot" in
  (* let _ = Format.printf "dot_file=%s@." dot_file in *)
  let com = !dotty_prog ^ " " ^ dot_file in
  let _ = dumpDot ?shape ?prefix_n ?expnl dot dot_file in
  fork_rmtmp dot_file com


let unql2uncal ?(print_interm=false) ?(desugar_letrec=false) q =
  let ds = if desugar_letrec then DesugarUnQL.desugar_letrec else DesugarUnQL.desugar_i in
  let dq = unQL_expr_try "desugar" ds q in
  let fq = unQL_expr_try "flatten" UnQL2unCAL.flatten dq in
  let qt = unQL_expr_try "e2qt" e2qt fq in
  let cq = unQL_template_try "qlx2cal" (UnQL2unCAL.qlx2cal []) qt in
  let _ = if print_interm then 
    begin
      print_endline "after desugar_i:"; print_expr dq;
      print_endline "after flatten:";   print_expr fq;
      print_endline "after e2qt:";      print_template qt 
    end 
  in cq
  

(* parse and evaluate unql string and return and  display the graph *)
let evalq_e_db (db:graph) (unql_str:string) =
  let q = parseUnQL_string unql_str in
  let cq = unql2uncal q in
  let cq = map_info (fun _ -> None) cq in
  (* let _  = print_aexpr cq in *)(* for debug *)
  let dg = fun g -> dispG_gc g; g in
  dg (eval_unCAL db cq)



(* Non-blocking invocation of dotty for view. Temporary files are removed. *)
let display_cg_gc ?gray_unreachable ?ops ?(shape=`ellipse)
  ?cmp_eps ?prefix_n g =
  let dot = g2dot ?gray_unreachable ?ops ?cmp_eps g in
  let dot_file = Filename.temp_file "display_cg" ".dot" in
  let com = !dotty_prog ^ " " ^ dot_file in
  let _ = dumpDot ~shape ?prefix_n dot dot_file in
  fork_rmtmp dot_file com


let ((eval_e_db,eval_e),(evalrw_e_db,evalrw_e)) =
  let re = (map_info (fun _ -> None)) @@ read_e in
  let rw = UnCALSA.rewriteE in
  let dg = fun g -> dispG_gc g; g in
  ((fun db str -> dg (EvalUnCAL.eval_unCAL db       (re str))),
   (fun    str -> dg (EvalUnCAL.load_db             (re str)))),
  ((fun db str -> 
    let e' = rw (make_defaultEnv db) (re str) in
    print_aexpr e';
    dg (EvalUnCAL.eval_unCAL db e')),
   (fun    str -> 
     let e' = rw emptyEnv            (re str) in
     print_aexpr e';
     dg (EvalUnCAL.load_db e')))
(* UnCAL "type" = set of input and output markers *)
let print_type = fprintf std_formatter "%a@." pr_vtype
let print_fvars (sL,sV) = fprintf std_formatter "(%a,%a)@." pr_SetofLname sL pr_SetofVname sV
let print_vtxs = fprintf std_formatter "%a@." pr_SetofVtx

open Parse
open Dot
open LexDot

let parseDot_string =
  Parse.parse_string ~parse:ParseDot.entry ~lex:LexDot.token 
let parseDot_file = Parse.parse_file ~parse:ParseDot.entry ~lex:LexDot.token 

(* parsing skolem term for isertion template generation using parseDot  *)
let parseVtx_string (s:string) : vtx = 
  let ds = "digraph \"g\" { \"" ^ s ^ "\" [ label = \"\\N\" ] }" in
  let dot = parseDot_string ds in
  match dot with
      { Dot.graph_id = "g";
        Dot.stmt_list =
          [Dot.DNode(DVtx vtx, _)]} -> vtx
    | _ -> failwith "parseVtx_string: failed in extracting vtx"

let parseEdg_string (s:string) : edge = 
  let ds = "digraph \"g\" { \"FrE(3," ^ s ^ ",0)\" [ label = \"\\N\" ] }" in
  let dot = parseDot_string ds in
  match dot with
    {Dot.graph_id = "g";
     Dot.stmt_list =
     [Dot.DNode(DVtx(FrE(_,edg,_)), _)]} -> edg
  | _ -> failwith "parseEdg_string: failed in extracting edg"

let parseLabel_string (s:string) : allit = 
  let ds = "digraph \"g\" { \"FrE(3,(1, " ^ s ^ " ,2),0)\" [ label = \"\\N\" ] }" in
  let dot = parseDot_string ds in
  match dot with
    {Dot.graph_id = "g";
     Dot.stmt_list =
     [Dot.DNode (DVtx(FrE (_, (_,label,_), _)), _)]} -> label
  | _ -> failwith "parseLabel_string: failed in extracting label"

(* Use UnCAL AST instead to rely on simpler syntax for string literal *)
let parseLabel_string (s:string) : allit = 
  let cs = "{" ^ s ^ ":{}}" in
  let ce = parseUnCAL_string cs in 
  match ce with
    AEEdg (_,(ALLit (_,label)),_) -> label
  | _ -> failwith "parseLabel_string: failed in extracting label"
  

let dispCg_gc (d:dot) =
  let dot_file = Filename.temp_file "dispCg" ".dot" in
  let _ = dumpDot d  dot_file in
  let eps_file = dot_file ^ ".eps" in
  let com = "dot -Teps " ^ dot_file ^ " -o " ^ eps_file in
  let status = Sys.command com in
  let _ = Sys.remove dot_file in
  if status <> 0 then print_string ("command " ^ com ^ " failed.")
  else 
    let com = "ghostview " ^ eps_file in
    fork_rmtmp eps_file com

type editinfo = {
      glue_eps:bool;
      g_edit:graph; 
      show_unreachable:bool;
      g_show:graph;
      cln_id: bool;
      vm:viewmaps;
      sbulk: bool;
      eapnd: bool;
      cycorig: bool;
      saunrch: bool;
}


module SetofEdge2MapofEdgeMHom=SetofEdge.MHom(MapofEdge)

let make_editinfo ?(cln_id=false) ?start_id (glue_eps:bool) (show_unreachable:bool) (g:graph) (sb:bool)
    (ea:bool) (co:bool) (sau:bool) : editinfo =
  let glue_eps = (glue_eps && (not show_unreachable)) in
  let g_show = if show_unreachable then g else reachableGI g in
  let (glue_eps,g_edit,vm) =
    if glue_eps then
      let (ge,vm) = (viewmaps_remove_eps_ec @@ viewmaps_glue_safe_eps) g_show in
      if check_multiedge ge && false then
	(fprintf err_formatter "%s@. %s@."
	   "Multiple edges detected for identical pair of nodes."
	   "Falling back to (glue_eps = false)."; (false,g_show,empty_viewmaps))
      else (true,ge,vm)
    else (false,g_show,empty_viewmaps) in
  (* cleaning id *)
  if cln_id then begin
    let (g_edit_flat,flatten,end_id) =  clean_id_aux ?start_id g_edit in
    let flatten_v v = MapofVtx.find v flatten in
    let unflatten = MapofVtx.invert flatten in (* unflatten : flat ID to structure ID mapping *)
    let edge_unflatten = (* edge version of unflatten *)
      SetofEdge2MapofEdgeMHom.map_kv (cross3 (flatten_v,id,flatten_v)) id g_edit.e in
    let vm = if glue_eps then vm else init_viewmaps g_edit in
    let vm' = { mapV  = MapofVtx.compose       unflatten vm.mapV;
		mapE  = MapofEdge.compose edge_unflatten vm.mapE; } in
    { glue_eps =glue_eps; g_edit=g_edit_flat; show_unreachable=show_unreachable; cln_id=cln_id;
      g_show=g_show; vm = vm'; sbulk = sb; eapnd = ea; cycorig = co; saunrch = sau; }  end 
  else
  { glue_eps =glue_eps; g_edit=g_edit; show_unreachable=show_unreachable; cln_id = cln_id;
    g_show=g_show; vm = vm; sbulk = sb; eapnd = ea; cycorig = co; saunrch = sau; }

(* editinfo2file *)
let edinfo2file (e:editinfo) (file:string) : unit = 
  let oc = open_out_bin file  in
  Marshal.to_channel oc e [];
  close_out oc
(* file to editinfo *)
let file2edinfo (file:string) : editinfo = 
  let is = open_in_bin file in
  let  d = (Marshal.from_channel is : editinfo) in
  close_in is;
  d


let edit_g ?(show_unreachable = true) ?gray_unreachable ?shape ?ops ?cmp_eps 
    ?(glue_eps = false) ?(cln_id=false) (g:graph) : graph =
  let ei  = make_editinfo ~cln_id:cln_id glue_eps show_unreachable g !skolemBulk 
      !escapeApnd !cycleSemanticsOriginal !saUnreach in
  let dot = g2dot ?gray_unreachable ?ops ?cmp_eps ei.g_edit in
  let dot_file = Filename.temp_file "edit_g" ".dot" in
  let _ = dumpDot ?shape dot  dot_file in
  let com = !dotty_prog ^ " " ^ dot_file in
  let status = Sys.command com in
  if status <> 0 then failwith ("command " ^ com ^ " failed.")
  else let dot' = parseDot_file dot_file in
  let g_edit' = dot2g dot' in
  let g_show' = if ei.glue_eps || cln_id then merge_viewmaps ei.g_edit g_edit' ei.g_show ei.vm else g_edit' in
  let g' = if ei.show_unreachable then g_show' else begin
    let g_unreachable = evalg_simple_diff g ei.g_show in
    evalg_simple_union g_show' g_unreachable end in
  Sys.remove dot_file;g'

open Contraction
open ExtSetMap
open UnCALDMpath
(* given epsilon and unreachable part removed graph, present normalized graph
   and let the user edit with dotty, and return the corresponding edpanded graph *)
(*
  contract g to g_edit and save to dot_file.
  if batch and dst is given, usrc is missing
    (* batch forward *), save the g_edit to dst and return original graph g
  else
    (* retrieve the updated view send set to g_edit' *)
    if batch, dst and usrc given,
       (* batch backward *) load the content from dst to g_edit
    else
       bdotty dot_file
       load content of dot_file and set as g_edit'
       if dot_file is updated and dst is given, save g_edit to dst
    do backward transformation with g and g_edit' and get g'
    if -batch or dot_file is updated, then save g' to the modified source usrc.
    return g'
*)

let edit_normg ?(batch=false) ?(dst="") ?(usrc="") (g:graph) : graph  =
  (* contract *)
  let (g_edit,mv,me) = contract_opt_with_map g in
  (* write to dot file *)
  let dot = g2dot g_edit in
  let dot_file = Filename.temp_file "edit_g" ".dot" in
  let _ = dumpDot dot dot_file in
  let get_mtime (file:string) : float = let s:Unix.stats = Unix.stat file in s.Unix.st_mtime  in
  let org_mtime = get_mtime dot_file in
  if batch && dst <> "" && usrc = "" then begin dumpDot ~shape:`ellipse dot dst;g end else
    let dot' =
      if batch && dst <> "" && usrc <> "" then parseDot_file dst
      else 
	(* interactive: updated view taken from tmp. file *)
	(* invoke editor and present to user *)
	let com = !dotty_prog ^ " " ^ dot_file in
	let status = Sys.command com in
	if status <> 0 then failwith ("command " ^ com ^ " failed.") else
	parseDot_file dot_file  in
    let upd_mtime = get_mtime dot_file in
    let is_view_updated = (upd_mtime > org_mtime) in
    (* if is_view_updated then printf "timestamp updated for %s@." dot_file;  *)
    if is_view_updated && dst <> "" then dumpDot ~shape:`ellipse dot' dst;
    let g_edit' = dot2g dot' in
    (* expand the graph according to contraction map *)
    let (g_dummy,gAdd_v,gDel_v,eSadd,eSdel,eSmod,eSmod_alist) = graph_diff_aux g_edit g_edit' in
    (* checking ID *)
    if (not (SetofVtx.is_empty (SetofVtx.inter g.v gAdd_v))) then failwith "Added node conflicts with noncontracted node" 
    else (* apply addition *)
      let imv =  MapofVtx.invert2m2s (module SetofVtx :  Set.S with type elt = vtx  and type t = SetofVtx.t)  mv in
      let ime = MapofEdge.invert2m2s (module SetofEdge : Set.S with type elt = edge and type t = SetofEdge.t) me in
      (* gAdd_v goes directly to src *)
      let gAdd_v = gAdd_v in
      (* gDel_v existed in the src, so expand *)
      let gDel_v = SetofVtx.setmap  ((flip  MapofVtx.find) imv) gDel_v in
      (* eSadd goes directly to src *) 
      let eSadd = eSadd in (* Invalid: if src and/or dst are to be expanded, then edge should be expanded as well *)
      let shortest_path g u v = try shortest_path g u v with _ -> [] in 
      let eSadd = SetofEdge.setmap (fun ((u,l,v) as e) ->
	let (uSrcS,vSrcS) = fsplit (mapT2 MapofVtx.find_some (u,v)) imv in
	match (uSrcS,vSrcS) with 
	  (None,None) -> SetofEdge.singleton e 
	| (Some vS,None) ->  (* target is a new node but src is old node *)
	    maps_Vtx2Edge (fun oldS  -> (oldS,l,v)) vS 
	| (None,Some vT) ->  (* source is a new node but target is old node *)
            maps_Vtx2Edge (fun oldT  -> (u,l,oldT)) vT 
	| (Some vS,Some vT) -> (* both source and target are old nodes *)
	    let (nS,nT) = mapT2 SetofVtx.cardinal (vS,vT) in
	    match (nS,nT) with
	      (_,1) -> let v = SetofVtx.choose vT in maps_Vtx2Edge (fun oldS  -> (oldS,l,v)) vS 
	    | (1,_) -> let u = SetofVtx.choose vS in maps_Vtx2Edge (fun oldT  -> (u,l,oldT)) vT 
	    | (_,_) -> let p = shortest_path g u v in
	      setmap_Vtx2Edge (fun oldS ->
		setmap_Vtx2Edge (fun oldT ->
                  let p' = shortest_path g oldS oldT in
		  if p' = p then SetofEdge.singleton (oldS,l,oldT) else
		  SetofEdge.empty) vT) vS
  	      ) eSadd in
      (* eSdel existed in the src, so expand *)
      let eSdel  = SetofEdge.setmap ((flip MapofEdge.find) ime) eSdel  in
      (** for modified edges **)
      (* deleted edge should be mapped and deleted *)
      (* same set of edge with replaced new label should be added *)
      let (eSmodAdd,eSmodDel) = List.fold_right (fun (eAdd,eDel) ->
	let dels = MapofEdge.find eDel ime in (* expand by map *)
	let (_,new_label,_) = eAdd in         (* get corresponding new label *)
	let adds = SetofEdge.map (fun (u,_,v) -> (u,new_label,v)) dels in (* swap labels of expanded edges *)
	cross (mapT2 SetofEdge.union (adds,dels))) eSmod_alist (SetofEdge.empty,SetofEdge.empty) in
      (* apply difference *)
      let vS =  SetofVtx.union g.v gAdd_v in
      let vS =  SetofVtx.diff  vS  gDel_v in
      let eS = SetofEdge.union g.e eSadd  in
      let eS = SetofEdge.diff  eS  eSdel  in
      let eS = SetofEdge.union eS  eSmodAdd in
      let eS = SetofEdge.diff  eS  eSmodDel in
      (* FIXME: if marked node added/deleted, then g.i and g.o component should be added/deleted accordingly *)
      let g' = { g with v = vS; e = eS } in
      if usrc <> "" then g2dot_file ~shape:`ellipse g' usrc;
      if (not batch) then begin
	let d = graph_diff g g' in
	dispD_gc d end;
      Sys.remove dot_file;
      g'

let bd_uncal db ?show_unreachable ?(useT = true) ?(ops = [ALLbl "src_of"]) ?(rewrite=false) ?glue_eps ce :graph = 
  let rho = (intern_gv "$db" db emptyDynEnv) in
  let ecenv = (intern_gv_aux "$db" (create_id_ecmap db.e) emptyEnv_aux) in
  let _ = GenId.set bd_start_id in
  let ce = 
    if rewrite 
    then let stEnv = dynenv2stenv rho in rewriteE stEnv ce
    else ce in
  let xg = bd_fwd ecenv rho ce in
  let g' = edit_g ?show_unreachable ~gray_unreachable:true ~shape:`ellipse ~cmp_eps:true ?glue_eps xg.graph in
  let _ = GenId.set bd_start_id in    (* restore state *)
  let f = !bwdRecUseT in
  let _ = bwdRecUseT := useT in
  let rho' = bd_bwd rho xg g' in
  let _ = bwdRecUseT := f in
  let db' = lookupVar rho' "$db" in
  (* display modified database *)
  (* display_cg_gc ~ops:ops db';  *)
  db'

let bd_cuncal db ?show_unreachable ?(useT = true) ?(ops = [ALLbl "src_of"]) ?(rewrite=false) ?glue_eps ce :graph = 
  let rho = (intern_gv "$db" db emptyDynEnv) in
  let _ = GenId.set bd_start_id in
  let ce = 
    if rewrite 
    then let stEnv = dynenv2stenv rho in rewriteE stEnv ce
    else ce in
  let (g,bf) = bd_eval_top rho ce in
  let g' = edit_g ?show_unreachable ~gray_unreachable:true ~shape:`ellipse ~cmp_eps:true ?glue_eps g in
  let _ = GenId.set bd_start_id in    (* restore state *)
  let f = !bwdRecUseT in
  let _ = bwdRecUseT := useT in
  let rho' = bf g' in
  let _ = bwdRecUseT := f in
  let db' = lookupVar rho' "$db" in
  (* display modified database *)
  (* display_cg_gc ~ops:ops db';  *)
  db'
  
(* display clean_id'ed graph *)
let display_cg ?(shape=`record) ?(ops = []) ?(cmp_eps = false) (g:graph) (fname:string) : unit = 
  let dot = g2dot ~ops:ops ~cmp_eps:cmp_eps g in
  let _ = dumpDot ~shape:`ellipse dot  fname in
  let com = !dotty_prog ^ " " ^ fname ^ "& " in
  let status = Sys.command com in
  if status <> 0 then failwith ("command " ^ com ^ " failed.")

let dispCG ?(shape=`ellipse) (g:graph) : unit = 
  let fname = "uuu.dot" in display_cg ~shape g fname




let ((fwd_eval_e_db,fwd_eval_e),(fwd_evalrw_e_db,fwd_evalrw_e)) =
  let re = (map_info (fun _ -> None)) @@ read_e in
  let rho = emptyDynEnv in
  let rw = UnCALSA.rewriteE in
   
  let fwd_e_db db ce = (bd_fwd (intern_gv_aux "$db" (create_id_ecmap db.e) emptyEnv_aux) (intern_gv "$db" db rho) ce).graph in
  let fwd_e       ce = (bd_fwd emptyEnv_aux rho                      ce).graph in

  ((fun db str -> dispG (fwd_e_db db (re str))),
   (fun    str -> dispG (fwd_e       (re str)))),
  ((fun db str -> 
    let e' = rw (make_defaultEnv db) (re str) in
    print_aexpr e';
    dispG (fwd_e_db db e')),
   (fun    str -> 
     let e' = rw emptyEnv            (re str) in
    print_aexpr e';
     dispG (fwd_e     e')))

let lists2graph (vl: vtx list) (el:edge list) 
    (il: inodeR list) (ol: onodeR list) : graph = 
  { v =    SetofVtx.fromList vl;  
    e =   SetofEdge.fromList el;
    i = SetofInodeR.fromList il;
    o = SetofOnodeR.fromList ol;}

(* simple list 2 graph *)
let slists2graph (vl: int list) (el: (int * string * int) list) 
    (il: (UnCAL.marker * int) list) (ol: (int * UnCAL.marker) list) : graph = 
   let i2v i : vtx  = Bid i in
   let s2l s : allit = if s = "!" then ALEps else ALLbl s in
   let isi2e (v,s,w) : edge  = (i2v v,s2l s,i2v w) in
   let mi2ir (m,i)   : inodeR = (m, i2v i) in
   let im2or (i,m)   : onodeR = (i2v i, m) in
  { v =    SetofVtx.fromList (List.map i2v   vl);
    e =   SetofEdge.fromList (List.map isi2e el);
    i = SetofInodeR.fromList (List.map mi2ir il);
    o = SetofOnodeR.fromList (List.map im2or ol);}

(* Set of nodes are collected from edges. Doesn't make sense for 
   single-node graphs *)
let eiolists2graph  (el: (int * string * int) list) 
    (il: (UnCAL.marker * int) list) (ol: (int * UnCAL.marker) list) : graph = 
   let i2v i : vtx  = Bid i in
   let s2l s : allit = if s = "!" then ALEps else ALLbl s in
   let isi2e (v,s,w) : edge  = (i2v v,s2l s,i2v w) in
   let mi2ir (m,i)   : inodeR = (m, i2v i) in
   let im2or (i,m)   : onodeR = (i2v i, m) in
   let eS = SetofEdge.fromList (List.map isi2e el) in
  { v = setofEdge_collectNodes eS;
    e = eS;
    i = SetofInodeR.fromList (List.map mi2ir il);
    o = SetofOnodeR.fromList (List.map im2or ol);}

let graph2slists (g:graph) : (int list) * ((int * string * int) list)
     * ((UnCAL.marker * int) list) * ((int * UnCAL.marker) list) = 
   let v2i v : int = match v with 
     Bid i->i|_->failwith ("graph2slists: unsupported node ID " ^ (vtx2str v)) in
   let l2s l : string = match l with 
     ALLbl s->s|ALEps->"!"|_->failwith ("unsupported edge label " ^ (allit2str l)) in
   let e2isi (v,l,w) = (v2i v,l2s l,v2i w) in
   let ir2mi (m,v)   = (m, v2i v) in
   let or2im (v,m)   = (v2i v, m) in
   (List.map v2i (SetofVtx.elements g.v),
    List.map e2isi (SetofEdge.elements g.e),
    List.map ir2mi (SetofInodeR.elements g.i),
    List.map or2im (SetofOnodeR.elements g.o))
   
  

(* produces dot file that reverals Skolem function values 
   db_file:     name of UnCAL file of input graph
   src_dotfile: name of dot file produced by db_file 
   unql_file:   name of UnQL file for transformation 
   unql_str:    string literal of UnQL expression for transformation
   uncal_file:  name of UnCAL file for transformation
   uncal_str:   string literal of UnCAL expression for transformation
   tgt_dotfile: name of dot file of output graph
   Note that unql_file, unql_str, uncal_file and uncal_str are mutually exclusive.
*)

(* Load dot file and convert to graph.
   If set_GenId is true, then set GenId seed to the next to the maximum 
   number used in the dot file.
   If descend_maxid is true, then the maximum number is searched recursively
   into the trace id. If false, fails if non-Bid node is found.
 *)

let collect_Bids_vtx (v:vtx) =
  let (sng,uni,emp) = (SetofVtx.singleton, SetofVtx.union, SetofVtx.empty) in
  let rec cb v = 
    match v with
      Bid _             -> sng v
    | S1 (v,x)
    | Hub (v,x,_)       -> cb v
    | S2 (u,a,v,w) 
    | FrE (w,(u,a,v),_) -> uni (uni (cb u) (cb v)) (cb w)
    | InT (i)           -> emp
    | ImT (i,x)         -> emp
    | IaT (i,v)         -> cb v in
  cb v

(* Returns maximum ID for Bid node and positional number.
   Since every node has either of the two, the maximum value
   always exists.  *)
let maxid_vtx (v:vtx) =
  let rec mxi v = 
    match v with
      Bid i             -> i
    | S1 (v,_)          -> mxi v
    | Hub (v,_,p)       -> max (mxi v) p
    | S2 (u,a,v,w)      -> max (max (mxi u) (mxi v))      (mxi w)
    | FrE (w,(u,a,v),p) -> max (max (mxi u) (mxi v)) (max (mxi w) p)
    | InT  p            -> p
    | ImT (p,_)         -> p
    | IaT (p,v)         -> max p (mxi v) in
  mxi v

let collect_Bids (g:graph) =
  SetofVtx.setmap collect_Bids_vtx g.v

let loadDot_file ?(set_GenId = false) ?(descend_maxid = false) db_file =
  let g = (dot2g @@ parseDot_file) db_file in
  if (set_GenId && (not (SetofVtx.is_empty g.v))) then begin
    let stripBid = function
	Bid i -> i
      | _     -> failwith ("loadDot_file:Remove trace ID in file" ^ db_file ^ " first.") in
    let pkmax = if descend_maxid then  maxid_vtx else stripBid in
    let maxid = fold_left1 max (List.map pkmax (SetofVtx.elements g.v)) in
    printf "maximum id in DB is %d@." maxid; 
    GenId.set (maxid + 1)
  end;
  g

let loadDotUnCAL_file ?set_GenId db_file = 
  let suffix = get_suffix db_file in
  match suffix with 
    "dot" -> loadDot_file ?set_GenId db_file
  | _     -> (* defaults to UnCAL *)
      (clean_id @@ remove_eps @@ load_db @@ (map_info (fun _ -> None)) @@ parseUnCAL_file) db_file
  
let genSkolemDot ?(show_unreachable = false) ?(bidir=false) (db_file:string) ?(src_dotfile:string = "")
   ?(unql_file:string = "")  ?(unql_str:string = "")
   ?(uncal_file:string = "") ?(uncal_str:string = "")
    (tgt_dotfile:string) : unit =
  (* save and set state *)
  let idstate = GenId.current () in
  let _ = GenId.set 0 in
  let db = loadDotUnCAL_file ~set_GenId:true db_file in
  let _ = if src_dotfile <> "" then g2dot_file ~shape:`ellipse db src_dotfile in
  if 1 <> List.length (List.filter ((<>) "") [unql_file;unql_str;uncal_file;uncal_str]) 
  then failwith "Either one of UnQL or UnCAL file(literal) must be specified.";
  let ce =
    if      unql_file  <> "" then ((map_info (fun _ -> None)) @@ unql2uncal @@ parseUnQL_file) unql_file
    else if uncal_file <> "" then ((map_info (fun _ -> None)) @@ parseUnCAL_file) uncal_file 
    else if unql_str   <> "" then ((map_info (fun _ -> None)) @@ unql2uncal @@ parseUnQL_string) unql_str
    else                          ((map_info (fun _ -> None)) @@ parseUnCAL_string) uncal_str in
  (* save evaluation mode *)
  let (err,cab,pb,sb,ea) = (!evalRecRecursive,!cleanAfterBulk,!pruneBulk,!skolemBulk,!escapeApnd) in
  let _ = evalRecRecursive := false
  and _ = cleanAfterBulk   := false
  and _ = pruneBulk        := true 
  and _ = skolemBulk       := true
  and _ = escapeApnd       := false
  in

  (* evaluation *)
  let g =
    if bidir then
      let rho = (intern_gv "$db" db emptyDynEnv) in
      let _ = GenId.set bd_start_id   in
      let (g,bf) = bd_eval_top rho ce in
       g
    else (eval_unCAL db ce) in
  let g = if show_unreachable then g else (reachableGI g) in

  (* restore evaluation mode *)
  let _ = evalRecRecursive := err 
  and _ = cleanAfterBulk   := cab 
  and _ = pruneBulk        := pb 
  and _ = skolemBulk       := sb
  and _ = escapeApnd       := ea
  and _ = GenId.set idstate in
  g2dot_file ~shape:`ellipse (g:graph) tgt_dotfile



let g2dot_and_edit ?(gray_unreachable = true) ?(shape=`record)
    ?(ops = []) ?(cmp_eps = false) (g:graph) (fname:string) =
  let dot = g2dot ~gray_unreachable:gray_unreachable ~ops:ops ~cmp_eps:cmp_eps g in
  let _ = dumpDot ~shape:`ellipse dot  fname in
  let com = !dotty_prog ^ " " ^ fname in
  let status = Sys.command com in
  if status <> 0 then failwith ("command " ^ com ^ " failed.")


(********** redifinition for environments lacking  fork, dot -Teps ***************)
let display_g =
  if Sys.os_type="Win32" || Sys.os_type = "Cygwin" then (fun (g:graph) (file:string) ->
  let _ = g2dot_file_light g file in
(*
  let com = "dot -Tps -O " ^ file in
  let status = Sys.command com in 
  if status <> 0 then print_string ("command " ^ com ^ " failed.");
  let com = "/cygdrive/c/Program\ Files/Ghostgum/gsview/gsview32 " ^ file ^ ".ps &" in
*)
  let com = !dotty_prog ^ " " ^ file in
  let status = Sys.command com in 
  if status <> 0 then print_string ("command " ^ com ^ " failed."))
  else display_g


let dispG =
if Sys.os_type="Win32" || Sys.os_type = "Cygwin" then (fun g ->

  let dot_file = Filename.temp_file "dispG" ".dot" in
  printf "writing to dot_file %s@." dot_file;
  display_g (reachableGI (remove_eps g)) dot_file)
else dispG

(* if communication of x-window system is too slow, this
    redifinition mighit help *)
let dispG_gc ?(is_raw = false) g =
  let g = if is_raw then g else clean_id (reachableGI (remove_eps g)) in
  display_cg_gc g

(********** end of redifinition ***************)

open TestInsert

(* convert graph to dot along with a list of insertion units *)
(* dst,src : "cyan" 
   graph  :  "green" *)
let gIlist2dot (g:graph) (ilist:  ins_unit list) : dot = 
  let dstS =  SetofVtx.fromLSet (List.map (fun iu -> iu.dst) ilist) in
  let srcS =  SetofVtx.fromLSet (List.map (fun iu -> iu.src) ilist) in
  let hubS = SetofVtx.union dstS srcS in
  let spoS = SetofEdge.fromLSet (List.map (fun iu ->
     setmap_InodeR2Edge (fun (im,v) -> 
         (SetofVtx.fold (fun u -> match (u,v) with
           (Hub (_ , m, idh), FrE(_, edge, idb)) -> 
              if idh = idb && m = im then SetofEdge.add (u,ALEps,v) else id
	 |    _                 -> failwith "gIlist2dot: not Hub/FrE")             
             iu.src SetofEdge.empty)) iu.graph.i)
           ilist) in
  let spiS = SetofEdge.fromLSet (List.map (fun iu ->
     setmap_OnodeR2Edge (fun (u,om) ->
         (SetofVtx.fold (fun v -> match (u,v) with
           (FrE(_, edge, idb),Hub (_ , m, idh)) -> 
              if idh = idb && om = m then SetofEdge.add (u,ALEps,v) else id
	 |    _                 -> failwith "gIlist2dot: not Hub/FrE")             
             iu.dst SetofEdge.empty)) iu.graph.o)
           ilist) in
  let spkS = SetofEdge.union spoS spiS in
  let iVS  =  SetofVtx.fromLSet (List.map (fun iu -> iu.graph.v) ilist) in

  let iES  = SetofEdge.fromLSet (List.map (fun iu -> iu.graph.e) ilist) in
  let g    = { g with
	       v =  SetofVtx.fromLSet [g.v;hubS;iVS];
	       e = SetofEdge.fromLSet [g.e;spkS;iES]; } in
  let d    = g2dot g in
  let hcol = "red" in
  let iucol= "purple" in
  let d    = addAttrToNodeSet d hubS "fontcolor" hcol  in
  let d    = addAttrToNodeSet d hubS "color"     hcol  in
  let d    = addAttrToEdgeSet d spkS "fontcolor" hcol  in
  let d    = addAttrToEdgeSet d spkS "color"     hcol  in
  let d    = addAttrToNodeSet d  iVS "fontcolor" iucol in
  let d    = addAttrToNodeSet d  iVS "color"     iucol in
  let d    = addAttrToEdgeSet d  iES "fontcolor" iucol in
  let d    = addAttrToEdgeSet d  iES "color"     iucol in
  d

let set_timeout (timeout:int) =
  let handler _ = failwith ("Timeout " ^ (string_of_int timeout) ^ " [sec].") in
  let _ = Sys.set_signal Sys.sigalrm (Sys.Signal_handle handler) in
  Unix.alarm timeout


(***************************** END basic definitions *****************************)
