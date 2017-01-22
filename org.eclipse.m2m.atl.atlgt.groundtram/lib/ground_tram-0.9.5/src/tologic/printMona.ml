(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
(** Pretty printer for MONA MSO expression *)

open Format
open Mona

let rec pp_join sep pp_a ppf = function
	| []   -> fprintf ppf ""
	| [e]  -> fprintf ppf "%a" pp_a e
	| e::t -> fprintf ppf "%a %s %a" pp_a e sep (pp_join sep pp_a) t

let rec pp_term ppf = function
	| `Var1(s)  -> fprintf ppf "%s" s
	| `Root     -> fprintf ppf "root"
	| `Left(t)  -> fprintf ppf "%a.0" pp_term t
	| `Right(t) -> fprintf ppf "%a.1" pp_term t
	| `Parent(t)-> fprintf ppf "%a^" pp_term t
	| `Var2(s)  -> fprintf ppf "%s" s
	| `Union(ts)-> fprintf ppf "(%a)" (pp_join "union" pp_term) ts
	| `Inter(ts)-> fprintf ppf "(%a)" (pp_join "inter" pp_term) ts

let rec pp_termlist ppf = function
	| []   -> fprintf ppf ""
	| [e]  -> fprintf ppf "%a" pp_term e
	| e::t -> fprintf ppf "%a, %a" pp_term e pp_termlist t

let rec pp_tagedtermlist ppf = function
	| []         -> fprintf ppf ""
	| [`T1 e]    -> fprintf ppf "%a" pp_term e
	| [`T2 e]    -> fprintf ppf "%a" pp_term e
	| (`T1 e)::t -> fprintf ppf "%a, %a" pp_term e pp_tagedtermlist t
	| (`T2 e)::t -> fprintf ppf "%a, %a" pp_term e pp_tagedtermlist t

let rec pp_paramlist ppf = function
	| []           -> fprintf ppf ""
	| [`Var1 e]    -> fprintf ppf "var1 %s" e
	| [`Var2 e]    -> fprintf ppf "var2 %s" e
	| (`Var1 e)::t -> fprintf ppf "var1 %s, %a" e pp_paramlist t
	| (`Var2 e)::t -> fprintf ppf "var2 %s, %a" e pp_paramlist t

let rec pp_msoexpr pp_pred ppf = function
	| `True          -> fprintf ppf "true"
	| `False         -> fprintf ppf "false"
	| `In(t1,t2)     -> fprintf ppf "@[%a in %a@]" pp_term t1 pp_term t2
	| `NotIn(t1,t2)  -> fprintf ppf "@[%a notin %a@]" pp_term t1 pp_term t2
	| `Subset(t1,t2) -> fprintf ppf "@[%a sub %a@]" pp_term t1 pp_term t2
	| `Empty(t1)     -> fprintf ppf "@[empty(%a)@]" pp_term t1
	| `Eq1(t1,t2)    -> fprintf ppf "@[%a = %a@]" pp_term t1 pp_term t2
	| `Eq2(t1,t2)    -> fprintf ppf "@[%a = %a@]" pp_term t1 pp_term t2
	| `Neq1(t1,t2)   -> fprintf ppf "@[%a ~= %a@]" pp_term t1 pp_term t2
	| `Neq2(t1,t2)   -> fprintf ppf "@[%a ~= %a@]" pp_term t1 pp_term t2
	| `Lt(t1,t2)     -> fprintf ppf "@[%a < %a@]" pp_term t1 pp_term t2
	| `Le(t1,t2)     -> fprintf ppf "@[%a <= %a@]" pp_term t1 pp_term t2
	| `And(es)       -> let rec iter ppf = function
	                      | []   -> fprintf ppf "true"
	                      | [e]  -> fprintf ppf "%a" (pp_msoexpr pp_pred) e
	                      | e::t -> fprintf ppf "%a@ & %a" (pp_msoexpr pp_pred) e iter t
	                    in
	                      fprintf ppf "@[<hv>(%a)@]" iter es
	| `Or(es)        -> let rec iter ppf = function
	                      | []   -> fprintf ppf "true"
	                      | [e]  -> fprintf ppf "%a" (pp_msoexpr pp_pred) e
	                      | e::t -> fprintf ppf "%a@ | %a" (pp_msoexpr pp_pred) e iter t
	                    in
	                      fprintf ppf "@[<hv>(%a)@]" iter es
	| `Not(e)        -> fprintf ppf "@[~(%a)@]" (pp_msoexpr pp_pred) e
	| `Imp(e1,e2)    -> fprintf ppf "(@[<1>%a@ => %a@])" (pp_msoexpr pp_pred) e1 (pp_msoexpr pp_pred) e2
	| `Iff(e1,e2)    -> fprintf ppf "(@[<1>%a@ <=> %a@])" (pp_msoexpr pp_pred) e1 (pp_msoexpr pp_pred) e2
	| `Ex1([],e)
	| `Ex2([],e)
	| `All1([],e)
	| `All2([],e)    -> fprintf ppf "%a" (pp_msoexpr pp_pred) e
	| `Ex1(ts,e)     -> fprintf ppf "(@[<2>ex1 %a: (%a)@])" pp_termlist ts (pp_msoexpr pp_pred) e
	| `Ex2(ts,e)     -> fprintf ppf "(@[<2>ex2 %a: (%a)@])" pp_termlist ts (pp_msoexpr pp_pred) e
(*
	| `All1(ts,`Imp(e1,e2))
		-> fprintf ppf "(@[<2>all1 %a where (%a): (%a)@])"
		     pp_termlist ts (pp_msoexpr pp_pred) e1 (pp_msoexpr pp_pred) e2
*)	| `All1(ts,e)    -> fprintf ppf "(@[<2>all1 %a: (%a)@])" pp_termlist ts (pp_msoexpr pp_pred) e
	| `All1Edge(ts,e)-> fprintf ppf "(@[<2>all1edge %a: (%a)@])" pp_termlist ts (pp_msoexpr pp_pred) e
	| `All2(ts,e)    -> fprintf ppf "(@[<2>all2 %a: (%a)@])" pp_termlist ts (pp_msoexpr pp_pred) e
	| `Call(pr,ts)   -> fprintf ppf "@[%a(%a)@]" pp_pred pr pp_tagedtermlist ts
	| `Let1(x,t,e)   -> fprintf ppf "(@[<2>let1 %a = %a in @,@[<3>%a@]@])" pp_term x pp_term t (pp_msoexpr pp_pred) e
	| `Let2(x,t,e)   -> fprintf ppf "(@[<2>let2 %a = %a in @,@[<3>%a@]@])" pp_term x pp_term t (pp_msoexpr pp_pred) e

let rec pp_msodecl pp_pred ppf = function
	| `Comment(s)       -> fprintf ppf "\n@[### %s@]\n" s
	| `Pred(pr, ts, e)  -> fprintf ppf "@[pred %s(%a) =@,@;<2 2>@[<hv>%a@]@];"
	                                     pr pp_paramlist ts (pp_msoexpr pp_pred) e
	| `VarDecl(`Var1 t) -> fprintf ppf "@[var1 %s;@]" t
	| `VarDecl(`Var2 t) -> fprintf ppf "@[var2 %s;@]" t
	| `Assert(e)        -> fprintf ppf "assert @[<hv>%a@];" (pp_msoexpr pp_pred) e
	| `Main(e)          -> fprintf ppf "@[%a@];" (pp_msoexpr pp_pred) e
	| `WS2S             -> fprintf ppf "ws2s;"

let rec pp_msoprogram pp_pred ppf = function
	| []    -> fprintf ppf ""
	| [d]   -> fprintf ppf "%a@." (pp_msodecl pp_pred) d
	| d::ds -> fprintf ppf "%a@.\n%a" (pp_msodecl pp_pred) d (pp_msoprogram pp_pred) ds

(** Pretty print MSO program into a channel *)
let msoprogram_to_channel pp_pred chan (e: 'a msoprogram_t) : unit =
	fprintf (formatter_of_out_channel chan) "%a" (pp_msoprogram pp_pred) e
