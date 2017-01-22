(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
(** Generalized simulation on labeled graphs *)
open ExtSetMap

(** Components for general labeled graph *)
module type GraphComponent = sig
  type v_id	(* vertex ID *)
  type v_label	(* vertex label *)
  type e_label	(* edge label   *)
  val vid_compare : v_id -> v_id -> int
  val vlb_compare : v_label -> v_label -> int
  val elb_compare : e_label -> e_label -> int
end

(** General labeled graph *)
module type Graph = sig
  include GraphComponent
  type vtx  = { vid: v_id; vlb: v_label }
  type edge = { src: vtx;  elb: e_label; dst: vtx }
  module SVtx  : Set.S with type elt = vtx
  module SEdge : Set.S with type elt = edge
  module MVtx  : Map.S with type key = vtx
  type g = { root: vtx; vs: SVtx.t; es: SEdge.t }
  val make_outgoing_edges_map : g -> SEdge.t MVtx.t
  val make_incomming_edges_map : g -> SEdge.t MVtx.t
end

module MakeGraph (C:GraphComponent) : Graph
  with type v_id = C.v_id and type v_label = C.v_label and type e_label = C.e_label
        (* These anotations are required for their visibility from outside *) = struct
  include C
  type vtx  = { vid: v_id; vlb: v_label }
  type edge = { src: vtx;  elb: e_label; dst: vtx }
  module Vtx = struct
    type t = vtx
    let compare v1 v2 = match C.vid_compare v1.vid v2.vid with
        | 0 -> C.vlb_compare v1.vlb v2.vlb
        | c -> c
  end
  module Edge = struct
    type t = edge
    let compare e1 e2 = match C.elb_compare e1.elb e2.elb with
        | 0 -> begin match Vtx.compare e1.dst e2.dst with
            | 0 -> Vtx.compare e1.src e2.src
            | c -> c end
        | c -> c
  end
  module SVtx  = Set.Make(Vtx)
  module SEdge = Set.Make(Edge)
  module MVtx  = Map.Make(Vtx)

  (** A labeled graph consists of a root and a set of vertices and edges. 
      The root is used for checking simulation. *)
  type g = { root: vtx; vs: SVtx.t; es: SEdge.t }

  (** It takes a labeled graph
      and produces a map from each node to a set of outgoing edges. *)
  let make_outgoing_edges_map g =
    SEdge.fold
      (fun edge map ->
        MVtx.uadd SEdge.singleton SEdge.add edge.src edge map) g.es MVtx.empty

  (** It takes a labeled graph
      and produces a map from each node to a set of incomming edges. *)
  let make_incomming_edges_map g =
    SEdge.fold
      (fun edge map ->
        MVtx.uadd SEdge.singleton SEdge.add edge.dst edge map) g.es MVtx.empty
end

module type SimulationAlgorithm = sig
  module G1 : Graph
  module G2 : Graph
  val find_simulation : G1.g -> G2.g ->
    (G1.v_label->G2.v_label->bool) -> (G1.e_label->G2.e_label->bool) ->
    G2.SVtx.t G1.MVtx.t
  val is_root_simulating : G1.g -> G2.g ->
    (G1.v_label->G2.v_label->bool) -> (G1.e_label->G2.e_label->bool) -> bool
end

(** [MakeGRel(G1)(G2)] generates a simulation module
    for two different kinds of labeled graphs.
    [g1:G1.g] is simulated by [g2:G2.g], that is, [g2:G2.g] simulates [g1:G1.g].
    @param G1 a Graph module for a simulated labeled graph  (e.g., graph data)
    @param G2 a Graph module for a simulating labeled graph (e.g., graph schema)
 *)
module MakeSimpleSA (G1:Graph) (G2:Graph)
  : SimulationAlgorithm with module G1 = G1 and module G2 = G2 = struct
  module G1 = G1
  module G2 = G2
  exception Updated of G2.SVtx.t G1.MVtx.t

  let remove u1 u2 us2 sim =
    let us2 = G2.SVtx.remove u2 us2 in
    if G2.SVtx.is_empty us2 then G1.MVtx.remove u1 sim
    else G1.MVtx.add u1 us2 sim

  let until_no_update_main outgo1 outgo2 erel sim =
    G1.MVtx.iter (fun u1 us2 ->
      match G1.MVtx.find_some u1 outgo1 with
        | None -> ()
        | Some es1 ->
          G2.SVtx.iter (fun u2 ->
            match G2.MVtx.find_some u2 outgo2 with
              | None -> raise (Updated (remove u1 u2 us2 sim))
              | Some es2 ->
                G1.SEdge.iter (fun e1 ->
                  match G1.MVtx.find_some e1.G1.dst sim with
                    | None -> raise (Updated (remove u1 u2 us2 sim))
                    | Some vs2 ->
                      if not (G2.SEdge.exists (fun e2 ->
                        G2.SVtx.mem e2.G2.dst vs2 && erel e1.G1.elb e2.G2.elb) es2) then
                        raise (Updated (remove u1 u2 us2 sim))) es1) us2) sim

  let rec until_no_update outgo1 outgo2 erel sim =
    try until_no_update_main outgo1 outgo2 erel sim; sim
    with Updated sim -> until_no_update outgo1 outgo2 erel sim

  (** [find_simulation g1 g2 vrel erel] computes
      a map from each vertex in [g1] to a set of simulating vertices in [g2].
      @param g1 a simulated graph
      @param g2 a simulating graph
      @param vrel a relation between vertex labels
      @param erel a relation between edge labels *)
  let find_simulation g1 g2 vrel erel =
    let outgo1 = G1.make_outgoing_edges_map g1
    and outgo2 = G2.make_outgoing_edges_map g2 in
    let init_sim =
      G1.SVtx.fold (fun v1 sim ->
        G1.MVtx.add v1 (G2.SVtx.filter (fun v2 -> vrel v1.G1.vlb v2.G2.vlb) g2.G2.vs) sim)
        g1.G1.vs G1.MVtx.empty in
    until_no_update outgo1 outgo2 erel init_sim

  exception Root_not_simulating

  let check_root_simulating root1 root2 sim =
    match G1.MVtx.find_some root1 sim with
      | None -> raise Root_not_simulating
      | Some vs2 -> if not(G2.SVtx.mem root2 vs2) then raise Root_not_simulating

  let rec until_no_update_or_root_not_simulating outgo1 outgo2 root1 root2 erel sim =
    try until_no_update_main outgo1 outgo2 erel sim; sim
    with Updated sim ->
      check_root_simulating root1 root2 sim;
      until_no_update_or_root_not_simulating outgo1 outgo2 root1 root2 erel sim

  let unless_root_simulating g1 g2 vrel erel =
    let outgo1 = G1.make_outgoing_edges_map g1
    and outgo2 = G2.make_outgoing_edges_map g2 in
    let init_sim =
      G1.SVtx.fold (fun v1 sim ->
        G1.MVtx.add v1 (G2.SVtx.filter (fun v2 -> vrel v1.G1.vlb v2.G2.vlb) g2.G2.vs) sim)
        g1.G1.vs G1.MVtx.empty in
    check_root_simulating g1.G1.root g2.G2.root init_sim;
    until_no_update_or_root_not_simulating
      outgo1 outgo2 g1.G1.root g2.G2.root erel init_sim

  (** Same as [find_simulation], 
      but it returns true when the root node simulates the other.
      It is more efficient than [find_simulation] in the sense that
      it returns false as soon as it is found that the root cannot simulate the other. *)
  let is_root_simulating g1 g2 vrel erel =
    try ignore(unless_root_simulating g1 g2 vrel erel); true
    with Root_not_simulating -> false

end

module HenzingerSA (G1:Graph) (G2:Graph)
  : SimulationAlgorithm with module G1 = G1 and module G2 = G2 = struct
  module G1 = G1
  module G2 = G2
  let find_simulation g1 g2 vrel erel = assert false
  let is_root_simulating g1 g2 vrel erel = assert false
end

module RanzatoSA (G1:Graph) (G2:Graph)
  : SimulationAlgorithm with module G1 = G1 and module G2 = G2 = struct
  module G1 = G1
  module G2 = G2
  let find_simulation g1 g2 vrel erel = assert false
  let is_root_simulating g1 g2 vrel erel = assert false
end
