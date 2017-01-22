(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
open ParseUnCAL
open LexUnCAL
open UnCALDMutil
open EvalUnCAL
open UnCALdynenv
open UnCALSA

let elim_info i = None
let parseUnCAL_file = Parse.parse_file ~parse:ParseUnCAL.entry ~lex:LexUnCAL.token
let parseUnCAL_file f = map_info elim_info (parseUnCAL_file f)

let evalFUnCAL expr = 
  let cons x y = (x::y) in
  let (vflist,expr') = elimDoc expr in
  let dynEnv = 
    {emptyDynEnv with gvenv = 
     List.fold_right 
       (fun (v,f) -> cons (v,(remove_eps (load_db (parseUnCAL_file f))))) vflist [];} in
  eval_with_env dynEnv expr'
  
  

