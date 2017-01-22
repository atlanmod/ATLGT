(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
(**
  This module provides the abstract syntax tree for MSO logic.
  The pretty printer will emit a textual representation to be fed to MONA.

  Example:
{[	let e =
		let r = `Var2 "R" in
		let x = `Var1 "x" in
		let y = `Var1 "y" in
		let z = `Var1 "z" in
		let w = `Var1 "w" in
			exists2 [r] (
			    (x |<-| r)
			|&| (y |<-| r)
			|&| forall1 [z] (
					(z |<-| r)  |=>|  exists1 [w] (w |<-| r)
				)
			|&| msocall ("foo",fun x->x) [r;x]
			|&| (r |=| `Inter [r;r])
		)

	let p : 'a Mona.msoprogram_t = [
		`WS2S;
		`Pred("foo", [`Var1 "x";`Var1 "y"],
			e
		)
	]

	let _ =
		msoprogram_to_channel stdout p
]}
*)






(* ******************************** AST *********************************** *)

(** first order variable *)
type var1_t = [`Var1 of string]

(** second order variable *)
type var2_t = [`Var2 of string]

(** variable of either 1st or 2nd order *)
type var_t  = [var1_t | var2_t]

(** first order term *)
type term1_t = [
	| `Root
	| `Left   of term1_t
	| `Right  of term1_t
	| `Parent of term1_t
	| var1_t
]

(** second order term *)
type term2_t = [
	| `Union of term2_t list
	| `Inter of term2_t list
	| var2_t
]

(** term of either order *)
type term_t = [
	| `T1 of term1_t
	| `T2 of term2_t
]

type term_1or2_t = [term1_t | term2_t]

(** MSO formula.
   The type variable 'a abstracts the name of predicates.
   You can put some structured names in this position.
   The node (`Call of 'a) * term_t list) takes the
   abstracted name and the list of arguments.
 *)
type 'a msoexpr_t = [
	| `True
	| `False
	| `In     of term1_t * term2_t
	| `NotIn  of term1_t * term2_t
	| `Subset of term2_t * term2_t
	| `Empty  of term2_t
	| `Eq1    of term1_t * term1_t
	| `Eq2    of term2_t * term2_t
	| `Neq1   of term1_t * term1_t
	| `Neq2   of term2_t * term2_t
	| `Lt     of term1_t * term1_t
	| `Le     of term1_t * term1_t
	| `And of 'a msoexpr_t list
	| `Or  of 'a msoexpr_t list
	| `Not of 'a msoexpr_t
	| `Imp of 'a msoexpr_t * 'a msoexpr_t
	| `Iff of 'a msoexpr_t * 'a msoexpr_t
	| `Ex1  of var1_t list * 'a msoexpr_t
	| `Ex2  of var2_t list * 'a msoexpr_t
	| `All1 of var1_t list * 'a msoexpr_t
	| `All1Edge of var1_t list * 'a msoexpr_t    (** for optimization specific to the current typechecker *)
	| `All2 of var2_t list * 'a msoexpr_t
	| `Call of 'a * term_t list
	| `Let1 of var1_t * term1_t * 'a msoexpr_t
	| `Let2 of var2_t * term2_t * 'a msoexpr_t
]

(** MSO declaration *)
type 'a msodecl_t = [
	| `Comment of string
	| `Pred    of string * var_t list * 'a msoexpr_t
	| `VarDecl of var_t
	| `Assert  of 'a msoexpr_t
	| `Main    of 'a msoexpr_t
	| `WS2S
]

(** whole MSO program *)
type 'a msoprogram_t = 'a msodecl_t list





(** Equality of two formulas.
    Well, I (kinaba) forgot the specific reason why I needed this...?
  *)
