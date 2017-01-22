(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
(* AST with materialized data for bidirectional transformation *)
open UnCALDM
open UnCAL
open UnCALSAST
open ECenv

(* We preserve all intermediate results during the forward evaluation
   because we should be able to split result graph 
   according to the results of operand (sub-)expressions. *)

type 'a maexpr = {
  graph  :    graph;  (* result of evaluating taexpr *)
  ecmap  : edge option MapofEdge.t; (* equivalence class mapping for edges *)
  ecenv  : ecenv;     (* maps from label variable to its equivalence class, and graph varaible to ecmap *)
  reach  : bool;      (* false if its output is unreachable *)
  taexpr : 'a taexpr; (* expression evaluated *)
  daexpr : 'a daexpr; (* AST including subexpression and intermediate results *)
} 
and 'a malpat = {     (* alpat equivalent of maexpr *)
  allit  :    allit;
  talpat : 'a talpat;
  dalpat : 'a dalpat;
} 
and 'a mabexpr = {    (* abexpr equivalent of maexpr *)
  tabexpr : 'a tabexpr;
  dabexpr : 'a dabexpr;
}
and  'a daexpr =                         (* E ::= *)
    DAETEmp                              (* {} *) (* empty tree constructor *)
  | DAEEdg  of 'a malpat * 'a maexpr     (* {L:E} *)
  | DAEUni  of 'a maexpr * 'a maexpr     (* E U E *)
  | DAEIMrk of marker    * 'a maexpr     (* &x := E *)
  | DAEOMrk of marker                    (* &y *)
  | DAEGEmp                              (* () *) (* empty graph constructor *)
  | DAEDUni of 'a maexpr * 'a maexpr     (* E (+) E *)  (* disjoint union *)
  | DAEApnd of 'a maexpr * 'a maexpr               (* E @ E  *)
  | DAECyc  of 'a maexpr                           (* cycle(E) *)
  | DAEVar  of vname                               (* Var *) (* variable reference *)
(*  | DAEIf   of 'a mabexpr * 'a maexpr * 'a maexpr *)    (* if B then E else E *)
  | DAEIf   of bool * 'a maexpr (* concrete result and the computations performed *)
  | DAERec  of lname * vname * 'a mbody *
	SetofVtx.t * SetofEdge.t * SetofEdge.t *
 'a maexpr * graph  (* rec ( \ (LabelVar,Var).E)(E) *)
  | DAELet  of vname * 'a maexpr * 'a maexpr         (* let Var = E in E *) (* EXTENSION *)
  | DAELLet of lname * 'a malpat * 'a maexpr         (* llet LabelVar = L in E *) (* EXTENSION *)
and 'a mbody = ('a maexpr) MapofEdge.t
and 'a dalpat =                                    (* L ::= *) (* label pattern *)
    DALVar of lname                                (* LabelVar *)  (* label variable reference *)
  | DALLit of allit                                (* a a \in Label *) (* label literal *)
  | DALBin of 'a malpat * albinop * 'a malpat
and 'a dabexpr =                                   (* B ::= *) (* boolean expr *)
    DAIsemp of 'a maexpr                            (* isempty(E) *)
  | DANot   of 'a mabexpr                           (* not B *) (* EXTENSION *)
  | DAAnd   of 'a mabexpr * 'a mabexpr               (* B and B *) (* EXTENSION *)
  | DAOr    of 'a mabexpr * 'a mabexpr               (* B or  B *) (* EXTENSION *)
  | DALcmp  of 'a malpat * alcmp * 'a malpat         (* L CMP L *) (* EXTENSION *)
  | DATrue                                         (* binary literal true *)  (* EXTENSION *)
  | DAFalse                                        (* binary literal false *) (* EXTENSION *)


(* materialized AST to file *)
let ma2file (xg: 'a maexpr) (file:string) : unit = 
  let oc = open_out_bin file  in
  Marshal.to_channel oc xg [];
  close_out oc

(* file to materialized AST *)
let file2ma (file:string) : 'a maexpr = 
  let is = open_in_bin file in
  let  xg = (Marshal.from_channel is : 'a maexpr) in
  close_in is;
  xg

(* start number of id at the beginning of forward and
   backward evaluation *)
let bd_start_id : int = 1000
  
