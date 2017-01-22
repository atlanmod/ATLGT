(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
open ExtSetMap
open UnCALDM
open GraphSim
module UGraph = MakeGraph(struct
  type v_id	= vtx
  type v_label	= SetofAllit.t
  type e_label	= UnCAL.allit
  let vid_compare = compare_vtx
  let vlb_compare = SetofAllit.compare
  let elb_compare = compare_allit
end)

open UGraph

(** Convert an unCALDM graph into UGraph. *)
let unCALDM_to_UGraph g =
  let outgo = 
    SetofEdge.fold (fun (src,elb,dst) outgo ->
      MapofVtx.uadd SetofAllit.singleton SetofAllit.add src elb outgo)
      g.e MapofVtx.empty in
  let ug_vtx v =
    { vid = v; vlb = try MapofVtx.find v outgo with Not_found -> SetofAllit.empty } in
  let root = try ug_vtx(UnCALDMutil.lookupI g "&")
    with Not_found -> failwith"Uschema.unCALDM_to_UGraph: root not found" in
  let vs = SetofVtx.fold (fun v vs -> SVtx.add (ug_vtx v) vs) g.v SVtx.empty in
  let es =
    SetofEdge.fold (fun (src,elb,dst) es ->
      SEdge.add { src = ug_vtx src; elb; dst = ug_vtx dst } es) g.e SEdge.empty in
  {root;vs;es}

type binop = [`eq|`lt|`le|`gt|`ge]

type pred =
  | Uand of pred * pred
  | Uor  of pred * pred
  | Unot of pred
  | Ureg of string * pexpr
  | Ubin of binop * pexpr * pexpr

and pexpr =
  | Uallit of UnCAL.allit
  | Uvar of int
  | Uself

module Pred = struct type t = pred let compare = compare end
module PredSet = Set.Make(Pred)

module USchema = MakeGraph(struct
  type v_id	= UnCALDM.vtx
  type v_label	= PredSet.t
  type e_label	= pred
  let vid_compare = compare_vtx
  let vlb_compare = PredSet.compare
  let elb_compare = Pred.compare
end)

(** Relation between a label in UGraph and a label (predicate) in USchema
    by checking if the label satisfies the predicate  *)
let rec prel lb = function
  | Uand(p1,p2) -> prel lb p1 && prel lb p2
  | Uor(p1,p2) -> prel lb p1 || prel lb p2
  | Unot p -> not(prel lb p)
  | Ureg(s,e) -> assert false
  | Ubin(op,e1,e2) -> pbin op (pexp lb e1) (pexp lb e2)

(** Evaluate an expression with a binary predicate. *)
and pbin op v1 v2 = match op with
  | `eq -> v1 = v2
  | `lt -> v1 < v2
  | `le -> v1 <= v2
  | `gt -> v1 > v2
  | `ge -> v1 >= v2

(** Compute an expression under the environment that the curent label is [lb]. *)
and pexp lb = function
  | Uself -> lb
  | Uvar i -> assert false
  | Uallit a -> a

let perel lbs preds =
  PredSet.for_all (fun pr -> SetofAllit.exists (fun allit -> prel allit pr) lbs) preds

module Sim = GraphSim.MakeSimpleSA(UGraph)(USchema)

let conforms_to ugraph uschema =
  Sim.find_simulation ugraph uschema perel prel
