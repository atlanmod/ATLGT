(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
open Version
open InsertionTemplate3
open UnCAL
open Format
open Fputil
open UnCALDMutil
open Dotutil
open TestUnCALutil
open PrintDot
open UnCALDM
open List (* concat,... *)
open UnCALSA (* map_info *)
open PrintUnCAL (* print_aexpr *)

(* 
 -idot   input DB in DOT
 -q      query in UnCAL
 -odot   view in DOT
 -uidot  updated source DB in DOT
 -uodot  updated view DB in DOT
 -ipt    insertion point
 -tidot  graph to be inserted in DOT
*)

(* Usage for insertion:

  0. Normal forward execution
    % insertg -idot db.dot -q q.uncal -odot output.dot [-opng result.png]

  1. User determine the insertion point by examining result.{dot,png}
    (ex. select "print node" in the bdotty context menu)

  4. User determine the graph to be inserted
    % insertg -idot db.dot -q q.uncal -odot output.dot [-opng result.png] \
     -ipt 1 -tidot tidot.dot   -uidot udb.dot -uodot uoutput.dot 
 
*)

(* Concrete commandline example:

 ./insertg -idot ../examples/PODS10Examples/bd_db.dot -q ../examples/POPL10BUExamples/a2d_xc.uncal -odot output.dot -ipt 3 -tidot ../examples/to_be_inserted.dot -uidot udb.dot -uodot uoutput.dot

 
*)

let parseUnCAL_file   = (map_info (fun _ -> None)) @@ parseUnCAL_file

type config = {
    mutable inputdb_file : string;      (* input DOT db file *)
    mutable q_file       : string;      (* input UnCAL query file *)
    mutable png_file     : string;      (* output png file *)
    mutable dot_file     : string;      (* output in dot format for user editing *)
    mutable prt_uncal    : bool;        (* turn on printing source UnCAL expression *)
    mutable ipt_node     : int;         (* insertion point *)
    mutable uidot_file   : string;      (* updated DOT db file *)
    mutable uodot_file   : string;      (* updated DOT view file *)
    mutable tidot_file   : string;      (* to_be_inserted DOT file *)
    mutable vv_flag      : bool;        (* turn on debug writing *)
}

let default_config = {
 inputdb_file = "";    
 q_file       = "";    
 png_file     = "";    
 dot_file     = "";    
 prt_uncal    = false; 
 ipt_node     = (-1);    
 uidot_file = "";    
 uodot_file  = "";
 tidot_file  = "";
 vv_flag      = false; 
}


let speclist =
  let cf = default_config in
  Arg.align
    [
     ("-idot", Arg.String (fun s->cf.inputdb_file<-s), " source db file (in DOT)"); 
     ("-q",    Arg.String (fun s->cf.q_file<-s),       " source UnCAL file");
     ("-opng", Arg.String (fun s->cf.png_file<-s),     " result PNG file");
     ("-odot", Arg.String (fun s->cf.dot_file<-s),    " result DOT file for editing and backward input");
     ("-uidot",Arg.String (fun s->cf.uidot_file<-s),   " updated DOT db file ");
     ("-uodot",Arg.String (fun s->cf.uodot_file<-s),   " updated DOT view file ");
     ("-tidot",Arg.String (fun s->cf.tidot_file<-s),   " to_be_inserted DOT file ");
     ("-pa",   Arg.Unit   (fun()->cf.prt_uncal<-true), " print UnCAL input expression");
     ("-ipt",  Arg.Int    (fun k->cf.ipt_node<-k),     " insertion point in the view");
     ("-vv",   Arg.Unit   (fun()->cf.vv_flag<-true),   " turn on debug writing (verbose)");
   ]

let speclist = add_version_spec speclist

let usage_msg = "Usage: "
       ^Sys.executable_name^ " -idot db.dot  -q query.uncal -odot output.dot [-opng result.png]
        [-ipt node -uidot udb.dot -tidot tidot.dot -uodot uoutput.dot   ] 
        [-vv] [-pa]"

let read_args () = 
  Arg.parse speclist (fun s -> ()) usage_msg; default_config

let failwith_msg msg =
  fprintf err_formatter "%s@." msg;
  Arg.usage speclist usage_msg; exit 1

let bdIverbose = ref false

(*  apply user specified concrete value to the edges *)
(* usage: 
  substitute_NLVar g (ALInt (-1005)) (ALLbl "yama") *)
let substitute_NLVar (nlv:allit) (lit:allit) (g:graph)   =
  let isNarrowingLVar lbl = isNarrowingLVar lbl init_restriction  in
  let replace_l lbl =
     if isNarrowingLVar lbl then lit else lbl in
  let replace_e = cross3 (id,replace_l,id) in
  { g with e = SetofEdge.map replace_e g.e }


(* Extract the subgraph that is rooted at the node "node" and appears
   in g1 but not in g2. *)
let diff 
    (g1: UnCALDM.graph)
    (g2: UnCALDM.graph)
    (node: UnCALDM.vtx) 
    : UnCALDM.graph
= 
  let g1' = make_dv g1 node in
  let g2' = make_dv g2 node in
    make_dv {v=g1'.v; e=SetofEdge.diff g1'.e g2'.e; i=g1.i; o=g1.o} node

(* pointed_via_eps n g: compute that node that is pointed by n via an
   epsilon edge in the graph g *)
let nodes_via_eps (n: UnCALDM.vtx) (g: UnCALDM.graph) : UnCALDM.vtx list =
  let f e xs = 
    match e with
	(n1,UnCAL.ALEps,n2) -> if n1=n then n2::xs else xs
      | _ -> xs in
  SetofEdge.fold f g.e [] 
    
(* Add an element to a list if it does not exist in the list *)
let rec addlv l ls =
  match ls with
      [] -> [l]
    | l'::ls' -> if l=l' then addlv l ls' else l' :: addlv l ls'

(* Compute all label variables in all negative equations in the list "neqL".
   Note that a variable in the equation is assumed to have the form of ATInt i. *)
let rec label_vs (neqL: (UnCAL.allit * UnCAL.allit) list): UnCAL.allit list =
  match neqL with
      [] -> []
    | (l1,l2)::neqL' ->
	match l1,l2 with
	    ALInt i, ALInt j -> addlv l1 (addlv l2 (label_vs neqL'))
	  | ALInt i, _ -> addlv l1 (label_vs neqL')
	  | _, ALInt j -> addlv l2 (label_vs neqL')
	  | _,_ -> label_vs neqL'

(* A naive algorithm to return a list of substitutions for the variables in "neqL".
   Varibles are mapped to "labels" given in the input.  *)
let inst 
    (neqL: (UnCAL.allit * UnCAL.allit) list)
    (labels: UnCAL.allit list)
    : (UnCAL.allit * UnCAL.allit) list list 
=
  (* store all label variables in neqL in vs *)
  let vs = label_vs neqL in
  (* check if all equations in neqL are satisfied *)
  let rec is_true neqL =
    match neqL with
	[] -> true
      | (l1,l2)::neqL' -> l1 <> l2 && is_true neqL' in
  (* return a list of substitutes (vs => labels) that make neqL hold *) 
  let rec inst' neqL vs labels =
    match vs with
	[] -> if is_true neqL then [[]] else []
      | v::vs' -> concat (map (fun l -> map (fun vls -> (v,l) :: vls)
				 (inst' (replaceList v l neqL) vs' labels)) labels) in
    inst' neqL vs labels

(* compute a list of edge labels of a graph. *)
let edge_labels (g: UnCALDM.graph) : UnCAL.allit list = 
  let add (_,l,_) ls = addlv l ls in
    SetofEdge.fold add g.e []

(**************************************************************** 
 *  Main Function: 
 *  Insert to the view (produced by transformation uncal on db)
 *  a graph gv at the node with number n, and return newly updated
 *  i/o graphs.
 *****************************************************************)

let insert 
    (uncal : 'a UnCAL.aexpr) (* transformation *)
    (db : UnCALDM.graph)              (* the input graph (after cleaning) *)
    (n,gv : int*UnCALDM.graph)        (* n: node number; gv: graph to be inserted *)
    : UnCALDM.graph * UnCALDM.graph   (*  updated input/output graphs *) 
    =
  (* calculate the view *)
  let view = test_eval_small uncal db in
    (* compute the mapping between node number and the internal node 
       representation with tracing information *)
  let (_,mapV,_) =  
    clean_id_aux (reachableGI (remove_eps (test_eval_small uncal db))) in
    (* compute the corresponding internal node corresponding to the view node n *)
  let nodev = 
    let nd = 
      try MapofVtx.find (Bid n) (MapofVtx.invert mapV)
      with Not_found -> failwith "The node specified for insertion does not exist." in
      match nd with
	| FrE _ -> 
	    (match nodes_via_eps nd view with
	       | [] -> failwith "the node in the view is not traceable"
	       | n::_ -> n)
	| _ -> nd in
    (* generate all possible templates as a stream *)
  let templates = test_insert nodev uncal db (fun _ -> true) in
  let templates_substs = 
    (* instantiate t is to find all possible instantiations for the template t.
     * Note that we reduce the space of labels that can be bound to variables to
     * those that only appear in the graphs to be inserted. *)
    let instantiate t = 
      let (outG, cst, inG) = t in 
      let view_diff = diff outG view nodev in
      let substs = 
	filter (fun subst -> bisimilar (substituteG subst view_diff) gv) 
	  (inst cst (edge_labels gv)) in (* second arg: we may add more constant labels to 
                                          * increase possible choices to instantiate label variables. *)
	(substs,t) in
      filter_stream (fun (substs,t) -> substs <> []) 
	(map_stream instantiate templates) in
    match templates_substs with
	SEnd -> failwith "no insertion exists on the source side"
      | _ -> 
	  let (substs, (outG,_,inG)) = hd_stream templates_substs in
	  let subst = hd substs in
	  let o = substituteG subst outG in
	  let i = substituteG subst inG in 
	    (i,o)

(* execute query *) 
let _ = 
  let cf = read_args () in
  let _ = print_version () in
  (* check arguments *)
  if      cf.inputdb_file = "" then failwith_msg "Source db file unspecified."
  else if cf.q_file       = "" then failwith_msg "UnCAL source file unspecified."
  else if cf.dot_file     = "" then failwith_msg "Result dot file for insertion unspecified."
  else 
    let _ = bdIverbose := cf.vv_flag in
    let _ = GenId.reset ()  in
    let db = (dot2g @@ parseDot_file) cf.inputdb_file in
    let ce = parseUnCAL_file cf.q_file in
    let _ = 
      if cf.prt_uncal 
      then 
	begin 
	  print_endline "(************** begin Submitted Query ****************)";
	  print_aexpr ce;
	  print_endline "(**************  end  Submitted Query ****************)"
	end in
    let (g,_,_) = clean_id_aux (reachableGI (remove_eps (test_eval_small ce db))) in
    let dot = g2dot ~gray_unreachable:true g in
    (* prefix_n is reluctantly set to false, because currently negative node ID
       is used for narrowing graph variable, which renders n-XXXX that looks unnatural *)
    let _ = dumpDot ~prefix_n:false dot cf.dot_file  in
    if cf.png_file <> "" then  dotf2pngf cf.dot_file cf.png_file;
    if (cf.ipt_node<> -1 && cf.tidot_file <> "") then (* Actual insertion *)
      begin
	let gv = (dot2g @@ parseDot_file) cf.tidot_file in
	let (dbI,tpl) = insert ce db (cf.ipt_node,gv) in
	let tpl = (reachableGI @@ remove_eps) tpl in
	let tpl = clean_id tpl in
	let uodot = g2dot ~gray_unreachable:true tpl  in
	let _ = dumpDot ~prefix_n:false uodot cf.uodot_file in
	let dbI = (clean_id @@ remove_eps) dbI in
	let uidot = g2dot ~gray_unreachable:true dbI in
	let _ = dumpDot ~prefix_n:false uidot cf.uidot_file in
          ()
      end
