(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
(* walking UnQL AST ; utility for UnQL   by S.Hidaka *)
open UnQL

(* variables, labels and constants *) 
let rec mpifo_variable (f : 'a -> 'b) :  'a variable -> 'b variable = function
    `var (a,s) -> `var (f a,s)
  | `doc (a,s) -> `doc (f a,s)
  | `database a -> `database (f a)
and mpifo_label (f : 'a -> 'b) : 'a label -> 'b label = function
    `label (a,s) -> `label (f a,s)
(* and mpifo_label_variable : f -> 'a label_variable -> 'b label_variable  = function *)
(*     `label_var (a,lv) -> `label_var (f a,lv) *)
and mpifo_marker_variable : marker_variable -> marker_variable = function
  `marker_var s -> `marker_var s
and mpifo_fun_name : fun_name -> fun_name = function
    `fun_name s -> `fun_name s
and mpifo_const (f : 'a -> 'b) : 'a const -> 'b const = function
    `bool (a,b) -> `bool (f a,b)
  | `int (a,i) -> `int (f a,i)
  | `string (a,s) -> `string (f a,s)
  | #label as l   -> ((mpifo_label f l) :> 'b const)

(* value expression *) 

let rec mpifo_value_expr (f:'a->'b) : 'a value_expr -> 'b value_expr = function
    #variable as v -> ((mpifo_variable f v) :> 'b value_expr)
  | #const    as c -> ((mpifo_const    f c) :> 'b value_expr)
  | `unary (a,uop,ve') -> `unary (f a,mpifo_unary_op uop, mpifo_value_expr f ve')
  | `binary (a,bop, ve1,ve2) -> `binary (f a,mpifo_binary_op bop,mpifo_value_expr f ve1,mpifo_value_expr f ve2)
and mpifo_unary_op : unary_op -> unary_op = function
    `NOT -> `NOT
  | `IsEmpty -> `IsEmpty
and mpifo_binary_op : binary_op -> binary_op = function
    `AND -> `AND
  | `OR  -> `OR
  | `EQ	 -> `EQ
  | `LT	 -> `LT
  | `GT	 -> `GT
  | `CONCAT -> `CONCAT


(* Patterns *)
let rec mpifo_rpp (f:'a->'b) : 'a rpp -> 'b rpp = function
    #label as l -> ((mpifo_label f l) :> 'b rpp)
  | `any        -> `any
  | `eps        -> `eps
  | `concat (rpp1,rpp2) -> `concat (mpifo_rpp f rpp1, mpifo_rpp f rpp2)
  | `union  (rpp1,rpp2) -> `union  (mpifo_rpp f rpp1, mpifo_rpp f rpp2)
  | `option p -> `option (mpifo_rpp f p)
  | `star p -> `star (mpifo_rpp f p)
  | `plus p -> `plus (mpifo_rpp f p)
  | `not p -> `not (mpifo_rpp f p)

let cross (f,g) : (('a * 'b) -> ('c * 'd))  = function
  (a,b) -> (f a,g b)

let rec mpifo_pattern (f:'a->'b) : 'a pattern -> 'b pattern = function
    `tree pp_list -> `tree (List.map (cross (mpifo_pat_label f,mpifo_pattern f)) pp_list)
  | #variable as v -> ((mpifo_variable f v) :> 'b pattern)
  | #const    as c -> ((mpifo_const    f c) :> 'b pattern)
and mpifo_pat_label (f:'a->'b): 'a pat_label -> 'b pat_label = function
    #variable as v -> ((mpifo_variable f v) :> 'b pat_label)
  | `label_const c -> `label_const (mpifo_const f c)
  | #rpp      as p -> ((mpifo_rpp f p) :> 'b pat_label)

(* Query *)
let rec mpifo_expr (f:'a->'b) : 'a expr -> 'b expr = function
    { action = a; where = bl; } -> { action=mpifo_action f a; where =List.map (mpifo_bcond f) bl; }
and mpifo_action (f:'a->'b) : 'a action -> 'b action = function
    `replace   (a,  rt,t)    -> `replace   (f a,              mpifo_rep_target f rt,mpifo_template f t)
  | `replace_in(a,p,rt,t1,t2)-> `replace_in(f a,mpifo_rpp f p,mpifo_rep_target f rt,mpifo_template f t1,mpifo_template f t2)
  | `delete    (a,  rt)      -> `delete    (f a,              mpifo_rep_target f rt)
  | `delete_in (a,p,rt,t)    -> `delete_in (f a,mpifo_rpp f p,mpifo_rep_target f rt,mpifo_template f t)
  | `extend    (a,  rt,t)    -> `extend    (f a,              mpifo_rep_target f rt,mpifo_template f t)
  | `extend_in (a,p,rt,t1,t2)-> `extend_in (f a,mpifo_rpp f p,mpifo_rep_target f rt,mpifo_template f t1,mpifo_template f t2)
  | `query     (a,t) ->         `query     (f a,                                     mpifo_template f t)
and mpifo_rep_target (f:'a->'b) : 'a rep_target -> 'b rep_target = function
    #variable as v    -> ((mpifo_variable f v) :> 'b rep_target)
  | `tree (v1,v2)     -> `tree  (mpifo_pat_label f v1,mpifo_variable f v2)
  | `under (v1,v2,v3) -> `under (mpifo_pat_label f v1,mpifo_variable f v2,mpifo_variable f v3)
and mpifo_template (f:'a->'b) : 'a template -> 'b template = function
    `tree (a,patlist) -> `tree (f a,List.map (cross (mpifo_tree_label f, mpifo_template f)) patlist)
  | #variable as v -> ((mpifo_variable f v) :> 'b template)
  | `expr  (a,e)    -> `expr (f a,mpifo_expr f e)
  | `union (a,t1,t2)-> `union (f a,mpifo_template f t1,mpifo_template f t2)
  | `app_exp (a,fn,t) -> `app_exp (f a,mpifo_fun_name fn,mpifo_template f t)
  | `let_exp (a,d,t)  -> `let_exp (f a,mpifo_definition f d,mpifo_template f t)
  | `letrec_exp (a,dl,t) -> `letrec_exp (f a,List.map (mpifo_definition f) dl,mpifo_template f t)
  | `template_list (a,tl) -> `template_list (f a,List.map (mpifo_template f) tl)
  | `filter (a,bc,t) ->     `filter (f a,mpifo_bool_cond f bc,mpifo_template f t)
  | `ifcond (a,bc,tt,tf) -> `ifcond (f a,mpifo_bool_cond f bc, mpifo_template f tt, mpifo_template f tf)
  | `letvalue (a,v,tbind,tbody) -> `letvalue (f a,mpifo_variable f v,mpifo_template f tbind,mpifo_template f tbody)
  | `i_marker (a,m,t) -> `i_marker (f a,mpifo_marker m , mpifo_template f t)
  | `o_marker (a,m) -> `o_marker (f a,mpifo_marker m)
  | `graph_empty a -> `graph_empty (f a)
  | `graph_union (a,t1,t2) -> `graph_union (f a,mpifo_template f t1,mpifo_template f t2)
  | `graph_append (a, t1,t2) ->  `graph_append (f a,mpifo_template f t1,mpifo_template f t2)
  | `graph_cycle (a,t) -> `graph_cycle (f a,mpifo_template f t)
  | `srec (a,fn,t)  -> `srec (f a,mpifo_fun_name fn, mpifo_template f t)
and mpifo_tree_label (f:'a->'b) : 'a tree_label -> 'b tree_label = function
    #value_expr as ve -> mpifo_value_expr f ve
(*     #label as l -> ((mpifo_label f l) :> 'b tree_label) *)
(*   | #label_variable as lv -> ((mpifo_label_variable f lv) :> 'b tree_label) *)

and mpifo_bcond (f:'a->'b) : 'a bcond -> 'b bcond = function
     #bind_cond as binc -> ((mpifo_bind_cond f binc) :> 'b bcond)
   | #bool_cond as bolc -> ((mpifo_bool_cond f bolc) :> 'b bcond)
and mpifo_definition (f:'a->'b): 'a definition -> 'b definition = function
    `def bl -> `def (List.map (mpifo_branch f) bl)
and mpifo_branch (f:'a->'b) : 'a branch -> 'b branch = function
  `branch (fn,arg,t) -> `branch (mpifo_fun_name fn, mpifo_argument f arg, mpifo_template f t)
and mpifo_argument (f:'a->'b) : 'a argument -> 'b argument = function
    `argument (pl,pat) -> `argument (mpifo_pat_label f pl, mpifo_pattern f pat)
and mpifo_marker : marker -> marker = function
  #marker_variable as mv -> mpifo_marker_variable mv
(* BC *)
and mpifo_bind_cond (f:'a->'b) : 'a bind_cond -> 'b bind_cond = function
    `pat_in (p,t) -> `pat_in (mpifo_pattern f p,mpifo_template f t)
and mpifo_bool_cond (f:'a->'b) : 'a bool_cond -> 'b bool_cond = function
    #value_expr as ve -> mpifo_value_expr f ve


