(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
(* translation from UnCAL to OCaml functions *)
open UnCAL
open UnCALSAST
open UnCALDM
open UnCALdynenv

val xlate :                      'a        taexpr -> dynenv -> graph
val xlate_with_env :   dynenv ->  'a option aexpr -> dynenv -> graph
val xlate_L :                    'a        talpat -> dynenv -> allit 
val xlate_L_with_env : dynenv -> 'a option  alpat -> dynenv -> allit
val xlate_Bexp :                'a        tabexpr -> dynenv -> bool

(** main translator **)
val xlate_unCAL :  graph -> 'a option aexpr -> dynenv -> graph

(** evaluation function using translator **)
val xeval_unCAL :  graph -> 'a option aexpr           -> graph
