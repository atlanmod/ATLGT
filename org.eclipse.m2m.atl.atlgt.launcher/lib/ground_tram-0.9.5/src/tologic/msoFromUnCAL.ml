(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
(**
	Convert KM3+UnCAL+KM3 to MSO formulas asserting type correctness.

	This module describes the inductive traversal on UnCAL expressions,
	the detail of the management of MSO formulas are writtein in the MsoGT
	module.
 *)

open ExtSetMap
open UnCAL
open MsoTcUtil
open StateMonad
open Mona
open MsoGT

(** The type of AST of UnCAL used in this module *)
type uncal_ast = info UnCAL.aexpr
 and info = {annot: string option; unique_id: int}

(** Extract the set of markers used inside the recursion body *)
let extract_markers (e: 'a UnCAL.aexpr) : name list =
	let rec impl e set =
		match e with
		| AETEmp(ann)          -> set
		| AEEdg(ann, lab, e)   -> impl e set
		| AEUni(ann, e1, e2)   -> impl e1 (impl e2 set)
		| AEIMrk(ann, mrk, e)  -> NameSet.add mrk (impl e set)
		| AEOMrk(ann, mrk)     -> NameSet.add mrk set
		| AEGEmp(ann)          -> set
		| AEDUni(ann, e1, e2)  -> impl e1 (impl e2 set)
		| AEApnd(ann, e1, e2)  -> set (* because, @ should only be used in the form & @ rec *)
		| AECyc(ann, e)        -> impl e set
		| AEVar(ann, gvar)     -> set
		| AEDoc(ann, filename) -> set
		| AEIf(ann, cond, e1, e2)                    -> impl e1 (impl e2 set)
		| AERec(ann, lvar, annl, gvar, anng, eb, ea) -> set
		| AELet(ann, gvar, anng, ea, eb)             -> impl ea (impl eb set)
		| AELLet(ann, lvar, annl, labexpr, eb)       -> impl eb set
	in
		NameSet.elements (impl e NameSet.empty)

(** Assign unique IDs to the expression *)
let decorate_with_fresh_id (e: UnCAL.info UnCAL.aexpr) : info UnCAL.aexpr =
	let i = ref 100000000 in
	let gen() = let v = !i in (incr i; v) in
	let rec reca ann = {annot=ann.UnCAL.annot; unique_id=gen()}
	and rece = function
	| AETEmp(ann)          -> AETEmp(reca ann)
	| AEEdg(ann, lab, e)   -> AEEdg(reca ann, recl lab, rece e)
	| AEUni(ann, e1, e2)   -> AEUni(reca ann, rece e1, rece e2)
	| AEIMrk(ann, mrk, e)  -> AEIMrk(reca ann, mrk, rece e)
	| AEOMrk(ann, mrk)     -> AEOMrk(reca ann, mrk)
	| AEGEmp(ann)          -> AEGEmp(reca ann)
	| AEDUni(ann, e1, e2)  -> AEDUni(reca ann, rece e1, rece e2)
	| AEApnd(ann, e1, e2)  -> AEApnd(reca ann, rece e1, rece e2)
	| AECyc(ann, e)        -> AECyc(reca ann, rece e)
	| AEVar(ann, gvar)     -> AEVar(reca ann, gvar)
	| AEDoc(ann, filename) -> AEDoc(reca ann, filename)
	| AEIf(ann, cond, e1, e2)                    -> AEIf(reca ann, recb cond, rece e1, rece e2)
	| AELet(ann, gvar, anng, ea, eb)             -> AELet(reca ann, gvar, reca anng, rece ea, rece eb)
	| AELLet(ann, lvar, annl, labexpr, eb)       -> AELLet(reca ann, lvar, reca annl, recl labexpr, rece eb)
	| AERec(ann, lvar, annl, gvar, anng, eb, ea) ->
		(* do another job here. insert explicit treatment of epsilon edges *)
		(* todo: move to add_implicit_marker *)
		let eb =
			let markers = extract_markers eb in
			let aNone = {UnCAL.annot=None} in
				AEIf(aNone,
					ALcmp(aNone, ALVar(aNone,lvar), ALOEq, ALLit(aNone,ALEps)),
					List.fold_left (fun e m -> AEIMrk(aNone,m,AEOMrk(aNone,m))) (AEGEmp aNone) markers,
					eb)
		in
			AERec(reca ann, lvar, reca annl, gvar, reca anng, rece eb, rece ea)
	and recb = function
	| AIsemp(ann, e)       -> AIsemp(reca ann, rece e)
	| ABisim(ann, e1, e2)  -> ABisim(reca ann, rece e1, rece e2)
	| ALpred(ann, pred, p) -> ALpred(reca ann, pred, recl p)
	| ATrue(ann)          -> ATrue(reca ann)
	| AFalse(ann)         -> AFalse(reca ann)
	| ANot(ann, be)       -> ANot(reca ann, recb be)
	| AAnd(ann, be1, be2) -> AAnd(reca ann, recb be1, recb be2)
	| AOr(ann, be1, be2)  -> AOr(reca ann, recb be1, recb be2)
	| ALcmp(ann, e1, c, e2) -> ALcmp(reca ann, recl e1, c, recl e2)
	and recl = function
	| ALVar(ann, x) -> ALVar(reca ann, x)
	| ALLit(ann, x) -> ALLit(reca ann, x)
	| ALBin(ann, l1, x, l2) -> ALBin(reca ann, recl l1, x, recl l2)
	in
		rece e

(** make implicit markers explicit *)
let add_implicit_marker (e: UnCAL.info UnCAL.aexpr) : UnCAL.info UnCAL.aexpr =
	let rec impl = function
	| AETEmp(ann)          -> AETEmp(ann)
	| AEEdg(ann, lab, e)   -> AEEdg(ann, lab, impl e)
	| AEUni(ann, e1, e2)   -> AEUni(ann, impl e1, impl e2)
	| AEIMrk(ann, mrk, e)  -> AEIMrk(ann, mrk, impl e)
	| AEOMrk(ann, mrk)     -> AEOMrk(ann, mrk)
	| AEGEmp(ann)          -> AEGEmp(ann)
	| AEDUni(ann, e1, e2)  -> AEDUni(ann, impl e1, impl e2)
	| AECyc(ann, e)        -> AECyc(ann, impl e)
	| AEVar(ann, gvar)     -> AEVar(ann, gvar)
	| AEDoc(ann, filename) -> AEDoc(ann, filename)
	| AEIf(ann, cond, e1, e2)                    -> AEIf(ann, cond, impl e1, impl e2)
	| AELet(ann, gvar, anng, ea, eb)             -> AELet(ann, gvar, anng, impl ea, impl eb)
	| AELLet(ann, lvar, annl, labexpr, eb)       -> AELLet(ann, lvar, annl, labexpr, impl eb)
	| AEApnd(a1, AEOMrk(a2, mrk), AERec(a3, lvar, annl, gvar, anng, eb, ea)) -> (* explicit marker *)
		AEApnd(a1, AEOMrk(a2, mrk), AERec(a3, lvar, annl, gvar, anng, impl_body eb, impl ea))
	| AEApnd(ann, e1, e2)  -> AEApnd(ann, impl e1, impl e2)
	| AERec(a3, lvar, annl, gvar, anng, eb, ea) -> (* implicit *)
		AEApnd({UnCAL.annot=None},
			AEOMrk({UnCAL.annot=None}, "&"), AERec(a3, lvar, annl, gvar, anng, impl_body eb, impl ea))
	and impl_body = function
	| AEIMrk(ann, mrk, e)  -> AEIMrk(ann, mrk, impl e)
	| AEGEmp(ann)          -> AEGEmp(ann)
	| AEDUni(ann, e1, e2)  -> AEDUni(ann, impl_body e1, impl_body e2)
	| e -> AEIMrk({UnCAL.annot=None}, "&", impl e)
	in
		impl e

(** Returns the unique id of the given UnCAL subexpression. *)
let position_id_of (e: uncal_ast) : int =
	match e with
	| AETEmp(ann)          -> ann.unique_id
	| AEEdg(ann, lab, e)   -> ann.unique_id
	| AEUni(ann, e1, e2)   -> ann.unique_id
	| AEIMrk(ann, mrk, e)  -> ann.unique_id
	| AEOMrk(ann, mrk)     -> ann.unique_id
	| AEGEmp(ann)          -> ann.unique_id
	| AEDUni(ann, e1, e2)  -> ann.unique_id
	| AEApnd(ann, e1, e2)  -> ann.unique_id
	| AECyc(ann, e)        -> ann.unique_id
	| AEVar(ann, gvar)     -> ann.unique_id
	| AEDoc(ann, filename) -> ann.unique_id
	| AEIf(ann, cond, e1, e2)                    -> ann.unique_id
	| AERec(ann, lvar, annl, gvar, anng, eb, ea) -> ann.unique_id
	| AELet(ann, gvar, anng, ea, eb)             -> ann.unique_id
	| AELLet(ann, lvar, annl, labexpr, eb)       -> ann.unique_id

(** Convert the name of a marker to 0-based index *)
let markername_to_copyid (expr: uncal_ast) (mrk: name) (markers: name list) : int =
	try fst (findi (fun i e->e=mrk) markers)
	with _-> failwith_unsupported "unusual use of markers"

(** Is annotation used or not; inspects deeply *)
let has_annotation_inside eb =
	let rec impl e =
		match e with
		| AETEmp(ann)          -> false
		| AEEdg(ann, lab, e)   -> impl e
		| AEUni(ann, e1, e2)   -> impl e1 || impl e2
		| AEIMrk(ann, mrk, e)  -> impl e
		| AEOMrk(ann, mrk)     -> false
		| AEGEmp(ann)          -> false
		| AEDUni(ann, e1, e2)  -> impl e1 || impl e2
		| AEApnd(ann, e1, e2)  -> impl e1 || impl e2
		| AECyc(ann, e)        -> impl e
		| AEVar({annot=None  }, _) -> false
		| AEVar({annot=Some _}, gvar) -> true
		| AEDoc(ann, filename) -> false
		| AEIf(ann, cond, e1, e2)                    -> impl e1 || impl e2
		| AERec({annot=None}, lvar, annl, gvar, {annot=None}, eb, ea) -> impl eb || impl ea
		| AERec(_, lvar, annl, gvar, _, eb, ea) -> true
		| AELet(ann, gvar, anng, ea, eb)       -> impl ea || impl eb
		| AELLet(ann, lvar, annl, labexpr, eb) -> impl eb
	in
		impl eb

(** Convert boolean expression into MSO *)
let rec bool2mso
	(curLVar : name)
	(ce      : copyid)
	(msogt   : MsoGT.t)
	(be      : info UnCAL.abexpr)
	: concrete_msoexpr_t
=
	let recur be = bool2mso curLVar ce msogt be in
	let open MSOFormula in match be with
	| AIsemp(annot, e)       -> failwith_unsupported "isEmpty is not supported in verifier"
	| ABisim(annot, e1, e2)  -> failwith_unsupported "bisimilarity test is not supported in verifier"
	| ALpred(annot, pred, p) -> failwith_unsupported "predicates are not supported in verifier"
	| ATrue(annot)          -> `True
	| AFalse(annot)         -> `False
	| ANot(annot, be)       -> msonot (recur be)
	| AAnd(annot, be1, be2) -> recur be1 |&| recur be2
	| AOr(annot, be1, be2)  -> recur be1 ||| recur be2
	| ALcmp(annot, ALVar(_, v), ALOEq, ALLit(_, ALLbl lab))
	| ALcmp(annot, ALLit(_, ALLbl lab), ALOEq, ALVar(_, v)) -> 
		if v = curLVar then
			if NISet.mem ("E"^lab,ce) msogt.pred_is then
				msocall (sprintf "is_E%s_%d" lab ce) [MSOFormula.e]
			else
				`False
		else
			failwith_unsupported ("outer scope label variable "^v^" cannot be used")
	| ALcmp(annot, ALVar(_, v), ALOEq, ALLit(_, ALEps))
	| ALcmp(annot, ALLit(_, ALEps), ALOEq, ALVar(_, v)) -> 
		if v = curLVar then
			if NISet.mem ("E",ce) msogt.pred_is then
				msocall (sprintf "is_E_%d" ce) [MSOFormula.e]
			else
				`False
		else
			failwith_unsupported ("outer scope label variable "^v^" cannot be used")
	| ALcmp(annot, _, _, _) ->
		failwith_unsupported "comparison other than $L=lab or lab=$L is not supported d in verifier"

(** Gather all the annotated schemas on $G *)
let gather_annotation gvar eb : MsoTcSchema.internal_schema list =
	let rec impl e ss =
		match e with
		| AETEmp(ann)          -> ss
		| AEEdg(ann, lab, e)   -> impl e ss
		| AEUni(ann, e1, e2)   -> impl e1 (impl e2 ss)
		| AEIMrk(ann, mrk, e)  -> impl e ss
		| AEOMrk(ann, mrk)     -> ss
		| AEGEmp(ann)          -> ss
		| AEDUni(ann, e1, e2)  -> impl e1 (impl e2 ss)
		| AEApnd(ann, e1, e2)  -> impl e1 (impl e2 ss)
		| AECyc(ann, e)        -> impl e ss
		| AEVar({annot=Some scm}, gv) when gv=gvar -> MsoTcSchema.load_schema_from_file scm :: ss
		| AEVar(_, gvar) -> ss
		| AEDoc(ann, filename) -> ss
		| AEIf(ann, cond, e1, e2)                    -> impl e1 (impl e2 ss)
		| AERec(ann, lvar, annl, gv, anng, eb, ea) when gv=gvar -> impl ea ss
		| AERec(ann, lvar, annl, gv, anng, eb, ea) -> impl eb (impl ea ss)
		| AELet(ann, gvar, anng, ea, eb)       -> impl ea (impl eb ss)
		| AELLet(ann, lvar, annl, labexpr, eb) -> impl eb ss
	in
		impl eb []

(**
  The main function implementing convertion from UnCAL to MSO.

  It convers UnCAL AST (with annotation containing type information for subexpressions
  in the form of filenames of KM3 schemas) into a set of MSO formulas.
  This is the internal inductive definition having quite a few auxiliary parameters.
  Usually it should only be called from the facade function generate_type_validity_formula.

  This is a straightforward implementation of our algorithm described in our paper,
  except one point: rootMe. The variable is introduced for optimizing away as many
  epsilon edges as possible.
  For instance, we translate
    {[ e1 U e2 ]}
  by
    {[ let node = generate_new_node in
       let _ = uncal2mso e1 (rootMe:=node) in 
       let _ = uncal2mso e2 (rootMe:=node) in
         node ]}
  instead of
    {[ let node = generate_new_node in
       let root1 = uncal2mso e1 in
       let root2 = uncal2mso e2 in
         add_edge node--EPS-->root1;
         add_edge node--EPS-->root2;
         node ]}
  This eliminates most of the epsilon edges, except the situations
    {[ &m := &m
       &m := rec(...)
       &m := $g ]}
  where the eps-edge is really needed so to distinguish input markers
 *)
let rec uncal2mso
	(expr            : uncal_ast)                (* current subformula *)
	((cv,ce,cu) as c : copyid * copyid * copyid) (* current edge in attention *)
	(phi             : concrete_msoexpr_t)       (* the condition that current subformula is executed *)
	(markers         : name list)                (* list of markers *)
	(curGVar         : name)                     (* current graph variable *)
	(curLVar         : name)                     (* current label variable *)
	(cuGraph         : mso_graph)                (* the graph pointed by $G *)
	(gamma           : mso_graph NameMap.t)      (* mapping from outer variable to annotation-enabled graph *)
	(rootMe          : copynode)                 (* Unless EmptyRoot, make him the root node *)
	: mso_graph MsoGT.action
=
	(********* utilities ********)
	let recur e = uncal2mso e c phi markers curGVar curLVar cuGraph gamma empty_root in
	let recurRooted me e = uncal2mso e c phi markers curGVar curLVar cuGraph gamma me in
	let return_with_rootMe g =
		if rootMe.orig = EmptyRoot then
			return g
		else
			let p = position_id_of expr in
			let n0 = rootMe in
			gen_copynode [ce; p; 9] CopyOfE >>= (fun n1 ->
			add_edge Eps n0 n1 g.root phi   >>= (fun () ->
				return {
					root     = n0;
					node_set = NodeSet.addl [n0.id; n1.id] g.node_set;
					edge_set = EdgeSet.add  (n0.id, n1.id, g.root.id) g.edge_set;	
			}))
	in
	let my_root rootMe neoSig orig : copynode action =
		if rootMe.orig = EmptyRoot then
			gen_copyid neoSig >>= (fun id -> return {orig=orig; id=id})
		else
			return rootMe
	in
	(********* main induction ********)
	match expr with
	| AETEmp(ann) ->
		let p = position_id_of expr in
		my_root rootMe [ce; p; 0] (if ce=0 then CopyOfRoot else CopyOfE) >>= (fun n0 ->
			return {
				root     = n0;
				node_set = NodeSet.singleton n0.id;
				edge_set = EdgeSet.empty;
			})

	| AEEdg(ann, ALLit(annl, ALLbl lab), e) ->
		let p = position_id_of expr in
		my_root rootMe [ce; p; 0] (if ce=0 then CopyOfRoot else CopyOfE)    >>= (fun n0 ->
		gen_copynode   [ce; p; 1] (if ce=0 then CopyOfRoot else CopyOfE)    >>= (fun n1 ->
		recur e                              >>= (fun g1 ->
		add_edge (Lab lab) n0 n1 g1.root phi >>= (fun () ->
			return {
				root     = n0;
				node_set = NodeSet.addl [n0.id; n1.id]             g1.node_set;
				edge_set = EdgeSet.add  (n0.id, n1.id, g1.root.id) g1.edge_set;	
			}))))

	| AEEdg(ann, _, e) ->
		failwith_todo "non-constant edge label"

	| AEIMrk(ann, mrk, e) ->
		let p = position_id_of expr in
		let m = markername_to_copyid expr mrk markers in
		gen_copynode [cv; m] CopyOfV >>= (fun n0 ->
			recurRooted n0 e
		)

	| AEOMrk(ann, mrk) ->
		let m = markername_to_copyid expr mrk markers in
		gen_copynode [cu; m] CopyOfU >>= (fun n2 ->
			return_with_rootMe {
				root     = n2;
				node_set = NodeSet.singleton n2.id;
				edge_set = EdgeSet.empty;
			})

	| AEGEmp(ann) ->
		return empty_graph

	| AEDUni(ann, e1, e2) ->
		recur e1 >>= (fun g1 ->
		recur e2 >>= (fun g2 ->
			let g = MsoGT.graph_union g1 g2 in
				if rootMe.orig = EmptyRoot then return g else return {g with root = rootMe}
		))

	| AEUni(ann, e1, e2) ->
		let p = position_id_of expr in
		my_root rootMe [ce; p; 0] (if ce=0 then CopyOfRoot else CopyOfE) >>= (fun n0 ->
		recurRooted n0 e1 >>= (fun g1 ->
		recurRooted n0 e2 >>= (fun g2 ->
			return {
				root     = n0;
				node_set = NodeSet.add n0.id (NodeSet.union g1.node_set g2.node_set);
				edge_set = EdgeSet.union g1.edge_set g2.edge_set;
			})))

	| AEIf(ann, cond, e1, e2) ->
		let p  = position_id_of expr in
		my_root rootMe [ce; p; 0] (if ce=0 then CopyOfRoot else CopyOfE) >>= (fun n0 ->
		state_get >>= (fun msogt ->
		let phiCond = bool2mso curLVar ce msogt cond in
		let phiT = let open MSOFormula in phi |&| phiCond in
		let phiF = let open MSOFormula in phi |&| msonot phiCond in
		uncal2mso e1 c phiT markers curGVar curLVar cuGraph gamma n0 >>= (fun g1 ->
		uncal2mso e2 c phiF markers curGVar curLVar cuGraph gamma n0 >>= (fun g2 ->
			return {
				root     = n0;
				node_set = NodeSet.add n0.id (NodeSet.union g1.node_set g2.node_set);
				edge_set = EdgeSet.union g1.edge_set g2.edge_set;
			}))))

	| AEVar(_, gvar) when gvar = curGVar ->
		return_with_rootMe cuGraph
	| AEVar({annot=None}, gvar) ->
		failwith_unsupported ("nested recursion requires variable annotation for "^gvar)

	| AEVar({annot=Some km3}, gvar) ->
		let g = match NameMap.find_some gvar gamma with Some g -> g
			| _ -> failwith_unsupported ("nested recursion requires variable annotation for "^gvar)
		in
			return g

	| AEApnd(annA, AEOMrk(annM, mrk), AERec(annR, lvar, annL, gvar, annG, eb, ea)) when has_annotation_inside eb ->
		begin match annR with
		| {annot = None} ->
			failwith_error "if annotation is used inside a rec, the rec expression must also be annotated"
		| {annot = Some km3} ->
			let p = position_id_of expr in
			let markers' = extract_markers eb in
			let markerid = markername_to_copyid expr mrk markers' in
			recur ea                   >>= (fun ga -> (* convert the argument graph *)
			let anos_for_current = gather_annotation curGVar eb in
			stateful_fold anos_for_current () (fun scm () ->
				emit_duty cuGraph phi scm
			) >>= (fun () ->
			let anos = gather_annotation gvar eb in   (* gather the annotations on $G *)
			(
				if List.length anos > 0 then
					gen_copyid [p; 0]          >>= (fun vg_vi ->
					gen_copyid [p; 1]          >>= (fun vg_ei ->
					add_graph vg_vi vg_ei anos >>= (fun vg -> (* enroll new 'opaque' graph for $G *)
					(* emit the formula stating the annotation can be assumed *)
					stateful_fold anos () (fun scmV () -> emit_right vg scmV) >>= (fun () ->
					return (NameMap.add gvar vg gamma)
				))))
				else
					return gamma
			) >>= (fun gamma ->
			(* then for each edge, convert the body and take the union*)
			stateful_fold (EdgeSet.elements ga.edge_set) MsoGT.empty_graph (fun ((cv,ce,cu) as c) g0 ->
				let phi = let open MSOFormula in msocall (sprintf "edge_%d_%d_%d" cv ce cu) [v;e;u] in
				let ga = {ga with root = {orig=CopyOfU; id=cu}} in
				uncal2mso eb c phi markers' gvar lvar ga gamma empty_root >>= (fun g1 ->
					return (MsoGT.graph_union g0 g1)
			)) >>= (fun gOut ->
			gen_copyid [ga.root.id; markerid] >>= (fun n0 ->
			let gOut = {gOut with root = {ga.root with id=n0}} in (* adjust the root node *)
			(* tasks about the annotation on the return value *)
			let scmR = MsoTcSchema.load_schema_from_file km3 in
			emit_duty gOut `True scmR  >>= (fun () -> (* the 'transparent' return graph must obey the annotation *)
			gen_copyid [p; 2]            >>= (fun rg_vi ->
			gen_copyid [p; 3]            >>= (fun rg_ei ->
			add_graph rg_vi rg_ei [scmR] >>= (fun rg -> (* add new 'opaque' graph for the return value *)
			emit_right rg scmR           >>= (fun () -> (* emit the assumption *)
				return_with_rootMe rg (* return the opaque return graph *)
			))))))))))
		end

	| AEApnd(annA, AEOMrk(annM, mrk), AERec(annR, lvar, annL, gvar, annG, eb, ea)) (* no annotation *) ->
		let p = position_id_of expr in
		let markers' = extract_markers eb in
		let markerid = markername_to_copyid expr mrk markers' in
		recur ea >>= (fun ga -> (* convert the argument graph *)
		(* then for each edge, convert the body and take the union*)
		stateful_fold (EdgeSet.elements ga.edge_set) MsoGT.empty_graph (fun ((cv,ce,cu) as c) g0 ->
			let phi  = let open MSOFormula in msocall (sprintf "edge_%d_%d_%d" cv ce cu) [v;e;u] in
			let ga = {ga with root = {orig=CopyOfU; id=cu}} in
			uncal2mso eb c phi markers' gvar lvar ga gamma empty_root >>= (fun g1 ->
				return (MsoGT.graph_union g0 g1)
		)) >>= (fun gOut ->
		gen_copyid [ga.root.id; markerid] >>= (fun n0 ->
		let gOut = {gOut with root = {ga.root with id=n0}} in (* adjust the root node *)
			return_with_rootMe gOut (* return the opaque return graph *)
		)))

	(* Other constructors are not (yet) supported by the verifier *)
	| AEApnd(ann, e1, e2) ->
		failwith_unsupported "@ can only be used in restricted form"
	| AERec(ann, lvar, annl, gvar, anng, eb, ea) ->
		failwith_unsupported "rec must be prefixed by projection: &m@rec(\\(...)...)(...)"
	| AECyc(ann, e) ->
		failwith_unsupported "cycle"
	| AEDoc(ann, filename) ->
		failwith_unsupported "doc"
	| AELet(ann, gvar, anng, ea, eb) ->
		failwith_unsupported "let"
	| AELLet(ann, lvar, annl, labexpr, eb) ->
		failwith_unsupported "llet"

(** Entry point of this module *)
let generate_type_validity_formula
	(scmi     : MsoTcSchema.internal_schema)
	(e        : UnCAL.info UnCAL.aexpr)
	(scmo     : MsoTcSchema.internal_schema)
	(progress : string -> unit)
	: string Mona.msoprogram_t
=
	let e = decorate_with_fresh_id (add_implicit_marker e) in
	let run =
		gen_copyid []        >>= (fun ng  -> (* generate copyid for global expressions *)
		gen_copyid [ng; 0]   >>= (fun p   ->
		gen_copyid [ng; 1]   >>= (fun q   -> (* generate copyids for the $db graph *)
		add_graph p q [scmi] >>= (fun gIn -> (* enroll the graph *)
		emit_right gIn scmi  >>= (fun ()  -> (* emit assumption that $db conforms to the input schema *)
		let varDB   = "$db" in
		let varLB   = "<bug: no global label variable>" in
		let cond    = `True in
		let markers = []    in
		let gamma   = NameMap.empty in
		let r = MsoGT.empty_root in
		uncal2mso e (ng,ng,ng) cond markers varDB varLB gIn gamma r >>= (fun gOut -> (* compute the output graph *)
		emit_duty gOut `True scmo >>= (fun () -> (* emit the duty that the output must conform to the output schema *)
		generate_whole_mso                 (* serialize the whole MSO formulas *)
	)))))))
	in
		snd (run MsoGT.empty_msogt)
