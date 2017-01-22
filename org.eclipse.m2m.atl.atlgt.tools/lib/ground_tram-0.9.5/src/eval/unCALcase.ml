(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
(* Lift conditional branches in rec body *)
(* The normal form is given by the following syntax:
 * E = {} | {L:E} | E \cup E | () | E \oplus E | $V 
 *   | &M | ($M:=E) | &M@rec(\($V, $T), TE)(E) 
 * TE = {} | if B then E else TE 
 * B = isempty(E) | B boolopB | Ecomp E 
 *   | true | false *)

open UnCAL
open UnCALinfix
open UnCALinline
open ExtSetMap

(* Branches : map from body to predicate *)
module Branches = Map.Make (struct type t = info aexpr let compare = compare end)

let branches_fold2 f abbs1 abbs2 =
  Branches.fold (fun aexp1 br1 ->
                   Branches.fold (fun aexp2 br2 -> f aexp1 br1 aexp2 br2) abbs2) abbs1

let branches_add aexp br brs = match Branches.find_some aexp brs with
  | None -> Branches.add aexp br brs
  | Some b -> Branches.add aexp (b<|>br) brs

let branches_singleton aexp br = Branches.add aexp br Branches.empty

let branches_map f abbs =
  Branches.fold (fun aexp br brs -> branches_add (f aexp) br brs) abbs Branches.empty

exception True_Branch of info aexpr
let branches_to_aexpr branches = try
  Branches.fold (fun aexp br acc ->
                   match br with 
		     ATrue _ -> raise (True_Branch aexp)
                   | _       -> AEIf({annot=None},br,aexp,acc)) branches (AETEmp {annot=None})
with True_Branch aexp -> aexp

let unsupported_expr expr_str =
  failwith ("unsupported branch (abexpr_for_aexpr _ ("^expr_str^")")

let rec aexpr_to_branches abexpr = function
  | AETEmp a -> branches_singleton (AETEmp a) abexpr
  | AEEdg(a,pat,exp) ->
      branches_map (fun aexp -> AEEdg(a,pat,aexp)) (aexpr_to_branches abexpr exp)
  | AEUni(_,exp1,exp2) ->
      branches_fold2
        (fun aexp1 br1 aexp2 br2 -> branches_add (aexp1<+>aexp2) (br1<&>br2))
        (aexpr_to_branches abexpr exp1) (aexpr_to_branches abexpr exp2) Branches.empty
  | AEIMrk(a,mkr,exp) ->
      branches_map (fun aexp -> AEIMrk(a,mkr,aexp)) (aexpr_to_branches abexpr exp)
  | AEOMrk (a,mkr) -> branches_singleton (AEOMrk (a,mkr)) abexpr
  | AEGEmp a -> branches_singleton (AEGEmp a) abexpr 
  | AEDUni(_,exp1,exp2) ->
      branches_fold2
        (fun aexp1 br1 aexp2 br2 -> branches_add (aexp1<++>aexp2) (br1<&>br2))
        (aexpr_to_branches abexpr exp1) (aexpr_to_branches abexpr exp2) Branches.empty
  | AEApnd(a,exp1,exp2) ->
      branches_fold2
        (fun aexp1 br1 aexp2 br2 -> branches_add (AEApnd(a,aexp1,aexp2)) (br1<&>br2))
        (aexpr_to_branches abexpr exp1) (aexpr_to_branches abexpr exp2) Branches.empty
  | AECyc (a,exp) ->
      branches_map (fun aexp -> AECyc(a,aexp)) (aexpr_to_branches abexpr exp)
  | AEVar (_,_) | AEDoc (_,_) as exp -> branches_singleton exp abexpr
  | AEIf(_,abe,exp1,exp2) ->
      let abexp = aexpr_to_branches_ab abe in
      Branches.fold
        (fun aexp1 br1 -> branches_add aexp1 br1)
        (aexpr_to_branches (abexpr<&>abexp) exp1)
        (aexpr_to_branches (abexpr<&>ANot ({annot=None},abexp)) exp2) 
  | AERec(a,l,la,v,va,exp1,exp2) ->
      let e1 = branches_to_aexpr (aexpr_to_branches (ATrue {annot=None}) exp1) in
      branches_map (fun aexp -> AERec(a,l,la,v,va,e1,aexp)) (aexpr_to_branches abexpr exp2)
  | AELet(_,v,_,exp1,exp2) -> failwith "AELet is assumed to be removed"
  | AELLet(_,l,_,pat,exp) -> failwith "AELLet is assumed to be removed"

and aexpr_to_branches_ab = function
  | AIsemp (a,exp) -> AIsemp(a,branches_to_aexpr (aexpr_to_branches (ATrue {annot=None}) exp))
  | ABisim (_,e1,e2) -> failwith "not implemented"
  | ANot (a,abe) ->  ANot(a,aexpr_to_branches_ab abe)
  | AAnd(a,abe1,abe2) ->
      AAnd(a,aexpr_to_branches_ab abe1, aexpr_to_branches_ab abe2)
  | AOr(a,abe1,abe2) ->
      AOr(a,aexpr_to_branches_ab abe1, aexpr_to_branches_ab abe2)
  | ALcmp(_,_,_,_) | ATrue _ | AFalse _ | ALpred(_,_,_) as abe -> abe

let lift_conditional_branches aexpr =
  branches_to_aexpr (aexpr_to_branches (ATrue {annot=None}) (remove_let aexpr))
