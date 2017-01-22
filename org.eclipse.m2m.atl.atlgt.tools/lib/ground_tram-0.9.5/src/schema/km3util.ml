(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
(** 
  Utilities for KM3 schema validation 
  *)
open Format
open Print
open ExtSetMap
open Km3
open PrintKm3
open UnCAL
open PrintUnCAL
open UnCALDM
open PrintUnCALDM
open UnCALDMutil

(** If true, debug write by dfprintf is enabled *)
let km3util_verbose = ref false

(** Act as fprintf if {!km3util_verbose} flag is true.
   Otherwise does nothing. *)
let dfprintf =
  if !km3util_verbose
  then fprintf 
  else ifprintf 

(** [dprintf ?flag] acts like printf except that it prints
    nothing if [flag] or {!km3util_verbose} is false.
    These values are checked at run-time. *)
let dprintf ?(verbose:bool = false) =
  if (!km3util_verbose || verbose)
  then Format.printf
  else Format.ifprintf std_formatter

(* Dictionary for a metamodel structure *)
type mm_dictionary = {
  classifier: classifier NameMap.t;
  package: NameSet.t NameMap.t; (* package name -> a set of class names *)
}

let pp_mm_dictionary fmt (mmdic:mm_dictionary) =
  pp_record [ pp_field "classifier"
                (pp_name_map_t pp_classifier) mmdic.classifier;
              pp_field "package"
                (pp_name_map_t pp_name_set_t) mmdic.package ] fmt

(**
  [make_mm_dictionary mm] creates from metamodel [mm] a metamodel dictionary
    which consists of:
    classifier: map from classifier name to corresponding classifier.
                all the classifiers are registered here regardless of
                the package they belongs to.
    package:    map from package name to set of names of non-abstract classes in the package.
*)

let make_mm_dictionary (mm:metamodel) : mm_dictionary =
  List.fold_left (* for each package *)
    (fun mmdic pkg -> 
       List.fold_left (* for each classifier in the list of classifiers in the package *)
         (fun mmdic clsf -> match clsf with
            | `klasse kls ->
                let package =
                  if kls.is_abstract then mmdic.package (* don't register in the package map *)
                  else
                    let kset = 
                      try NameMap.find pkg.pname mmdic.package
                      with Not_found -> NameSet.empty in
                    NameMap.add
                      pkg.pname (NameSet.add kls.kname kset) mmdic.package in
                { classifier =
                    NameMap.add kls.kname clsf mmdic.classifier;
                  package = package }
            | `datatype n | `enumeration(n,_) ->
                { mmdic with classifier = NameMap.add n clsf mmdic.classifier })
         mmdic pkg.classifiers)
    { classifier = NameMap.empty;
      package = NameMap.empty } mm

(* auxiliary pretty printer for debugging *)
let pp_just_or_once ppf = function
    `just -> fprintf ppf "just"
  | `once -> fprintf ppf "once"
let pp_Hashtbl_t pp_a pp_b fmt h =
  fprintf fmt "@[<1>{";
  Hashtbl.iter (fun k v -> fprintf fmt "(%a => %a);" pp_a k pp_b v) h;
  fprintf fmt "}@]"
let pp_string_just_or_once_hash ppf x = (pp_Hashtbl_t PrintKm3.pp_name pp_just_or_once) ppf x

(* Topological sort on class hierarchy and expanding features *)
let klasse_expand (cdic:classifier NameMap.t) : classifier NameMap.t =
  (* Memo table mapping kname to either  `just or `once. 
     `just is used for circular inheritance detection
       (if the memo hits with `just while expansion then aborts).
     `once is used to store a class for which expansion succeeds
      without circule detection *)
  let visited = Hashtbl.create 97 in
  (* [visit kname kls expanded]
     expands the classifier dictionary [expanded] with respect
     to the class [kls]. [expanded] is the dictionary with expansion 
     thus far has been applied.
     kname: name of the classifier [kls]
     returns a pair of expanded dictionary and [kls] (as is)
    *)
  let rec visit kname kls expanded =
    Hashtbl.add visited kname `just;
    (* exp_kls: a pair of expanded classifier dictionary and classifier definition *)
    let exp_kls =
      (* expand features of a class along its list of superclasses *)
      List.fold_left
	(* exp: expanded classifier map (accumulated), kls: classifier having supertype supname,
	   supname: name of one of the supertypes *)
        (fun (exp,kls) supname ->
	  dprintf "exp=%a@." (pp_name_map_t pp_classifier) exp;
	  dprintf "visited=%a@." pp_string_just_or_once_hash visited;
	  (* sup: definition of one of the supertypes of the class kls *)
           let sup = try begin match NameMap.find supname (* cdic *) expanded with
             | `klasse kls -> kls
             | _ -> (* Can't 'extend' a primitive data type *)
		 failwith(sprintf "%s: not class name." supname)
           end with Not_found -> (* Can't extend nonexistent class *)
             failwith(sprintf "%s: unknown class name." supname) in
           let exp, sup =
             if Hashtbl.mem visited supname then
               if Hashtbl.find visited supname = `just then
                 failwith(sprintf "%s <=> %s: Circular inheritance detected."
                            supname kname)
               else exp, sup (* if already visited in different recursion or iteration
                            without circular detection, then returm the memoized super class *)
             else visit supname sup exp (* traverse the super class recursively *)
           in
           (* override features of supertypes *)
           let features = NameMap.fold NameMap.add kls.features sup.features in
	   let kls' = { kls with features = features } in
           let clsf = `klasse kls' in
           (* replace the entry of kname with its class definition updated with expanded features *)
           NameMap.add kname clsf exp, (* kls *) kls') (expanded,kls) kls.supertypes in
    Hashtbl.add visited kname `once;
    exp_kls in
  (* For each class, expand its definition by their superclasses and update
     the classifier dictionary with these expansions.  *)
  NameMap.fold (fun name clsf exp -> match clsf with
                  | `klasse kls -> fst (visit name kls exp)
                  | _ -> exp) cdic cdic

(* remove abstract class and expand features *)
let clean_mm_dictionary (mmdic:mm_dictionary) : mm_dictionary =
  { mmdic with
      classifier =
      NameMap.fold
        (fun name clsf cdic -> match clsf with
           | `klasse kls ->
               if kls.is_abstract then cdic else NameMap.add name clsf cdic
           | _ -> NameMap.add name clsf cdic)
        (klasse_expand mmdic.classifier) NameMap.empty }

(* Checking multiplicity *)
(* The current implementation ignores `ordered' *)
let multiplicity_check (m:multiplicity) (n:int) : bool =
  let bs = match m with #bounds as bs -> bs | `ordered bs -> bs in
  match bs with
    | `range(lw,up) -> lw <= n && n <= up
    | `to_many lw -> lw <= n

module Vertex = struct type t = vtx let compare = compare end
module VMap = Map.Make(Vertex)
module VSet = Set.Make(Vertex)
module AMap = Map.Make(struct type t = allit let compare = compare end)
(** Map of {!UnCALDM.vtx} to map of {!UnCAL.allit} to set of {!UnCALDM.vtx}.
    Example: [AMap.find l VMap.find v] returns set of destination
             vtx accessible from vertex [v] via label [l].    *)
type edges = VSet.t AMap.t VMap.t (* source -> allit -> PowSet(destination) *)
(** Type for the map of {!UnCALDM.vtx} to {!Km3.classifier}. Used 
    in the validation process to memoize already visited set of nodes 
    associated with {!Km3.classifier} that the nodes are supposed to represent.   *)
type known_vtx_classifier = classifier VMap.t

let pp_vtx fmt vtx = fprintf fmt "%s" (vtx2str vtx)
let pp_allit fmt a = fprintf fmt "%s" (allit2str a)
let pp_vmap_t pp_a = VMap.pp_t "VMap" pp_vtx pp_a
let pp_vset_t = VSet.pp_t "VSet" pp_vtx
let pp_amap_t pp_a = AMap.pp_t "AMap" pp_allit pp_a
let pp_edges = pp_vmap_t (pp_amap_t pp_vset_t)

(* let pp_known_vtx_classifier = pp_vmap_t pp_classifier *)
(* We use a simplified pp_classifier for pp_known_vtx_classifier *)
let pp_classifier_simple fmt (clsf:classifier) = match clsf with
  | `klasse kls -> fprintf fmt "`klasse{kname = %a}" pp_name kls.kname
  | `datatype name -> fprintf fmt "`datatype %a" pp_name name
  | `enumeration(name,lits) ->
      fprintf fmt "`enumeration(%a,_)" pp_name name
let pp_known_vtx_classifier = pp_vmap_t pp_classifier_simple

(** [vmap] is a map from allit to destination nodes.
  [vset_amap_is_empty vamap] holds if the map is empty 
  or every entry of the map has empty set of nodes.
  The latter case never happens if [vmap] is created from a graph.
  See {!take_single_allit_dst} for detail.
 *)
let vset_amap_is_empty (vamap:VSet.t AMap.t) : bool =
  AMap.fold (fun _ vset b -> b && VSet.is_empty vset) vamap true

(* A label of the edge representing the name of the class *)
(* Discussion - Should we use the same name for a class and a label? *)
let allit_of_kname kname = ALLbl kname (* String.uncapitalize kname *)
let kname_of_allit allit = match allit with
  | ALLbl str -> str (* String.capitalize str *)
  | _ -> invalid_arg "kname_of_allit"
let allit_of_typeref typeref = ALLbl typeref (* String.uncapitalize typeref *)
let typeref_of_allit allit = match allit with
  | ALLbl str -> str (* String.capitalize str *)
  | _ -> invalid_arg "typeref_of_allit"

(** [edges_of_graph g] creats an index of vtx -> allit -> PowSet(vtx) from
    graph [g]. It is guaranteed that every entry of the map
    from allit to VSet.t is nonempty since the entry is only 
    created when corresponding edge exists.
 *)
let edges_of_graph (g:graph) : edges =
  SetofEdge.fold
    (fun (u,a,v) es ->
       let es_u = try VMap.find u es with Not_found -> AMap.empty in
       let es_u_a = try AMap.find a es_u with Not_found -> VSet.empty in
       VMap.add u (AMap.add a (VSet.add v es_u_a) es_u) es) g.e VMap.empty

(** [validation_fails vtx reason] prints an error message about 
    the node [vtx] with string [reason] that explains the error. *)
let validation_fails vtx reason =
  failwith (sprintf "Validation fails at %s: %s@?" (vtx2str vtx) reason)

(** A data structure that represents the outgoing edges from a node.
    See {!take_single_allit_dst} for the semantics of the data structure. *)
type single_allit_dst =
    Empty | Single of allit * vtx | Multiple of allit * allit

(** 
  [take_single_allit_dst es_v] extracts {!single_allit_dst}
  from a map [es_v] from allit to set of vtx. [es_v] represents
  outgoing edges of a node. Entries with empty destination
  nodes are ignored, because it is impossible if es_v 
  is taken from {!edges} that is created from a graph,
  since the entry is never created without
  an edge, which should always have a destination node.
  If there are only such kind of entries, then
  [Empty] is reported without raising error.
  @return [Empty] if the node has no outgoing edges.
           [Single][(l,v)] if there is exactly one outgoing edge
                   labeled [l] to node [v].
           [Multiple][(l1,l2)] if there are more than one outgoing
                   edges. If every edge is identically labeled, 
                   then l1=l2. Otherwise, l1 <> l2 and they are 
                   the first two labels found.
  *)

let take_single_allit_dst (es_v:VSet.t AMap.t) : single_allit_dst =
  AMap.fold (fun allit dsts -> function
              | Empty -> begin match VSet.cardinal dsts with
                  | 0 -> Empty
                  | 1 -> Single(allit,VSet.choose dsts)
                  | _ -> Multiple(allit,allit) end
              | Single(al,_) as s ->
                  if VSet.is_empty dsts then s else Multiple(al,allit)
              | Multiple _ as m -> m) es_v Empty 

let get_allit_dst (v:vtx) (es:edges) (typeref:name) : (allit * vtx) = 
  
  let es_v = try VMap.find v es (* obtain branches (map from label to PSet(nodes)) *)
                                (* outgoing edge of v (should be singule) *)
  with Not_found ->
    validation_fails v
      (sprintf "There is no edge for %S" (string_of pp_name typeref)) in
    (* take a single edge *)
    let allit, dst = match take_single_allit_dst es_v with
    | Empty ->
        validation_fails v
          (sprintf "There is no edge for %s" (string_of pp_name typeref))
    | Single(allit,dst) -> allit, dst
    | Multiple(al1,al2) ->
        validation_fails v
          (sprintf "There are multiple edges %s and %s."
             (allit2str al1) (allit2str al2)) in
    allit,dst



(** [validate_klasse v es kls mmdic known] checks for each {!Km3.feature} of
    the class [kls], if the node [v] of the graph (represented as [es] of 
    map vtx -> allit -> PowSet(vtx)) has branches that are valid instances
    of the feature. Multiplicity and the opposite_of property is checked
    here, and validation of each value of the feature is delegated to
    {!validate_classifier_vtx}.
    @param mmdic       metamodel dictionary
    @param known       map from vtx to classifier that has been already known.
    @return            map from vtx to classifier accumlated after the validation,
                       or error is raised if the check failed.
                       Accumulation of [known] occurs only via {!validate_classifier_vtx}.
    The following pattern is checked:

                              /
     (---Classifier_Name-->)[v]----
                              \
 *)
let rec validate_klasse_vtx (v:vtx) (es:edges) (kls:klasse)
    (mmdic:mm_dictionary) (known: known_vtx_classifier) : known_vtx_classifier =
  let _ = dprintf "[validate_klasse_vtx]edges=%a@." pp_edges es in
  let _ = dprintf "[validate_klasse_vtx]mmdic=%a@." pp_mm_dictionary mmdic in
  let _ = dprintf "[validate_klasse_vtx]known=%a@." pp_known_vtx_classifier known in
  (* es_v: map from edge labels (feature name) to set of destination nodes *)
  (* known: accumulated map from vtx to the classifier the vtx represents *)
  let es_v = try VMap.find v es with Not_found -> AMap.empty in 
  let es_v, known = 
    NameMap.fold
      (* opposite_of is not supported yet *)
      (fun fname ft (es_v,known) ->
	 let _ = dprintf "[NameMap.fold]es_v=%a@." (pp_amap_t pp_vset_t) es_v in
	 let _ = dprintf "[NameMap.fold]known=%a@." pp_known_vtx_classifier known in
         let allit = ALLbl fname in
         let es_v_f = try AMap.find allit es_v with Not_found -> VSet.empty in
	 let _ = dprintf "[NameMap.fold]es_v_f=%a@." pp_vset_t es_v_f in
         let f = match ft with
           | `attribute f | `reference{feature=f;opposite_of=None}-> f
           | `reference{feature=f;opposite_of=Some op} ->
               let allit_op = ALLbl op in
               let allit_kls = allit_of_kname kls.kname in
               (* check oppositeOf edges *)
               VSet.iter
                 (fun dst ->
                    let es_dst =
                      try VMap.find dst es with Not_found -> AMap.empty in
                    match take_single_allit_dst es_dst with
                      | Empty | Multiple _ ->
                          validation_fails dst
                            (sprintf "There should be a single edge from %s."
                               (vtx2str dst))
                      | Single(_,dst_dst) -> try
                          if not(VSet.exists
                                  (fun dst_dst_dst -> try
                                     VSet.mem v
                                       (AMap.find allit_kls
                                          (VMap.find dst_dst_dst es))
                                   with Not_found -> false)
                                  (AMap.find allit_op
                                     (VMap.find dst_dst es))) then raise Not_found
                        with Not_found ->
                          validation_fails dst_dst
                            (sprintf "An edge for 'oppositeOf' %s is not found."
                               (string_of pp_name op))) es_v_f;
               f in
         let card = VSet.cardinal es_v_f in
         if multiplicity_check f.multiplicity card then
           (AMap.remove allit es_v, (* exclude already checked edges *)
            VSet.fold (* check each value if it is a valid instance of the feature type *)
              (fun dst known ->
		let _ = dprintf "[VSet.fold]known=%a@." pp_known_vtx_classifier known in
                 validate_classifier_vtx dst es f.typeref mmdic known)
              es_v_f known)
         else if card = 0 then
           validation_fails v
             (sprintf "Feature %s is missing." (string_of pp_name fname))
         else
           validation_fails v
             (sprintf
                "The number of edges %d does not match with its multiplicity %s."
                card (string_of pp_multiplicity f.multiplicity)))
      kls.features (es_v,known) in
  (* Since the above fold removes all the outgoig edges that represents the features
     declared in the metamodel, whatever remain in the new es_v are invalid excess
     edges, so ... *)
  (* choose one edge to show the error if it is not empty *)
  AMap.iter (fun allit _ ->
               validation_fails v
                 (sprintf "%s is invalid." (allit2str allit))) es_v;
  (* The control reaches here if the es_v is empty, since if es_v is
     non-empty, the body of the above iteration would have aborted
     with an error message. *)
  (* just return known if it is empty *)
  known

(**
   [validate_classifier_vtx v es typeref  mmdic known] checks the node [v] 
   of the graph (represented as [es] of map vtx -> allit -> PowSet(vtx))
   to see if the node representes a feature of valid type [typeref] 
   as described in the feature description of the metamodel dictionary [mmdic].
   Note that all the abstract class entries (key-value pairs) had been removed 
   from [mmdic] as a preprocess by [clean_mm_dictionary], while
   [typeref] may still be one of the removed abstract classes that was in the
   original metamodel before the preprocessing. In this case, 
   if the concrete class in the graph instance is the subclass
   of the superclass, then it proceeds with the subclass instead.
   The node [v] is supposed to have a singleton edge with capitalized 
   label that represents a classifier, and this singularity is also checked here.

    @param known       map from vtx to classifier that has been already known.
    @return            map from vtx to classifier accumlated after the validation,
                       or error is raised if the check failed.

   The edge of the graph checked here is the form
      [v]--Classifier_name-->dst
   where [v] is pointed by an edge labeled with a feature name.
   First, if dst has already been memoized to have type [typ] in [known] map, 
   then the [typ] is  compared to that indicated by [typeref] and if it matches, then
   the validation just succeeds. If not, it indicates that the edge 
   points to the destination dst with unintended type, so the validation fails.
   If dst has not been memoized in the [known] map, then first memoize dst with 
   the type indicated by [typeref], and Classifier_name is checked with the assumed type
   (after checking of singularity of outgoing edge of [v]).
   If it doesn't match with the assumed type, then the validation fails.
   If matches, go on with checking if dst is a valid instance of the assumed type.
   If the type is a class type, then the check is delegated to
   {!validate_klasse_vtx}. If the type is a primitive data type,
   then dst should have only one single edge labeled with the
   value of the primitive data type. The Classifier_name is
   checked with the data type name. If matches, then 
   after the singularity check of the value edge, the actual type 
   of the label of the edge is checked against the name of the primitive data type.
   Correspondence of 
    ("String", ALStr), ("Boolean",ALBol), ("Int", ALInt), ("Float", ALFlt)
   is checked. 
   In case of success, the memo (map) extended from [known] is returned.
*)
and validate_classifier_vtx (v:vtx) (es:edges) (typeref:name)
    (mmdic:mm_dictionary) (known: known_vtx_classifier) : known_vtx_classifier =
  let _ = dprintf "[validate_classifier_vtx]es=%a@." pp_edges es in
  let _ = dprintf "[validate_classifier_vtx]mmdic=%a@." pp_mm_dictionary mmdic in
  let _ = dprintf "[validate_classifier_vtx]known=%a@." pp_known_vtx_classifier known in
  (* Resolve the type definition of typeref by the metamodel dictionary mmdic. *)
  let typ = try NameMap.find typeref mmdic.classifier
  with Not_found -> 
    (************ BEGIN concrete subclass of abstract class check ***********)
    (* Since all abstract classes are eliminated by clean_mm_dictionary, 
       typeref cannot be found in mmdic if it is an abstract class
       (declared in KM3 schema). However, the graph subject to validation
       may have the subclass of the abstract class.
       So examine the actual edge and if it is a subclass of typeref, then
       continue with the subclass type. *)

    let allit,_ = get_allit_dst v es typeref in

    let kname =  kname_of_allit allit in
    let typ =
      try NameMap.find kname mmdic.classifier
      with Not_found -> validation_fails v (sprintf "%s is an unknown classifier."
					    (string_of pp_name kname)) in
    match typ with
    | `klasse kls ->
        List.iter (fun t -> dprintf "supertype=%s@." t) kls.supertypes;
	if (List.mem typeref kls.supertypes) then
	  ((dprintf "subtype %s is found for its supertype %s@." kname typeref);typ)
	else
	  validation_fails v (sprintf "%s is an unknown classifier."
				(string_of pp_name kname))
    | _ -> validation_fails v (sprintf "%s is an unknown classifier."
				(string_of pp_name kname)) in
    (************  END  concrete subclass of abstract class check ***********)
  (* check the structure  v--allit(Classifier name)-->dst *)
  match VMap.find_some v known with (* check the memo of node v *)
    | Some t -> (* memo hit *)
        if t = typ then known  (* memo actually stores the type consistent with typeref *)
        else begin
          printf "%a@;does not match with@;%a.@."
            pp_classifier t
            pp_classifier typ;
          validation_fails v ("label not matched."^string_of pp_classifier typ)
        end
    | None -> (* memo didn't hit. first visit of v *)
        let known = VMap.add v typ known in (* memoize v with assumed type typ *)
	let allit, dst = get_allit_dst v es typeref in
	
        match typ with
          | `klasse kls ->
              let allit_kls = allit_of_kname kls.kname in
              if allit_kls <> allit then
                validation_fails v
                  (sprintf "%s should be %s." (allit2str allit) (allit2str allit_kls));
	      (* check the subgraph beyond dst if it represents a valid instance of kls *)
              validate_klasse_vtx dst es kls mmdic known
          | `datatype t ->
              (* check for one of the following patterns 
                    v--ALLbl "String" -->dst--ALStr s -->{}
                    v--ALLbl "Boolean"-->dst--ALBol b -->{}
                    v--ALLbl "Int"    -->dst--ALInt i -->{}
                    v--ALLbl "Float"  -->dst--ALFlt f -->{} *)
              let allit_t = allit_of_typeref t in
              if allit_t <> allit then
                validation_fails v
                  (sprintf "%s should be %s." (allit2str allit) (allit2str allit_t));
              let es_dst = try VMap.find dst es
              with Not_found ->
                validation_fails dst
                  (sprintf "There is no edge for %s" (string_of pp_name typeref)) in
              let allit = match take_single_allit_dst es_dst with
                | Empty ->
                    validation_fails dst
                      (sprintf "There is no edge for %s" (string_of pp_name typeref))
                | Single(allit,leaf) -> begin try
                    if vset_amap_is_empty (VMap.find leaf es) then allit
                    else
                      validation_fails leaf
                        (sprintf "The vertex %s must have no edge." (vtx2str leaf))
                  with Not_found -> allit end
                | Multiple(al1,al2) ->
                    validation_fails dst
                      (sprintf "There are multiple edges %s and %s."
                         (allit2str al1) (allit2str al2)) in
              begin match typeref, allit with
                | "String", ALStr _ | "Boolean", ALBol _
                | "Int", ALInt _ | "Float", ALFlt _ -> known
                | _ ->
                    validation_fails v
                      (sprintf "The edge %s does not match with the type %s."
                         (allit2str allit) typeref) end
          | `enumeration _ ->
              failwith "Not implemented yet for enumeration."
                
(* It just returns vertex mapping to classifier if validation succeed. *)
(* Othewise an error is raised. *)
(** [validate g pname mm] validates the graph [g] with respect to package [pname]
    in the metamodel [mm] and returns a map from vtx to classifier if validation succeed.
    Otherwise an error is raised.
    For the graph [g], the following conditions are checked by [validate] itself:
      1. non-empty (have at least one edge at the top level)
      2. have exactly one default root marker
      3. each top-level edge should 
        3-1. have labeled with a name using ALLbl.
        3-2. the label represents the name of a classifier declared in the metamodel [mm].
        3-3. the classifier should be a class (datatype and enumeration are disallowed)
    The subgraphs following the top-level edges are checked by {!validate_klasse_vtx}.
    Each entry of the result map corresponds to an edge
      vtx--Classifier_Name-->dst 
    and maps vtx to its data type description, of which dst is the valid instance,
    assuming that the edge is the only outgoing edge of vtx.
    Snce the root node is an exception of this (have multiple edges of 
    this shape), the root is not registered in the result map.
 *)
let validate (g:graph) (pname:name) (mm:metamodel) : known_vtx_classifier =
  match SetofInodeR.cardinal g.i with
    | 1 ->
        let edges = edges_of_graph g in
	let _ = dprintf "edges=%a@." pp_edges edges in
        let mmdic = clean_mm_dictionary (make_mm_dictionary mm) in
	let _ = dprintf "mmdic=%a@." pp_mm_dictionary mmdic in
        let (_,root) as inodeR = SetofInodeR.min_elt g.i in
        if isroot inodeR then
          let kset = try NameMap.find pname mmdic.package with
              Not_found -> failwith (Format.sprintf "validate: unknown package %s." (string_of pp_name pname)) in
          let es_root = try VMap.find root edges with
              Not_found -> failwith "validate: graph is empty." in
	  let _ = dprintf "es_root=%a@." (pp_amap_t pp_vset_t) es_root in
          let allit_fails allit reason =
            validation_fails root (sprintf "%s is invalid. %s" (allit2str allit) reason) in
          AMap.fold
            (fun allit dsts known ->
	       let _ = dprintf "dsts=%a@." pp_vset_t dsts in
	       let _ = dprintf "known=%a@." pp_known_vtx_classifier known in
               let kname = try kname_of_allit allit
               with _ -> allit_fails allit (sprintf "Invalid type of label at the top." ) in
               if not(NameSet.mem kname kset) then
		 (* Top-level edge represents a classifier that do not belong
                    to the package [pname]. It may be the case that allit
                    reprecents non-class datatype, since these are not 
                    registered to mmdic.package *)
		 allit_fails allit (sprintf "Unknown classifier %S" kname);
               let kls = try match NameMap.find kname mmdic.classifier with
                 | `klasse kls -> kls
                 | clsf -> 
		     (* this case is impossible since mmdic.package only stores the
			(non-abstract) classes *)
		     allit_fails allit (sprintf "non class classifier at the top level.")
               with Not_found -> 
                    (* this case is impossible since all entries of mmdic.package
		       are also found in mmdic.classifier *)
                    allit_fails allit (sprintf "unknown classifier.") in
               VSet.fold
                 (fun dst known ->
		   let _ = dprintf "[VSet.fold]dsts=%a@." pp_vset_t dsts in
		   let _ = dprintf "[VSet.fold]known=%a@." pp_known_vtx_classifier known in
                    validate_klasse_vtx dst edges kls mmdic known) dsts known)
            es_root VMap.empty
        else
          failwith "No root node is found."
    | n ->
        failwith(sprintf "The number of input markers should be 1 (not %d)." n)
