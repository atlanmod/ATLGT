(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
(* variables, labels and constants *) 
type 'a variable = [
| `var      of 'a * string
| `doc      of 'a * string
| `database of 'a
]
and 'a label = [`label of 'a * string] 
(* and label_variable = [`label_var of string] *)
and marker_variable = [`marker_var of string]
and fun_name = [`fun_name of string]  (* syntactic sugar *)

type 'a const = [
| `bool   of 'a * bool
| `int    of 'a * int
| `string of 'a * string
| 'a label
]

(* value expression *) 
type 'a value_expr = [
| 'a variable
| 'a const
| `unary  of 'a * unary_op * 'a value_expr
| `binary of 'a * binary_op * 'a value_expr * 'a value_expr
]
and unary_op = [
| `NOT
| `IsEmpty
]
and binary_op = [
| `AND
| `OR
| `EQ	(* equal to *)
| `LT	(* less than *)
| `GT	(* greater than *)
| `CONCAT (* concatenation of string *)
]

(* Patterns *)
type 'a rpp = [			(* RPP ::= *)
| 'a label			(*   Label *)
| `any				(* | _ *)
| `concat of 'a rpp * 'a rpp	(* | (RPP.RPP) *)
| `union  of 'a rpp * 'a rpp	(* | (RPP|RPP) *)
| `option of 'a rpp		(* | RPP? *)
| `star   of 'a rpp		(* | RPP* *)
| `plus   of 'a rpp		(* | RPP* *)
| `not    of 'a rpp		(* | !RPP *)
| `eps                          (* | epsilon *)
]
type 'a pattern = [				(* Pat ::= *)
| `tree of ('a pat_label * 'a pattern) list	(*   { (PE:Pat)* } *)
| 'a variable					(* | Var *)
| 'a const					(* | Const *)
]
and 'a pat_label =	[	(* PE ::= *)
  				(*   Label -- included in RPP *)
				(* | label_variable *)
| 'a variable			(* | LabelVar *)
| `label_const of 'a const 	(* | constant (string,int,bool) labels *)
| 'a rpp			(* | RPP *)
]

(* BC *)
type ('a,'tmpl) _bind_cond = [		(* BindCond ::= *)
(* | `pat_in of pattern * variable	(\*   Pat in Var *\) *)
| `pat_in of 'a pattern * 'tmpl		(*   Pat in Template *)
]
and 'a bool_cond = [
| 'a value_expr
]

(* Query *)
type 'a expr = {		(* Query ::= *)
  action: 'a action;	(*   select Template where (BC)* *)
  where:  'a where }

and 'a action = [
| `replace    of 'a * 'a rep_target * 'a template
| `replace_in of 'a * 'a rpp * 'a rep_target * 'a template * 'a template
| `delete     of 'a * 'a rep_target
| `delete_in  of 'a * 'a rpp * 'a rep_target * 'a template
| `extend     of 'a * 'a rep_target * 'a template
| `extend_in  of 'a * 'a rpp * 'a rep_target * 'a template * 'a template
| `query      of 'a * 'a template
]

and 'a rep_target = [
| 'a variable
| `tree of ('a pat_label * 'a variable)
| `under of ('a pat_label * 'a variable * 'a variable)	(* {$l:$g} under $v *)
]

and 'a where = 'a bcond list

and 'a template = [	                                (* Template ::= *)
| `tree of 'a * ('a tree_label * 'a template) list	(* { (TE:Template)* } *)
| 'a variable				                (* | Var *)
| `expr of 'a * 'a expr			                (* | (Query) | (Edit) *)
(* | `query of query *)
(* | `edit  of edit *)
| `union of 'a * 'a template * 'a template	        (* | (Template U Template) *)
					                (*     -- for example Q4 *)

                                                        (* -- syntactic sugars -- *)

| `app_exp       of 'a * fun_name * 'a template                   (* | Var (Var) *)
| `let_exp       of 'a * 'a definition * 'a template              (* | let h1(...) = ... in ... *)
| `letrec_exp    of 'a * 'a definition list * 'a template         (* | letrec h1(...) = ... and h2 = ... in ... *)
| `template_list of 'a * 'a template list                         (* | (Template1, Template2, ...) *)
| `filter        of 'a * 'a bool_cond * 'a template               (* | for bool expressions in where statement*)
| `ifcond        of 'a * 'a bool_cond * 'a template * 'a template
| `letvalue      of 'a * 'a variable * 'a template * 'a template  (* | let Var = Template in Template *)          
                                                        (* -- graph constructor -- *)
| `i_marker      of 'a * marker * 'a template             (* &x := Template *) 
| `o_marker      of 'a * marker                           (* &y *)
| `graph_empty   of 'a                                    (* () *)
| `graph_union   of 'a * 'a template * 'a template        (* Template (+) Template *)
| `graph_append  of 'a * 'a template * 'a template        (* Template @ Template *)
| `graph_cycle   of 'a * 'a template                      (* cycle(Template) *)
| `srec          of 'a * fun_name * 'a template           (* for temperal use in desugaring *)
]

and 'a tree_label = [	(* TE ::= Label | LabelVar *)
| 'a value_expr	(* extended for computation on labels *)
(*
| label
| label_variable
*)
]

and 'a bcond = [		(* BC ::= *)
| ('a, 'a template) _bind_cond	(*   BindCond *)
| 'a bool_cond		        (* | BoolCond *)
]

(* syntax sugar for Let and Letrec *)
and 'a definition = [
| `def of 'a branch list
]

and 'a branch = [
| `branch of fun_name * 'a argument * 'a template
]

and 'a argument = [
| `argument of 'a pat_label * 'a pattern
]

and marker = [
| marker_variable
]

type 'a bind_cond = ('a,'a template) _bind_cond
