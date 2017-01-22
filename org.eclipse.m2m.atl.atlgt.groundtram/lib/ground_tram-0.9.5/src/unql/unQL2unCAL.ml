(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
open UnQL
open UnCAL
open DesugarUnQL
open PrintUnQL

let initAnno = ()
(* two variable names used in definiting the the function in AERec *)
let label_var_name = (initAnno,"$L")
let graph_var_name = (initAnno,"$T")

(*******************************************************
 flatten is to remove letrec via tupling transformation 
 ******************************************************)

let rec flatten (e:'a expr) : 'a expr = match e.action with
  | `query (a,t) -> { e with action = `query(a,tupling_t t) }
  | _ -> e

and tupling_t  (t:'a template) : 'a template = match t with 
  | `tree(a,tts) -> `tree(a,List.map (fun (l,t) -> (l, tupling_t t)) tts)
  | #variable -> t
  | `expr (a,e) -> `expr(a,flatten e)
  | `union(a,t1,t2) -> `union(a,tupling_t t1, tupling_t t2)
  | `app_exp(a,f,t) -> `app_exp(a,f,tupling_t t)
  | `let_exp(a,d,t) -> `let_exp(a,tupling_d d, tupling_t t)
  | `letrec_exp(a,ds,t) -> let (d1,t1)=tuple_recs (List.map tupling_d ds) (tupling_t t) in
      `let_exp(a,d1,t1)
  | `filter(a,b,t) -> `filter(a,b, tupling_t t)
  | `ifcond (a,bl,t1,t2) -> `ifcond (a,bl, tupling_t t1, tupling_t t2)
  | `letvalue(a,v,t1,t2) -> `letvalue(a,v, tupling_t t1, tupling_t t2)
  | `template_list (a,ts) -> `template_list (a,List.map tupling_t ts)
  | `i_marker(a,m,t) -> `i_marker(a,m, tupling_t t)
  | `o_marker(a,m) -> `o_marker(a,m)
  | `graph_empty a -> `graph_empty a
  | `graph_union(a,t1,t2) -> `graph_union(a,tupling_t t1, tupling_t t2)
  | `graph_append(a,t1,t2) -> `graph_append(a,tupling_t t1, tupling_t t2)
  | `graph_cycle (a,t) -> `graph_cycle (a,tupling_t t)
  | t -> t

and tupling_d ((`def bs):'a definition) : 'a definition = `def (List.map tupling_b bs)

and tupling_b (`branch(f,a,t):'a branch) : 'a branch = `branch(f,a,tupling_t t)

and tuple_recs (ds: 'a definition list) (t: 'a template) 
    : ('a definition*'a template) = 
  let (ds':'a definition list) = List.map norm_def ds in
  let (fs:string list) = List.map f_name_in_def ds' in
  let fs_no = List.length fs in 
  let tupled_fun_name = String.concat "_" fs in
  let zs = gen_zs fs_no in
  let assoc_f_z = (* List.combine *) List.map2 (fun a b -> (a,b)) fs zs in
  let atss = List.map (fun (`def bs) -> 
			 (List.map (fun (`branch(_,a,t)) 
				      -> (a,apply_st assoc_f_z t)) bs)) ds' in
  let ats' = merge_atss atss assoc_f_z in 
  let t' = f_in_tupled_form assoc_f_z tupled_fun_name t in
  let d' =
    `def (List.map (fun (a,ts) -> 
		      `branch(`fun_name tupled_fun_name,
			      a, 
			      `template_list (initAnno, List.map2 (fun z t -> `i_marker(initAnno,`marker_var z,t)) zs ts))) ats') in
    (d',t')

and norm_def (`def bs : 'a definition) =
  let bs1 = List.sort cmp_b bs in 
    `def bs1

(* for sorting branches according the the argument *)
and cmp_b (`branch(_,`argument(l1,_),_)) (`branch(_,`argument(l2,_),_)) = cmp_l l1 l2

