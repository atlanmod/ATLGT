(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
open UnCAL

let fatal_error fname msg = failwith (Format.sprintf "MonaOut.%s: %s" fname msg)

type message = {
  is_valid: bool;
  free_vars: var_name array;
  cnt_example: example option;
  sat_example: example option;
}

and var_name = string

and example = {
  booleans: var_name list;
  univ: (var_name * bin_tree) list;
}
  
and bin_tree = Leaf | Node of var_name * bin_tree * bin_tree

let var_decode = let var_decode_hash = Hashtbl.create 137 in
fun (free_vars:var_name array) str -> try
  Hashtbl.find var_decode_hash str
with Not_found ->
  if String.length str > Array.length free_vars then
    fatal_error "var_decode" ("unknown variable code '"^str^"'")
  else try
    let var_name = free_vars.(String.index str '1') in
    Hashtbl.add var_decode_hash str var_name;
    var_name
  with Not_found ->
    fatal_error "var_decode" ("invalid variable code '"^str^"'")

let var2alpat free_vars v =
  match (var_decode free_vars v) with
  | "DString"  -> ALLit({annot=None},ALStr "stringdata")
  | "DInt"     -> ALLit({annot=None},ALInt 42)
  | v          -> ALLit({annot=None},ALLbl(String.sub v 3 (String.length v-3)))

let rec bt2uncal free_vars = function
  | Leaf -> AETEmp {annot=None}
  | Node(v,t1,t2) -> AEUni({annot=None},AEEdg({annot=None},var2alpat free_vars v, bt2uncal free_vars t1),
                           bt2uncal free_vars t2)

let bt2uncal free_vars = function
  | Leaf -> AETEmp {annot=None}
  | Node(_,t,Leaf) -> bt2uncal free_vars t
  | _ -> fatal_error "bt2uncal" "invalid counter-example"