let rec equal_formula (t1: 'a msoexpr_t) (t2: 'a msoexpr_t) : bool =
	match t1, t2 with
	| `And(ts1),         `And(ts2)
	| `Or(ts1),          `Or(ts2)           -> List.for_all2 equal_formula ts1 ts2
	| `Not(t1),          `Not(t2)           -> equal_formula t1 t2
	| `Imp(t11,t12),     `Imp(t21,t22)
	| `Iff(t11,t12),     `Iff(t21,t22)      -> equal_formula t11 t21 && equal_formula t12 t22
	| `Ex1(vs1,t1),      `Ex1(vs2,t2)
	| `All1(vs1,t1),     `All1(vs2,t2)
	| `All1Edge(vs1,t1), `All1Edge(vs2,t2)  -> List.for_all2 (=) vs1 vs2 && equal_formula t1 t2
	| `Ex2(vs1,t1),      `Ex2(vs2,t2)
	| `All2(vs1,t1),     `All2(vs2,t2)      -> List.for_all2 (=) vs1 vs2 && equal_formula t1 t2
	| `Call(p1,ts1),     `Call(p2,ts2)      -> p1=p2 && ts1=ts2
	| `Let1(v1,t1,e1),   `Let1(v2,t2,e2)    -> v1=v2 && t1=t2 && equal_formula e1 e2
	| `Let2(v1,t1,e1),   `Let2(v2,t2,e2)    -> v1=v2 && t1=t2 && equal_formula e1 e2
	| _ -> t1 = t2





(**
  Convenient Constructors for MSO Formulas
 *)