and cmp_l (l1:'a pat_label) (l2:'a pat_label) = 
  match (l1,l2) with
    | (#label, `var _) -> -1 (* 'label before `var *)
    | (`var _, #label) -> 1
    | (`label(_,l1),`label(_,l2)) | (`var(_,l1),`var(_,l2)) -> compare l1 l2
    |_ -> failwith "Labels are imcomparable in tupling."
      
and f_name_in_def (d:'a definition) : string =
  match d with
    | `def (`branch (`fun_name f,_,_) :: _) -> f
    | `def [] -> failwith "Empty body in definition."

and gen_zs (n:int) : string list = 
  if n=0 then [] else gen_zs (n-1) @ ["&z" ^ string_of_int (fresh())]

and apply_st (table: (string*string) list) (t: 'a template) : 'a template =
(*   (print_string "apply_st:"; print_table table; print_string " ,";print_template t;); *)
  match t with
      | `tree (a,tts) -> `tree (a,(List.map (fun (l,t) -> (l, apply_st table t)) tts))
      | #variable -> t
      | `expr(a1,({action=`query (a2,t)} as e)) -> `expr(a1,{e with action=`query(a2,apply_st table t)})
      | `union(a,t1,t2) -> `union(a,apply_st table t1, apply_st table t2)
      | `app_exp(a,`fun_name f,`var x) -> `o_marker (a,`marker_var (List.assoc f table))
(*       | `let_exp(d,t) -> `let_exp(apply_st_d table d, apply_st table t) *)
(*       | `let_exp(d,t) -> tupling_t(`let_exp(d, t)) *)
(*       | `letrec_exp(ds,t) -> `letrec_exp(List.map (apply_st_d table) ds, apply_st table t) *)
(*       | `letrec_exp(ds,t) -> tupling_t(`letrec_exp(ds, t)) *)
      | `filter(a,b,t) -> `filter(a,b, apply_st table t)
      | `ifcond (a,bl,t1,t2) -> 
	  `ifcond (a,bl, apply_st table t1, apply_st table t2)
      | `letvalue(a,v,t1,t2) -> 
	  `letvalue(a,v, apply_st table t1, apply_st table t2)
      | `template_list (a,ts) -> `template_list (a,List.map (apply_st table) ts)
      | `i_marker(a,m,t) -> `i_marker(a,m, apply_st table t)
      | `o_marker(a,m) -> `o_marker(a,m)
      | `graph_empty a -> `graph_empty a
      | `graph_union(a,t1,t2) -> 
	  `graph_union(a,apply_st table t1, apply_st table t2)
      | `graph_append(a,t1,t2) -> 
	  `graph_append(a,apply_st table t1, apply_st table t2)
      | `graph_cycle (a,t) -> `graph_cycle (a,apply_st table t)
      | t -> t

and merge_atss (atss: ('a argument*'a template) list list) (table: (string*string) list) 
    : ('a argument*'a template list) list =
  (* we assume that each definition is endded with the branch of the form {l:T} -> t *)
  let rec merge2 (ats1: ('a argument*'a template) list) (ats2: ('a argument*'a template list) list)
      : ('a argument*'a template list) list =
    let `argument(lx1, px1), tx1 = List.hd (List.rev ats1) in
    let `argument(lx2, px2), txs2 = List.hd (List.rev ats2) in
    let x1 = match lx1 with
	  | `var x -> x
	  | _ -> failwith "A label variable is expected in tupling." in
    let x2 =  match lx2 with
      | `var x -> x
      | _ -> failwith "A label variable is expected in tupling." in
      match ats1, ats2 with
	| [_], [_] 
	    -> [(`argument(`var x1, px1), tx1::txs2)] 
	| (`argument(`label l1, p1),t1)::ats1', (`argument(`label l2, p2),ts2)::ats2'
	    -> 
	    if l1<l2 then 
	      (`argument(`label l1, p1), t1::List.map (replace_label x2 l1) txs2) :: merge2 ats1' ats2
	    else if l1>l2 then 
	      (`argument(`label l2, p2), replace_label x1 l2 tx1::ts2) :: merge2 ats1 ats2'  
	    else
	      (`argument(`label l1, p1), t1::ts2) :: merge2 ats1' ats2'
	| (`argument(`label l1, p1),t1)::ats1', [_]
	    -> 
	    (`argument(`label l1, p1), t1::List.map (replace_label x2 l1) txs2) :: merge2 ats1' ats2
	| [_], (`argument(`label l2, p2),ts2)::ats2'
	    -> 
	    (`argument(`label l2, p2), replace_label x1 l2 tx1::ts2) :: merge2 ats1 ats2'
	| _ -> failwith "Cannot merge different branches in tupling"
  in 
    match atss with
      | [] -> failwith "Function definition has no branch."
      | [ats] -> List.map (function (a,t) -> (a,[t])) ats
      | ats :: atss' -> merge2 ats (merge_atss atss' table)

