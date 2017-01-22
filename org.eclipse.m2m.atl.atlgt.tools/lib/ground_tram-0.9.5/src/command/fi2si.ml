(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
(* covert flat ID on the view to internal fully structured id  *)
(* Synopsis:
  fi2si -ipt <flat_id> -ei *.ei 
   <flat_id>: flat node id on the view (integer)
   *.ei:      editinfo file

   Extended usage (vidualize traced nodes via DOT files):
   
   1. Forward execution and trace information collection
   %  fwd_uncal -ge -sb -cl -zn -fi -np -sa -t -rw -as -db class.dot -uq class2table.unql -dot \
       table.dot -xg table.xg -ei table.ei

   2. Backward tracing (from target node 1)
   % fi2si -ipt 1 -ei table.ei -tr -db class.dot -odot table.dot
   
   3. View dot files that are automatically generated from dots specified by -db and -odot 
      in which traced nodes are highlighted
   % (b)dotty class_highlighted.dot &
   % (b)dotty table_highlighted.dot &
  
   4. Forward tracing (from source node 1)
   % fi2si -sv 1 -ei table.ei -db class.dot -odot table.dot
   
   5. Reload highlighted dot file by typing 'L' on (b)dotty.

   6. Repeat step 2 or 4 followed by step 5.
*)

open Format
open BiEvalUnCAL
open UnCALDMutil
open UnCALDM
open PrintUnCALDM
open PrintDot
open TestUnCALutil
open Version
open Fputil
open ExtSetMap
open Dotutil

type bwd_config =  {
    mutable ei_file      : string; (* editinfo file *)
    mutable ipt_node     : int;    (* flat node ID in the view *)
    mutable src_node     : int;    (* flat node ID in the source *)
    mutable tr_flag      : bool;   (* trace back to source node ID *)
    mutable pt_flag      : bool;   (* print trace table *)
    mutable idot_file    : string; (* input dot file *)
    mutable odot_file    : string; (* output dot file *)
  }

let default_config = { ei_file = "";  ipt_node     = (-1);  
		       tr_flag = false; 
		       pt_flag = false; 
		       idot_file = "";
		       odot_file = "";
		       src_node  = (-1);
		     }

let speclist = 
  let cf = default_config in 
  Arg.align
    [
     ("-ei",  Arg.String (fun s->cf.ei_file <-s),      " editinfo produced by forward trans.");
     ("-ipt", Arg.Int    (fun k->cf.ipt_node<-k),      " flat node ID in the view");
     ("-tr",  Arg.Unit   (fun()->cf.tr_flag<-true),    " trace back to source node ID");
     ("-sv",  Arg.Int    (fun k->cf.src_node<-k),      " flat node ID in the source");
     ("-pt",  Arg.Unit   (fun()->cf.pt_flag<-true),    " print entire trace correspondence");
     ("-db",  Arg.String (fun s->cf.idot_file <-s),    " input dot file (optional)");
     ("-odot",Arg.String (fun s->cf.odot_file <-s),    " output dot file (optional)");
   ]

let speclist = add_version_spec speclist

let usage_msg = "Usage: "^Sys.executable_name^" -ei fwd_result.ei [-ipt node [-tr]] [-pt] [-sv node] [-db db.dot] [-odot result.dot]"

let read_args () = 
  let cf = default_config in 
  Arg.parse speclist (fun s -> ()) usage_msg; cf 

let failwith_msg msg =
  fprintf err_formatter "%s@." msg;
  Arg.usage speclist usage_msg; exit 1

let _ = 
  let cf = read_args () in
  let _ = print_version () in
  (* check arguments *)
       if cf.ei_file       = "" then failwith_msg "editinfo file unspecified."
  else 
    let ei = file2edinfo cf.ei_file in
    let _ = skolemBulk             := ei.sbulk    in
    let _ = escapeApnd             := ei.eapnd    in
    let _ = cycleSemanticsOriginal := ei.cycorig  in
    let _ = saUnreach              := ei.saunrch  in
    let expand_vtx v = MapofVtx.find v ei.vm.mapV in
    let tr_list l = List.concat (List.map (fun v -> try [trace v] with _ -> []) l) in
    let tr_set s = SetofVtx.setmap (fun v ->
      try SetofVtx.singleton (trace v) with _ -> SetofVtx.empty) s in
    let pr_list_newline pr_elem fmt xs =
      match xs with
	[] -> () 
      | x::xs -> pr_elem fmt x; List.iter (fprintf fmt "\n%a" pr_elem) xs in
    let pr_node_list_node_per_line node_list =
      Format.fprintf Format.std_formatter "%a@." (pr_list_newline pp_skolemV) node_list in
    (* generate DOT file with specified node highlighted *)
    let highlight_nodes fname vS =
      let traced_node_color = "red" in
      let suffix = get_suffix fname in
      let prefix = Filename.chop_extension fname in
      let hl_dotfile = prefix ^ "_" ^ "highlighted"  ^  "." ^ suffix in
      let org_dot = parseDot_file fname in
      let d = addAttrToNodeSet org_dot vS "fontcolor" traced_node_color in
      let d = addAttrToNodeSet d       vS "color"     traced_node_color in
      (* dispD_gc d *)
      dumpDot ~prefix_n:false d hl_dotfile in 
    let bwd_vtx : (vtx -> SetofVtx.t) = tr_set @@ expand_vtx in
    let bwd_MapofVtx = vtxSet2Map bwd_vtx ei.g_edit.v in
    let invert_MapofVtx2SVtx =
      MapofVtx.invert_m2s (module SetofVtx : Set.S with type elt = vtx and type t = SetofVtx.t) in
    let fwd_MapofVtx = invert_MapofVtx2SVtx bwd_MapofVtx in
    let fwd_vtx v = MapofVtx.find v fwd_MapofVtx in
    if cf.ipt_node <> -1 then begin
      let v = (Bid cf.ipt_node) in
      let vS = expand_vtx v in
      let vL = SetofVtx.elements vS in
      if (not cf.tr_flag) then begin pr_node_list_node_per_line vL end;
      if cf.tr_flag then begin
	let svL = SetofVtx.elements (SetofVtx.fromList (tr_list vL)) in
	pr_node_list_node_per_line svL;
	if cf.odot_file <> "" then highlight_nodes cf.odot_file (SetofVtx.singleton v);
	if cf.idot_file <> "" then highlight_nodes cf.idot_file (SetofVtx.fromList svL);
	end;
    end;
    if cf.src_node <> -1 then begin
      let v = (Bid cf.src_node) in
      let vS = fwd_vtx v in
      let tvL = SetofVtx.elements vS in
      pr_node_list_node_per_line tvL;
      if cf.idot_file <> "" then highlight_nodes cf.idot_file (SetofVtx.singleton v);
      if cf.odot_file <> "" then highlight_nodes cf.odot_file vS;
    end;
    if cf.pt_flag then begin
      MapofVtx.iter (fun k v ->
	Format.fprintf Format.std_formatter "%a -> %a@." pp_skolemV k (SetofVtx.pr pp_skolemV) v) fwd_MapofVtx;
      MapofVtx.iter (fun k v ->
	Format.fprintf Format.std_formatter "%a <- %a@." (SetofVtx.pr pp_skolemV) v pp_skolemV k) bwd_MapofVtx
    end
     (*
      let vL = SetofVtx.elements ei.g_edit.v in
      List.iter (fun v ->
	let sv = tr_set (expand_vtx v) in
	Format.fprintf Format.std_formatter "%a <- %a@." (SetofVtx.pr pp_skolemV) sv pp_skolemV v) vL
      *)
