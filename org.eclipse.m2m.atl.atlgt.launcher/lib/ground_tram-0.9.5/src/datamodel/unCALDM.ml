(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
open Format
open UnCAL
open ExtSetMap

(*  Skolem function on markers is implemented by string append operator ^ in O'Caml,
   (x ^ y) ^ z = x ^ (y ^ z)
    Now that marker string include prefix "&",  exeptional case
    for "&" are added  (implicit "" ^ x = x ^ "" is not used anymore *)

(* type that is closed under application of  Skolem functions S1 and S2 *)
type ('a,'b) sid =  (* 'b is a type of edge labels *)
    Bid of 'a                                           (* base id *)
  | S1 of ('a,'b) sid * marker                          (* type returned by S1 *)
  | S2 of ('a,'b) sid * 'b * ('a,'b) sid * ('a,'b) sid  (* type returned by S2 *)
  | Hub of ('a,'b) sid * marker * 'a                    (* bidir. hub            *)
  | FrE of ('a,'b) sid * edge   * 'a                    (* bidir. rec body       *)
  | InT of 'a                                           (* bidir. InT for {},&y  *)
  | ImT of 'a * marker                                  (* bidir. InT for U,cyc. *)
  | IaT of 'a * ('a,'b) sid                             (* bidir. InT for @      *)
  
(* exprid = 'a = int is assumed *)

and vtx  = (int,allit) sid      (* type for vertex *)

and edge = (vtx * allit * vtx)  (* type for edge *)

let compare_string (s:string) (s':string) : int = (compare : string -> string -> int) s s' 

let compare_int (i:int) (i':int) : int = (compare : int -> int -> int) i i'

let compare_allit a1 a2 =
  match a1,a2 with
      ALLbl s, ALLbl s' -> compare_string s s'
    | ALLbl _, _        -> -1
    | ALStr _, ALLbl _  ->  1
    | ALStr s, ALStr s' -> compare_string s s'
    | ALStr _, _        -> -1 
    | ALInt _, ALLbl _ | ALInt _, ALStr _ -> 1
    | ALInt i, ALInt i' -> compare_int i i' 
    | ALInt _, _        -> -1
    | ALFlt _, ALLbl _ | ALFlt _, ALStr _ | ALFlt _, ALInt _ -> 1
    | ALFlt f, ALFlt f' -> compare f f' 
    | ALFlt _, _        -> -1
    | ALBol _, ALLbl _ | ALBol _, ALStr _ | ALBol _, ALInt _ | ALBol _, ALFlt _ -> 1
    | ALBol b, ALBol b' -> compare b b' 
    | ALBol _, _        -> -1 
    | ALUkn, ALLbl _ | ALUkn, ALStr _ | ALUkn, ALInt _ | ALUkn, ALFlt _ | ALUkn, ALBol _ -> 1
    | ALUkn, ALUkn      -> 0
    | ALUkn, _          -> -1 
    | ALEps, ALEps      -> 0
    | ALEps, _          -> 1 

let rec compare_edge (v1,al,v2) (v1',al',v2') =
  let c1 = compare_vtx v1 v1' in
    if c1 <> 0 then c1 else
      let c2 = compare_allit al al' in
	if c2 <> 0 then c2 else
	  let c3 = compare_vtx v2 v2' in
	    c3

and  compare_vtx v1 v2 =
  match v1,v2 with
      Bid i, Bid i' -> compare_int i i'
    | Bid _, _      -> -1 
    | S1  _, Bid _  ->  1
    | S1 (v1,m), S1 (v1',m') -> 
	let c1 = compare_vtx v1 v1' in
	  if c1 <> 0 then c1 else compare_string m m' 
    | S1 _, _ -> -1 
    | S2 _, Bid _  | S2 _, S1 _  -> 1 
    | S2 (v1,al,v2,v3), S2 (v1',al',v2',v3') -> 
	let c1 = compare_edge (v1,al,v2) (v1',al',v2') in
	  if c1 <> 0 then c1 else compare_vtx v3 v3'
    | S2 _, _ -> -1 
    | Hub _, Bid _  | Hub _, S1 _  | Hub _, S2 _  -> 1
    | Hub (v1,m,i), Hub (v1',m',i') ->
	let c1 = compare_vtx v1 v1' in
	  if c1 <> 0 then c1 else
	    let c2 = compare_string m m' in
	      if c2 <> 0 then c2 else
		compare_int i i' 
    | Hub _, _     -> -1
    | FrE _, Bid _ | FrE _, S1 _ | FrE _, S2 _ | FrE _, Hub _  -> 1
    | FrE (v,e,i), FrE (v',e',i') ->
	let c1 = compare_vtx v v' in 
	  if c1 <> 0 then c1 else
	    let c2 = compare_edge e e' in
	      if c2 <> 0 then c2 else
		compare_int i i'
    | FrE _, _ -> -1 
    | InT _, Bid _ | InT _, S1 _ | InT _, S2 _ | InT _, Hub _ | InT _, FrE _ -> 1
    | InT i, InT i' -> compare_int i i'
    | InT i, _      -> -1
    | ImT _, Bid _ | ImT _, S1 _ | ImT _, S2 _ | ImT _, Hub _ | ImT _, FrE _ | ImT _, InT _ -> 1
    | ImT (i,m), ImT (i',m') ->
	let c1 = compare_int i i' in
	  if c1 <> 0 then c1 else
	    compare_string m m' 
    | ImT _, _      -> -1
    | IaT _, Bid _ | IaT _, S1 _ | IaT _, S2 _ | IaT _, Hub _ | IaT _, FrE _ | IaT _, InT _ | IaT _, ImT _ -> 1
    | IaT (i,v), IaT (i',v') ->
	let c1 = compare_int i i' in
	  if c1 <> 0 then c1 else
	    compare_vtx v v' 


(* type for set of vertex *)
module Vtx = struct 
  type t = vtx
  let compare = compare_vtx (* Pervasives.compare *)
end
module SetofVtx = Set.Make(Vtx)
module MapofVtx = Map.Make(Vtx)

(* type for set of edges *)  
module Edge = struct
  type t = edge
  let compare = compare_edge 
end
module SetofEdge = Set.Make(Edge)
module MapofEdge = Map.Make(Edge)

(* type for set of markers X,Y,Z *)
module Marker = struct 
  type t = marker
  let compare = compare_string
end
module SetofMarker = Set.Make(Marker)
module MapofMarker = Map.Make(Marker)

(* type for set of label literals *)
module Allit = struct 
  type t = allit
  let compare = compare_allit (* Pervasives.compare *)
end
module SetofAllit = Set.Make(Allit)
module MapofAllit = Map.Make(Allit)


module SetofPAllit = Set.Make(
  struct 
    type t = allit * allit
    let compare = Pervasives.compare
  end )

type inodeR = marker * vtx   (* type for input node relations *)
type onodeR = vtx * marker   (* type for output node relations *)


(* type for set of input node relations *)
module SetofInodeR = Set.Make (struct 
    type t = inodeR
    let compare (m,v) (m',v') =
      let c = compare_string m m' in
	if c <> 0 then c else
	  compare_vtx v v'
  end )


(* type for set of output node relations *)
module SetofOnodeR = Set.Make (struct 
    type t = onodeR
    let compare (v,m) (v',m') =
      let c = compare_string m m' in
	if c <> 0 then c else
	  compare_vtx v v' 
			       end )


(* the data type for graph *)
type graph = {
  v : SetofVtx.t;     (* V *)
  e : SetofEdge.t;    (* E *)   
  i : SetofInodeR.t;  (* I *)
  o : SetofOnodeR.t;  (* O *)
}

(* The slot eid is intended to be used for Set library to suppress duplicate 
   removal. Since mEdge is modified within Set, and the Set do not reorganize
   the modification, duplicate may arise in the Set as a result of modification. 
   The usage of the mEdge is based on the physical equality but requires 
   efficient update of collection based on the ordering based on Pervasives.compare,
   the additional slot (eid) is introduced and initialized to unique integer
   so that modification of other slot does not cause duplicates any more. *)
type mEdge = {
    eid : int;
     mutable sourceV : vtx;
             xlabel  : allit;
     mutable destV   : vtx;
}
module SetofMEdge = Set.Make(
  struct
    type t = mEdge
    let compare = Pervasives.compare
  end
)

type mVtx = 
    {            id : vtx;
     mutable incomE : SetofMEdge.t;
     mutable outgoE : SetofMEdge.t;
     mutable imarks : SetofMarker.t;
     mutable omarks : SetofMarker.t;
   }

(* mutually recursive data structure by mutually recursive moudle *)
(******************************************************************
module rec MEdge : sig
  type t = { eid             : int;
	     mutable sourceV : MVtx.t;
	     xlabel          : allit;
	     mutable destV   : MVtx.t;
	    }
  val compare : t -> t -> int
end = struct
  type t = { eid             : int;
	     mutable sourceV : MVtx.t;
	     xlabel          : allit;
	     mutable destV   : MVtx.t;
	    }
  let compare = Pervasives.compare
  end
and SMEdge : Set.S with type elt = MEdge.t
  = Set.Make(MEdge)
and MVtx : sig
   type t = {  vid            : vtx;
	       mutable incomE : SMEdge.t;
	       mutable outgoE : SMEdge.t;
	       mutable imarks : SetofMarker.t;
	       mutable omarks : SetofMarker.t;
	     }
end = struct
  type t = { vid            : vtx;
	     mutable incomE : SMEdge.t;
	     mutable outgoE : SMEdge.t;
	     mutable imarks : SetofMarker.t;
	     mutable omarks : SetofMarker.t;
	   }
end

let dummy_mvtx = { MVtx.vid = Bid 0;
  	MVtx.incomE = SMEdge.empty;
  	MVtx.outgoE = SMEdge.empty;
  	MVtx.imarks = SetofMarker.empty;
  	MVtx.omarks = SetofMarker.empty;
  }
******************************************************************)

(* to make rendezvous on node IDs generated by body expression
  in bulk semantics of rec(e) operator, namely e(a,d_v), 
  we have to materialize  the results and store them for later use.
  It should be uniquely identified by pair of label literal and 
  node id. The results are stored in Map
 *)
module MapofEbody = Map.Make (struct 
    type t = (allit * vtx)
    let compare = Pervasives.compare
  end )

type viewmaps = {
  mutable mapV : SetofVtx.t  MapofVtx.t;
  mutable mapE : SetofEdge.t MapofEdge.t;
}

module PVtx = struct 
  type t = vtx * vtx
  let compare = Pervasives.compare
end
module SetofPVtx = Set.Make(PVtx)
module MapofPVtx = Map.Make(PVtx)

type editop = 
     EMod of allit * allit (* old label to new label *)
  |  EDel (* the edge is deleted *)
  |  EAdd (* the edge is added -- maybe not used for the mappings
             from edges in the original graph *)

(* Global mapping from source edge to its operation.
   It will be the candidate of update reflection to the edges in the source graph.
   It is used to check the branching change behavior *)
let editop_map : editop MapofEdge.t ref = ref MapofEdge.empty