and f_in_tupled_form (table:(string*string) list) (tupled_name:string) (t:'a template) : 'a template = match t with
  | `tree (a,tts) -> `tree (a,(List.map (fun (l,t) -> (l, f_in_tupled_form table tupled_name t)) tts))
  | #variable -> t
  | `expr(a1,({action=`query (a2,t)} as e)) ->
      `expr(a1,{e with action = `query(a2,f_in_tupled_form table tupled_name t)})
  | `union(a,t1,t2) -> `union(a,f_in_tupled_form table tupled_name t1, f_in_tupled_form table tupled_name t2)
  | `app_exp(a,`fun_name f,t) ->
      if List.mem_assoc f table then
	let v = List.assoc f table in
	`graph_append(a, `o_marker (initAnno,`marker_var v), `srec(initAnno,`fun_name tupled_name, f_in_tupled_form table tupled_name t))
      else
	`app_exp(a,`fun_name f, f_in_tupled_form table tupled_name t)
  | `let_exp(a,d,t) -> `let_exp(a,f_in_tuped_form_d table tupled_name d, f_in_tupled_form (List.remove_assoc (f_name_in_def d) table) tupled_name t)
  | `letrec_exp(a,ds,t) ->
      let rec remove_assocs xs table =
	match xs with
	  | [] -> table
	  | x::xs' -> List.remove_assoc x (remove_assocs xs' table) in
      let table' = remove_assocs (List.map f_name_in_def ds) table in
      `letrec_exp(a,(List.map (f_in_tuped_form_d table tupled_name)) ds, f_in_tupled_form table' tupled_name t)
  | `filter(a,b,t) -> `filter(a,b, f_in_tupled_form table tupled_name t)
  | `ifcond (a,bl,t1,t2) -> `ifcond (a,bl, f_in_tupled_form table tupled_name t1, f_in_tupled_form table tupled_name t2)
  | `letvalue(a,v,t1,t2) -> `letvalue(a,v, f_in_tupled_form table tupled_name t1, f_in_tupled_form table tupled_name t2)
  | `template_list (a,ts) -> `template_list (a,List.map (f_in_tupled_form table tupled_name) ts)
  | `i_marker(a,m,t) -> `i_marker(a,m, f_in_tupled_form table tupled_name t)
  | `o_marker(a,m) -> `o_marker(a,m)
  | `graph_empty a -> `graph_empty a
  | `graph_union(a,t1,t2) -> `graph_union(a,f_in_tupled_form table tupled_name t1, f_in_tupled_form table tupled_name t2)
  | `graph_append(a,t1,t2) -> `graph_append(a,f_in_tupled_form table tupled_name t1, f_in_tupled_form table tupled_name t2)
  | `graph_cycle (a,t) -> `graph_cycle (a,(f_in_tupled_form table tupled_name t))
  | t -> t

and f_in_tuped_form_d table tupled_name  (`def bs) = `def (List.map (f_in_tuped_form_b table tupled_name) bs)

and f_in_tuped_form_b table tupled_name (`branch(f,a,t)) = `branch(f,a,f_in_tupled_form table tupled_name t)

and replace_label (x:'a*string) (c:'a*string) (t:'a template) : 'a template = match t with
  | `tree (a,tts) -> `tree (a,(List.map (fun (l,t) -> ((if l = `var x then `label c else l),
						     replace_label x c t))
			  tts))
  | `var s -> `var s
  | `expr (a,e) -> begin match e.action with
      | `query (a',t') -> `expr (a,{e with action=`query (a', replace_label x c t')})
      | _ -> failwith "error in replace_label: not query"    end 
  | `union(a,t1,t2) -> `union(a,replace_label x c t1, replace_label x c t2)
  | `app_exp(a,f,t) -> `app_exp(a,f,replace_label x c t)
  | `let_exp(a,d,t) -> `let_exp(a,replace_label_d x c d, replace_label x c t)
  | `letrec_exp(a,ds,t) -> `letrec_exp(a,(List.map (replace_label_d x c)) ds, replace_label x c t)
  | `filter(a,b,t) -> `filter(a,b, replace_label x c t)
  | `ifcond (a,bl,t1,t2) -> `ifcond (a,bl, replace_label x c t1, replace_label x c t2)
  | `letvalue(a,v,t1,t2) -> `letvalue(a,v, replace_label x c t1, replace_label x c t2)
  | `template_list (a,ts) -> `template_list (a,List.map (replace_label x c) ts)
  | `i_marker(a,m,t) -> `i_marker(a,m, replace_label x c t)
  | `o_marker(a,m) -> `o_marker(a,m)
  | `graph_empty a -> `graph_empty a
  | `graph_union(a,t1,t2) -> `graph_union(a,replace_label x c t1, replace_label x c t2)
  | `graph_append(a,t1,t2) -> `graph_append(a,replace_label x c t1, replace_label x c t2)
  | `graph_cycle (a,t) -> `graph_cycle (a,(replace_label x c t))
  | t -> t

and replace_label_d (x:'a*string) (c:'a*string) (`def bs) = `def (List.map (replace_label_b x c) bs)

and replace_label_b (x:'a*string) (c:'a*string) (`branch(f,a,t)) = `branch(f,a,replace_label x c t)


(*********************************************************************
   qlx2cal is to map a desugared unQL template (select part) 
   to that in unCAL. A desugared unQL template should have
   - no where-clause
   - no letrec 
   - no application of a function_name to a template
 ***********************************************************************)

let rec qlx2cal (env:(string * (('a*string)*('a*string)*'a aexpr)) list) (t : 'a template)
    : 'a aexpr = 
(*   (print_string "qlx2cal:"; print_template t;print_string "\n"); *)
  match t with
    | `tree (ann,tts) ->
	List.fold_right (fun a r -> AEUni(ann,a,r))
	  (List.map (fun (l,t) -> AEEdg(ann,label2alpat l, qlx2cal env t)) tts)
	  (AETEmp (initAnno))
    | `var (a,s) -> AEVar (a,s)
    | `doc (a,s) -> AEDoc (a,s)
    | `database a -> AEVar (a,"$db")
    | `expr(_, {action=`query (_,t)}) -> qlx2cal env t
    | `expr _ -> failwith "qlx2cal: not desugared"
    | `union(a,t1,t2) -> AEUni(a, qlx2cal env t1, qlx2cal env t2)
    | `app_exp(a,`fun_name f, t) ->
	let ((a_l,l),(a_p,p),e) = try List.assoc f env
        with Not_found -> failwith (Format.sprintf "Unknown function (%s)" f) in
	AERec(a, l, a_l, p, a_p, e, qlx2cal env t)
    | `let_exp(_, d,t) -> qlx2cal (addEnv d env) t
    | `letrec_exp(_,ds,t) -> failwith "Explicit (mutual) recursion should not exist after tupling."
    | `template_list (an,ts) ->
	List.fold_right (fun a r -> AEDUni(an,a,r))
	  (List.map (qlx2cal env) ts)
	  (AEGEmp initAnno)
    | `filter (a,b,t) -> AEIf (a, bool_cond2abexpr b, qlx2cal env t, AETEmp initAnno)
    | `ifcond (a,b,t1,t2) ->
	AEIf (a,bool_cond2abexpr b, qlx2cal env t1, qlx2cal env t2)
    | `letvalue (a, ((`var (x_a,x)):'a variable),t1,t2) ->
	AELet(a, x, x_a, qlx2cal env t1, qlx2cal env t2)
    | `letvalue (a,((`database d_a) :'a variable),t1,t2) ->
	AELet(a, "$db", d_a, qlx2cal env t1, qlx2cal env t2)
    | `letvalue (a, ((`doc _):'a variable),_,_) ->
        failwith "`doc' cannot be used as a bound variable."
    | `i_marker(a,`marker_var x,t) -> AEIMrk(a,x, qlx2cal env t)
    | `o_marker(a, `marker_var x) -> AEOMrk (a,x)
    | `graph_empty a -> AEGEmp a 
    | `graph_union(a, t1,t2) -> AEDUni(a, qlx2cal env t1, qlx2cal env t2)
    | `graph_append(a,t1,t2) -> AEApnd(a,qlx2cal env t1, qlx2cal env t2)
    | `graph_cycle (a,t) -> AECyc(a, qlx2cal env t)
    | `srec (a,`fun_name f, t) ->
	let ((l_a,l_var),(g_a,g_var),e) = List.assoc f env in
	  AERec(a, l_var, l_a, g_var, g_a, e, qlx2cal env t)

