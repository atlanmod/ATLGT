(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
open Format
open PrintUnCAL
open PrintUnCALDM
open Fputil
open UnCAL
open UnCALDM

type dynenv = {
  gvenv : (vname * graph) list;
  lvenv : (lname * allit) list;
}

(* initial (empty) data graph variable and label variable binding environment *)
let emptyDynEnv = { gvenv = []; lvenv = [];}

let pr_dynenv ppf env =
  fprintf ppf "{@[gvenv=[%a];@ lvenv=[%a]@]}"
    (pr_list (pr_pair pr_vname pr_graph)) env.gvenv
    (pr_list (pr_pair pr_lname pr_allit)) env.lvenv

(*
val emptyDynEnv : dynenv
val intern_gv : vname -> graph -> dynenv -> dynenv
val intern_lv : lname -> allit -> dynenv -> dynenv
val lookupVar :  dynenv -> vname -> graph
val lookupLVar : dynenv -> lname -> allit
val unintern_gv : vname -> dynenv -> dynenv
val unintern_lv : lname -> dynenv -> dynenv
*)
let lookupVar env n =
	(try List.assoc n env.gvenv with 
	  Not_found -> 
	   failwith ("lookupVar: Undefined variable "  ^ n))

let lookupLVar env n =
  (try List.assoc n env.lvenv with
    Not_found -> failwith ("lookupLVar: Unbound label variable "  ^ n))

let intern_gv (vn:vname) (g:graph) (env:dynenv) = 
  {env with gvenv=((vn,g)::env.gvenv);}

let intern_lv (ln:lname) (l:allit) (env:dynenv) = 
  {env with lvenv=((ln,l)::env.lvenv);}

let unintern_gv (vn:vname) (env:dynenv) = 
  {env with gvenv = List.remove_assoc vn env.gvenv }

let unintern_lv (ln:lname) (env:dynenv) = 
  {env with lvenv = List.remove_assoc ln env.lvenv }

(*
val replace_bindingG : vname -> graph -> dynenv -> dynenv
val replace_bindingL : lname -> allit -> dynenv -> dynenv
*)

(** updating bindings **)
let replace_binding (sym:string) (value:'b) (lst: (string*'b) list ) : (string * 'b) list = 
  let rec rb = function
      []                -> failwith ("no binding found for " ^ sym)
    | ((v',_) as x)::xs -> if v' = sym then (sym,value)::xs else x::(rb xs)
  in rb lst

let replace_bindingG  (v:vname) (g:graph) (rho:dynenv) : dynenv =
 {rho with gvenv = replace_binding v g rho.gvenv;}
let replace_bindingL (v:lname) (l:allit) (rho:dynenv) : dynenv =
 {rho with lvenv = replace_binding v l rho.lvenv;}