module MSOFormula = struct

	(** e1 AND e2 *)
	let (|&|) (t1: 'a msoexpr_t) (t2: 'a msoexpr_t) : 'a msoexpr_t =
		match t1, t2 with
		| `False, t | t, `False -> `False
		| `True,  t | t, `True  -> t
		| (`And xs), (`And ys)  -> `And(xs@ys)
		| x, (`And ys)          -> `And(x::ys)
		| (`And xs), y          -> `And(y::xs) (* `And(xs@[y]) *)
		| x, y when equal_formula x y -> x
		| x, y                  -> `And([x;y])

	(** e1 OR e2 *)
	let (|||) (t1: 'a msoexpr_t) (t2: 'a msoexpr_t) : 'a msoexpr_t =
		match t1, t2 with
		| `True, t  | t, `True  -> `True
		| `False, t | t, `False -> t
		| (`Or xs), (`Or ys)    -> `Or(xs@ys)
		| x, (`Or ys)           -> `Or(x::ys)
		| (`Or xs), y           -> `Or(y::xs) (* `Or(xs@[y]) *)
		| x, y when equal_formula x y -> x
		| x, y                  -> `Or([x;y])

	(** (f e1) AND (f e2) AND ... AND (f en) *)
	let all_and_with (es: 'a list) (fn: 'a -> 'b msoexpr_t) : 'b msoexpr_t =
		let rec iter acc = function
			| []   -> acc
			| h::t ->
				match fn h with
				| `False -> `False
				| e      -> iter (acc |&| e) t
		in
			iter `True es

	(** (f e1) OR (f e2) OR ... OR (f en) *)
	let all_or_with (es: 'a list) (fn: 'a -> 'b msoexpr_t) : 'b msoexpr_t =
		let rec iter acc = function
			| []   -> acc
			| h::t ->
				match fn h with
				| `True -> `True
				| e     -> iter (acc ||| e) t
		in
			iter `False es

	(** e1 AND e2 AND ... AND en *)
	let all_and es = all_and_with es (fun x->x)

	(** e1 AND e2 AND ... AND en *)
	let all_or  es = all_or_with  es (fun x->x)


	(** e1 IMPLIES e2 *)
	let (|=>|)  (t1: 'a msoexpr_t) (t2: 'a msoexpr_t) : 'a msoexpr_t =
		match t1, t2 with
		| `True,  t -> t
		| `False, t -> `True
		| t, `True  -> `True
		| t, `False -> `Not t
		| _, _      -> `Imp(t1,t2)

	(** e1 IFF e2 *)
	let (|<=>|) (t1: 'a msoexpr_t) (t2: 'a msoexpr_t) : 'a msoexpr_t =
		match t1, t2 with
		| `True,  t -> t
		| `False, t -> `Not t
		| t, `True  -> t
		| t, `False -> `Not t
		| _, _      -> `Iff(t1,t2)

	(** NOT e1 *)
	let msonot (e1: 'a msoexpr_t) = match e1 with
		| `True  -> `False
		| `False -> `True
		| t      -> `Not t

	(** t1 LT t2 *)
	let (|<|)   (t1:term1_t) (t2:term1_t) : 'a msoexpr_t = `Lt(t1,t2)

	(** t1 LE t2 *)
	let (|<=|)  (t1:term1_t) (t2:term1_t) : 'a msoexpr_t = `Le(t1,t2)

	(** t1 IN t2 *)
	let (|<-|)  (t1:term1_t) (t2:term2_t) : 'a msoexpr_t = `In(t1,t2)

	(** t1 EQ t2.
	   Runtime error is thrown when the order of t1 and t2 mismatch.
	   Is there any good way to write such overloading in OCaml?
	 *)
	let (|=|) (t1:term_1or2_t) (t2:term_1or2_t) : 'a msoexpr_t =
		match (t1,t2) with
		| (#term1_t as t1), (#term1_t as t2) -> `Eq1(t1,t2)
		| (#term2_t as t1), (#term2_t as t2) -> `Eq2(t1,t2)
		| _ -> failwith "[BUG] The orders of lhs and rhs of '=' do not match"

	(** t1 NE t2.
	   Runtime error is thrown when the order of t1 and t2 mismatch.
	   Is there any good way to write such overloading in OCaml?
	  *)
	let (|~=|) (t1:term_1or2_t) (t2:term_1or2_t) : 'a msoexpr_t  =
		match (t1,t2) with
		| (#term1_t as t1), (#term1_t as t2) -> `Neq1(t1,t2)
		| (#term2_t as t1), (#term2_t as t2) -> `Neq2(t1,t2)
		| _ -> failwith "[BUG] The orders of lhs and rhs of '~=' do not match"

	(** FORALL v1 v2 ... vn. e *)
	let rec forall1 (vars : var1_t list) (e: 'a msoexpr_t) : 'a msoexpr_t  =
		match vars, e with
		| _, `True  -> `True
		| _, `False -> `False
		| [], _     -> e
		| _,  `And(es) -> all_and_with es (forall1 vars)
		| _,  _     -> `All1(vars, e)

	(** FORALL v1 v2 ... vn. e *)
	let rec forall1edge (vars : var1_t list) (e: 'a msoexpr_t) : 'a msoexpr_t  =
		match vars, e with
		| _, `True  -> `True
		| _, `False -> `False
		| [], _     -> e
		| _,  `And(es) -> all_and_with es (forall1edge vars)
		| _,  _     -> `All1Edge(vars, e)

	(** FORALL v1 v2 ... vn. e *)
	let forall2 (vars : var2_t list) (e: 'a msoexpr_t) : 'a msoexpr_t  =
		match vars, e with
		| _, `True  -> `True
		| _, `False -> `False
		| [], _     -> e
		| _,  _     -> `All2(vars, e)

	(** EXISTS v1 v2 ... vn. e *)
	let exists1 (vars : var1_t list) (e: 'a msoexpr_t) : 'a msoexpr_t  =
		match vars, e with
		| _, `True  -> `True
		| _, `False -> `False
		| [], _     -> e
		| _, _      -> `Ex1(vars, e)

	(** EXISTS v1 v2 ... vn. e *)
	let exists2 (vars : var2_t list) (e: 'a msoexpr_t) : 'a msoexpr_t  =
		match vars, e with
		| _, `True  -> `True
		| _, `False -> `False
		| [], _     -> e
		| _, _      -> `Ex2(vars, e)

	(** t1 UNION t2 UNION ... UNION tn *)
	let union_all (ts:term2_t list) : term2_t =
		match ts with
		| []    -> failwith "[BUG] union of zero-length term list"
		| [t]   -> t
		| ts    -> `Union ts

	(** name(t1, t2, ..., tn) *)
	let msocall (name: 'a) (ts: term_1or2_t list) : 'a msoexpr_t =
		`Call(
			name,
			List.map (function (#term1_t as x) -> `T1 x | (#term2_t as x) -> `T2 x) ts
		)

	let x    = `Var1 "x"
	let y    = `Var1 "y"
	let z    = `Var1 "z"
	let v    = `Var1 "v"
	let e    = `Var1 "e"
	let u    = `Var1 "u"
	let f    = `Var1 "f"
	let g    = `Var1 "g"
	let dmy  = `Var1 "dmy"
	let r    = `Var1 "r"
	let t1   = `Var1 "tt"
	let t2   = `Var1 "ss"
	let t3   = `Var1 "uu"
	let setX = `Var2 "X"
	let setR = `Var2 "R"
	let setES = `Var2 "ES"
	let root = `Root
end