and  bool_cond2abexpr (b: 'a bool_cond) : 'a abexpr = 
  match b with
    | `unary(a,`NOT,b1) -> ANot (a, bool_cond2abexpr b1)
    | `unary(a,`IsEmpty,b1) -> 
	(match b1 with 
	  `var (a',s) -> AIsemp (a,AEVar (a',s))
	| _ -> failwith "isempty other than variable argument is not implemented")
    | `binary(a,`AND,b1,b2) -> AAnd(a,bool_cond2abexpr b1, bool_cond2abexpr b2)
    | `binary(a,`OR,b1,b2) -> AOr(a,bool_cond2abexpr b1, bool_cond2abexpr b2)
    | `binary(a,`EQ,vc1,vc2) -> ALcmp(a,vc2alpat vc1, ALOEq, vc2alpat vc2)
    | `binary(a,`LT,vc1,vc2) -> ALcmp(a,vc2alpat vc1, ALOLt, vc2alpat vc2)
    | `binary(a,`GT,vc1,vc2) -> ALcmp(a,vc2alpat vc1, ALOGt, vc2alpat vc2)
    | `bool(a,true) -> ATrue a
    | `bool(a,false) -> AFalse a
    | _ -> failwith "incorrect boolean expression"

and vc2alpat (vc: 'a bool_cond) : 'a alpat =
  match vc with
    | `var (a,x) ->ALVar (a,x) 
    | #const as c -> ALLit (initAnno, const2allit c)
    | _ -> failwith "comparison cannot be defined on complicated boolean expression"

and label2alpat l = value_expr2alpat l

and value_expr2alpat = function
  | `var (a,x) -> ALVar (a,x)
  | #const as c -> ALLit (initAnno, const2allit c)
  | `binary(a, `CONCAT,l1,l2) -> ALBin(a, label2alpat l1, ALConc, label2alpat l2)
  | _ -> failwith "value_expr2alpat: not implemented yet (for value_expr)"

and const2allit = function
  | `bool (a,b) -> ALBol(b)
  | `int (a,i) -> ALInt(i)
  | `string (a,s) -> ALStr s
  | `label (a,l) -> ALLbl(l)

and addEnv 
    (d:'a definition) 
    (env:(string * (('a*string)*('a*string)*'a aexpr)) list) =
  let f = f_name_in_def d in
  let `def bs = d in
  let ats = List.map (fun (`branch(_,a,t)) -> (a,t)) bs in
  let (l_var:'a*string) =
    match List.filter (fun (`argument(l,_),_) -> has_label_var l) ats with
      | [] -> label_var_name
      | (`argument(`var x,_),_) :: _ -> x
      | _ -> failwith "labels in branch definitions are not in a simplified form" in
  let (g_var:'a*string) =
    match List.filter  (fun (`argument(_,p),_) -> has_pattern_var p) ats with
      | [] -> graph_var_name
      | (`argument(_,`var x),_) :: _ -> x
      | _ -> failwith "patterns in branch definitions are not in a simplified form" in
  let (if_exp:'a aexpr) = ats2if ats env (l_var,g_var) in
    (f,(l_var,g_var,if_exp)) :: env

and has_label_var = function
  | `var _ -> true
  | _ -> false

and has_pattern_var = function
  | `var _ -> true
  | _ -> false

and ats2if 
    (ats:('a argument*'a template) list) 
    (env:(string * (('a*string)*('a*string)*'a aexpr)) list) 
    ((l_a,l_var),(g_a,g_var)) : 'a aexpr =
  match ats with
    | [] ->
	AETEmp initAnno
    | [(`argument(`label (_,l), `var _),(`template_list (a1,[`i_marker(a, `marker_var x,t)])))] -> (* for single leterc *)
	AEIf (initAnno, 
	      ALcmp (initAnno, ALVar (l_a,l_var), ALOEq, ALLit (initAnno, ALLbl l)), (* l_var == l *)
	      qlx2cal env (`template_list (a1,[`i_marker(a,`marker_var x,t)])),
	      AEIMrk(a, x, AETEmp initAnno))
    | (`argument(`label (_,l), `var _),t) :: ats' ->
	AEIf (initAnno, 
	      ALcmp (initAnno, ALVar (l_a,l_var), ALOEq, ALLit (initAnno, ALLbl l)), (* l_var == l *)
	      qlx2cal env t,
	      ats2if ats' env ((l_a,l_var),(g_a,g_var)))
    | (`argument(`label _, #const),t) :: ats' -> failwith "constant graph patterns should be desugared."
    | (`argument(`label_const c, _),t) :: ats' ->
	AEIf (initAnno, 
	      ALcmp (initAnno, ALVar (l_a,l_var), ALOEq, ALLit (initAnno, const2allit c)), (* l_var == c *)
	      qlx2cal env t,
	      ats2if ats' env ((l_a,l_var),(g_a,g_var)))
    | [`argument(`var _, _),t] -> qlx2cal env t
    | _ -> failwith "fail to eliminate pattern matching with if_exp and srec"


(*****************
   Main function 
unQL2unCAL : transform UnQL.expr into UnCAL.allit aexpr

 ******************)

let rec unQL2unCAL (e : 'a expr) =
  let e1 = desugar_i e in
(*   let e1 = desugar e in *)
  let e2 = flatten e1 in
  let e3 = match e2.action with
    | `query (_,t) -> qlx2cal [] t
    | _ -> failwith "unQL2unCAL: fatal error" in
  e3


let rec unQL2unCAL_cleanup (e : 'a expr) =
  let rec cleanup f = match f with
    | AEIf (_,ATrue _,  e, _)
    | AEIf (_,AFalse _, _, e)
    | AEUni (_,AETEmp _ ,e)
    | AEUni (_, e,AETEmp _ ) ->  cleanup e
    | AEDUni (_,AEGEmp _,e)
    | AEDUni (_,e,AEGEmp _) ->  cleanup e
    | AEIf (a, b, e1, e2) -> AEIf(a, b, cleanup e1, cleanup e2)
    | AEUni (a,e1,e2)  -> AEUni(a,cleanup e1, cleanup e2)
    | AEDUni (a,e1,e2) -> AEDUni(a,cleanup e1, cleanup e2)
    | AETEmp _ 
    | AEOMrk _
    | AEVar _
    | AEDoc _
    | AEGEmp _ -> f
    | AEEdg (a,pat,e) -> AEEdg(a,pat, cleanup e)
    | AEIMrk (a,m,e)  -> AEIMrk(a, m, cleanup e)
    | AEApnd (a,e1,e2) -> AEApnd(a,cleanup e1, cleanup e2)
    | AECyc (a,e)        -> AECyc(a, cleanup e)
    | AERec  (a1,l,a2,v,a3,e1,e2) -> AERec(a1,l, a2, v, a3, cleanup e1, cleanup e2)
    | AELet (a,v,a_v,e1,e2) -> AELet(a,v, a_v,cleanup e1, cleanup e2)
    | AELLet (a,l,a_l,lp,e) -> AELLet(a,l, a_l,lp, cleanup e)
  in
    cleanup (unQL2unCAL e)
