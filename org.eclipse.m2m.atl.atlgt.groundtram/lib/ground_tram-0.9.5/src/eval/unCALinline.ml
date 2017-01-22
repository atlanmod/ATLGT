(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
(* inline expansion of let and llet for UnCAL *)
open UnCAL
open UnCALinfix
open ExtSetMap

module VarEnv = Map.Make(struct type t = vname let compare = compare end)
module LVarEnv = Map.Make(struct type t = lname let compare = compare end)

type env = {
  var: info aexpr VarEnv.t;
  lvar: info alpat LVarEnv.t;
}

let rec remove_let env = function
  | AETEmp _ | AEOMrk (_,_) | AEGEmp _ | AEDoc (_,_) as exp -> exp
  | AEEdg(a,pat,exp) -> AEEdg(a,pat,remove_let env exp)
  | AEUni(_,exp1,exp2) -> remove_let env exp1 <+> remove_let env exp2
  | AEIMrk(a,mkr,exp) -> AEIMrk(a,mkr,remove_let env exp)
  | AEDUni(_,exp1,exp2) -> remove_let env exp1 <++> remove_let env exp2
  | AEApnd(a,exp1,exp2) -> AEApnd(a,remove_let env exp1,remove_let env exp2)
  | AECyc (a,exp) -> AECyc(a,remove_let env exp)
  | AEVar (a,v) -> begin match VarEnv.find_some v env.var with
      | None -> AEVar (a,v)
      | Some exp -> AECyc(a,remove_let env exp) end (* FIXME: tentative propagation of annot. *) 
  | AEIf(a,abexp,exp1,exp2) ->
      AEIf(a,remove_let_ab env abexp,remove_let env exp1,remove_let env exp2)
  | AERec(a,l,la,v,va,exp1,exp2) ->
      let env = { var = VarEnv.remove v env.var;
                  lvar = LVarEnv.remove l env.lvar } in
      AERec(a,l,la,v,va,remove_let env exp1,remove_let env exp2)
  | AELet(_,v,_,exp1,exp2) ->
      remove_let { env with var = VarEnv.add v (remove_let env exp1) env.var } exp2 
  | AELLet(_,l,_,pat,exp) ->
      remove_let { env with lvar = LVarEnv.add l (remove_let_pat env pat) env.lvar } exp

and remove_let_pat env = function
  | ALVar (a,l) as pat -> begin match LVarEnv.find_some l env.lvar with
      | None -> pat
      | Some p -> p end
  | ALLit (_,_) as pat -> pat
  | ALBin(a,pat1,op,pat2) -> ALBin(a,remove_let_pat env pat1,op,remove_let_pat env pat2)

and remove_let_ab env = function
  | AIsemp (a,exp) -> AIsemp(a,remove_let env exp)
  | ABisim (a,e1,e2) -> ABisim(a,remove_let env e1,remove_let env e2)
  | ANot (a,ab) -> ANot(a,remove_let_ab env ab)
  | AAnd(_,ab1,ab2) -> remove_let_ab env ab1 <&> remove_let_ab env ab2
  | AOr(_,ab1,ab2) -> remove_let_ab env ab1 <|> remove_let_ab env ab2
  | ALcmp(a,pat1,op,pat2) -> ALcmp(a,remove_let_pat env pat1,op,remove_let_pat env pat2)
  | ATrue _ | AFalse _ as ab -> ab
  | ALpred(a,pty,pat) -> ALpred(a,pty,remove_let_pat env pat)

let remove_let aexpr =
  remove_let { var = VarEnv.empty; lvar = LVarEnv.empty } aexpr
  
