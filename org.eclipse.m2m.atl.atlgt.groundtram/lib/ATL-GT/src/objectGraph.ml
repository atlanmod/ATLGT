(** Representation of model elements *)
open Km3
open ExtSetMap
open UnCALDM

(* topological sort on the containment hierarchy needed to
   reconstruct XMI parent-child element relationship. 
   Circular containment could be detected at KM3 level
   as well as deferred to instance level,
   because the circle can be broken by a zero-occurrence
   of an optional feature. *)
(* or,
   convert known_klassifier table to map from vtx to model element
   (excluding primitive data types)
*)
type vtx_triple_option = (vtx * vtx * vtx) option
type vto = vtx_triple_option (** alias to {!vtx_triple_option} *)
module SetofInt = Set.Make(struct type t = (int*vto)    let compare = compare end)
module SetofStr = Set.Make(struct type t = (string*vto) let compare = compare end)
module SetofFlt = Set.Make(struct type t = (float*vto)  let compare = compare end)
module SetofBol = Set.Make(struct type t = (bool*vto)   let compare = compare end)

(** set of primitive data values and their trace information *)
type primset = 
    SetofInt of SetofInt.t (** set of interger values *)
  | SetofStr of SetofStr.t (** set of string values *)
  | SetofFlt of SetofFlt.t (** set of real  values *)
  | SetofBol of SetofBol.t (** set of boolean values *)

(** map from attrivute name to its classifier name and set of primitive data values *)
type attrmap  = (name * primset)    NameMap.t
(* because of object orientation, concrete class is not
   uniform for each attribute, so refmap and chidmap 
   stores the name of the concrete class for each target node *)
(** Set of references to contained and non-contained elements, each with 
    node IDs used in graph encoding for traceability. The target node
    is also used for the key to retrieve referred model element.
    The name slot is used to store classifier name when decoded from graphs, 
    or XMI IDs when decoded from XMI file. *)
module NameVtxSet = Set.Make (struct type t = name*(vtx option)*(vtx option) let compare = compare end)

(** map from name of the contained references to the set of references to refered model elements *)
       
type childmap = NameVtxSet.t NameMap.t
type refmap   = NameVtxSet.t NameMap.t

(** representation of model element *)
type xmi_element = {
    xe_kname : name; (** classifier name of the model element *)
    xe_is_top : bool; (** true if the element is at the top level (contained by no other element) *)
    attrmap : attrmap; (** map of non-structured attributes *)
    refmap : refmap;  (** map of non-containment references *)
    childmap : childmap; (** map of containment references *)
    xe_pivot : vtx option;  (** the pivot node used to encode the model element in a graph *)
  }
(* example:
     Bid(48)->("Class",true,
              {"name"=>("String",{"Person"});"isAbstract"=>("Boolean",{false})},
              {},{"attr"=>{("Attribute",Bid(42)),("Attribute",Bid(41))}});
     Bid(42)->("Attribute",true
              {"name"=>("String",{"family"});"multiValued"=>("Boolean",{false})},
              {"type"=>{("Class",Bid(47))};"owner"=>{("Class",Bid 48)}},{}) *)
