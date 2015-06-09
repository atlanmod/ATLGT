(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
(* Pretty printer for UnQL AST 
   Some of the expressions are currently not recognized by the parser. *)
open UnQL
open Print
open Format

let pp_variable ppf (v:'a variable) = 
  match v with
    | `var (_, s)    -> fprintf ppf "%s" s
    | `doc (_, s)    -> fprintf ppf "doc(%S)" s
    | `database _    -> fprintf ppf "$db" 
and  pp_label ppf (l:'a label) =
  match l with
    `label(_,s)  -> fprintf ppf "%s" s
and pp_marker_variable ppf (mv:marker_variable) = 
  match mv with
  `marker_var s -> fprintf ppf "%s" s
and pp_fun_name ppf (fn:fun_name) =
  match fn with
    `fun_name s -> fprintf ppf "%s" s

let pp_const ppf (c:'a const) =
  match c with
  | `bool(_,b)	-> fprintf ppf "%a" pp_bool   b
  | `int(_,i)	-> fprintf ppf "%a" pp_int    i
  | `string(_,s)-> fprintf ppf "%a" pp_string s
  | #label as l -> fprintf ppf "%a" pp_label  l

(* operator precedence *)

let value_expr_gt (ve1:'a value_expr) (ve2:'a value_expr) = match (ve1,ve2) with
| #variable,        #variable         -> false (* nullaries *)
| #const,           #const             -> false (* uullaries *)
| `unary(_,_,_),      `unary(_,_,_)        -> false (* unaries   *)
| `binary (_,_,_,_),  `unary(_,_,_)        -> true
| `binary (_,`OR,_,_),`binary (_,`AND,_,_) -> true
| _               ,_                   -> false

let rec pp_value_expr ppf (ve:'a value_expr) =
  match ve with
    | #variable as v -> fprintf ppf "%a" pp_variable v
    | #const    as c -> fprintf ppf "%a" pp_const    c
    | `unary (_,u_op,ve1) ->
	if value_expr_gt ve1 ve
	then fprintf ppf "%a@ (%a)" pp_unary_op u_op pp_value_expr ve1
	else fprintf ppf "%a@ %a" pp_unary_op u_op pp_value_expr ve1
    | `binary (_,b_op,ve1,ve2) ->
	if (value_expr_gt ve1 ve) && (value_expr_gt ve2 ve)
	then fprintf ppf "(%a)@ %a@ (%a)" pp_value_expr ve1 pp_binary_op b_op pp_value_expr ve2
	else if value_expr_gt ve1 ve
	then fprintf ppf "(%a)@ %a@ %a"   pp_value_expr ve1 pp_binary_op b_op pp_value_expr ve2
	else if value_expr_gt ve2 ve
	then fprintf ppf "%a@ %a@ (%a)"   pp_value_expr ve1 pp_binary_op b_op pp_value_expr ve2
	else fprintf ppf "%a@ %a@ %a"     pp_value_expr ve1 pp_binary_op b_op pp_value_expr ve2

and pp_unary_op ppf (uo:unary_op) =
  match uo with
    `NOT     -> fprintf ppf "not"
  | `IsEmpty -> fprintf ppf "isempty"
and pp_binary_op ppf (bo:binary_op) =
  match bo with
    `AND      -> fprintf ppf "and"
  | `OR       -> fprintf ppf "or"
  | `EQ       -> fprintf ppf "="
  | `LT	      -> fprintf ppf "<"
  | `GT	      -> fprintf ppf ">"
  | `CONCAT   -> fprintf ppf "^"

(* operator precedence *)

let rpp_gt (p1:'a rpp) (p2:'a rpp) = match (p1,p2) with
  #label,#label             -> false  (* nullaries *)
| `any,`any                 -> false  (* nullaries *)
| `option(_),`option(_)     -> false  (* unaries  *)
| `star(_), `star(_)        -> false  (* unaries  *)
| `plus(_), `plus(_)        -> false  (* unaries  *)
| `not(_), `not(_)          -> false  (* unaries  *)
| `union(_,_),`union(_,_)   -> false  (* binaries *)
| `concat(_,_),`concat(_,_) -> false  (* binaries *)
| `union(_,_),`concat(_,_)  -> true 
| `concat(_,_),`union(_,_)  -> false
| `union(_,_),_             -> true
| `concat(_,_),_            -> true
| _,_                       -> false

let rec pp_rpp ppf (p:'a rpp) = 
  match p with 
  #label as l       -> fprintf ppf "%a" pp_label l
  | `eps            -> fprintf ppf "!"
  | `any            -> fprintf ppf "_"
  | `concat (p1,p2) -> 
      if (rpp_gt p1 p) && (rpp_gt p2 p)
      then fprintf ppf "(%a)@,.(%a)" pp_rpp p1 pp_rpp p2
      else if (rpp_gt p1 p) 
      then fprintf ppf "(%a)@,.%a"   pp_rpp p1 pp_rpp p2
      else if (rpp_gt p2 p) 
      then fprintf ppf "%a@,.(%a)"   pp_rpp p1 pp_rpp p2
      else fprintf ppf "%a@,.%a"     pp_rpp p1 pp_rpp p2

  | `union (p1,p2)  -> fprintf ppf "%a@,|%a" pp_rpp p1 pp_rpp p2
  | `option p1      -> 
      if rpp_gt p1 p 
      then fprintf ppf "(%a)?" pp_rpp p1
      else fprintf ppf "%a?"   pp_rpp p1
  | `star p1	    -> 
      if rpp_gt p1 p 
      then fprintf ppf "(%a)*"  pp_rpp p1
      else fprintf ppf "%a*"    pp_rpp p1
  | `plus p1	    -> 
      if rpp_gt p1 p 
      then fprintf ppf "(%a)+"  pp_rpp p1
      else fprintf ppf "%a+"    pp_rpp p1
  | `not p1         -> 
      if rpp_gt p1 p 
      then fprintf ppf "!(%a)"  pp_rpp p1
      else fprintf ppf "!%a"    pp_rpp p1

let pr_seq (delim:string) pr_elem ppf lst  =
  let v = ref lst in
  while (!v <> []) 
  do
    fprintf ppf "%a" pr_elem (List.hd (!v));
    v := (List.tl (!v));
    if (!v <> []) then fprintf ppf "%s@ " delim
  done

let pr_nl_seq (delim:string) pr_elem ppf lst  =
  let v = ref lst in
  let cnt = ref 0 in
  let offstr = String.make ((String.length delim)+2) ' ' in
  while (!v <> []) 
  do
    if !cnt = 0 
    then fprintf ppf "%s" offstr
    else fprintf ppf "%s " delim;
    fprintf ppf "%a"  pr_elem (List.hd (!v));
    v := (List.tl (!v)); cnt := !cnt + 1;
    if (!v <> []) then fprintf ppf "@\n@ "
  done

(* delimiter before newline *)
let pr_nl_pseq (delim:string) pr_elem ppf lst  =
  let v = ref lst in
  let cnt = ref 0 in
  let offstr = String.make ((String.length delim)+2) ' ' in
  while (!v <> []) 
  do
    fprintf ppf "%a"  pr_elem (List.hd (!v));
    v := (List.tl (!v)); cnt := !cnt + 1;
    if (!v <> []) then fprintf ppf ",@\n"
  done

let pr_nl2_seq (delim:string) pr_elem ppf lst  =
  let v = ref lst in
  while (!v <> []) 
  do
    fprintf ppf "%a" pr_elem (List.hd (!v));
    v := (List.tl (!v));
    if (!v <> []) then fprintf ppf "@\n%s@\n" delim
  done


let pr_forest pr_elem = pr_seq "," pr_elem

let rec pp_pattern ppf (p:'a pattern) = 
  match p with 
  `tree (pp_list) -> fprintf ppf "{@[%a@]}" (pr_forest pp_pat_label_colon_pattern) pp_list
| #variable as v  -> fprintf ppf "%a"       pp_variable v
| #const as c     -> fprintf ppf "%a"       pp_const    c
and pp_pat_label ppf (pl:'a pat_label) = 
  match pl with 
    #variable as v -> fprintf ppf "%a" pp_variable v
  | `label_const c -> fprintf ppf "%a" pp_const    c
  | #rpp as      p -> fprintf ppf "%a" pp_rpp      p
and pp_pat_label_colon_pattern ppf ((pl,pat):(('a pat_label)*('a pattern))) =
  fprintf ppf "%a:@,%a" pp_pat_label pl pp_pattern pat


let rec pp_expr ppf (e:'a expr) =
  fprintf ppf "@[@[<hov 2>%a@]@\n@[<hov 2>where@ %a@]@]" pp_action e.action pp_where e.where
and pp_action ppf (a:'a action) =
  match a with
    | `replace(_,t1,t) -> fprintf ppf "@[<hov 2>replace %a@ by %a@]" pp_rep_target t1 pp_template t
    | `replace_in(_,r,v,t1,t2) -> fprintf ppf "@[<hov 2>replace %a -> %a@ by %a@ in %a@]" pp_rpp r pp_rep_target  v pp_template t1 pp_template t2
    | `delete(_,t1)  -> fprintf ppf "@[<hov 2>delete %a@]" pp_rep_target t1
    | `delete_in(_,r,t1,t2)  -> fprintf ppf "@[<hov 2>delete %a -> %a@ in %a@]" pp_rpp r pp_rep_target t1 pp_template t2 
    | `extend(_,t1,t)  -> fprintf ppf "@[<hov 2>extend %a@ with %a@]" pp_rep_target t1 pp_template t
    | `extend_in(_,r,v,t1,t2) -> fprintf ppf "@[<hov 2>extend %a -> %a@ with %a@ in %a@]" pp_rpp r pp_rep_target  v pp_template t1 pp_template t2
    | `query(_,t)      -> fprintf ppf "@[<hov 2>select %a@]" pp_template t
and pp_rep_target ppf (t:'a rep_target) = 
  match t with
    | #variable as v -> fprintf ppf "%a" pp_variable v
    | `tree ((#pat_label as v1),  (#variable as v2)) -> fprintf ppf "{%a:%a}" pp_pat_label v1 pp_variable v2
    | `under ((#pat_label as v1),(#variable as v2),(#variable as v3)) ->
      fprintf ppf "{%a:%a} under %a" pp_pat_label v1 pp_variable v2 pp_variable v3
(*     | `tree (ttlist) -> fprintf ppf "{@[%a@]}"  *)
(* 	(pr_forest pp_tree_label_colon_template) ttlist *)
and pp_where ppf (bl:'a bcond list) = 
  fprintf ppf "@[%a@]" (pr_nl_pseq "," pp_bcond) bl
and pp_bind_cond ppf (bc:'a bind_cond) =
  match bc with
   `pat_in(pat,t) -> fprintf ppf "@[<hov 2>@[%a@] in@ @[%a@]@]" pp_pattern pat pp_template t
and pp_bool_cond ppf (bc:'a bool_cond) = 
  match bc with
    #value_expr as ve -> fprintf ppf "@[%a@]" pp_value_expr ve
and pp_template ppf (t:'a template) = 
  match t with
    `tree (_, ttlist)     -> fprintf ppf "{@[%a@]}" 
	(pr_forest pp_tree_label_colon_template) ttlist
  | #variable as v     -> fprintf ppf "%a" pp_variable v
  | `expr(_,e)           -> fprintf ppf "(%a)" pp_expr e
  | `union (_,t1,t2)     -> fprintf ppf "%a@ U %a" pp_template t1 pp_template t2
  | `app_exp (_,fn,t1)   -> fprintf ppf "%a(@[%a@])" pp_fun_name fn pp_template t1 
  | `let_exp (_,d,t1)    -> fprintf ppf  "@[<hov 2>let@\n%a in@]@\n%a" 
	pp_definition d pp_template t1
  | `letrec_exp (_,dl,t1) -> fprintf ppf "@[<hov 2>letrec@\n%a in@]@\n%a"
	(pr_nl2_seq "and" pp_definition) dl pp_template t1
  | `template_list (_,tl) -> fprintf ppf "(@[%a@])" (pr_forest pp_template) tl
  | `filter (_,bc,t1)    -> fprintf ppf "filter@ %a@ %a" pp_bool_cond bc pp_template t1
  | `ifcond (_,bc,tt,tf) -> fprintf ppf "@[<hv>if @[%a@]@ then @[%a@]@ else @[%a@]@]"
    pp_bool_cond bc pp_template tt pp_template tf
  | `letvalue(_,v,tb,ta) -> fprintf ppf "@[<hov 2>let %a =@ %a in @]@\n%a"
    pp_variable v pp_template tb pp_template ta
  | `i_marker (_,m,t1)   -> fprintf ppf "%a := @[%a@]" pp_marker m pp_template t1
  | `o_marker (_,m)        -> fprintf ppf "%a" pp_marker m
  | `graph_empty _       -> fprintf ppf "()"
  | `graph_union(_,t1,t2)-> fprintf ppf "%a@ (+)  %a" pp_template t1 pp_template t2
  | `graph_append(_,t1,t2)->fprintf ppf "%a@ @@ %a" pp_template t1 pp_template t2
  | `graph_cycle (_,t1)  -> fprintf ppf "cycle(@[%a@])" pp_template t1
  | `srec(_,fn,t1)       -> fprintf ppf "@[<hov 2>rec(%a,@[%a@])@]" pp_fun_name fn pp_template t1
and pp_tree_label_colon_template ppf ((tl,t):(('a tree_label)*('a template))) =
  fprintf ppf "@[%a:@,%a@]" pp_tree_label tl pp_template t
and pp_fun_name ppf (fn:fun_name) =
  match fn with 
    `fun_name s -> fprintf ppf "%s" s
and pp_tree_label ppf (tl:'a tree_label) = 
  match tl with
    #value_expr as ve -> fprintf ppf "%a" pp_value_expr ve
and pp_bcond ppf (bc:'a bcond) = 
  match bc with
    #bind_cond as binc -> fprintf ppf "%a" pp_bind_cond binc
  | #bool_cond as bolc -> fprintf ppf "%a" pp_bool_cond bolc
and pp_definition ppf (d:'a definition) = 
  match d with
    `def bl -> fprintf ppf "sfun @[%a@]" (pr_nl_seq "|" pp_branch) bl
and pp_branch ppf (b:'a branch) =
  match b with
    `branch (fn,a,t) -> 
      fprintf ppf "%a(%a) =@ %a" pp_fun_name fn pp_argument a pp_template t
and pp_argument ppf (a:'a argument) = 
  match a with
    `argument (pl,pat) -> fprintf ppf"{%a}" pp_pat_label_colon_pattern (pl,pat)
and pp_marker ppf (m:marker) =
  match m with
    #marker_variable as mv -> fprintf ppf "%a" pp_marker_variable mv

let pp_table ppf (table:(string*string) list) =
  fprintf ppf "%a" (pp_list (pp_pair pp_string pp_string)) table


let print_expr e = fprintf std_formatter "%a@." pp_expr e

let print_template t = fprintf std_formatter "%a@." pp_template t

let print_table t = fprintf std_formatter "%a@." pp_table t
