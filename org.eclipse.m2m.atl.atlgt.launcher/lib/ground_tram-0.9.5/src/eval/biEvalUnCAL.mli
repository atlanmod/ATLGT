(*	$Id: biEvalUnCAL.mli,v 1.9 2010/09/08 14:57:40 hidaka Exp $	*)

(********************************************************************
		 the bidirectional UnCAL interpreter
 ********************************************************************)

open UnCALdynenv
open UnCALenv
open ECenv
open UnCALDM
open UnCALMAST
open UnCALSAST
open UnCAL

(** evaluation parameter **)
val bwdRecUseT : bool ref
val skolemBulk : bool ref
val saUnreach  : bool ref
val detectInConsistentGVarUpdateInRec : bool ref
val biEvalUnCAL_verbose : bool ref

(** evaluatior for label expressions **)
val bd_fwdL : dynenv -> 'a option alpat  -> 'a option malpat
val bd_bwdL : dynenv -> 'a option malpat -> allit        -> dynenv

(** main evaluator **)
val bd_fwd :  ecenv -> dynenv -> 'a option aexpr  -> 'a option maexpr
val bd_bwd :  dynenv -> 'a option maexpr -> graph        -> dynenv
(** reproducible interface **)
val eval_fwd : ecenv -> dynenv -> 'a option taexpr -> 'a option maexpr
val eval_fwdL : dynenv -> 'a option talpat -> 'a option malpat

(** closure based implementation **)
val bd_eval_top :  dynenv -> 'a option aexpr  -> graph * (graph -> dynenv)
(** reproducible interface **)
val bd_eval :      dynenv -> 'a option taexpr -> graph * (graph -> dynenv)

(** for insertion module **)
exception Eval_Bwd of string
val ebodyEpsExpr : SetofMarker.t -> 'a option aexpr
val dfwd_AERec : expid -> SetofMarker.t -> (SetofEdge.t * SetofEdge.t) ->
    graph MapofEdge.t -> (vtx -> SetofEdge.t) -> (vtx -> SetofEdge.t) ->
    graph -> (graph * SetofVtx.t * SetofEdge.t * SetofEdge.t)
val uplus_cmp    : dynenv -> dynenv   -> dynenv -> dynenv
val biguplus_cmp : dynenv MapofEdge.t -> dynenv -> dynenv
val stripMarker : marker -> marker -> marker
val stripFrE : ('a, 'b) sid -> ('a, 'b) sid
val stripFrE_VEIO : graph -> graph
val decompose_ALBin :             albinop -> allit -> allit -> allit -> allit -> allit * allit
val decompose_AEEdg :             allit -> graph -> graph -> graph -> allit * graph
val decompose_AEApnd :  expid ->  graph -> graph -> graph -> graph -> graph * graph
val decompose_AEUni :             graph -> graph -> graph -> graph -> graph * graph
val decompose_AEDUni :            graph -> graph -> graph -> graph -> graph * graph
val decompose_AECyc :                      graph -> graph -> graph -> graph
val decompose_AEIMrk :           marker -> graph -> graph -> graph -> graph
val decompose_AERec :  expid ->  graph MapofEdge.t ->  SetofVtx.t -> 
  SetofEdge.t ->  SetofEdge.t -> graph -> graph MapofEdge.t
val restore_input_AERec :  lname ->  vname ->  dynenv MapofEdge.t ->  graph -> graph -> graph
val bd_evalL :  dynenv ->  'a option talpat -> allit * (allit -> dynenv)
