(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
(** The definition of MSO definable graph transduction system *)

open ExtSetMap
open MsoTcUtil
open StateMonad
open Mona

type name  = string
type label = Eps | Lab of name
let name_of_label = function Eps -> "E" | Lab x -> "E" ^ x
module NameSet = Km3.NameSet
module NameMap = Km3.NameMap

(** The types of concrete MSO formula *)
type concrete_msoexpr_t    = string Mona.msoexpr_t
type concrete_msodecl_t    = string Mona.msodecl_t
type concrete_msoprogram_t = string Mona.msoprogram_t

(** Abstract MSO formula used during the formula construction *)
type mypred = Edge | Outgoing | Is of string | Other of string
type abstract_msoexpr_t    = mypred Mona.msoexpr_t
type abstract_msodecl_t    = mypred Mona.msodecl_t
type abstract_msoprogram_t = mypred Mona.msoprogram_t

(**
	Copy-ID augmented with the origin information

	"CopyOfV n" means that the node (or edge) is created as the n-th
	copy of the node v (source node of the edge in recursion: v--e-->u)
 *)
type copynode = {orig: origin; id: copyid}
 and   copyid = int
 and   origin = CopyOfV | CopyOfE | CopyOfU | CopyOfRoot | EmptyRoot

module EdgeCmp = struct type t = copyid * copyid * copyid let compare = compare end
module EdgeSet = Set.Make(EdgeCmp)
module EdgeMap = Map.Make(EdgeCmp)

module NodeCmp = struct type t = copyid let compare = compare end
module NodeSet = Set.Make(NodeCmp)
module NodeMap = Map.Make(NodeCmp)

module NICmp = struct type t = name * copyid let compare = compare end
module NISet = Set.Make(NICmp)
module NIMap = Map.Make(NICmp)

module ICmp = struct type t = copyid let compare = compare end
module ISet = Set.Make(ICmp)
module IMap = Map.Make(ICmp)

module CopyIDCmp = struct type t = int list let compare = compare end
module CopyIDMap = Map.Make(CopyIDCmp)
module CopyIDSet = Map.Make(CopyIDCmp)

(** retrive origin (as a MSO term) from copynode *)
let term_of_node (v: copynode) =
	match v.orig with
	| CopyOfV    -> MSOFormula.v
	| CopyOfE    -> MSOFormula.e
	| CopyOfU    -> MSOFormula.u
	| CopyOfRoot -> MSOFormula.root
	| EmptyRoot  -> failwith_bug "empty graph was touched"

(** Representation of (intermediate) graphs in MSO-definable graph transduction system *)
type mso_graph = {root: copynode;  node_set: NodeSet.t;  edge_set: EdgeSet.t}

(** The dummy root node for the empty graph *)
let empty_root = {orig = EmptyRoot; id = -1}

(** The empty graph *)
let empty_graph = {root = empty_root;  node_set = NodeSet.empty;  edge_set = EdgeSet.empty}

(** Union of two graphs *)
let graph_union g1 g2 = {
	root     = (if g1.root.orig <> EmptyRoot then g1 else g2).root;
	node_set = NodeSet.union g1.node_set g2.node_set;
	edge_set = EdgeSet.union g1.edge_set g2.edge_set;
}

(** The data structure representing the whole transformation *)
type t = {
	copyid_map : copyid CopyIDMap.t; (* memo table for copyid generation *)
	pred_edge     : EdgeSet.t; (* set of non-false edge_I_J_K predicates *)
	pred_is       : NISet.t;   (* set of non-false is_X_I     predicates *)
	pred_outgo    : EdgeSet.t; (* set of non-false og_I_J_K   predicates *)
	pred_treeform : ISet.t;    (* set of non-false tf_I       predicates *)
	decllist      : concrete_msodecl_t list; (* reverse list of predicates in demand-driven order *)
	dutylist      : concrete_msoexpr_t list; (* list of duties *)
}

(* The list of MSO predicates used globally in the generated MSO formula *)
let initial_mso_environment : concrete_msodecl_t list =
	let open MSOFormula in [
		`WS2S;
		`Pred ("prefix_closed", [setX],
			forall1 [x] ((x|<-|setX) |=>| ((x |=| `Left `Root) ||| (`Parent x |<-| setX))));
	]

(** Empty MSO-definable graph transduction *)
let empty_msogt = {
	copyid_map    = CopyIDMap.empty;
	pred_edge     = EdgeSet.empty;
	pred_is       = NISet.empty;
	pred_outgo    = EdgeSet.empty;
	pred_treeform = ISet.empty;
	decllist      = List.rev initial_mso_environment;
	dutylist      = [];
}

(**
	The implementation of this module is written in monadic-style using the state monad.

	The value of type 'a action is a stateful action returning a value of type 'a
 *)
type 'a action = t -> t * 'a

(** Hash the given list (unique signature identifying a copy-id) into an integer *)
let gen_copyid (tup: int list) : copyid action =
	fun msogt ->
		match CopyIDMap.find_some tup msogt.copyid_map with
		| Some id ->
			(msogt, id)
		| None ->
			let id     = CopyIDMap.cardinal   msogt.copyid_map in
			let newMap = CopyIDMap.add tup id msogt.copyid_map in
				({msogt with copyid_map = newMap}, id)

(** Hash the given list (unique signature identifying a copy-id) into an integer *)
let gen_copynode (tup: int list) (o: origin) : copynode action =
	gen_copyid tup >>= (fun i -> return {orig=o; id=i})

(** support function of add_edge *)
let enroll_edge_I_J_K (i: copyid) (j: copyid) (k: copyid) (phi: concrete_msoexpr_t) : unit action =
	match phi with
	| `False -> return ()
	| _      -> state_get >>= (fun msogt ->
		if EdgeSet.mem (i,j,k) msogt.pred_edge then failwith_bug "copyid collision for edges";
		state_set { msogt with
			pred_edge = EdgeSet.add (i,j,k) msogt.pred_edge;
			decllist  = `Pred (sprintf "edge_%d_%d_%d" i j k,
				[MSOFormula.x;MSOFormula.y;MSOFormula.z], phi) :: msogt.decllist
		}
	)

(** support function of add_edge *)
let enroll_is_X_I (x: name) (i: copyid) (phi: concrete_msoexpr_t) : unit action =
	match phi with
	| `False -> return ()
	| _      -> state_get >>= (fun msogt ->
		if NISet.mem (x,i) msogt.pred_is then failwith_bug "copyid collision for edge labels";
		state_set { msogt with
			pred_is  = NISet.add (x,i) msogt.pred_is;
			decllist = `Pred (sprintf "is_%s_%d" x i, [MSOFormula.y], phi) :: msogt.decllist
		}
	)

(**
	Add an edge to the the MSO-definable transduction.

	It declares that the node (copy-of x) is connected to the node (copy-of z)
	by the edge (copy-of y) of label (l), when the formula (phi) is satisfied.
	If add_edge is called two or more times for the same combination of (l,x,y,z),
	they are automatically or-ed together.
 *)
let add_edge (lb: label) (nx: copynode) (ny: copynode) (nz: copynode) (phi: concrete_msoexpr_t) : unit action =
	let phiEd = let open MSOFormula in
		exists1 [v; e; u]
			(phi |&| (x |=| term_of_node nx) |&| (y |=| term_of_node ny) |&| (z |=| term_of_node nz))
	in
	let phiIs = let open MSOFormula in
		exists1 [v; e; u]
			(phi |&| (y |=| term_of_node ny))
	in
	let (nm, xi, yi, zi) = (name_of_label lb, nx.id, ny.id, nz.id) in
		enroll_is_X_I nm yi phiIs >>= (fun () -> enroll_edge_I_J_K xi yi zi phiEd)

(**
	Add a new input graph to the MSO-definable transduction.

	More specifically, it introduces a list of variables representing an input graph,
	and a list of predicates representing the graph (using the variables). Also,
	it introduces a predicate tree_formed, stating that the variables do encode a
	valid (finite) tree.
 *)
let add_graph (vi: copyid) (ei: copyid) (scms: MsoTcSchema.internal_schema list) : mso_graph action =
	let edgenames = NameSet.elements (List.fold_left (fun se scm ->
			NameSet.union se (MsoTcSchema.edges_of_schema scm)
		) NameSet.empty scms)
	in
	let edgeVars  = List.map (fun lab -> `Var2 ("C"^string_of_int ei^lab)) edgenames in
	fun msogt ->
		let msogt = List.fold_left (fun msogt var ->
				{msogt with decllist = `VarDecl var :: msogt.decllist}
			) msogt edgeVars
		in
		let msogt = {msogt with
			decllist =
				`Assert (let open MSOFormula in 
					msocall (sprintf "tree_formed_%d" ei) []
					|&| `Let2(setES, union_all edgeVars,
					       msocall ("prefix_closed") [setES] |&| msonot (root |<-| setES))
				) ::
				`Pred (sprintf "tree_formed_%d" ei, [], let open MSOFormula in 
					all_and (List.map (fun (e,f) -> `Empty(`Inter [e; f])) (pairs_of edgeVars))
				) ::
				msogt.decllist;
			pred_treeform = ISet.add ei msogt.pred_treeform;
		}
		in
		let msogt = List.fold_left (fun msogt lab ->
				fst (enroll_is_X_I lab ei (let open MSOFormula in
					y |<-| `Var2 ("C"^string_of_int ei^lab)
				) msogt)
			) msogt edgenames
		in
		let msogt, () = enroll_edge_I_J_K vi ei vi (let open MSOFormula in (* x,y,z *)
			msocall ("tree_formed_"^string_of_int ei) []
			|&|	(y |=| z)
			|&|	(y |<-| union_all edgeVars)
			|&|	forall2 [setX] (
				(
					(y |<-| setX)
					|&|
					forall1 [v] (
						((v |<-| setX) |&| (`Right(`Parent v) |=| v))
						|=>| (`Parent v |<-| setX)
					)
				)
				|=>|
					(`Left x |<-| setX)
			)
			) msogt
		in
			(msogt, {
				root     = {orig=CopyOfRoot; id=vi};
				node_set = NodeSet.fromList [vi; ei];
				edge_set = EdgeSet.singleton (vi,ei,vi);
			})

(** M-ake C-opy A-ware *)
let rec mca
	(rootid : copyid)             (* copy-id of the root *)
	(dmp    : copyid NameMap.t)   (* mapping from 1st-order variables to its copy-id *)
	(nodeid : copyid list)
	(edgeid : (copyid*copyid*copyid) list)
	(msogt  : t)
	(expr   : abstract_msoexpr_t) (* the formula to be converted *)
	: concrete_msoexpr_t
=
	let recur expr = mca rootid dmp nodeid edgeid msogt expr in
	let cid ky =
		try NameMap.find ky dmp with Not_found -> failwith_bug ("The variable "^ky^" has no copy-id")
	in
	let var2expand ts =
		List.fold_right (fun (`Var2 s) vs -> List.map (fun i -> `Var2(s^string_of_int i)) nodeid @ vs) ts []
	in
	let recur_order1quantification ts expr =
		let rec iter dmp es = function
		| []            -> mca rootid dmp nodeid edgeid msogt expr :: es
		| `Var1 s :: ts -> List.fold_right (fun i es -> iter (NameMap.add s i dmp) es ts) nodeid es
		in
			iter dmp [] ts
	in
	let concrete_msocall name ijk (args: term_t list) =
		match name, ijk with
		| Edge, [i;j;k] ->
			if EdgeSet.mem (i,j,k) msogt.pred_edge then
				`Call ((sprintf "edge_%d_%d_%d" i j k), args)
			else
				`False
		| Outgoing, [i;j;k] ->
			if EdgeSet.mem (i,j,k) msogt.pred_outgo then
				`Call ((sprintf "og_%d_%d_%d" i j k), args)
			else
				`False
		| Is x, [i] ->
			if NISet.mem (x,i) msogt.pred_is then
				if x = "E" then
					(* Aggressive epsilon elimination.
					   In the current version, all the edges are assigned different copy-ids.
					   Hence, if it can be an epsilon edge, then it is an epsilon edge.
					   Since in the MSO formula generated from the current MsoGT all the is_X_J
					   predicates are guarded by edge_I_J_K, this optimization is safe.
					 *)
					`True
				else
					`Call ((sprintf "is_%s_%d" x i), args)
			else
				`False
		| Other str, ijk ->
			`Call ((List.fold_left (fun s i -> s^"_"^string_of_int i) str ijk), args)
		| _ ->
			failwith_bug "mismatch in number of arguments in static_msocall"
	in
	let rec term2ith i = function
		| `Var2(s)   -> `Var2(s^string_of_int i)
		| `Union(ts) -> `Union(List.map (term2ith i) ts)
		| `Inter(ts) -> `Inter(List.map (term2ith i) ts)
	in
	let open MSOFormula in match expr with
	| `True  -> `True
	| `False -> `False
	| `Eq1 (`Var1 s1,`Var1 s2) -> if cid s1 = cid s2 then `Eq1 (`Var1 s1,`Var1 s2) else `False
	| `Neq1(`Var1 s1,`Var1 s2) -> if cid s1 = cid s2 then `Neq1(`Var1 s1,`Var1 s2) else `False
	| `Lt  (`Var1 s1,`Var1 s2) -> if cid s1 = cid s2 then `Lt  (`Var1 s1,`Var1 s2) else `False
	| `Le  (`Var1 s1,`Var1 s2) -> if cid s1 = cid s2 then `Le  (`Var1 s1,`Var1 s2) else `False
	| `Eq1 (_,_) -> failwith_bug "Constants and Funtions are Not Allowed as operands of =  in mac"
	| `Neq1(_,_) -> failwith_bug "Constants and Funtions are Not Allowed as operands of ~= in mac"
	| `Lt  (_,_) -> failwith_bug "Constants and Funtions are Not Allowed as operands of <  in mac"
	| `Le  (_,_) -> failwith_bug "Constants and Funtions are Not Allowed as operands of <= in mac"
	| `In   (`Var1 s1,`Var2 s2) -> `In   (`Var1 s1, `Var2 (s2 ^ string_of_int (cid s1)))
	| `NotIn(`Var1 s1,`Var2 s2) -> `NotIn(`Var1 s1, `Var2 (s2 ^ string_of_int (cid s1)))
	| `In   (`Root,   `Var2 s2) -> `In   (`Root,    `Var2 (s2 ^ string_of_int rootid))
	| `In   (_,_) -> failwith_bug "Constants and Funtions are Not Allowed as operands of 'in' in mac"
	| `NotIn(_,_) -> failwith_bug "Constants and Funtions are Not Allowed as operands of 'notin' in mac"
	| `Empty (t1)    -> `And(List.map (fun i -> `Empty (term2ith i t1)) nodeid)
	| `Subset(t1,t2) -> `And(List.map (fun i -> `Subset(term2ith i t1, term2ith i t2)) nodeid)
	| `Eq2   (t1,t2) -> `And(List.map (fun i -> `Eq2   (term2ith i t1, term2ith i t2)) nodeid)
	| `Neq2  (t1,t2) -> `Or (List.map (fun i -> `Neq2  (term2ith i t1, term2ith i t2)) nodeid)
	| `And(es)    -> all_and_with es recur
	| `Or(es)     -> all_or_with  es recur
	| `Not(e)     -> msonot (recur e)
	| `Imp(e1,e2) -> recur e1 |=>|  recur e2
	| `Iff(e1,e2) -> recur e1 |<=>| recur e2
	| `Ex1 (ts,e) -> exists1 ts (all_or  (recur_order1quantification ts e))
	| `All1(ts,e) -> forall1 ts (all_and (recur_order1quantification ts e))
	| `Ex2 (ts,e) -> exists2 (var2expand ts) (recur e)
	| `All2(ts,e) -> forall2 (var2expand ts) (recur e)
	(* optimization specific to our usecase : 
	   "forall_edge x e y" is dealt with differently from "forall x forall e forall y"
	   so that we avoid the meaningless generation of cases (x,e,y) never forms an edge. *)
	| `All1Edge([(`Var1(nx) as vx); (`Var1(ne) as ve); (`Var1(ny) as vy)], e) ->
		let e = msocall Edge [vx;ve;vy] |=>| e in
		let se =
			List.fold_right (fun (i,_,_) ->
				List.fold_right (fun (_,j,k) -> EdgeSet.add (i,j,k)) edgeid
			) edgeid EdgeSet.empty
		in
		forall1 [vx;ve;vy] (all_and(
			EdgeSet.fold (fun (i,j,k) acc ->
				mca rootid (NameMap.fromList [nx,i; ne,j; ny,k]) nodeid edgeid msogt e :: acc
			) se []
		))
	| `All1Edge(_, _) -> failwith_bug "invalid form of all1edge"
	| `Call(pr, ts) ->
		let rec iter ijk = function
			| []                -> concrete_msocall pr ijk ts
			| `T1(`Root)   ::ts -> iter (ijk @ [rootid]) ts
			| `T1(`Var1(s))::ts -> iter (ijk @ [cid s] ) ts
			| _ -> failwith_bug "Only order-1 variables are allowed as predicate arguments."
		in
			iter [] ts
	| `Let1(x,t,e) -> failwith_bug "mso-let expression is not supported for mca"
	| `Let2(x,t,e) -> failwith_bug "mso-let expression is not supported for mca"

let formula_outgoing : abstract_msoexpr_t = (* "from the node x we can reach the edge (_,y,z) via eps-closure" *)
	let open MSOFormula in
		exists1 [dmy] (msocall Edge [dmy;y;z])     (* (_,y,z) is indeed an edge, and *)
	|&| forall2 [setR] (                                              (* for any set *)
			((x |<-| setR)                                             (* containg x *)
			 |&| forall1edge [t1;t2;t3] (          (* and closed and eps-transition, *)
					((t1 |<-| setR) |&| msocall (Is "E") [t2]) |=>| (t3 |<-| setR)))
			|=>|                                            (* (_,e,y) is contained. *)
				exists1 [v] (msocall Edge [v;y;z] |&| (v |<-| setR)))
	|&| msonot (msocall (Is "E") [y])        (* also, (_,y,z) is not an epsilon edge *)

let formula_conformschema scm vroot : abstract_msoexpr_t = (* "the graph conforms to the schema scm" *)
	let decl_of_schema (MsoTcSchema.ISchema (_, decls)) t =
		let MsoTcSchema.IDecl decl = 
			try NameMap.find t decls with Not_found -> failwith_bug ("The key "^t^" not found")
		in
			NameMap.fold (fun en (MsoTcSchema.IType tl) acc ->
				(en, MSOFormula.union_all (List.map (fun s->`Var2 s) tl)) :: acc
			) decl []
	in
	let es = MsoTcSchema.edgenames_of_schema scm in
	let ts = List.map (fun s -> `Var2 s) (MsoTcSchema.typenames_of_schema scm) in
	let rt = List.map (fun s -> `Var2 s) (MsoTcSchema.roottype_of_schema  scm) in
	let open MSOFormula in
		exists2 ts (                                         (* there exists a type-assignment such that *)
			(vroot |<-| union_all rt)                                   (* root is assigned  the rootype *)
		|&|	forall1 [x] (all_and_with ts (fun (`Var2 typnm as t) -> (* and, for all nodes x and types t, *)
				(x |<-| t) |=>| (                                         (* when x is assigned a type t *)
					forall1 [e;y] (msocall Outgoing [x; e; y] |=>| (           (* its all outgoing edges *)
						let decl = decl_of_schema scm typnm in              (* obey to the schema, i.e., *)
							all_or_with decl (fun (edgename, dt) -> (* they've matching edges in the scm *)
								msocall (Is edgename) [e] |&| (y |<-| dt)         (* with a correct type *)
		)))))))

(** generate the list of "outgoing" predicates for the given graph *)
let generate_pred_outgoing (g: mso_graph) : unit action =
	let se = (* list of indices meaningful for "outgoing" *)
		EdgeSet.fold (fun (i,_,_) ->
			EdgeSet.fold (fun (_,j,k) -> EdgeSet.add (i,j,k)) g.edge_set
		) g.edge_set EdgeSet.empty
	in
	state_modify (EdgeSet.fold (fun (i,j,k) msogt ->
		if EdgeSet.mem (i,j,k) msogt.pred_outgo then
			msogt
		else
			let phi =
				let rootid = g.root.id in
				let nodeid = NodeSet.elements g.node_set in
				let edgeid = EdgeSet.elements g.edge_set in
				let dmp = NameMap.fromList ["x",i; "y",j; "z",k] in
				(* very specific optimization here *)
				match (mca rootid dmp nodeid edgeid msogt formula_outgoing) with
				| `And( [_; `All2(_, `Imp(`In(_,`Var2 rx), `Ex1(_, `And([`Call(eijk,_);`In(_,`Var2 rv)]))))] )
					when rx<>rv -> `False
				| `And( [_; `All2(_, `Imp(`In(_,`Var2 rx), `Ex1(_, `And([`Call(eijk,_);`In(_,`Var2 rv)]))))] )
					when rx=rv -> `Call(eijk, [`T1 (`Var1 "x"); `T1 (`Var1 "y"); `T1 (`Var1 "z")])
				| phi -> phi
			in
			if phi = `False then msogt else
				{msogt with
					pred_outgo = EdgeSet.add (i,j,k) msogt.pred_outgo;
					decllist   = `Pred (
						sprintf "og_%d_%d_%d" i j k,
						[MSOFormula.x; MSOFormula.y; MSOFormula.z],
						phi
					):: msogt.decllist}
	) se)

(** helper function for emit_duty and emit_right *)
let generate_schema_formula (g: mso_graph) (scm: MsoTcSchema.internal_schema) (isRoot: bool)
	: concrete_msoexpr_t action =
	let e      = formula_conformschema scm (if isRoot then `Root else `Var1 "u") in
	let rootid = g.root.id in
	let nodeid = NodeSet.elements g.node_set in
	let edgeid = EdgeSet.elements g.edge_set in
	let idmap  = if isRoot then NameMap.empty else NameMap.singleton "u" g.root.id in
	generate_pred_outgoing g >>= (fun ()    ->
	state_get                >>= (fun msogt ->
	return (mca rootid idmap nodeid edgeid msogt e)
))

(** Generate and register a formula stating that a graph must satisfy a schema *)
let emit_duty (g: mso_graph) (cond: concrete_msoexpr_t) (scm: MsoTcSchema.internal_schema) : unit action =
	generate_schema_formula g scm (cond=`True) >>= (fun phi   ->
	let phi = if cond = `True then phi else let open MSOFormula in forall1 [v;e;u] (cond |=>| phi) in
	state_get                     >>= (fun msogt ->
	state_set {msogt with dutylist = phi :: msogt.dutylist}
))

(** Generate and register a formula stating that a graph can be assumted to satisfy a schema *)
let emit_right (g: mso_graph) (scm: MsoTcSchema.internal_schema) : unit action =
	generate_schema_formula g scm true >>= (fun phi   ->
	state_get                          >>= (fun msogt ->
	state_set {msogt with decllist = `Assert phi :: msogt.decllist}
))

(** This is the finalizing function to obtain a MSO formula from the whole UnCAL transforamtion *)
let generate_whole_mso : concrete_msoprogram_t action =
	state_get >>= (fun msogt ->
	return (List.rev msogt.decllist @ List.map (fun p -> `Main p) msogt.dutylist)
)
