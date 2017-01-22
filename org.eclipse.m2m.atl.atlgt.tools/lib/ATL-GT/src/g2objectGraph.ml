(** Convert graph to object graph using KM3 metamodel information *)
open Km3util
open Km3
open PrintUnCAL
(* open ExtSetMap *) (* If included, VSet.mapto causes type error for module argument,
                        because Set.S would mean ExtSetMap.S which is not considered 
                        compatible with what mapto requires. *)
open Fputil
open UnCALDM
open UnCALDMutil
open PrintUnCALDM
open UnCAL
open Format
open Print
open PrintKm3
open TestUnCALutil
open ObjectGraph

(** extract name from a classifier *)
let name_of_classifier (c:classifier) : name = 
  match c with  
   `klasse {kname=n} | `datatype n | `enumeration (n,_) -> n

(** extract value from allit *)

let string_of_allit allit : string = match allit with
  | ALStr str -> str
  | _ -> invalid_arg "string_of_allit"
let int_of_allit allit : int = match allit with
  | ALInt i -> i
  | _ -> invalid_arg "int_of_allit"
let float_of_allit allit : float = match allit with
  | ALFlt f -> f
  | _ -> invalid_arg "float_of_allit"
let bool_of_allit allit : bool = match allit with
  | ALBol f -> f
  | _ -> invalid_arg "bool_of_allit"



(*  v---String|Int|Boolean|Float-->dst --value-->leaf => (allit,dst,leaf)
    Ex: v---String-->dst --"yama"-->leaf => (ALStr "yama",dst,leaf) *)
(** [get_primitive_data v typeref es] extracts a label of edge encoding 
    primitive data of type [typeref], from a chain of edges outgoing 
    from node [v]. [typeref] is only used for debugging purpose.
    Returns the nodes of the source and destination of the edge for
    traceability. *)
let get_primitive_data (v:vtx) (typeref:name) (es:edges) : (allit*vtx*vtx) =
  let allit,dst = get_allit_dst v es typeref in
  let es_dst = try VMap.find dst es
  with Not_found ->
    validation_fails dst
      (sprintf "There is no edge for %s" (string_of pp_name typeref)) in
  let allit,leaf = match take_single_allit_dst es_dst with
  | Empty ->
      validation_fails dst
        (sprintf "There is no edge for %s" (string_of pp_name typeref))
  | Single(allit,leaf) -> begin try
      if vset_amap_is_empty (VMap.find leaf es) then (allit,leaf)
      else
        validation_fails leaf
          (sprintf "The vertex %s must have no edge." (vtx2str leaf))
  with Not_found -> (allit,leaf) end
  | Multiple(al1,al2) ->
      validation_fails dst
        (sprintf "There are multiple edges %s and %s."
           (allit2str al1) (allit2str al2)) in
  begin match typeref, allit with
  | "String", ALStr _ | "Boolean", ALBol _
  | "Int", ALInt _ | "Float", ALFlt _ -> (allit,dst,leaf)
  | _ ->
      validation_fails v
        (sprintf "The edge %s does not match with the type %s."
           (allit2str allit) typeref) end

(** [typeref2primset es es_dst_f typeref]
    extracts {!ObjectGraph.primset} of type [typeref] from edges in [es] 
    outgoing from set of nodes in [es_dst_f]. *)
let typeref2primset (es:edges) (es_dst_f:VSet.t) (typeref:name) : primset =
  let type_vto type_of_allit =
    (fun v' -> 
      (* v'---String|Int|Boolean|Float-->pre_leaf---lit--->leaf *)
      (* check each value if it is a valid instance of the feature type *)	      
      (*  validate_classifier_vtx dst es f.typeref mmdic known *)
      let (lit,pre_leaf,leaf) = get_primitive_data v' typeref es in
      dprintf "%s! %a@." typeref pp_allit lit;
      (type_of_allit lit,Some (v',pre_leaf,leaf))) in
  match typeref with
    "String" -> SetofStr
        (VSet.mapto (module SetofStr : Set.S with type elt = (string*vto) and type t = SetofStr.t)
	   (type_vto string_of_allit)  es_dst_f)
  | "Int" -> SetofInt
	(VSet.mapto (module SetofInt : Set.S with type elt = (int*   vto) and type t = SetofInt.t)
	   (type_vto    int_of_allit)  es_dst_f)
  | "Float" -> SetofFlt
	(VSet.mapto (module SetofFlt : Set.S with type elt = (float* vto) and type t = SetofFlt.t)
	   (type_vto  float_of_allit)  es_dst_f)
  | "Boolean" -> SetofBol
	(VSet.mapto (module SetofBol : Set.S with type elt = (bool*  vto) and type t = SetofBol.t)
	   (type_vto   bool_of_allit)  es_dst_f)
  | _ -> failwith ("g2vtx2xmi_element_Map: unknown typeref : " ^ typeref)

(** [typeref2childmap_refmap_ent is_c es es_dst_f typeref]
 extracts an entry of type {!ObjectGraph.NameVtxSet} for either 
 {!ObjectGraph.childmap} or {!ObjectGraph.refmap} depending on the boolean value [is_c],
 from edges in [es] outgoing from nodes in [es_dst_f].
 The source and destination node of the edge encoding the 
 referred classifier is also returned for traceability.
 [typeref] and [is_c] is only used for debugging purpose. *)
let typeref2childmap_refmap_ent (is_c:bool) (es:edges) (es_dst_f:VSet.t) (typeref:name) :  NameVtxSet.t =
  (* v'---allit_c(ClassName)-------->vtx_c *)
  (* ex:   {("Attribute",Bid(42)),("Attribute",Bid(41))} *)
  (VSet.mapto
     (module NameVtxSet : Set.S with 
      type elt = (name * vtx option * vtx option) and type t = NameVtxSet.t)
     (fun v' ->
       let allit_c,vtx_c = get_allit_dst v' es typeref in
       let typeref_value = typeref_of_allit allit_c in
       dprintf "is_child=%b, %s %a@." is_c typeref_value  pp_vtx vtx_c;
       (typeref_value,Some v',Some vtx_c)
     ) es_dst_f)

(** [g2vtx2xmi_element_Map g pname mm] converts graph [g] conforming to package [pname]
    in the KM3 metamodel [mm] to object graph in the form of mapping from nodes
    to {!ObjectGraph.xmi_element}. It also returns root node of the input grah
    for traceability. *)
let g2vtx2xmi_element_Map (g:graph) (pname:name) (mm:metamodel) : vtx * xmi_element VMap.t =
  let es = edges_of_graph g in
  let known_classifier = validate g pname mm in
  (* following codes assume that the graph g is valid *)
  (* Generate non-concflicting vertex id and split the root, 
     and register top-level entries to known_classifier,
     because known_classifier do not have top-level entries  *)
  let mmdic = clean_mm_dictionary (make_mm_dictionary mm) in
  let (_,root) = SetofInodeR.min_elt g.i in
  let max_vtx = SetofVtx.max_elt (collect_Bids g) in
  let max_vtx_id = match max_vtx with 
    Bid id -> id | _ -> failwith "g2vtx2xmi_element_Map: invalid node ID" in
  let (known_classifier,roots,_,g) =
    SetofEdge.fold (fun (_,allit,dst) (known,roots,vtx_id,g) ->
      (
       let kname = kname_of_allit allit in
       let kls = NameMap.find kname mmdic.classifier in
       let v = (Bid vtx_id) in
       VMap.add v kls known ,SetofVtx.add v roots,(vtx_id + 1) ,
       {g with e=SetofEdge.add (v,allit,dst) g.e}))
         (outgoEdgeS g root) (known_classifier,SetofVtx.empty,max_vtx_id+1,g) in
  let es = edges_of_graph g in
  (root,VMap.fold (fun v kls acc ->
    (* v--ClassifierName-->dst(features subgraph) *)
    (* inheritance already solved so kls is always concrete. mmdic unnecessary *)
    match kls with
      `klasse kls ->
	let allit_k,dst = get_allit_dst v es kls.kname in
	(* let r = validate_klasse_vtx dst es kls mmdic VMap.empty in *)
	(* es_dst: feature branches from the dst node *)
	let es_dst = try VMap.find dst es with Not_found -> AMap.empty in
	let (es_dst,attrmap,refmap,childmap) =
	  NameMap.fold (fun fname ft (es_dst,am,rm,cm) ->
	    let allit_f = ALLbl fname in (* label for the feature *)
	    (* v ---allit_k(ClassifierName)--->dst--allit_f(featureName)--> *)
	    (* lookup set of target nodes representing the feature *)
	    let es_dst_f : VSet.t = try AMap.find allit_f es_dst with Not_found -> VSet.empty in
	    let (am,rm,cm) =
	      match ft with
	      | `attribute f ->
		  (NameMap.add fname (f.typeref,       typeref2primset es es_dst_f f.typeref) am,rm,cm)
	      | `reference{feature=f;is_container=is_c;}->
		  let add_to_cm_or_rm m = 
		   NameMap.add fname (typeref2childmap_refmap_ent is_c es es_dst_f f.typeref) m in
		  if is_c then  (am,                rm,add_to_cm_or_rm cm)
		  else          (am,add_to_cm_or_rm rm,                cm)
   		in
	    AMap.remove allit_f es_dst,am,rm,cm)
	    kls.features (es_dst,NameMap.empty,NameMap.empty,NameMap.empty) in
        VMap.add dst {xe_kname=kls.kname;xe_is_top=SetofVtx.mem v roots;attrmap=attrmap;
		      refmap=refmap;childmap=childmap;xe_pivot=Some dst} acc
    | _           -> acc) known_classifier  VMap.empty)
    
