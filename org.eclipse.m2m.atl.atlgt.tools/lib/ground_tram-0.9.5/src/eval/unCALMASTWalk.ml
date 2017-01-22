(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
(* Generic walker on maexpr *)
open UnCALMAST
open Fputil
open UnCALDM

(** Apply function [f] to [maexpr] recursively *)
let rec map_maexpr f maexpr =
 let daexpr = match maexpr.daexpr with
    DAETEmp | DAEOMrk _  | DAEGEmp | DAEVar _ -> maexpr.daexpr
  | DAEEdg (mlpat,e)     -> DAEEdg  (mlpat,map_maexpr f e)
  | DAEIMrk    (m,e)     -> DAEIMrk (m,    map_maexpr f e)
  | DAEIf      (b,e)     -> DAEIf   (b,    map_maexpr f e)
  | DAELLet (v,le,e)     -> DAELLet (v,le, map_maexpr f e) 
  | DAECyc        e      -> DAECyc  (      map_maexpr f e)
  | DAEUni   (e1,e2) -> let (e1,e2) = mapT2 (map_maexpr f) (e1,e2) in DAEUni   (e1,e2)
  | DAEDUni  (e1,e2) -> let (e1,e2) = mapT2 (map_maexpr f) (e1,e2) in DAEDUni  (e1,e2)
  | DAEApnd  (e1,e2) -> let (e1,e2) = mapT2 (map_maexpr f) (e1,e2) in DAEApnd  (e1,e2)
  | DAELet (v,e1,e2) -> let (e1,e2) = mapT2 (map_maexpr f) (e1,e2) in DAELet (v,e1,e2)
  | DAERec (l,t,mbody,hub,spoke,s1s1eps,garg,cmpl) ->
      let mbody' = MapofEdge.map (map_maexpr f) mbody in
      let garg'  = map_maexpr f garg in
    DAERec (l,t,mbody',hub,spoke,s1s1eps,garg',cmpl)
in
  f {maexpr with daexpr=daexpr}

(* Ideally the binary expression also has an opportunity to walk through as well *)
(*
and map_mabexpr f mabexpr = 
 let dabexpr = match mabexpr.dabexpr with
    DAIsemp e -> DAIsemp (map_maexpr f e)
  | DANot e  -> DANot (map_mabexpr f e)
  | DAAnd (e1,e2) -> let (e1,e2) = mapT2 (map_mabexpr f) (e1,e2) in DAAnd (e1,e2)
  | DAOr  (e1,e2) -> let (e1,e2) = mapT2 (map_mabexpr f) (e1,e2) in DAOr  (e1,e2)
  | DALcmp x -> DALcmp x
  | DATrue   | DAFalse  -> mabexpr.dabexpr
in { mabexpr with daexpr=daexpr }
*)


  

