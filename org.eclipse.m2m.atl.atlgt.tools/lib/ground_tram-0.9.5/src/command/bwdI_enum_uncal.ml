(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
(* driver of insertionTemplate3.ml *)

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
open UnQL2unCAL
open UnCALSA
open PrintUnCAL (* print_aexpr *)

let parseUnCAL_file   = (map_info (fun _ -> None)) @@ parseUnCAL_file

(* 
 -idot   input DB in DOT
 -q      query in UnCAL
 -odot   view in DOT
 -uidot  updated source DB in DOT
 -uodot  updated view DB in DOT
 -ipt    insertion point (Skolem term)
 -k      template number
 -nlv  k=v  assignments values to the narrowing label variables
*)

(* Usage for insertion:

  0. Normal forward execution
    % insert -idot db.dot -q q.uncal -odot output.dot [-opng result.png]

  1. User determine the insertion point by examining result.{dot,png}
    (ex. select "print node" in the bdotty context menu)

  4. Enumerate insertion template, and choose the template.
     Inserted portion is hilighted with colors.
    % insert -idot db.dot -q q.uncal -odot output.dot [-opng result.png] \
       -ipt "Hub(2,&,9)" -uidot udb.dot -k 0 -uodot uoutput.dot
 
  7. User specify the concrete values for each narrowing label var
    % insert -idot db.dot -q q.uncal -odot output.dot [-opng result.png] \
       -ipt "Hub(2,&,9)" -uidot udb.dot -k 0 -uodot uoutput.dot -nlv 1003=a -nlv 1005=b
*)
(* 
   The following steps are not necessary anymore.
    2. Trace back source.
    3. Replace the id of the vsrc to that of narrowing var (by negation).
 *)

(* Concrete commandline example:
  ./insert -idot ../examples/PODS10Examples/bd_db.dot -q ../examples/POPL10BUExamples/a2d_xc.uncal -odot output.dot -ipt "Hub(5,&,9)" -uidot udb.dot -uodot uoutput.dot -nlv 1005=x -k 1000
*)
type config = {
    mutable inputdb_file : string;      (* input DOT db file *)
    mutable q_file       : string;      (* input UnCAL query file *)
    mutable uq_file      : string;      (* input UnQL query file *)
    mutable png_file     : string;      (* output png file *)
    mutable dot_file     : string;      (* output in dot format for user editing *)
    mutable prt_uncal    : bool;        (* turn on printing source UnCAL expression *)
    mutable ipt_node     : string;      (* source of insertion unit *)
    mutable k            : int;         (* index of insertion template *)
    mutable uidot_file   : string;      (* updated DOT db file *)
    mutable uodot_file   : string;      (* updated DOT view file *)
    mutable vv_flag      : bool;        (* turn on debug writing *)
    mutable lblist       : string list; (* list of binding of LNVar=val *)
}

let default_config = {
 inputdb_file = "";    
 q_file       = "";    
 uq_file      = "";    
 png_file     = "";    
 dot_file     = "";    
 prt_uncal    = false; 
 ipt_node     = "";    
 k            = (-1);  
 uidot_file = "";    
 uodot_file  = "";
 vv_flag      = false; 
 lblist       = [];    
}

let speclist =
  let cf = default_config in 
  Arg.align
    [
     ("-idot", Arg.String (fun s->cf.inputdb_file<-s), " source db file (in DOT)"); 
     ("-q",    Arg.String (fun s->cf.q_file<-s),       " source UnCAL file");
     ("-uq",   Arg.String (fun s->cf.uq_file     <-s), " source UnQL file");
     ("-opng", Arg.String (fun s->cf.png_file<-s),     " result PNG file");
     ("-odot", Arg.String (fun s->cf.dot_file<-s),    " result DOT file for editing and backward input");
     ("-uidot",Arg.String (fun s->cf.uidot_file<-s),   " updated DOT db file ");
     ("-uodot",Arg.String (fun s->cf.uodot_file<-s),   " updated DOT view file ");
     ("-pa",   Arg.Unit   (fun()->cf.prt_uncal<-true), " print UnCAL input expression");
     ("-ipt",  Arg.String (fun s->cf.ipt_node<-s),     " insertion unit in the view");
     ("-k",    Arg.Int    (fun i->cf.k<-i),            " index of insertion template");
     ("-nlv",  Arg.String (fun s->cf.lblist<-s::cf.lblist), " binding of LNVar=allit");
     ("-vv",   Arg.Unit   (fun()->cf.vv_flag<-true),   " turn on debug writing (verbose)");
   ]

let speclist = add_version_spec speclist

let usage_msg = "Usage: 
   "^Sys.executable_name^" -idot db.dot  -q query.uncal -odot output.dot [-opng result.png]
     [-ipt node -uidot udb.dot -k n -uodot uoutput.dot
       [-nlv ln1=litn1 -nlv ln2=litn2 ... ]] 
     [-vv] [-pa]"

let read_args () = 
  let cf = default_config in 
  Arg.parse speclist (fun s -> ()) usage_msg; cf

let failwith_msg msg =
  fprintf err_formatter "%s@." msg;
  Arg.usage speclist usage_msg; exit 1

let ppr_allit ppf = function
    ALLbl (l) -> fprintf ppf "%s" l
  | ALStr (s) -> fprintf ppf "%S" s
  | ALInt (i) -> 
      if i < 0 then fprintf ppf "$l_%i" (0 - i)
      else fprintf ppf "%i"     i
  | ALFlt (f) -> fprintf ppf "%f" f
  | ALBol (b) -> fprintf ppf "%B" b
  | ALUkn     -> fprintf ppf "%s" "?"
  | ALEps     -> fprintf ppf "%s" "!"

let pr_neq ppf (lhs,rhs) = 
  fprintf ppf "@[%a!=%a@]" ppr_allit lhs ppr_allit rhs 

let pr_label_restriction ppf lr =
  fprintf ppf "(@[neqL:{%a}])" (pr_list pr_neq) lr 

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

(* execute query *) 
let _ = 
  let cf = read_args () in
  let _ = print_version () in
  (* check arguments *)
  if      cf.inputdb_file = "" then failwith_msg "Source db file unspecified."
  else if (cf.q_file = "" && cf.uq_file = "") then failwith_msg "UnCAL source file unspecified."
  else if cf.dot_file     = "" then failwith_msg "Result dot file for insertion unspecified."
  else 
    let _ = bdIverbose := cf.vv_flag in
    let _ = GenId.reset ()  in
    let db = (dot2g @@ parseDot_file) cf.inputdb_file in
    let ce =
      if   cf.q_file <> "" then parseUnCAL_file cf.q_file
      else       ((map_info (fun _ -> None)) @@ unQL2unCAL_cleanup @@ parseUnQL_file) cf.uq_file in
    let _ = 
      if cf.prt_uncal 
      then 
	begin 
	  print_endline "(************** begin Submitted Query ****************)";
	  print_aexpr ce;
	  print_endline "(**************  end  Submitted Query ****************)"
	end in
    let g = test_eval_small ce db in
    let dot = g2dot ~gray_unreachable:true g in
    (* prefix_n is reluctantly set to false, because currently negative node ID
       is used for narrowing graph variable, which renders n-XXXX that looks unnatural *)
    let _ = dumpDot ~prefix_n:false dot cf.dot_file  in
    if cf.png_file <> "" then  dotf2pngf cf.dot_file cf.png_file;
    if (cf.ipt_node<> "" && cf.k <> -1) then (* Actual generation of templates *)
      begin
	let node = TestUnCALutil.parseVtx_string cf.ipt_node in
	let (tpl,cst,dbI) = nth_stream cf.k (test_insert node ce db (fun _ -> true)) in
	printf "Restriction=%a@." pr_label_restriction cst;
	(* look restriction before substitution *)
	let lblist = List.map (fun a -> Scanf.sscanf a "%d@=%s" (fun ln lv ->(ln,lv))) cf.lblist in
	(** -nlv ln1=litn1 -nlv ln2=litn2 ... -nlv ln_n=lit_n   -> al=[(ln_n,"lit_n");(ln_n-1,"lit_n-1"); ... ; (ln1,"lit1")] **) 
        (**
        let l = List.length lblist in
        let _ = Format.fprintf Format.std_formatter "Total number of bindings: %d@." l in **)
	let apply_bindings = List.fold_right (fun (ln,lv) -> 
	   substitute_NLVar (ALInt (- ln)) (parseLabel_string lv)) lblist in
        let dbI = apply_bindings dbI in 
        let tpl = apply_bindings tpl in 
	let uidot = g2dot ~gray_unreachable:true dbI in
	let _ = dumpDot ~prefix_n:false uidot cf.uidot_file in
	let uodot = g2dot ~gray_unreachable:true tpl  in
	let _ = dumpDot ~prefix_n:false uodot cf.uodot_file in
          ()
      end



