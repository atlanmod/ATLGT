(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
open ExtSetMap

(* UnCAL expr Core Algebraic Expression  AST *)
type allit =                                      (* label literal serves as a container *)
    ALLbl of string                               (* ordinary label *)
  | ALStr of string                               (* string  literal *)
  | ALInt of int                                  (* integer literal *)
  | ALFlt of float                                (* float   literal *)
  | ALBol of bool                                 (* boolean literal *) (* EXTENSION *)
  | ALUkn                                         (* unknown literal *) (* EXTENSION *)
  | ALEps                                         (* label for the epsilon edge *)

type 'a aexpr =                                        (* E ::= *)
    AETEmp of 'a                                       (* {} *) (* empty tree constructor *)
  | AEEdg  of 'a * 'a alpat * 'a aexpr                 (* {L:E} *)
  | AEUni  of 'a * 'a aexpr * 'a aexpr                 (* E U E *)
  | AEIMrk of 'a * marker * 'a aexpr                   (* &x := E *)
  | AEOMrk of 'a * marker                              (* &y *)
  | AEGEmp of 'a                                       (* () *) (* empty graph constructor *)
  | AEDUni of 'a * 'a aexpr * 'a aexpr                 (* E (+) E *)  (* disjoint union *)
  | AEApnd of 'a * 'a aexpr * 'a aexpr                 (* E @ E  *)
  | AECyc  of 'a * 'a aexpr                            (* cycle(E) *)
  | AEVar  of 'a * vname                               (* Var *) (* variable reference *)
  | AEDoc  of 'a * string                              (* doc(file) *) (* input UnCAL file *)
  | AEIf   of 'a * 'a abexpr * 'a aexpr * 'a aexpr     (* if B then E else E *)
  | AERec  of 'a * lname * 'a * vname * 'a * 'a aexpr * 'a aexpr (* rec ( \ (LabelVar,Var).E)(E) *)
  | AELet  of 'a * vname * 'a * 'a aexpr * 'a aexpr    (* let Var = E in E *) (* EXTENSION *)
  | AELLet of 'a * lname * 'a * 'a alpat * 'a aexpr    (* llet LabelVar = L in E *) (* EXTENSION *)
and 'a alpat =                                         (* L ::= *) (* label pattern *)
    ALVar of 'a * lname                                (* LabelVar *)  (* label variable reference *)
  | ALLit of 'a * allit                                (* a a \in Label *) (* label literal *)
  | ALBin of 'a * 'a alpat * albinop * 'a alpat        (* L BOP L *)  (* EXTENSION *)
and albinop =
   ALAdd | ALSub | ALMul | ALDiv | ALMod | ALConc      (* + - * / % ^ *)
and 'a abexpr =                                        (* B ::= *) (* boolean expr *)
    AIsemp of 'a * 'a aexpr                            (* isempty(E) *)
  | ABisim of 'a * 'a aexpr * 'a aexpr                 (* bisimilar(E,E) *) (* EXTENSION *)
  | ANot   of 'a * 'a abexpr                           (* not B *) (* EXTENSION *)
  | AAnd   of 'a * 'a abexpr * 'a abexpr               (* B and B *) (* EXTENSION *)
  | AOr    of 'a * 'a abexpr * 'a abexpr               (* B or  B *) (* EXTENSION *)
  | ALcmp  of 'a * 'a alpat * alcmp * 'a alpat         (* L CMP L *) (* EXTENSION *)
  | ATrue  of 'a                                       (* binary literal true *)  (* EXTENSION *)
  | AFalse of 'a                                       (* binary literal false *) (* EXTENSION *)
  | ALpred of 'a * alptype * 'a alpat
and alptype = 
    ALPLbl                                        (* isLabel  *)
  | ALPStr                                        (* isString *)
  | ALPInt                                        (* isInt    *)
  | ALPFlt                                        (* isFloat  *)
  | ALPBol                                        (* isBool   *)
and alcmp =                                       (* comparison operators *) (* EXTENSION *)
    ALOEq                                         (* = *)
  | ALOLt                                         (* < *)
  | ALOGt                                         (* > *)
and marker = string                               (* marker name *)  
and vname = string                                (* variable name *)
and lname = string                                (* label variable name *)

(* type for set of variables (for static analysis) *)
module SetofVname = Set.Make (
  struct 
    type t = vname
    let compare = Pervasives.compare
  end
)

(* type for set of label variables (for static analysis) *)
module SetofLname = Set.Make (
  struct 
    type t = lname
    let compare = Pervasives.compare
  end
)

(* information for each node in syntax trees after parsing *)
type info = { annot: string option }
