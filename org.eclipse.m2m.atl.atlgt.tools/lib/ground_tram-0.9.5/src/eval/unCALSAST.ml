(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
(* UnCAL AST augmented with type infromation *)
open UnCAL
open UnCALDM
open PrintUnCALDM
open UnCALDMutil
open Format


type ltype = 
    SLLbl  (* label   *)
  | SLStr  (* string  *)
  | SLInt  (* integer *)
  | SLFlt  (* float   *)
  | SLBol  (* boolean *)
  | SLEps  (* epsilon edge *)
  | SLUkn  (* unkown  *) (* impossible to statically determine the type in body of rec *)

let pr_ltype ppf = function
    SLLbl  ->  fprintf ppf "%s" "label"
  | SLStr  ->  fprintf ppf "%s" "string"
  | SLInt  ->  fprintf ppf "%s" "int"
  | SLFlt  ->  fprintf ppf "%s" "float"
  | SLBol  ->  fprintf ppf "%s" "bool"
  | SLEps  ->  fprintf ppf "%s" "eps"
  | SLUkn  ->  fprintf ppf "%s" "unkown"

(* I didn't want to materialize the product type X x Y, 
   so tried to maintain unevaluated "expression" as list of set of markers.
   Otherwise the number of elements will be the product of all cardinalities of
   component marker sets  *)

(* X . Y =def { x . y | x \in X, y \in Y }
  {&,&x} . {&,&y} =def {x . y | x \in {&,&x}, y \in {&,&y}}
 = {&.&, &.&y, &x.&, &x.&y} = {&, &y, &x, &x&y}
  {&,&x} . {&y1,y2} =def {x . y | x \in {&,&x}, y \in {&y1,&y2}}
     = {&.&y1,&.&y2,&x.&y1,&x.&y2} = {&y1,&y2, &x&y1,&x.&y2 }
  Property: root marker is eliminated if product of sets
    some of which have no root marker.

   (X1 . Y1) U (X2 . Y2)
    {&x11,&x12}.{&y11,&y12} U {&x21,&x22}.{&y21,&y22}
  = {&x11&y11,&x11&y12,&x12&y11,&x12&y12} U {&x21&y21,&x21&y22,&x22&y21,&x22&y22}
  != (X1 U X2).(Y1 U Y2)
   = {&x11,&x12,&x21,&x22} U {&y11,&y12,&y21,&y22}
   = {&x11&y11,&x11&y12, ... &x11&y22, ... }
  It is impossible to canonicalize to product of sets.
  Maintaining union represantation as expression would cost equally 
  to those materializing product of sets of markers.
*)

type vtype = (SetofMarker.t*SetofMarker.t) (* sets of input and output markers *)
(* pretty printer of vtype *)
let pr_vtype ppf = function
    (setI,setO) ->
      fprintf ppf "(@[%a,@ %a@])" pr_SetofMarker setI pr_SetofMarker setO

type expid = int
let pr_expid ppf i = fprintf ppf "%i" i
    
type 'a taexpr = {
  vtype : vtype;
  aexpr : 'a aexpr;
  saexpr : 'a saexpr;
  expid : expid;
} 
and 'a talpat = {
  ltype : ltype;
  alpat : 'a alpat;
  salpat : 'a salpat;
} 
and 'a tabexpr = {
  abexpr : 'a abexpr;
  sabexpr : 'a sabexpr;
}
and  'a saexpr =                                     (* E ::= *)
    SAETEmp                                          (* {} *) (* empty tree constructor *)
  | SAEEdg  of 'a talpat * 'a taexpr                 (* {L:E} *)
  | SAEUni  of 'a taexpr * 'a taexpr                 (* E U E *)
  | SAEIMrk of marker    * 'a taexpr                 (* &x := E *)
  | SAEOMrk of marker                                (* &y *)
  | SAEGEmp                                          (* () *) (* empty graph constructor *)
  | SAEDUni of 'a taexpr * 'a taexpr                 (* E (+) E *)  (* disjoint union *)
  | SAEApnd of 'a taexpr * 'a taexpr                 (* E @ E  *)
  | SAECyc  of 'a taexpr                             (* cycle(E) *)
  | SAEVar  of vname                                 (* Var *) (* variable reference *)
  | SAEIf   of 'a tabexpr * 'a taexpr * 'a taexpr    (* if B then E else E *)
  | SAERec  of lname * vname * 'a taexpr * 'a taexpr (* rec ( \ (LabelVar,Var).E)(E) *)
  | SAELet  of vname * 'a taexpr * 'a taexpr         (* let Var = E in E *) (* EXTENSION *)
  | SAELLet of lname * 'a talpat * 'a taexpr         (* llet LabelVar = L in E *) (* EXTENSION *)
and 'a salpat =                                      (* L ::= *) (* label pattern *)
    SALVar of lname                                  (* LabelVar *)  (* label variable reference *)
  | SALLit of allit                                  (* a a \in Label *) (* label literal *)
  | SALBin of 'a talpat * albinop * 'a talpat
and 'a sabexpr =                                     (* B ::= *) (* boolean expr *)
    SAIsemp of 'a taexpr                             (* isempty(E) *)
  | SABisim of 'a taexpr * 'a taexpr                 (* bisimilar(E,E) *) (* EXTENSION *)
  | SANot   of 'a tabexpr                            (* not B *) (* EXTENSION *)
  | SAAnd   of 'a tabexpr * 'a tabexpr               (* B and B *) (* EXTENSION *)
  | SAOr    of 'a tabexpr * 'a tabexpr               (* B or  B *) (* EXTENSION *)
  | SALcmp  of 'a talpat * alcmp * 'a talpat         (* L CMP L *) (* EXTENSION *)
  | SATrue                                           (* binary literal true *)  (* EXTENSION *)
  | SAFalse                                          (* binary literal false *) (* EXTENSION *)
  | SALpred of alptype * 'a talpat

let default_expid = -1
