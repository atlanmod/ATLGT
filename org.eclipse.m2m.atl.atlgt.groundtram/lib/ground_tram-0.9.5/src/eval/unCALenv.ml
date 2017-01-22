(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
(*
  generic variable environment manipulation module
 *)
open UnCAL

type ('a,'b) glenv   = {
   genv : (vname * 'a) list;
   lenv : (lname * 'b) list;
  }

let emptyEnv_aux : ('a,'b) glenv  = { genv = []; lenv = []; }

let lookupGVar_aux (env: ('a,'b) glenv) (n:vname) =
	(try List.assoc n env.genv with 
	  Not_found ->
	   failwith ("Undefined graph variable "  ^ n))

let lookupLVar_aux (env: ('a,'b) glenv) (n:lname) =
  (try List.assoc n env.lenv with
    Not_found -> failwith ("Unbound label variable "  ^ n))

let intern_gv_aux (vn:vname) (g: 'a) (env: ('a,'b) glenv ) =
  {env with genv=((vn,g)::env.genv);}

let intern_lv_aux (ln:lname) (l: 'b) (env: ('a,'b) glenv ) =
  {env with lenv=((ln,l)::env.lenv);}

let unintern_gv_aux (vn:vname) (env: ('a,'b) glenv ) =
  {env with genv = List.remove_assoc vn env.genv }

let unintern_lv_aux (ln:lname) (env:('a,'b) glenv ) =
  {env with lenv = List.remove_assoc ln env.lenv }

let replace_bindingG_aux  (vn:vname) (g:'a) (env: ('a,'b) glenv) : ('a,'b) glenv =
 {env with genv = UnCALdynenv.replace_binding vn g env.genv;}
let replace_bindingL_aux  (ln:lname) (l:'b) (env: ('a,'b) glenv) : ('a,'b) glenv =
 {env with lenv = UnCALdynenv.replace_binding ln l env.lenv;}
