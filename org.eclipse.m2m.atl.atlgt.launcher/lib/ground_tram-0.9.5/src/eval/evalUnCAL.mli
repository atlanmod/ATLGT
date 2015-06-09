(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
(********************************************************************
		an UnCAL interpreter (unidirectional)
 ********************************************************************)

open UnCALdynenv
open UnCALDM
open UnCAL
open UnCALSA
open UnCALSAST

(* functions on environments *)
val dynenv2stenv : dynenv -> stenv

(* rec semantics flag (bulk/recursive) *)
val evalRecRecursive : bool ref

(* using hub node in recursive semantics *)
val skolemRec : bool ref

(* if true, recursive semantics uses minimum nodes for base_s1 *)
val recShrinkBaseS1 : bool ref

(* if true, use node id based on lexical position *)
val useTransNodeId : bool ref

(* optimization flag *)
val optApndRecRecursive : bool ref
val pruneBulk :           bool ref
val cleanAfterBulk :      bool ref
val optTCRec :            bool ref

(* main interpreter *)
val eval_with_env :   dynenv -> 'a option aexpr -> graph
val eval_unCAL :       graph -> 'a option aexpr -> graph
val load_db :                   'a option aexpr -> graph

(* auxiliary interpreter *)
val eval      :       dynenv -> 'a option taexpr   -> graph
val eval_Bexp :       dynenv -> 'a option tabexpr  -> bool
val eval_L_with_env : dynenv -> 'a option alpat    -> allit

