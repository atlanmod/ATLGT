(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
(**
   Conversion from KM3+UnCAL+KM3 to MSO formulas asserting type correctness
 *)

open Km3
open ExtSetMap
open MsoTcSchema
open MsoTcUtil
open UnCAL
open Mona
open MSOFormula




let foldleft_wi (fn: 'a->int->'b->'a) (ini: 'a) (lst: 'b list) =
	let rec iter a i bs =
		match bs with
		| []    -> a
		| b::bs -> iter (fn a i b) (i+1) bs
	in
		iter ini 0 lst

let namemap_lookup mp ky =
	try NameMap.find ky mp with Not_found -> failwith ("[BUG] The key "^ky^" not found")

let rec term2ith i = function
	| `Var2(s)   -> `Var2(s^string_of_int i)
	| `Union(ts) -> `Union(List.map (term2ith i) ts)
	| `Inter(ts) -> `Inter(List.map (term2ith i) ts)

let union_list xs ys =
	let rec iter acc = function
		| [] -> acc
		| h::t when List.mem h xs -> iter acc t
		| h::t -> iter (h::acc) t
	in
		iter xs ys

let decl_of_schema (ISchema (_, decls)) t =
	let IDecl decl = namemap_lookup decls t in
		NameMap.fold (fun en (IType tl) acc ->
			(en, MSOFormula.union_all (List.map (fun s->`Var2 s) tl)) :: acc
		) decl []


(*****************************************************************************
 * (rough deescription for our encoding scheme)
 *
 * <<encoding of graphs in MONA>>
 *
 * - As input graphs, we only consider finite trees
 *     (this is sufficient to accomplish sound&complete checking)
 * - Finite edge-labeled unranked unordered trees are encoded into
 *   finite node-labeled binary ordered trees
 *
 *   {a: {b: {c}, a}}
 *==>
 *         v0
 *        /
 *       v1
 *      /
 *     v2
 *    \ \
 *   v3  v4
 * Ea = {v1, v4}
 * Eb = {v2}
 * Ec = {v3}
 *
 * here used
 *   - the usual unranked->binary encoding,
 *       i.e., leftChild=fstChild, rightChild=nextSibling
 *   - node label denotes the label of the incoming edge
 *       e.g., (v1 in Ea) implies v1's incoming edge was 'a'
 *   - order is not significant. we just choose arbitrary one of ordering
 *
 * <<regarding the encoding as Courcelle's MSO-based finite-copying transduction>>
 *   (x, i) denotes the "i-th copy of x"
 *
 *  node:(v0, 0)
 *      |
 *  edge:(v1, 1)
 *      |
 *      v
 *  node:(v1, 0) --edge:(v4,1)--> node:(v4,0)
 *      |
 *  edge:(v2, 1)
 *      |
 *      v
 *  node:(v2, 0) --edge:(v3,1)--> node:(v3,0)
 *
 *****************************************************************************)






(*****************************************************************************
 * Definition and Manipulation of Copy-IDs
 *****************************************************************************)

type gcid      = int       (* global-copy-id *)
type gcid_list = gcid list (* global-copy-id list *)

let gcid_empty () = []
let gcid_sing x   = [x]

let rec gcid_union xs ys =
	match xs, ys with
	| [], zs | zs, [] -> zs
	| (x::xs), (y::ys) when x=y -> x::gcid_union xs ys
	| (x::xs), (y::ys) when x<y -> x::gcid_union xs (y::ys)
	| (x::xs), (y::ys)          -> y::gcid_union (x::xs) ys



(*****************************************************************************
 * Formula Expander & Optimizer
 *
 *   Here is the list of predicates we generate for describing transformations
 *
 *    BP1: edge_I_J_K(x,e,y)
 *         is the I-th copy of x (x,i) is connected to (y,k) by an edge (e,j)?
 *    BP2: is_Exxx_I(e)
 *         is (e,I) an edge, labeled xxx?
 *
 *   From these, we generate a set of (currently only one type) aux preds
 *
 *    AP1: outgoing_I_J_K(x, e, y)
 *         is there a path of form
 *             node:(x,I) ---eps--->* _ ---edge:(e,J)---> node:(y,K) ?
 *
 *   And on top of these, we produce main formulas such as
 *
 *    MP1: input_type()
 *          asserts that the input graph satifies the given input schema
 *    MP2: output_type()
 *          ... output graph
 *    MP3: main formula : input_type() => output_type()
 *
 * BPs are 'nonuniform', in the sense that, say, for different I,J,Ks,
 * the definitions of edge_I_J_K is completely different.
 * On the other hand, APs or MPs are 'uniform', in the sense that they
 * can be generated by instanciating a single schematic formula (having I,J,Ks
 * as to-be-filled parameters), on top of BPs.
 *
 * Hence,
 *   1. we first accumulate all the definitions of BPs in 'edge info repository'
 *   2. then, we generate APs and MPs uniformly
 *        during this phase, we need a kind of constant-folding for
 *        avoiding generating 'too huge' formulas.
 * The code below implements this approach.
 *****************************************************************************)

type mypred =
	| Edge
	| Outgoing
	| Is    of string  (* is_E *)
	| Other of string

type msoexpr_t    = mypred Mona.msoexpr_t
type msodecl_t    = mypred Mona.msodecl_t
type msoprogram_t = mypred Mona.msoprogram_t

let edge_pr      = Edge
let outgoing_pr  = Outgoing
let is_pr s      = Is s
let other_pr s   = Other s

let outgoing_name = "og"

module IIIMap = Map.Make(struct type t=int*int*int let compare=compare end)
module  NIMap = Map.Make(struct type t=name*int let compare=compare end)

type basepred = PredEdge of int * int * int | PredIs of name * int

type edgerepos_t =
	  msoexpr_t IIIMap.t  (* edge_ *)
	* msoexpr_t  NIMap.t  (* is_   *)
	* (int * int * int * msoexpr_t) list  (* outgoing_ *)
	* basepred list (* reverse list of edge_ of is_ predicates in demand-driven order *)

let emptyEdgerepos = (IIIMap.empty, NIMap.empty, [], [])

let enroll_edge_I_J_K ((ee,ei,eo,rl): edgerepos_t) (i,j,k,e) : edgerepos_t =
	let (ee, rl) =
		match e with
		| `False -> (ee, rl)
		| _ ->
			match IIIMap.find_some (i,j,k) ee with
			| Some e2 -> (IIIMap.add (i,j,k) (e ||| e2) ee, rl)
			| None    -> (IIIMap.add (i,j,k) e ee, (PredEdge (i,j,k) :: rl))
	in
		(ee, ei, eo, rl)

let enroll_is_X_I ((ee,ei,eo,rl): edgerepos_t) (n,i,e) : edgerepos_t =
	let (ei, rl) =
		match e with
		| `False -> (ei, rl)
		| _ ->
			match NIMap.find_some (n,i) ei with
			| Some e2 -> (NIMap.add (n,i) (e ||| e2) ei, rl)
			| None    -> (NIMap.add (n,i) e ei, (PredIs (n,i) :: rl))
	in
		(ee, ei, eo, rl)


let generate_preds_for_edgeinfo ((ee, ei, eo, rl): edgerepos_t) =
	(* generate edge_X_X_X and is_Exx_X from edgerepos *)
	List.fold_left (fun acc bp ->
		match bp with
		| PredEdge(i,j,k) ->
			`Pred (sprintf "edge_%d_%d_%d" i j k, [x;e;y], IIIMap.find (i,j,k) ee) :: acc
		| PredIs(n,i)     ->
			`Pred (sprintf "is_%s_%d" n i, [e], NIMap.find (n,i) ei) :: acc
	) [] rl
	@
	(* generate outgoing_X_X_X *)
	List.fold_left (fun acc (i,j,k,mso) ->
		`Pred (sprintf "%s_%d_%d_%d" outgoing_name i j k, [x;e;y], mso) :: acc
	) [] eo


let static_msocall ((ee,ei,eo,rl): edgerepos_t) name ijk args =
	match name, ijk with
	| Edge, [i;j;k] ->
		if IIIMap.mem (i,j,k) ee then
			`Call (other_pr (sprintf "edge_%d_%d_%d" i j k), args)
		else
			`False
	| Outgoing, [i;j;k] ->
		if List.exists (function a,b,c,p -> i=a && j=b && k=c) eo then
			`Call (other_pr (sprintf "%s_%d_%d_%d" outgoing_name i j k), args)
		else
			`False
	| Is x, [i] ->
		if NIMap.mem (x,i) ei then
			`Call (other_pr (sprintf "is_%s_%d" x i), args)
		else
			`False
	| Other str, ijk ->
		`Call (other_pr (List.fold_left (fun s i -> s^"_"^string_of_int i) str ijk), args)
	| _ ->
		failwith "[BUG] mismatch in number of arguments in static_msocall"

let make_copyid_aware
	(rootid: int)
	(copyid: int list)
	(((ee,ei,eo,rl) as eir): edgerepos_t)
	msocall
	dmp
	(e:msoexpr_t)
	: msoexpr_t
=
	let rec make_copyid_aware dmp (e:msoexpr_t) = match e with
		| `True  -> `True
		| `False -> `False
		(* 1st atomic *)
		| `Eq1(`Var1 s1,`Var1 s2)
		| `Neq1(`Var1 s1,`Var1 s2)
		| `Lt(`Var1 s1,`Var1 s2)
		| `Le(`Var1 s1,`Var1 s2) as e -> if namemap_lookup dmp s1 = namemap_lookup dmp s2 then e else `False
		| `Eq1(_,_)
		| `Neq1(_,_)
		| `Lt(_,_)
		| `Le(_,_) -> failwith "[RESTRICTION] Constants and Funtions are Not Allowed as operands of (<,<=,=,~=)"
		(* 1st-2nd atomic *)
		| `In(`Var1 s1,`Var2 s2) -> `In(`Var1 s1, `Var2 (s2 ^ string_of_int (namemap_lookup dmp s1)))
		| `NotIn(`Var1 s1,`Var2 s2)  -> `NotIn(`Var1 s1, `Var2 (s2 ^ string_of_int (namemap_lookup dmp s1)))
		| `In(`Root, `Var2 s2) -> `In(`Root, `Var2 (s2 ^ string_of_int rootid))
		| `In(_,_)
		| `NotIn(_,_) -> failwith "[RESTRICTION] Constants and Funtions are Not Allowed as operands of (in, notin)"
		(* 2nd atomic : must allow unions/inters! *)
		| `Empty(t1)     -> `And(List.map (fun i -> `Empty(term2ith i t1)) copyid)
		| `Subset(t1,t2) -> `And(List.map (fun i -> `Subset(term2ith i t1, term2ith i t2)) copyid)
		| `Eq2(t1,t2)    -> `And(List.map (fun i -> `Eq2(term2ith i t1, term2ith i t2)) copyid)
		| `Neq2(t1,t2)   -> `Or(List.map (fun i -> `Neq2(term2ith i t1, term2ith i t2)) copyid)
		(* expression *)
		| `And(es)       -> all_and_with es (make_copyid_aware dmp)
		| `Or(es)        -> all_or_with es (make_copyid_aware dmp)
		| `Not(e)        -> msonot (make_copyid_aware dmp e)
		| `Imp(e1,e2)    -> make_copyid_aware dmp e1 |=>| make_copyid_aware dmp e2
		| `Iff(e1,e2)    -> make_copyid_aware dmp e1 |<=>| make_copyid_aware dmp e2
		| `Ex1([],e)
		| `Ex2([],e)
		| `All1([],e)
		| `All2([],e)    -> e
		| `Ex1(ts,e)     ->
			exists1 ts (all_or(
				let rec iter dmp es = function
				| [] -> make_copyid_aware dmp e :: es
				| `Var1 s :: ts ->
					List.fold_right (fun i es ->
						iter (NameMap.add s i dmp) es ts
					) copyid es
				in
					iter dmp [] ts
			))
		| `All1(ts,e)    ->
			forall1 ts (all_and(
				let rec iter dmp es = function
				| [] -> make_copyid_aware dmp e :: es
				| `Var1 s :: ts ->
					List.fold_right (fun i es ->
						iter (NameMap.add s i dmp) es ts
					) copyid es
				in
					iter dmp [] ts
			))
		(* optimization specific to our usecase *)
		| `All1Edge([(`Var1(nx) as vx); (`Var1(ne) as ve); (`Var1(ny) as vy)], e) ->
			let e = MSOFormula.msocall edge_pr [vx;ve;vy] |=>| e in
			let module IISet = Set.Make(struct type t=int*int let compare=compare end) in
			let jks = IISet.elements
				(List.fold_left (fun acc ed ->
					match ed with
					| PredEdge(i,j,k) -> IISet.add (j,k) acc
					| _ -> acc
				) IISet.empty rl)
			in
				forall1 [vx;ve;vy] (all_and(
					List.fold_left (fun acc (j,k) ->
						List.fold_left (fun acc i ->
							make_copyid_aware (NameMap.fromList [nx,i; ne,j; ny,k]) e :: acc
						) acc copyid
					) [] jks
				))
		| `All1Edge(_, _) -> failwith "[BUG] invalid form of all1edge"
		| `Ex2(ts,e)     ->
			exists2
				(List.fold_right (fun (`Var2 s) vs ->
					List.map (fun i -> `Var2(s^string_of_int i)) copyid @ vs
				) ts [])
				(make_copyid_aware dmp e)
		| `All2(ts,e)    ->
			forall2
				(List.fold_right (fun (`Var2 s) vs ->
					List.map (fun i -> `Var2(s^string_of_int i)) copyid @ vs
				) ts [])
				(make_copyid_aware dmp e)
		| `Call(pr,ts)   ->
			let rec iter ijk = function
				| [] ->
					msocall pr ijk ts
				| `T1(`Root)::ts ->
					iter (ijk @ [rootid]) ts
				| `T1(`Var1(s))::ts ->
					iter (ijk @ [namemap_lookup dmp s]) ts
				| _ ->
					failwith "[BUG] Only order-1 variables are allowed as predicate arguments."
			in
				iter [] ts
		| `Let1(x,t,e) -> failwith "[BUG] desugaring of mso-let expression."
		| `Let2(x,t,e) -> failwith "[BUG] desugaring of mso-let expression."
	in
		make_copyid_aware dmp e

let introduce_pred (rootid: int) (copyid: int list) (eir: edgerepos_t) (nm,vs,e) msocall =
	let rec iter_vs ijk dmp kont = function
		| [] ->
			let e = make_copyid_aware rootid copyid eir msocall dmp e in
				(ijk, e) :: kont
		| (`Var1 s)::vs ->
			List.fold_right (fun i kont ->
				iter_vs (ijk@[i]) (NameMap.add s i dmp) kont vs
			) copyid kont
	in
		iter_vs [] NameMap.empty [] vs

let rec as_3 = function
	| [] -> []
	| ([i;j;k], `False)::es -> as_3 es
	| ([i;j;k], mso)::es -> (i,j,k,mso)::as_3 es
	| _ -> failwith "[BUG] 3-parameter predicate expected"

let rec as_2 x = function
	| [] -> []
	| ([i], `False)::es -> as_2 x es
	| ([i], mso)::es -> (x,i,mso)::as_2 x es
	| _ -> failwith "[BUG] 1-parameter with edge-name predicate expected"

let outgoing_formula =
		exists1 [dmy] (msocall edge_pr [dmy;e;y])
	|&|
		forall2 [setR] (
			((x |<-| setR)
(*
			 |&| forall [t1;t2;t3] (
					((t1 |<-| setR) |&| msocall edge_pr [t1;t2;t3] |&| msocall (is_pr "E") [t2])
*)
			 |&| forall1edge [t1;t2;t3] (
					((t1 |<-| setR) |&| msocall (is_pr "E") [t2])
					|=>| (t3 |<-| setR)
				)
			)
			|=>|
				exists1 [z] (msocall edge_pr [z;e;y] |&| (z |<-| setR))
		)
	|&|
		msonot (msocall (is_pr "E") [e])

let introduce_aux_preds ((ee,ei,eo,rl) as eir) copyid : edgerepos_t =
	let eo = as_3
		(introduce_pred
			(-1)
			copyid
			eir
			(outgoing_name, [x;e;y], outgoing_formula)
			(static_msocall eir)
		)
	in
		(ee,ei,eo,rl)


let introduce_aux_preds_specialized_for_outgoing ((ee,ei,eo,rl) as eir) copyid progress : edgerepos_t =
	let module IISet = Set.Make(struct type t=int*int let compare=compare end) in
	let jks = IISet.elements
		(List.fold_left (fun acc ed ->
			match ed with
			| PredEdge(i,j,k) -> IISet.add (j,k) acc
			| _ -> acc
		) IISet.empty rl)
	in
	let eo =
		let total = List.length jks * List.length copyid in
		let sub   = List.length jks in
		let cur   = ref 0 in
		List.fold_left (fun acc i ->
			progress (sprintf "%d%%\r" (!cur*100/total));
			cur := !cur + sub;
			List.fold_left (fun acc (j,k) ->
				let cae = make_copyid_aware (-1) copyid eir (static_msocall (ee,ei,eo,rl))
					(NameMap.fromList ["x",i; "e",j; "y",k]) outgoing_formula
				in
				([i;j;k], cae) :: acc
			) acc jks
		) [] copyid
	in
	let eo = as_3 eo
	in
		(ee,ei,eo,rl)


(*****************************************************************************
 * Tree-Encoding to MSO
 *
 *     Our internal encoding for expressing UnCAL graphs as MONA trees
 *     is implemented by the following MSO formulas and variables.
 *****************************************************************************)

let generate_preds_for_input_tree_encoding
	(scm : internal_schema)
	(eid : gcid)
	: msodecl_t list
=
	let edgeVars = List.map (fun s -> `Var2 ("C"^string_of_int eid^s)) (edgenames_of_schema scm)
	in
	(* declare variables encoding input structure *)
	(*   e.g., var2 E, EA, EB, Ea, Eb, ...;       *)
	List.map (fun e -> `VarDecl e) edgeVars
	@
	(* pred tree_formed()                              *)
	(*   tells that the above variables are satisfying *)
	(*   certain constraints to be a valid encoding    *)
	[`Pred ("tree_formed"^string_of_int eid, [],
		all_and (List.map (fun (e,f) -> `Empty(`Inter [e; f])) (pairs_of edgeVars))
	)]

let generate_preds_for_input_tree_encoding_debug
	(scm : internal_schema)
	(eid : gcid)
	: msodecl_t list
=
	let edgeVars = List.map (fun s -> `Var2 ("C"^string_of_int eid^s)) (edgenames_of_schema scm)
	in
	(* pred tree_formed_debug()                        *)
	(*   a debug version for tree_formed() that has    *)
	(*   more constraints so that the MONA-generated   *)
	(*   counterexamples to be much more useful        *)
	[`Pred ("prefix_closed", [setX],
		forall1 [x] (
			(x|<-|setX)
			  |=>|
			((x |=| `Left `Root) ||| (`Parent x |<-| setX))
		)
	)]
	@
	[`Pred ("tree_formed_debug"^string_of_int eid, [],
		`Let2(setES,  union_all edgeVars,
				msocall (other_pr "prefix_closed") [setES]
			|&|
				msonot (`Root |<-| setES)
(*
			|&|
				exists [x;y] ( (x |<| y) |&| (x |<-| setES) |&| (y |<-| setES) )
*)
		)
	)]

let enroll_edges_from_input_tree_encoding
	(scm : internal_schema)
	(vid : gcid)
	(eid : gcid)
	(eir : edgerepos_t) 
	: edgerepos_t
=
	let eee = edgenames_of_schema scm in
	let edgeVars = List.map (fun s -> `Var2 ("C"^string_of_int eid^s)) eee
	in
	let eir = (* pred is_EX_1(e) = e in EX;   for every EX *)
		List.fold_left enroll_is_X_I
			eir
			(List.map (fun name -> (name, eid, e |<-| `Var2 ("C"^string_of_int eid^name))) eee)
	in
	let eir = (* pred edge_0_1_0(x,e,y) = x.01*=e=y & e in Exx *)
		enroll_edge_I_J_K eir (vid, eid, vid,
				msocall (other_pr ("tree_formed"^string_of_int eid)) [] (* curcial optimizaion! *)
			|&|	(e |=| y)
			|&|	(e |<-| union_all edgeVars)
			|&|	forall2 [setX] (
					(
						(e |<-| setX)
						|&|
						forall1 [z] (
							((z |<-| setX) |&| (`Right(`Parent z) |=| z))
							|=>| (`Parent z |<-| setX)
						)
					)
					|=>|
						(`Left x |<-| setX)
				)
		)
	in
		eir



(*****************************************************************************
 * Schema to MSO
 *****************************************************************************)

let generate_schema_formula
	(eir      : edgerepos_t)
	(predname : string)
	(rootid   : gcid)
	(copyid   : gcid_list)
	(scm      : internal_schema)
	: msodecl_t list
=
	let es = edgenames_of_schema scm in
	let ts = List.map (fun s -> `Var2 s) (typenames_of_schema scm) in
	let rt = List.map (fun s -> `Var2 s) (roottype_of_schema  scm) in
	let theFormula =
		(* there exists a type-assignment such that *)
		exists2 ts (
			(* root is assigned  the rootype *)
			(`Root |<-| union_all rt)
		|&| (* and, for all nodes x and types t, *)
			forall1 [x] (all_and_with ts (fun (`Var2 typename as t) ->
				(* when v is assigned a type t *)
				(x |<-| t) |=>| (
					(* its all outgoing edges *)
					forall1 [e;y] (msocall outgoing_pr [x; e; y] |=>| (
						(* obey to the schema, i.e., *)
						let decl = decl_of_schema scm typename in
							all_or_with decl (fun (edgename, dt) ->
								(* it has a matching edgename in the schema,
								   with a properly-typed destination *)
								msocall (is_pr edgename) [e] |&| (y |<-| dt)
							)
					))
				)
			))
		)
	in (* make the formula copy-aware *)
		[`Pred (predname, [],
		        make_copyid_aware rootid copyid eir (static_msocall eir)
		                          NameMap.empty theFormula)]



(*****************************************************************************
 * Read an UnCAL file and re-format it for typechecking
 *****************************************************************************)

(* expr with copy-info *)
type rooted_gcid = gcid * gcid_list

type ci_expr =
    (* x *)
	| CI_Emp  of lecid
    (* x --y--> e1
         --z--> e2 *)
	| CI_Uni  of lvcid * (lecid * ci_expr) * (lecid * ci_expr)
	| CI_GEmp
	| CI_DUni of ci_expr * ci_expr
	(* x --y--> e1 *)
	| CI_IMrk of lvcid * (lecid * ci_expr)
	(* x *)
	| CI_OMrk of lvcid
	(* x --y--> e1 *)
	| CI_Edg  of lecid * info alpat * (lecid * ci_expr)
	| CI_Var  of vname
	| CI_OutVar  of vname * rooted_gcid
	(* [output gids] copysize labname varname [cond->expr] (gid_base, argCID, argExpr) *)
	| CI_Rec  of rooted_gcid * int * lname * vname * (info abexpr * ci_expr) list * (gcid * rooted_gcid * ci_expr)
	| CI_RecAnn  of (rooted_gcid * internal_schema) * (rooted_gcid * internal_schema) * (* &1_schema * $G_schema *)
         rooted_gcid * int * lname * vname * (info abexpr * ci_expr) list * (gcid * rooted_gcid * ci_expr)




and lecid = int (* local-edge-copy-id *)
and lvcid = int (* local-vertex-copy-id *)


let edges_of_expr (e: ci_expr) : NameSet.t =
	let rec iter a = function
	| CI_Emp(_)
	| CI_GEmp
	| CI_OMrk(_) -> a
	| CI_Uni (_,(_,e1),(_,e2))
	| CI_DUni(e1,e2) -> iter (iter a e1) e2
	| CI_IMrk(_,(_,e1)) -> iter a e1
	| CI_Edg(_, ALLit(_, ALStr _), (_, e1)) -> iter (NameSet.add "DString" a) e1
	| CI_Edg(_, ALLit(_, ALInt _), (_, e1)) -> iter (NameSet.add "DInt" a) e1
	| CI_Edg(_, ALLit(_, ALLbl lab), (_, e1)) -> iter (NameSet.add ("E"^lab) a) e1
	| CI_Edg(_, _, (_, e1)) -> iter a e1
	| CI_Var(_) -> a
	| CI_OutVar(_, _) -> a
	| CI_Rec(_,_,_,_,be1s,(_,_,e2)) -> iter (List.fold_left (fun a (b,e1) -> iter a e1) a be1s) e2
	| CI_RecAnn(_,_,_,_,_,_,be1s,(_,_,e2)) -> iter (List.fold_left (fun a (b,e1) -> iter a e1) a be1s) e2
	in
		iter NameSet.empty e


let uncal_add_copyinfo
	(uncal: info aexpr)
	: ci_expr
=
	(* unique copy-id management *)
	let fresh_gid : gcid ref  = ref 2 in
	let new_gid () = let x = !fresh_gid in (incr fresh_gid; x) in
	let new_gid2 () = [new_gid (); new_gid ()] in

	(* annotate rec-expression *)
	let rec annotate_rec (e: info aexpr) (curVar: vname) (v2gcid: rooted_gcid NameMap.t) : ci_expr =
		match e with
		(* ultra dirty hack *)
		| AEApnd(an1, AEOMrk(an2, outMrk), AEDUni(_, AEIMrk(_, "&out", AEEdg(_, ALLit (_, ALStr km3out),AETEmp(_))),
		                         AEDUni(_, AEIMrk(_, "&var", AEEdg(_, ALLit (_, ALStr km3var),AETEmp(_))), theRec)))
		->
			let giO = new_gid2 () in
			let giV = new_gid2 () in
			let outID = (List.hd giO, giO) in
			let varID = (List.hd giV, giV) in
			let scmO = load_schema_from_file km3out in
			let scmV = load_schema_from_file km3var in
				begin match annotate_rec (AEApnd(an1, AEOMrk(an2, outMrk),theRec)) curVar
					(NameMap.addl [curVar,varID] v2gcid) with
				| CI_Rec(outCID, nCopy, labVar, treVar, abody, (gid_base, argCID, carg))
				->
					CI_RecAnn((outID,scmO), (varID,scmV),
						outCID, nCopy, labVar, treVar, abody, (gid_base, argCID, carg))
				| _ -> failwith "[BUG] recursion not converted to CI_Rec in uncal_add_copyinfo"
				end
		| AEApnd(_, AEOMrk(_, outMrk), AERec(_, labVar, _, treVar, _, body, AEVar(_, argVar)))
		->
			let gid_base = !fresh_gid in
			let argCID                 = namemap_lookup v2gcid argVar in
			let v2gcid'                = NameMap.addl [labVar,argCID; treVar,argCID] v2gcid in
			let (outCID, nCopy, abody) = annotate_body body treVar outMrk argCID gid_base v2gcid' in
				CI_Rec(outCID, nCopy, labVar, treVar, abody, (gid_base, argCID, CI_Var(argVar)))
		| AERec(_, labVar, _, treVar, _, body, AEVar(_, argVar))
		->
			let outMrk = "&" in (* same as above except this line *)
			let gid_base = !fresh_gid in
			let argCID                 = namemap_lookup v2gcid argVar in
			let v2gcid'                = NameMap.addl [labVar,argCID; treVar,argCID] v2gcid in
			let (outCID, nCopy, abody) = annotate_body body treVar outMrk argCID gid_base v2gcid' in
				CI_Rec(outCID, nCopy, labVar, treVar, abody, (gid_base, argCID, CI_Var(argVar)))
		| AEApnd(_, AEOMrk(_, outMrk), AERec(_, labVar, _, treVar, _, body, arg))
		->
			let carg = annotate_rec arg curVar v2gcid in
			begin match carg with
			| CI_Rec(argCID, _, _, _, _, _) ->
				let gid_base = !fresh_gid in
				let v2gcid'                = NameMap.addl [labVar,argCID; treVar,argCID] v2gcid in
				let (outCID, nCopy, abody) = annotate_body body treVar outMrk argCID gid_base v2gcid' in
					CI_Rec(outCID, nCopy, labVar, treVar, abody, (gid_base, argCID, carg))
			| _ ->
				failwith "[BUG] recursion not converted to CI_Rec in uncal_add_copyinfo"
			end
		| AERec(_, labVar, _, treVar, _, body, arg)
		->
			let outMrk = "&" in (* same as above except this line *)
			let carg = annotate_rec arg curVar v2gcid in
			begin match carg with
			| CI_Rec(argCID, _, _, _, _, _) ->
				let gid_base = !fresh_gid in
				let v2gcid'                = NameMap.addl [labVar,argCID; treVar,argCID] v2gcid in
				let (outCID, nCopy, abody) = annotate_body body treVar outMrk argCID gid_base v2gcid' in
					CI_Rec(outCID, nCopy, labVar, treVar, abody, (gid_base, argCID, carg))
			| _ ->
				failwith "[BUG] recursion not converted to CI_Rec in uncal_add_copyinfo"
			end
		| AEApnd(_, _, _)
		->
			failwith "[RESTRICTION] append expression (&m @ e) can be used only in front of rec"
		| _
		->
			failwith "[RESTRICTION] the root-expression and argument of a rec-expression must be a rec-expression or a variable (where $v in {...} in UnQL is not supported yet)"

	(* annotate body of rec-expression *)
	and annotate_body (e: info aexpr) (curVar: vname)
		(outMrk: vname) (argCID: rooted_gcid) (gid_base: gcid) (v2gcid: rooted_gcid NameMap.t)
			: (rooted_gcid * int * (info abexpr * ci_expr) list) =
		(* Collect vertex-copy information   *)
		(* i.e., the number of markers used *)
		let rec gather_markers = function
		| AETEmp(_)           -> NameSet.empty
		| AEUni(_, e1, e2)    -> NameSet.union (gather_markers e1) (gather_markers e2)
		| AEGEmp(_)           -> NameSet.empty
		| AEDUni(_, e1,e2)    -> NameSet.union (gather_markers e1) (gather_markers e2)
		| AEIMrk(_, mk, e)    -> NameSet.union (NameSet.singleton mk) (gather_markers e)
		| AEOMrk(_, mk)       -> NameSet.singleton mk
		| AEEdg(_, lab,e)     -> gather_markers e
		| AEVar(_, v)         -> NameSet.empty
		| AEApnd(_,_, _)
		| AERec(_,_,_,_,_,_,_)   -> NameSet.empty (* &@rec(...)(arg) : arg shouldn't use markers *)
		| AEIf(_, eb, et, ee) -> NameSet.union (gather_markers et) (gather_markers ee)
		| AECyc(_, _)      -> failwith "[RESTRICTION] cycle() is not supported by chkuncal"
		| AEDoc(_, _)      -> failwith "[RESTRICTION] doc() is not supported by chkuncal"
		| AELet(_,_,_,_,_)  -> failwith "[RESTRICTION] let expression is not supported by chkuncal"
		| AELLet(_,_,_,_,_) -> failwith "[RESTRICTION] llet expression is not supported by chkuncal"
		in
		let mks  : NameSet.t       = gather_markers e in
		let mks  : vname list      = outMrk :: NameSet.elements (NameSet.remove outMrk mks) in
		let mkmp : lvcid NameMap.t = foldleft_wi (fun a i m -> NameMap.add m i a) NameMap.empty mks in
		let vCopy = List.length mks in

		(* Collect edge-copy information *)
		let rec count_edgecopy = function
		| AETEmp(_)           -> 1
		| AEUni(_, e1, e2)    -> 3 + count_edgecopy e1 + count_edgecopy e2
		| AEGEmp(_)           -> 0
		| AEDUni(_,e1,e2)    -> count_edgecopy e1 + count_edgecopy e2
		| AEIMrk(_,mk, e)    -> 1 + count_edgecopy e
		| AEOMrk(_,mk)       -> 0
		| AEEdg(_,lab,e)     -> 2 + count_edgecopy e
		| AEVar(_,v)         -> 0
		| AEApnd(_,_, _) | AERec(_,_,_,_, _, _, _) -> 0
		| AEIf(_,eb, et, AETEmp(_)) -> count_edgecopy et
		| AEIf(_,eb, et, ee)     -> max (count_edgecopy et) (count_edgecopy ee)
		| AECyc(_,_)      -> failwith "[RESTRICTION] cycle() is not supported by chkuncal"
		| AEDoc(_,_)      -> failwith "[RESTRICTION] doc() is not supported by chkuncal"
		| AELet(_,_,_,_,_)  -> failwith "[RESTRICTION] let expression is not supported by chkuncal"
		| AELLet(_,_,_,_,_) -> failwith "[RESTRICTION] llet expression is not supported by chkuncal"
		in
		let eCopy = count_edgecopy e in
		let nCopy = max vCopy eCopy in

		(* global_id management *)
		let  width = List.length (snd argCID) in
		fresh_gid := gid_base + nCopy*width;

		(* memorizer *)
		let gid_used   = ref (fromTo gid_base (!fresh_gid)) in
		let gid_add gs = gid_used := gcid_union (!gid_used) gs in

		(* Annotate each expression with copy-info *)
		let rec iter (e: info aexpr) : (info abexpr * ci_expr) list =
			match e with
			| AEIf(_, _, _, _) -> iterimpl e
			| _ -> iterimpl (AEIf({annot=None}, ATrue({annot=None}), e, AETEmp({annot=None})))
		and iterimpl (e: info aexpr) : (info abexpr * ci_expr) list =
			match e with
			| AEIf(_, eb, (AEIMrk(_, _, _) as et), ee)
			| AEIf(_, eb, (AEDUni(_, _, _) as et), ee) -> (eb, annotate_expr et) :: iterimpl ee
			| AEIf(_, eb, et, ee)                   -> (eb, annotate_expr (AEIMrk({annot=None},"&",et))) :: iterimpl ee
			| AEIMrk(_, _, AETEmp(_))
			| AETEmp(_) -> []
			| _ -> failwith "[BUG] bug of normalizer : the body of tail-else is not {}"
		and annotate_expr (e: info aexpr) : ci_expr =
			(* local id mamanement *)
			let localid  = ref 0 in
			let new_id () =
				let lid = !localid in
					localid   := !localid +1;
					lid
			in
			(* recursive annotation *)
			let rec iter = function
			| AETEmp(_)            -> CI_Emp(new_id())
			| AEUni(_, e1, e2)     -> CI_Uni(new_id(), (new_id(), iter e1), (new_id(), iter e2))
			| AEGEmp(_)            -> CI_GEmp
			| AEDUni(_, e1,e2)     -> CI_DUni(iter e1, iter e2)
			| AEIMrk(_, mk, e)     -> CI_IMrk(namemap_lookup mkmp mk, (new_id(), iter e))
			| AEOMrk(_, mk)        -> CI_OMrk(namemap_lookup mkmp mk)
			| AEEdg(_, lab,e)      -> CI_Edg(new_id(), lab, (new_id(), iter e))
			| AEVar(_, v) when v==curVar -> gid_add (snd (namemap_lookup v2gcid v)); CI_Var(v)
			| AEVar(_, v)                -> gid_add (snd (namemap_lookup v2gcid v)); CI_OutVar(v, namemap_lookup v2gcid v)
			| (AERec(_, _, _, _,_,_,_)as e)
			| (AEApnd(_, _, _)  as e) -> begin match annotate_rec e curVar v2gcid with
			                       | CI_Rec(outCID, _, _, _, _, _) as ce ->
			                          gid_add (snd outCID); ce
			                       | CI_RecAnn((outAnnCID,_),_,outCID, _, _, _, _, _) as ce ->
			                          gid_add (snd outAnnCID); ce
			                       | _ -> failwith "[BUG] annotate_rec returning non-CI_Rec"
			                       end
			| AEIf(_, _,_,_)   -> failwith "[RESTRICTION] chkuncal supports if expression only at the top-level of rec-body"
			| AECyc(_, _)      -> failwith "[RESTRICTION] cycle() is not supported by chkuncal"
			| AEDoc(_, _)      -> failwith "[RESTRICTION] doc() is not supported by chkuncal"
			| AELet(_, _, _,_,_)  -> failwith "[RESTRICTION] let expression is not supported by chkuncal"
			| AELLet(_, _, _,_,_) -> failwith "[RESTRICTION] llet expression is not supported by chkuncal"
			in
				iter e
		in
		let argRoot =
			let (r,lst) = argCID in
				List.assq r (List.map2 (fun a b -> (a,b)) lst (fromTo 0 (List.length lst)))
		in
			((gid_base + nCopy*argRoot,!gid_used), nCopy, iter e)
(*  + nCopy * (fst argCID) *)
	(* main of read_uncal_for_typecheck *)
	in
		annotate_rec uncal "$db" (NameMap.fromList ["$db", (0,[0;1])])


let global_enforcement : (rooted_gcid * internal_schema) list ref = ref []
let add_global_enforcement e = if not (List.mem e (!global_enforcement)) then (global_enforcement := e :: !global_enforcement)
let global_assertion   : (rooted_gcid * internal_schema) list ref = ref []
let add_global_assertion e = if not (List.mem e (!global_assertion)) then (global_assertion := e :: !global_assertion)

(*****************************************************************************
 * UnCAL to MSO
 *****************************************************************************)

let rec generate_transformation_formula
	(eir: edgerepos_t)
	(e:   ci_expr)
	(possible_edge_names: name list)
	: (edgerepos_t * gcid_list * gcid)
=
	let cur_edgeCopyId = ref (-1) in (* [TODO] do not use side-effects...! *)
	let eir = ref eir in
	(* for each input edge (v,eu,eu), output edge is either *)
	(* copy-of-v, copy-of-eu, copy-of-eu *)
	let add_edge_vee (i,j,k,n,e) =
		if i<0 or j<0 or k<0 then failwith "[BUG] -1 -1 -1 edge : because of a rec body without &:= marker";
		eir := enroll_edge_I_J_K (!eir) (i,j,k, (`Var1 "e" |=| `Var1 "y") |&| e);
		if n = "@<labvar>@" then (* for $L edge: [TODO] do not use magic literal... *)
			List.iter (fun n ->
				eir := enroll_is_X_I (!eir) (n,j, static_msocall (!eir) (is_pr n) [!cur_edgeCopyId] [`T1 (`Var1 "e")] |&|
				                                  exists1 [`Var1 "x"; `Var1 "y"] e)
			) possible_edge_names
		else
			eir := enroll_is_X_I (!eir) (n,j, exists1 [`Var1 "x"; `Var1 "y"] e)
	in
	(* or copy-of-eu, copy-of-eu, copy-of-eu *)
	let add_edge_eee (i,j,k,n,e) =
		if i<0 or j<0 or k<0 then failwith "[BUG] -1 -1 -1 edge : because of a rec body without &:= marker";
		eir := enroll_edge_I_J_K (!eir) (i,j,k, (`Var1 "x" |=| `Var1 "e") |&| (`Var1 "e" |=| `Var1 "y")
		                                      |&| exists1 [`Var1 "x"] e);
		if n = "@<labvar>@" then (* for $L edge: [TODO] do not use magic literal...  *)
			List.iter (fun n ->
				eir := enroll_is_X_I (!eir) (n,j, static_msocall (!eir) (is_pr n) [!cur_edgeCopyId] [`T1 (`Var1 "e")] |&|
				                                  exists1 [`Var1 "x"; `Var1 "y"] e)
			) possible_edge_names
		else
			eir := enroll_is_X_I (!eir) (n,j,   exists1 [`Var1 "x"; `Var1 "y"] e)
	in
	(* visitor *)
	let rec visit_rec = function
		| CI_RecAnn((outGID,outScm), (varGID,varScm),
			outgids, nCopy, labName, treName, bodies, (gid_base, (argRoot,argCID), argExpr)) ->
			begin
				visit_rec (CI_Rec(outgids, nCopy, labName, treName, bodies, (gid_base, (argRoot,argCID), argExpr)));
(* ISSUE ENFORCEMENT: outgids obey star(outScm) *)
(* ISSUE ENFORCEMENT: argCID obey varscm *)
			end
		| CI_Rec(outgids, nCopy, labName, treName, bodies, (gid_base, (argRoot,argCID), argExpr)) ->
			begin match argExpr with
			| CI_Var(v)           -> ()
			| CI_Rec(_,_,_,_,_,_) -> visit_rec argExpr
			| CI_RecAnn(_,_,_,_,_,_,_,_) -> visit_rec argExpr
			| _ -> failwith "[RESTRICTION] Currently, rec argument must be a variable or a rec"
			end;
			for iv = 0 to (List.length argCID)-1 do
			 for ie = 0 to (List.length argCID)-1 do
			  for iu = 0 to (List.length argCID)-1 do if ie != iu then
				cur_edgeCopyId := List.nth argCID ie;
				let edgecond =
					static_msocall (!eir) edge_pr
						[List.nth argCID iv; List.nth argCID ie; List.nth argCID iu]
						[`T1 (`Var1 "x"); `T1 (`Var1 "e"); `T1 (`Var1 "y")]
				in
				(* add normal edges *)
			   List.iter (fun (cond, expr) ->
				let rec convcond cond =
					match cond with
					| ATrue(_) -> `True
					| AFalse(_) -> `False
					| ANot(_, e) -> msonot (convcond e)
					| AAnd(_, e1,e2) -> convcond e1 |&| convcond e2
					| AOr(_, e1,e2) -> convcond e1 ||| convcond e2
					| ALcmp(_, ALLit(_, ALLbl lab), ALOEq, ALVar(_, var))
					| ALcmp(_, ALVar(_, var), ALOEq, ALLit(_, ALLbl lab)) ->
						if var = labName then
							static_msocall (!eir) (is_pr ("E"^lab)) [List.nth argCID ie] [`T1 (`Var1 "e")]
						else
							failwith ("[RESTRICTION] outer scope variable "^lab^" cannot be used")
					| ALcmp(_, _, _, _) -> failwith "[RESTRICTION] comparisons other than $L=lab is not supported by chkuncal"
					| AIsemp(_, _)   -> failwith "[RESTRICTION] isEmpty() is not supported by chkuncal"
					| ABisim(_, _,_) -> failwith "[RESTRICTION] bisimilar() is not supported by chkuncal"
					| ALpred(_, _,_) -> failwith "[RESTRICTION] predicates in if-condtion is not supported by chkuncal"
				in
				visit false (-1) (-1) "|D|U|M|M|Y|"
					(edgecond |&| convcond cond |&|
	 					msonot (static_msocall (!eir) (is_pr "E") [List.nth argCID ie] [`T1 (`Var1 "e")])
					)
					(fun lc -> gid_base + iv*nCopy + lc)
					(fun lc -> gid_base + ie*nCopy + lc)
					(fun lc -> gid_base + iu*nCopy + lc)
					(labName, treName, List.nth argCID iu)
					expr
			   ) bodies;
				(* add eps edges *)
			    add_edge_vee (gid_base+iv*nCopy, gid_base+ie*nCopy, gid_base+iu*nCopy, "E",
					edgecond
					 |&|
					static_msocall (!eir) (is_pr "E") [List.nth argCID ie] [`T1 (`Var1 "e")]
				)
			  done
			 done
			done;
		| _ ->
			failwith "[BUG] visit_rec applied to not-rec expression"
	and visit (is_vee: bool) (cx: gcid) (cy: gcid) (lab: string) (cond: msoexpr_t)
		      (toGIDv: int->gcid) (toGIDe: int->gcid) (toGIDu: int->gcid) (labName, treName, argCID) e =
		let add_edge = (if is_vee then add_edge_vee else add_edge_eee) in
		match e with
		| CI_Emp(i) ->
			add_edge (cx, cy, (toGIDe i), lab, cond)
		| CI_Uni(i, (j1,e1), (j2,e2)) ->
			add_edge (cx, cy, (toGIDe i), lab, cond)
			; visit false (toGIDe i) (toGIDe j1) "E" cond toGIDv toGIDe toGIDu (labName, treName, argCID) e1
			; visit false (toGIDe i) (toGIDe j2) "E" cond toGIDv toGIDe toGIDu (labName, treName, argCID) e2
		| CI_GEmp ->
			()
		| CI_DUni(e1,e2) ->
			  visit false cx cy lab cond toGIDv toGIDe toGIDu (labName, treName, argCID) e1
			; visit false cx cy lab cond toGIDv toGIDe toGIDu (labName, treName, argCID) e2
		| CI_IMrk(i, (j, e)) ->
			visit true (toGIDv i) (toGIDe j) "E" cond toGIDv toGIDe toGIDu (labName, treName, argCID) e
		| CI_OMrk(i) ->
			add_edge (cx, cy, (toGIDu i), lab, cond)
		| CI_Edg(i, ALLit(_, ALLbl lab2), (j,e)) ->
			add_edge (cx, cy, (toGIDe i), lab, cond)
			; visit false (toGIDe i) (toGIDe j) ("E"^lab2) cond toGIDv toGIDe toGIDu (labName, treName, argCID) e
		| CI_Edg(i, ALLit(_, ALStr _), (j,e)) ->
			add_edge (cx, cy, (toGIDe i), lab, cond)
			; visit false (toGIDe i) (toGIDe j) ("DString") cond toGIDv toGIDe toGIDu (labName, treName, argCID) e
		| CI_Edg(i, ALLit(_, ALInt _), (j,e)) ->
			add_edge (cx, cy, (toGIDe i), lab, cond)
			; visit false (toGIDe i) (toGIDe j) ("DInt") cond toGIDv toGIDe toGIDu (labName, treName, argCID) e
		| CI_Edg(i, ALVar(_, var), (j,e)) when var = labName ->
			add_edge (cx, cy, (toGIDe i), lab, cond)
			; visit false (toGIDe i) (toGIDe j) ("@<labvar>@") cond toGIDv toGIDe toGIDu (labName, treName, argCID) e
		| CI_Edg(i, ALVar(_, var), (j,e)) ->
			failwith ("[RESTRICTION] outer scope variable reference "^var^" is not supported by chkuncal")
		| CI_Edg(i, _, (j,e)) ->
			failwith "[RESTRICTION] edge label must be a literal, string, or int"
		| CI_Var(var) when var = treName ->
			add_edge (cx, cy, argCID, lab, cond)
		| CI_Var(var) ->
			failwith ("[RESTRICTION] outer scope variable reference "^var^" is not supported by chkuncal")
		| CI_OutVar(var, ((vcr, _) as varCID)) ->
			add_edge (cx, cy, vcr, lab, cond)
		| CI_Rec(outgids, nCopy, labName, treName, bodies, (gid_base, argCID, argExpr)) as r->
			add_edge (cx, cy, gid_base, lab, cond);
			visit_rec r
		| CI_RecAnn(((outGIDroot,_) as outGID,outScm), (varGID,varScm),
				outgids, nCopy, labName, treName, bodies, (gid_base, argCID, argExpr)) as r->
			add_edge (cx, cy, outGIDroot, lab, cond);
			add_global_assertion (outGID, (starize outScm));
			add_global_assertion (varGID, varScm);
			visit_rec r
	in
	visit_rec e;
	let (outroot, outgid) = match e with CI_Rec(og, _, _, _, _, (ort, _, _)) -> og
                                       | CI_RecAnn((og,_), _, _, _, _, _, _, (ort, _, _)) -> og
	                                   | _ -> failwith "[BUG] visit_rec returned not-rec expression"
	in
		(!eir, outgid, outroot)



(*****************************************************************************
 * Main
 *****************************************************************************)

let to_mso
	(iScm : internal_schema)
	(tUcl : ci_expr)
	(oScm : internal_schema)
	(progress : string -> unit)
	: msoprogram_t
=
	let possible_edges = NameSet.union (edges_of_schema iScm) (edges_of_expr tUcl) in

	progress "...Converting UnCAL to MSO...\n";
	let eir: edgerepos_t     = enroll_edges_from_input_tree_encoding iScm 0 1 emptyEdgerepos in
	let rec iter_assertions eir = function
		| [] -> eir
		| ((rt,[g0;g1]), scm)::tl -> iter_assertions (enroll_edges_from_input_tree_encoding scm g0 g1 eir) tl
		| _ -> failwith "strange annotation id"
	in
	let rec gen_iter_assertions = function
		| [] -> []
		| ((rt,[g0;g1]), scm)::tl -> generate_preds_for_input_tree_encoding scm g1 @ gen_iter_assertions tl
		| _ -> failwith "strange annotation id"
	in
	let eir = iter_assertions eir (!global_assertion) in
(********)
	let (eir, outgid, oroot) = generate_transformation_formula eir tUcl (NameSet.elements possible_edges) in


	progress "...Generating auxiliary formulas...\n";
	let eir = introduce_aux_preds_specialized_for_outgoing eir (gcid_union [0;1] outgid) progress in

	progress "...Converting Schemas to MSO...\n";
		[`WS2S]
		@ [`Comment "Encoding of Input Graphs (from IN.KM3)"]
		@    generate_preds_for_input_tree_encoding iScm 1
		@    gen_iter_assertions (!global_assertion)
		@ [`Comment "Edge Relations (from IN.KM3 & TRANSFORM.UNCAL)"]
		@    generate_preds_for_edgeinfo eir
		@ [`Comment "Input Validity (from IN.KM3)"]
		@    generate_schema_formula eir "input_type" 0 [0;1] iScm
		@ [`Comment "Output Validity (from OUT.KM3)"]
		@    generate_schema_formula eir "output_type" oroot outgid oScm
		@ [`Comment "Debug (from IN.KM3)"]
		@    generate_preds_for_input_tree_encoding_debug iScm 1
		@ [`Comment "Main"]
		@   [`Assert(msocall (other_pr "tree_formed1") [])]
		@   [`Assert(msocall (other_pr "tree_formed_debug1") [])]
		@   [`Assert(msocall (other_pr "input_type")  [])]
		@   [`Main  (msocall (other_pr "output_type") [])]
