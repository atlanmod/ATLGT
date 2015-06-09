(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
open UnCALDM
open UnCAL

(** operations on markers **)
val ( &^ ) : string -> string -> string

(** extcact nodes from set of edges **)
val setofEdge_collectNodes : SetofEdge.t -> SetofVtx.t

(** converter from set to map **)
val setofEdge2mapofPVtx : SetofEdge.t -> SetofEdge.t MapofPVtx.t

(** predicates on nodes **)
val isrootG :  graph -> vtx -> bool
val isInodeG : graph -> vtx -> bool
val isOnodeG : graph -> vtx -> bool

(** predicates on edges **)
val isEpsEdge : edge -> bool

(** predicates on I/O relations **)
val isroot : inodeR -> bool

(** printers **)
(* unused *)
val graph2lists : graph -> vtx list * edge list * inodeR list * onodeR list

(** node constructors **)
module type GENID =
  sig
    val reset : unit -> unit
    val next : unit -> int
    val set : int -> unit
    val current : unit -> int
  end
module GenId : GENID
val newnode : unit -> vtx


(** homomorphisms **) 
(*  ('a -> 'b) -> 'a Set -> 'b Set *)
val maps_Vtx2Edge :                  (vtx -> edge) ->     SetofVtx.t ->   SetofEdge.t
val maps_Edge2Vtx :                  (edge -> vtx) ->    SetofEdge.t ->    SetofVtx.t
val maps_Edge2PVtx :             (edge -> vtx*vtx) ->    SetofEdge.t ->   SetofPVtx.t 
val maps_PVtx2Edge :             (vtx*vtx -> edge) ->    SetofPVtx.t ->   SetofEdge.t
val maps_InodeR2Vtx :              (inodeR -> vtx) ->  SetofInodeR.t ->    SetofVtx.t
val maps_InodeR2Edge :            (inodeR -> edge) ->  SetofInodeR.t ->   SetofEdge.t
val maps_OnodeR2Edge :            (onodeR -> edge) ->  SetofOnodeR.t ->   SetofEdge.t
val maps_InodeR2Marker :  (inodeR -> UnCAL.marker) ->  SetofInodeR.t -> SetofMarker.t
val maps_OnodeR2Marker :  (onodeR -> UnCAL.marker) ->  SetofOnodeR.t -> SetofMarker.t
val maps_Marker2Vtx :     (UnCAL.marker ->    vtx) ->  SetofMarker.t ->    SetofVtx.t
val maps_Marker2InodeR :  (UnCAL.marker -> inodeR) ->  SetofMarker.t -> SetofInodeR.t
val maps_Marker2OnodeR :  (UnCAL.marker -> onodeR) ->  SetofMarker.t -> SetofOnodeR.t
(*  ('a -> graph) ->  'a Set -> graph *)
val maps_Marker2DUni :    (UnCAL.marker ->  graph) ->  SetofMarker.t -> graph
(*  ('a -> 'b Set) -> 'a Set -> 'b Set *)
val setmap_Vtx2Edge  :                (vtx -> SetofEdge.t) ->    SetofVtx.t ->   SetofEdge.t
val setmap_Edge2Vtx :                (edge ->  SetofVtx.t) ->   SetofEdge.t ->    SetofVtx.t
val setmap_PVtx2Edge :            (vtx*vtx -> SetofEdge.t) ->   SetofPVtx.t ->   SetofEdge.t
val setmap_Edge2PVtx :               (edge -> SetofPVtx.t) ->   SetofEdge.t ->   SetofPVtx.t
val setmap_OnodeR2Edge :           (onodeR -> SetofEdge.t) -> SetofOnodeR.t ->   SetofEdge.t
val setmap_InodeR2Edge :           (inodeR -> SetofEdge.t) -> SetofInodeR.t ->   SetofEdge.t
val setmap_Marker2Edge :     (UnCAL.marker -> SetofEdge.t) -> SetofMarker.t ->   SetofEdge.t
val setmap_Marker2OnodeR : (UnCAL.marker -> SetofOnodeR.t) -> SetofMarker.t -> SetofOnodeR.t
val setmap_Edge2Marker :           (edge -> SetofMarker.t) ->   SetofEdge.t -> SetofMarker.t
(*  ('a -> 'b Set) -> 'a Set -> 'a (Mapof b') *)
val  vtxSet2Map :   (vtx -> 'a) ->   SetofVtx.t -> 'a  MapofVtx.t
val edgeSet2Map :  (edge -> 'a) ->  SetofEdge.t -> 'a MapofEdge.t
(* 'a (Mapof 'b) -> 'a (Mapof b') *)
(* 
val invert_MapofVtx2Vtx : vtx MapofVtx.t -> vtx MapofVtx.t 
*)
(* (Setof 'a) (Mapof 'b) -> (Setof 'a) (Mapof b') *)
(* 
val invert_MapofVtx2SVtx : SetofVtx.t MapofVtx.t -> SetofVtx.t MapofVtx.t
val invert_MapofEdge2SEdge : SetofEdge.t MapofEdge.t -> SetofEdge.t MapofEdge.t
*)
val invert_MapofEdgeToEdgeOpt : edge option MapofEdge.t -> SetofEdge.t MapofEdge.t

(** graph constructors **)
val emptyGraph :                                   graph
val evalg_simple_union :         graph -> graph -> graph
val evalg_simple_diff :          graph -> graph -> graph
val evalg_simple_append :        graph -> graph -> graph
val ( @&& ) :                    graph -> graph -> graph
val evalg_AETEmp : ?expid:int -> unit           -> graph
val ( !<> ) :      ?expid:int -> unit           -> graph
val evalg_AEOMrk : ?expid:int -> UnCAL.marker   -> graph
val ( !& ) :       ?expid:int -> UnCAL.marker   -> graph
val add_edge :                   graph  -> edge -> graph
val evalg_AEEdg :  ?expid:int -> allit -> graph -> graph
val ( /: ) :       ?expid:int -> allit -> graph -> graph
val evalg_AEIMrkG :       UnCAL.marker -> graph -> graph
val ( ^:= ) :             UnCAL.marker -> graph -> graph
val faithfulUnion : bool ref
val evalg_AEUni :  ?expid:int -> graph -> graph -> graph
val ( +| ) :       ?expid:int -> graph -> graph -> graph
val ( +|<! ) :                   graph -> graph -> graph
val ( +|< ) :                    graph -> graph -> graph
val evalg_AEDUni :               graph -> graph -> graph
val ( |++ ) :                    graph -> graph -> graph
val escapeApnd : bool ref
val leaveOMrkApnd : bool ref
val evalg_AEApnd : ?expid:int -> graph -> graph -> graph
val ( @& ) :       ?expid:int -> graph -> graph -> graph
val escapeApndG1 : int option ->          graph -> graph
val cycleSemanticsOriginal : bool ref
val evalg_AECyc :  ?expid:int          -> graph -> graph
val ( !!<> ) :     ?expid:int          -> graph -> graph
val evalg_AERec : int -> SetofMarker.t -> SetofEdge.t * SetofEdge.t -> graph MapofEbody.t -> graph -> graph
(** graph destructors **)
val remove_edge :                graph  -> edge -> graph


(** operators on labels **)
exception Eval_ALUkn of string
val evall_ALpred : alptype -> allit          -> bool
val evall_bin :    allit -> albinop -> allit -> allit
val evall_cmp :    allit -> alcmp   -> allit -> bool

(** nagivation **)
val incomEdgeS :   graph ->        vtx          -> SetofEdge.t
val outgoEdgeS :   graph ->        vtx          -> SetofEdge.t
val outgoEdgeSS :  graph -> SetofVtx.t          -> SetofEdge.t
val incomEdgeSS :  graph -> SetofVtx.t          -> SetofEdge.t
val imageVS :      graph ->        vtx          -> SetofVtx.t
val fwd :          graph ->        vtx -> allit -> SetofVtx.t
val fwdS :         graph -> SetofVtx.t -> allit -> SetofVtx.t
val preimgVS :     graph ->        vtx          -> SetofVtx.t
val bwd :          graph ->        vtx -> allit -> SetofVtx.t
val bwdS :         graph -> SetofVtx.t -> allit -> SetofVtx.t

(** accessors **)
val lookupI :       graph -> UnCAL.marker -> vtx
val inputNodes :    graph ->                 SetofVtx.t    * SetofVtx.t
val inputMarkers :  graph ->                 SetofMarker.t
val outputMarkers : graph ->                 SetofMarker.t
val markersV :      graph ->  vtx ->         SetofMarker.t * SetofMarker.t

(** viewmaps  **)
val empty_viewmaps : viewmaps
val init_viewmaps : graph -> viewmaps
val check_multiedge : graph -> bool
val merge_viewmaps : graph -> graph -> graph -> viewmaps -> graph
val viewmaps_glue_safe_eps : graph -> graph * viewmaps
val viewmaps_remove_eps_ec : graph * viewmaps -> graph * viewmaps

(** graph indices **)
val build_ioedge_map : graph -> (MapofVtx.key -> SetofEdge.t) * (MapofVtx.key -> SetofEdge.t)
val build_node_map : graph -> 
  ((SetofEdge.t * SetofEdge.t) * (SetofMarker.t * SetofMarker.t))  MapofVtx.t
val build_ioedge_ionode_map : graph -> 
    (MapofVtx.key -> SetofEdge.t) * (MapofVtx.key -> SetofEdge.t) *
  (MapofVtx.key -> SetofMarker.t) * (MapofVtx.key -> SetofMarker.t)
val build_ud_EC : graph -> (SetofVtx.t * SetofVtx.t) MapofVtx.t * SetofEdge.t * SetofEdge.t

(** graph converters **)
(* epsilon edge elimination *)
val glue_safe_eps :                            graph -> graph
val glue_every_eps :                           graph -> graph
val remove_eps_ec : ?leave_unreachable:bool -> graph -> graph
val remove_eps_ec1 :                           graph -> graph
val remove_eps :                               graph -> graph
(* structured id elimination *)
val clean_id_aux : ?start_id:int ->            graph -> graph * vtx MapofVtx.t * int
val clean_id : ?start_id:int ->                graph -> graph

(* graph decomposition *)
val split_graph :      graph -> vtx -> vtx -> marker -> graph

(* extracting difference *)
val graph_diff_aux : graph -> graph -> (graph * SetofVtx.t * SetofVtx.t * SetofEdge.t * SetofEdge.t 
					  * SetofEdge.t * ((edge * edge) list))

(** subgraph extractors **)
val reachableGI1s :                              graph -> graph
val reachableGI :                                graph -> graph
val split_reachableGI :                          graph -> graph * graph
val reachableG :                                 graph -> graph
val make_dv :                                    graph ->        vtx -> graph
val make_dv_with_oEmap : (vtx -> SetofEdge.t) -> graph ->        vtx -> graph
val bundle :                                     graph -> SetofVtx.t -> graph
(** map function on each node id **)
val map_VEIO :  (vtx -> vtx)                  -> graph -> graph

(** predicates on graphs **)
val cpntw_eq :     graph -> graph -> bool
val ( =.= ) :      graph -> graph -> bool
val bisimilar :    graph -> graph -> bool
val evalg_AIsemp :          graph -> bool
val dumpableG :             graph -> bool

(** trace function **)
val trace : vtx -> vtx
val corr : edge -> edge
val corr_set : edge -> SetofEdge.t

(** UnCAL aexpr conversion  *)
val any2none_aexpr : 'a aexpr -> 'b option aexpr
