(** Convert XMI file to DOT file via UnCAL graph using KM3 metamodel information *)
open Km3
open Km3util
open PrintKm3
open Fputil
open UnCAL
open Format
open UnCALDM
open UnCALDMutil
open EvalUnCAL
open Dotutil
open PrintUnCAL
open Xml
open ObjectGraph

(* Following structure of the input XMI file is assumed:
   1. Top level model elements have classifier name as its tag.
   2. Top level model elements have identifiers as xmi:id attribute.
   3. Contained model elements have feature name as its tag.
   4. Reference attributes is of the form <featurename>=<xmi:id>.
   
   If KM3 metamodel is provided, then it is fully used for encoding.
   If not provided, then we instead assume the presense of 
   xsi:type attribute as the classifier name of the contained 
   model element.
   We then do the following guess.

   1. Reference attributes identified by matching with
      one of all the xmi:id attributes appearing in the XMI file.
      Otherwise it can be treated as primitive data types.
   2. Primitive data type attributes can be inferred lexically by
      parsing as UnCAL label literal:
      ALLbl, ALStr => String, ALInt => Integer, ALBol => Boolean,
      ALFlt => Float.
   These assumptions may not be safe because some attribute value
   may coincide with xmi:id.

 *)

(******** Encoding stragety by example ********
 namespace:
    mlns:relational="Relational"
  => Package name is Relational, 
     XMI file's namespace prefix is "relational"
  <relational:Table xmi:id="IN/0.Class2Table.t" name="Family">
    <col xsi:type="relational:Column" name="firstName" type="IN/2.Datatype2Type.t"/>
    <col xsi:type="relational:Column" name="family" type="IN/0.Class2Table.t"/>
  >/relational:Table>
  
   => Model element's Classifier name is Table
      model element's identifier is  "IN/0.Class2Table.t"
      "name" attribute is "Family"
      "col" attribute is the following model element:
        Classifier name is "Column"
        "name" attribute is "firstName"
        "type" attribute refers to model element "IN/2.Datatype2Type.t"
        Classifier name is "Column"
        "name" attribute is "family"
        "type" attribute refers to model element "IN/0.Class2Table.t"

  (&IN/0.Class2Table.t U &IN/1.Class2Table.t U &IN/2.Datatype2Type.t)@ cycle(
 (&IN/0.Class2Table.t :=
   {Table: {xmi_id: {String:{"IN/0.Class2Table.t":{}}},
           name : {String:{"Family"}},
           col : {Column: {name:{String:{"name":{}}},
                           type: {Type: &IN/2.Datatype2Type.t}}}}},
  &IN/1.Class2Table.t := 
   {Table: {xmi:id: {String:{"IN/1.Class2Table.t":{}}},
            name:   {String:{"Person":{}}},
            col : {Column: {name:{String:{"firstName":{}}},
                            type: {Type: &IN/2.Datatype2Type.t}}}}},
  &IN/2.Datatype2Type.t :=
    {Type: {xmi_id:{String:{"IN/2.Datatype2Type.t":{}}},
            name={String:{"String":{}}}}})
*)

(** If true, debug write by {!dprintf} is enabled *)
let xmi2dot_generic_verbose = ref false

(** [dprintf ?flag] acts like printf except that it prints
    nothing if [flag] or {!xmi2dot_generic_verbose} is false.
    These values are checked at run-time. *)
let dprintf ?(verbose:bool = false) =
  if (!xmi2dot_generic_verbose || verbose)
  then Format.printf
  else Format.ifprintf std_formatter

(** [is_qualified name] returns true if [name] is qualified *)
let is_qname (name : string) : bool =
  match Str.split (Str.regexp ":") name with
    [_;_] -> true
  | _     -> false

(** [split_qname qname] splits qualified name [qname] into the pair of
    namespace prefix and local name *)
let split_qname (qualified_name : string) : (string * string) =
  match Str.split (Str.regexp ":") qualified_name with
    [qualifier;localname] -> (qualifier,localname)
  | _ -> failwith ("split_qname: malformed_qname " ^ qualified_name)

(** [qname2localname qname] extracts local part of the
    qualified name [qname]. If namespace prefix is 
    not present in [qname], [qname] itself is returned. *)
let qname2localname (qualified_name : string) : string =
  match Str.split (Str.regexp ":") qualified_name with
    [qualifier;localname] -> localname
  | [localname] -> localname
  | _ -> failwith ("qname2localname: malformed_qname " ^ qualified_name)

(** [split_nmtokens nmtokens] splits Nmtokens separated by spaces *) 
let split_nmtokens (nmtokens : string) : string list = 
    Str.split (Str.regexp " ") nmtokens

(** Escapes the xmi:id attribute string to cope with lexical
    constraincts of other tools. *)
let escape_xmi_id (xmiId:string) =
  let m = Str.global_replace (Str.regexp "/") "_" xmiId in
  Str.global_replace (Str.regexp "\\.") "_" m

(** Converts xmi:id string to marker *)
let xmiId2marker (xmiId:string) : marker = "&" ^ (escape_xmi_id xmiId)
let parseKm3_file = Parse.parse_file ~parse:ParseKm3.entry ~lex:LexKm3.token 

(** {9 strings to UnCAL label literal conversion } *)

let   str_allit_of_string s = ALLit (None,(ALStr  s))
let  bool_allit_of_string s = ALLit (None,(ALBol  (bool_of_string s)))
let   int_allit_of_string s = ALLit (None,(ALInt  (int_of_string s)))
let float_allit_of_string s = ALLit (None,(ALFlt  (float_of_string s)))

(** [prepend_labels llist expr] prepends edge labels in [llist] 
    on top of UnCAL expression [expr].  *)
let prepend_labels (llist : string list) expr = 
  List.fold_right (fun label expr ->
    AEEdg (None,ALLit (None, ALLbl label),expr)) llist expr

(** Generates UnCAL expression to represent a feature named [attr]
    with the primitive data value [value] of type [typ] *)
let prim2uncal (attr:string) (typ:string) (value:string) = 
  prepend_labels [attr;typ]
  (AEEdg(None,
  (match typ with
    | "String"  ->   str_allit_of_string value
    | "Boolean" ->  bool_allit_of_string value
    | "Int"     ->   int_allit_of_string value
    | "Float"   -> float_allit_of_string value
    | _ -> failwith ("Unknown type tag: " ^ typ)),AETEmp None))

(** Convert XMI id to a feature that encodes the XMI id. *)
let xmiId2uncal (xmiId:string) =
  prim2uncal
    (* "xmi:id"  *) (* "xmi_id" *) "__xmiID__"
    "String" xmiId

(** Lookup xsi:type attribute in the attribute list [attrlist] 
    for type information. [tag] is used only for debug purpose. *)
let lookup_xsi_type ?(tag:name option) (attrlist: (name * string) list) =
  let tag_debuginfo = 
    match tag with Some t -> ("for element " ^ t) | None -> "" in
  let xsi_type = try (List.assoc "xsi:type" attrlist) with
    Not_found -> failwith ("no xsi_type info found " ^ tag_debuginfo) in
  let xsi_type = qname2localname xsi_type in
  let _ = dprintf "lookup_xsi_type: xsi_type %s = %s@." tag_debuginfo xsi_type in
  xsi_type


(** Generate map from xmi:id to classifier names.
    For non top-level elements, the tag name is 
    not a classifier name, so we need xsi:type, 
    regardless of the presence/absence of metamodel. *)
let gen_xmi_id_map (xml_list:xml list) : name NameMap.t =
  let rec elem2table (is_top:bool) elem map =
    match elem with
      Element (ename,attrlist,elemlist) ->
        let classifier_name = 
          if is_top then ename 
          else lookup_xsi_type ~tag:ename attrlist in
	let map =
	  try let xmi_id = List.assoc "xmi:id" attrlist in
    	  NameMap.add xmi_id (qname2localname classifier_name) map
	  with Not_found -> map in
	List.fold_right (elem2table false) elemlist map 
    | PCData _ -> map
  in List.fold_right (elem2table true) xml_list NameMap.empty

(** Data type for storing either reference or non-structured attribute
    Reference may be multi-valued and may have different classifier names *)
type x2d_attr =
    X2DRef  of string * ((string * string) list) (** featurename,[(classifiername,xmi_id)] *)
  | X2DAttr of string * string * string (** featurename,classifiername,value *)

(** [resolve_classifiers xmi_id_map value] splits Nmtokens [value] and pair them with 
     their classifier names by consulting [xmi_id_map]. *)
let resolve_classifiers (xmi_id_map:name NameMap.t) (value:string) : (string*string) list =
  let refs = split_nmtokens value in
  List.map (fun xmi_id ->
    match NameMap.find_some xmi_id xmi_id_map with
      Some tr -> (tr,xmi_id)
    | None -> failwith ("resolve_classifiers: classifier for xmi:id" ^ xmi_id ^ " not found")) refs
 
(** [attr2x2d_attr_with_mm kname mmdic xmi_id_map aname value] 
    encodes an XMI attribute [aname] and value [value] of the
    classifier [kname].
    [mmdic] is used to determine whether the attribute is a reference
    to other element or primitive data. The former is converted to 
    output marker expression. *)
let attr2x2d_attr_with_mm kname mmdic xmi_id_map aname value =
  let kls_entry = try (NameMap.find kname mmdic.classifier) with
    Not_found -> failwith (sprintf "parent classifier %s unknown." kname) in
  let features = match kls_entry with
    `klasse {is_abstract = _; kname = _; supertypes = _; features = f} -> f
  | _ -> failwith "attribute with non_classifier?" in
  let feature = try (NameMap.find aname features) with
    Not_found -> failwith (sprintf "feature %s for kname %s not found" aname kname) in
  match feature with
    (* current encoding does not require typeref *)
    `reference {feature = {multiplicity = _; typeref = _}; 
		is_container = _; opposite_of = _} -> 
                (* tr is not enough because it might be a super class.
		   We need the concrete class(classifier) name. *)
		  X2DRef (aname,resolve_classifiers xmi_id_map value)
  | `attribute {multiplicity = _; typeref = tr}    ->
      let kls_entry = try (NameMap.find tr mmdic.classifier) with
	Not_found -> failwith (sprintf "attribute classifier %s unknown." tr) in
      let prim_tag = match kls_entry with
	`datatype s ->
	  dprintf "attr2x2d_attr_with_mm: resolved typeref %s to datatype %s@." tr s;
	  s
      | _ -> failwith (sprintf "attr2x2d_attr_with_mm: non-structured attribute for %s" tr) in
      X2DAttr(aname,prim_tag,value)

(** [guess_primitive_data_type value] lexically determines the primitive data type
    of the given string representation [value] *)
let guess_primitive_data_type (value:string) : string =
  match (TestUnCALutil.parseLabel_string value) with
    ALInt _ -> "Integer"
  | ALBol _ -> "Boolean"
  | ALLbl _ -> "String"
  | ALStr _ -> "String"
  | ALFlt _ -> "Float"
  | _       -> failwith (sprintf "guess_primitive_data_type: failed to guess primitive data type of %s" value) 

(** Encoding without metamodel dictionary.  Table [xmi_id_map] from
    XMI ID to classifier name is used so that if the attribute value
    is found in the map, then it is considered as reference type,
    otherwise it is considered as primitive data type and the type is
    determined lexically. *)
let attr2x2d_attr_without_mm (xmi_id_map: name NameMap.t) aname value =
  match NameMap.find_some value xmi_id_map with
    Some tr ->
      dprintf "attr2x2d_attr_without_mm: reference feature %s of type %s to %s@." aname tr value;
      X2DRef (aname,resolve_classifiers xmi_id_map value)
  | None ->
      let tr = guess_primitive_data_type value in
      dprintf "attr2x2d_attr_without_mm: non-structured feature %s of type %s with value %s@." aname tr value;
      X2DAttr (aname,tr,value)

(** Encodes list of XMI attributes [attrlist] of the classifier [kname]
    using metamodel dictionary [mmdic].
*)
let attrs2uncal (mmdic:mm_dictionary option) (xmi_id_map: name NameMap.t)
    (kname:name) (attrlist:(name * string) list)  =
  let an       = None            (* default notation *) in
  let uni  x y = AEUni  (an,x,y) (* union x U y *)      in
  let aname_value2x2d aname value =
    let _ = dprintf "attrs2uncal: kname,aname,value = (%s,%s,%s)@." kname aname value in
    match mmdic with
      Some mmdic -> attr2x2d_attr_with_mm kname mmdic xmi_id_map  aname value
    | None       -> attr2x2d_attr_without_mm xmi_id_map aname value in
  let insert_uncal4attr (aname,value) expr =
    match aname with
      "xmi:id"   -> uni (xmiId2uncal value) expr
    | "xsi:type" -> expr  (* should coincide with kname *)
    | _ -> uni
	  (match (aname_value2x2d aname value) with
	  X2DRef (aname,classifier_value_list) -> 
	    (* now, tr (classifier name) is used *)
           (fold_right1 uni
  	    (List.map (fun (classifier,value) -> (prepend_labels [aname;classifier] (AEOMrk (None,xmiId2marker value)))) classifier_value_list))
	| X2DAttr(aname,tr,value) -> prim2uncal aname tr value) expr
  in
  List.fold_right insert_uncal4attr attrlist (AETEmp an)



(** [lookup_tagtype mmdic kname tag] looks up typeref of the 
    feature [tag] of the classifier [kname].
    It is used to determine the edge label following the edge
    encoding feature name. *)
let lookup_tagtype (mmdic:mm_dictionary) (kname:name) (tag:name) : name =
  let kls_entry = try (NameMap.find kname mmdic.classifier) with
    Not_found -> failwith (sprintf "lookup_tagtype: unknown classifier %s" kname) in
  let features = match kls_entry with
    `klasse {is_abstract = _; kname = _; supertypes = _; features = f} -> f
  | _ -> failwith (sprintf "lookup_tagtype: looking up feature %s for classifier klasse  %s" tag kname) in
  let feature = try (NameMap.find tag features) with
    Not_found -> failwith (sprintf "lookup_tagtype: unexpected feature %S for classifier %s" tag kname) in
  match feature with
    `reference {feature = {multiplicity = _; typeref = tr};
		is_container = _; opposite_of = _} -> tr 
  | `attribute {multiplicity = _ ; typeref = tr} 
    -> tr (* XMI element used for an attribute. Non-structured attribute? *)

(** Recursively encodes the element [elem] of the classifier [kname] using
    metamodel dictionalry [mmdic] *)
let rec elem2uncal (mmdic:(mm_dictionary option)) xmi_id_map (kname:name) (elem:xml)  =
  (* mmdic is common, so do not pass around as arguments during recursive call *)
  let an = None (* default notation *) in
  let uni  x y = AEUni  (an,x,y) (* union x U y *) in
  let ((tag,attrlist,elemlist): (string * (name*string) list * xml list)) =
    match elem with
      Element (t,a,e) -> (t,a,e)
    | _ -> failwith "invalid element" in
  let xsi_type = 
    try (Some (lookup_xsi_type ~tag:tag attrlist))
    with Failure s -> None in
  (* FIXME: because of object orientation in KM3, typeref may be abstract,
     so XMI may encode its concrete descendant. In this case, xsi:type 
     should exist, because nothing else can encode the concrete class.
     xsi:type and typeref naturally disagrees in this case, so no 
     error should be raised but xsi:type should be used for the encoding.
     Concrete example (in KM3.km3): 
	abstract class ModelElement extends LocatedElement {
		attribute name : String;
		reference "package" : Package oppositeOf contents;
	}
	class Package extends ModelElement {
	reference contents[*] ordered container : ModelElement oppositeOf "package";
        ... }
 *)
  let typeref =
    match mmdic with 
      Some mmdic ->
	(let typeref = lookup_tagtype mmdic kname tag in
	match xsi_type with
	  Some xsi_type ->
	    if (xsi_type <> typeref) then
	      dprintf ~verbose:true "xsi_type=%s and typeref=%s disagrees.@." xsi_type typeref;
	      typeref
	| None -> typeref
	      (* if xsi:type attribute is provided, check it against the metamodel *))
    | None ->
	match xsi_type with
	  Some xsi_type -> xsi_type
	| None -> failwith (sprintf "neither metamodel or xsi:type is found for tag %s under kname %s" tag kname)
  in 
    let attrs_uncal = (attrs2uncal mmdic xmi_id_map typeref attrlist) in
    let (uncal_tree_list,uncal_graph_list_list) =
      List.split (List.map (fun elem -> elem2uncal mmdic xmi_id_map typeref elem) elemlist) in
    let xmi_id = try (List.assoc "xmi:id" attrlist) with Not_found ->
        failwith "elem2uncal: xmi:id is not found in the attribute list" in
    let marker = xmiId2marker xmi_id in
    let omrk m   = AEOMrk (an,m) in
    let imrk m e = AEIMrk (an,m,e) in
    (prepend_labels [qname2localname tag;typeref] (omrk marker),
     (imrk marker (List.fold_right uni uncal_tree_list attrs_uncal))
      :: (List.concat uncal_graph_list_list))

(** Convert XMI data [xml] into UnCAL expression using metamodel 
    dictionary [mmdic]. *)
let xmi2uncal mm (xml:xml) =
  let mmdic = match mm with None -> None | Some mm -> Some (clean_mm_dictionary (make_mm_dictionary mm)) in
  let (toptag, top_attrlist, top_elemlist) =
    match xml with
      Element (t,a,e) -> (t,a,e)
    | PCData _        -> failwith "PCData on toplevel unexpected" in
  (* Remove idiomatic declaration to extract model elements namespace
  prefix declaration *)
  let is_decls = function
      ("xmi:version", _) | ("xmlns:xmi", _) | ("xmlns:xsi", _) -> true
    | _ -> false in
  let (decls,non_decls) = List.partition is_decls top_attrlist in
  let is_nsdecls (attr,_) = 
    is_qname attr && 
    (match (split_qname attr) with ("xmlns",_)->true | _ -> false) in
  let (namespace_prefix,package_name,top_elemlist) =
    let (qname_pname,data_attrlist) = List.partition is_nsdecls non_decls in
    (if List.length qname_pname = 1 then
      let (qualified_name, package_name) = List.nth qname_pname 0 in
      let (xmlns,namespace_prefix) = split_qname qualified_name in
      (namespace_prefix,package_name,
       if toptag="xmi:XMI" then 
	 (* There are more thatn one real top level element under "xmi:XMI" *)
	 top_elemlist 
       else
	 (* singleton real top level element comes at the top *)
	 [Element (toptag,data_attrlist,top_elemlist)])
    else
      failwith "supurious declaration or namespace prefix not found" ) in
  ignore namespace_prefix;
  let xmi_id_map = gen_xmi_id_map top_elemlist in
  let an = None (* default notation *) in
  let duni x y = AEDUni (an,x,y) (* disjoint union x ++ y *) in
  let imrk m e = AEIMrk (an,m,e) (* input marker expression &m:=e *) in
  let omrk m   = AEOMrk (an,m)   (* output marker expression &m *) in
  let uni  x y = AEUni  (an,x,y) (* union x U y *) in
    let apnd x y = AEApnd (an,x,y) (* append x @ y *) in
    (* Extract list of toplevel markers (converted from xmi:id attributes) and 
       corresponding disjoint union of UnCAL encodings. *)
    let (topmarker_list,top_expr) =
    List.fold_right (fun top_elem (topmarker_list,expr) ->
    (* Toplevel is specialy treated in the sense that its encoding is
       &xmi:id := {ClassifierName: (features subgraph)} where
       ClassifierName is directly taken from the tag name and
       xmi:id is assumed to be present as one of the attributes. *)
    let (tag, attrlist, elemlist) =
      match top_elem with
	Element (t,a,e) -> (t,a,e)
      | _               -> failwith "unexpected toplevel" in
    let kname = qname2localname tag in
    let xmi_id = try (List.assoc "xmi:id" attrlist) with Not_found ->
      failwith "xmi:id is not found in the toplevel element" in
    let topmarker = xmiId2marker xmi_id in
    (((prepend_labels [kname] (omrk topmarker)) :: topmarker_list),
     (let attrs_uncal = attrs2uncal mmdic xmi_id_map kname attrlist in
      let (uncal_tree_list,uncal_graph_list_list) =
       List.split (List.map (fun elem -> elem2uncal mmdic xmi_id_map kname elem) elemlist) in
    duni 
     (duni (imrk topmarker (List.fold_right uni uncal_tree_list attrs_uncal))
           (List.fold_right duni (List.concat uncal_graph_list_list) (AEGEmp an)))
    expr))) top_elemlist ([],(AEGEmp an)) in
    let _ = dprintf "xmi2uncal: UnCAL expr before cycle operation = %a@." ppr_a_aexpr top_expr in 
    apnd (List.fold_right uni topmarker_list (AETEmp an)) (AECyc(an,top_expr))

let known_vtx_classifier_to_string arg = fprintf str_formatter "%a" pp_known_vtx_classifier arg;flush_str_formatter ()
let validate_and_print (prefix:string) (prt_time:bool) (g:graph) (pname:name) (mm:metamodel) : unit =
  begin 
    print_endline ("********* begin " ^ prefix ^ " message *************");
    let msg =
      try ("Validation succeeded.\n" ^ (known_vtx_classifier_to_string 
					  (let lcls = (lazy (validate g pname mm)) in
					  if prt_time 
					  then print_time ~prefix:prefix lcls
					  else Lazy.force lcls)
				       ))
      with 
	e -> ("Validation failed.\n" ^ (Printexc.to_string e)) in
    print_endline msg;
    print_endline ("********** end " ^ prefix ^ " message **************")
  end


(** xmi2g xml [mm] converts XMI file [xml] to UnCAL graph using metamodel [mm] *)
let xmi2g mm xml =
  let cg = xmi2uncal mm xml in
  let _ = dprintf "xmi2g: UnCAL expr = %a@." ppr_a_aexpr cg in 
  let _ = cycleSemanticsOriginal := true in
  clean_id (reachableGI (remove_eps (load_db cg)))

(** Convert XMI file [xmi_file] to DOT file [dot_file] 
    using package [pname] in the metamodel in KM3 file [km3_file] *)
let xmi2dot pname km3_file (validate_flag:bool) (xmi_file:string)  (dot_file:string) =
  let xml = Xml.parse_file xmi_file in
  let km3 = match km3_file with None -> None | Some km3_file -> Some (parseKm3_file km3_file) in
  let g = xmi2g km3 xml in
  if validate_flag then
    (match (pname,km3) with
      (Some pname,Some km3) -> validate_and_print "Output validation" true g pname km3
    | _ -> ());
  let dot = g2dot g in
  dumpDot dot dot_file

(** {9 Backward transformation from XMI to DOT, taking original DOT into consideration.}  *)

(** map unification checkers *)

let xmi_element_map_unify_check (x:xmi_element) (y:xmi_element) : bool = true (* FIXME *)
let xemuc = xmi_element_map_unify_check
let nameVtxSet_map_unify_check (x:NameVtxSet.t) (y:NameVtxSet.t) : bool = (NameVtxSet.compare x y = 0)
let nvsmuc = nameVtxSet_map_unify_check
let name_primset_map_unify_check (x:(name * primset)) (y:(name * primset)) : bool = 
  let ((namex,primsetx),(namey,primsety)) = (x,y) in
  namex = namey && (match (primsetx,primsety) with
    (SetofInt(x),SetofInt(y)) -> (SetofInt.compare x y = 0)
  | (SetofStr(x),SetofStr(y)) -> (SetofStr.compare x y = 0)
  | (SetofFlt(x),SetofFlt(y)) -> (SetofFlt.compare x y = 0)
  | (SetofBol(x),SetofBol(y)) -> (SetofBol.compare x y = 0)
  |  _ -> false)
let npmuc = name_primset_map_unify_check

(** [attrs2attrmap_refmap is_toplevel mmdic xmi_id_map kname attrlist]
    converts XMI attributes [attrlist] of the classifier [kname] to attrmap and refmap
    using metamodel dictionary [mmdic]
*)
let attrs2attrmap_refmap (is_toplevel:bool) (mmdic:mm_dictionary option) (xmi_id_map: name NameMap.t)
    (kname:name) (attrlist:(name * string) list)  =
  (* if non-toplevel, extract kname from xsi:type *)
  let aname_value2x2d aname value =
    let _ = dprintf "aname_value2x2d: kname,aname,value = (%s,%s,%s)@." kname aname value in
    match mmdic with
      Some mmdic -> attr2x2d_attr_with_mm kname mmdic xmi_id_map aname value
    | None       -> attr2x2d_attr_without_mm xmi_id_map aname value in
  let insert_am_rm4attr (aname,value) (attrmap,refmap) =
    match aname with
      "xmi:id"   -> (NameMap.add aname ("String",SetofStr(SetofStr.singleton(value,None))) attrmap,refmap)
    | "xsi:type" -> (attrmap,refmap)  (* should coincide with kname *)
    | _ ->
	match (aname_value2x2d aname value) with
	  X2DRef (aname,tr_refs_list) ->
	    (* tr (classifier name) is discarded and replaced by XMI ID *)
	    let id_none_list = List.map (fun (tr,xmi_id)->(xmi_id,None,None)) tr_refs_list in
	    (attrmap,NameMap.add aname (NameVtxSet.fromList id_none_list) refmap)
	| X2DAttr(aname,prim_tag,value) ->
	    let nmtokens = split_nmtokens value in
	    let map_nmtokens of_string =
	      (List.map (fun s -> (of_string s, None)) nmtokens) in
	    let primset =
	      match prim_tag with
		"String" -> SetofStr(SetofStr.fromList (map_nmtokens              id))
	      | "Int"    -> SetofInt(SetofInt.fromList (map_nmtokens   int_of_string))
	      | "Float"  -> SetofFlt(SetofFlt.fromList (map_nmtokens float_of_string))
	      | "Boolean" ->SetofBol(SetofBol.fromList (map_nmtokens  bool_of_string))
	      | prim_tag -> failwith ("Unknown primitive type tag: " ^ prim_tag)  in
	    (NameMap.add aname (prim_tag,primset) attrmap,refmap)
  in
  List.fold_right insert_am_rm4attr attrlist (NameMap.empty,NameMap.empty)


(** 
  [elem2xmi_elements kname mmdic xmi_id_map elem]
  @param elem        xml element
  @param xmi_id_map  map from xmi:id to its value
  @return ((tag,xmi_id),map) where 
  tag is the tag name of the element, xmi_id is the value of attribute "xmi:id",
  and map is the map from xmi:id to xmi_element, including the entry produced
  by [elem]. *)
let rec elem2xmi_elements ?(kname:name option) (mmdic:(mm_dictionary option)) xmi_id_map (elem:xml)
   : ((name * name) * (xmi_element NameMap.t)) =
  (* mmdic is common, so do not pass around as arguments during recursive call *)
  let ((tag,attrlist,elemlist): (string * (name*string) list * xml list)) =
    match elem with
      Element (t,a,e) -> (t,a,e)
    | _ -> failwith "elem2xmi_elements: invalid element" in
  let (xsi_type,is_top) =
    match kname with
      None        -> (qname2localname tag,              true)
    | Some kname  -> (lookup_xsi_type ~tag:tag attrlist,false)
  (* because of object orientation in KM3, typeref may be abstract,
     so XMI may encode its concrete descendant. In this case, xsi:type 
     should exist, because nothing else can encode the concrete class.
     xsi:type and typeref naturally disagrees in this case, so no 
     error should be raised but xsi:type should be used for the encoding.
     Concrete example (in KM3.km3): 
	abstract class ModelElement extends LocatedElement {
		attribute name : String;
		reference "package" : Package oppositeOf contents;
	}
	class Package extends ModelElement {
	reference contents[*] ordered container : ModelElement oppositeOf "package";
        ... }
 *)
  in
  let (attrmap,refmap) = (attrs2attrmap_refmap is_top mmdic xmi_id_map xsi_type attrlist) in
  let (tag_xmi_id_list,xmi_element_map_list) = List.split (List.map (elem2xmi_elements ~kname:xsi_type mmdic xmi_id_map) elemlist) in
  let xmi_id = try (List.assoc "xmi:id" attrlist) with Not_found ->
    failwith "elem2xmi_elements: xmi:id is not found in the attribute list" in
  let childmap = List.fold_right (fun (tag,xmi_id) ->
    NameMap.uadd NameVtxSet.singleton NameVtxSet.add tag (xmi_id,None,None)) tag_xmi_id_list  NameMap.empty in
  ((tag,xmi_id),NameMap.add xmi_id {xe_kname=xsi_type;xe_is_top=is_top;attrmap=attrmap;refmap=refmap;childmap=childmap;xe_pivot=None} (NameMap.fromLMap xemuc xmi_element_map_list))
    
(** Convert XMI to ObjectGraph *)
let xmi2objectGraph mm xml : xmi_element NameMap.t =
  let mmdic = match mm with None -> None | Some mm -> Some (clean_mm_dictionary (make_mm_dictionary mm)) in
    let (toptag, top_attrlist, top_elemlist) =
    match xml with
      Element (t,a,e) -> (t,a,e)
    | PCData _        -> failwith "PCData on toplevel unexpected" in
  (* Remove idiomatic declaration to extract model elements namespace
  prefix declaration *)
  let is_decls = function
      ("xmi:version", _) | ("xmlns:xmi", _) | ("xmlns:xsi", _) -> true
    | _ -> false in
  let (decls,non_decls) = List.partition is_decls top_attrlist in
  let is_nsdecls (attr,_) = 
    is_qname attr && 
    (match (split_qname attr) with ("xmlns",_)->true | _ -> false) in
  let (namespace_prefix,package_name,top_elemlist) =
    let (qname_pname,data_attrlist) = List.partition is_nsdecls non_decls in
    (if List.length qname_pname = 1 then
      let (qualified_name, package_name) = List.nth qname_pname 0 in
      let (xmlns,namespace_prefix) = split_qname qualified_name in
      (namespace_prefix,package_name,
       if toptag="xmi:XMI" then 
	 (* There are more thatn one real top level element under "xmi:XMI" *)
	 top_elemlist 
       else
	 (* singleton real top level element comes at the top *)
	 [Element (toptag,data_attrlist,top_elemlist)])
    else
      failwith "supurious declaration or namespace prefix not found" ) in
  ignore namespace_prefix;
  let xmi_id_map = gen_xmi_id_map top_elemlist in
  let (tag_xmi_id_list,xmi_element_map_list) =
       List.split (List.map (fun elem -> elem2xmi_elements mmdic xmi_id_map elem) top_elemlist) in
  NameMap.fromLMap xemuc xmi_element_map_list

let nextvtx (origno:int) : (vtx*int) = (Bid origno,origno+1)

let vt_of_vto (vto:vto) (vtx_no:int) : ((vtx*vtx*vtx)*int) = 
    match vto with
      Some (v1,v2,v3) -> ((v1,v2,v3),vtx_no)
    | None            -> 
	let (v1,vtx_no) = nextvtx vtx_no in
	let (v2,vtx_no) = nextvtx vtx_no in
	let (v3,vtx_no) = nextvtx vtx_no in
	((v1,v2,v3),vtx_no)

let fill_set (type b) (type st) 
    (mst:(module Set.S with type elt = b * ObjectGraph.vto and type t = st)) 
    (s:st) (vtx_no:int) : (st * int) =
  let module S = (val mst : Set.S with type elt = (b * vto) and type t = st) in
  S.fold (fun (i,vto) (s,vtx_no) ->
    let (vt,vtx_no) = vt_of_vto vto vtx_no in
    S.add (i,Some vt) s,vtx_no) s (S.empty,vtx_no)


(* fill in omitted slots for vertices *)
let fill_vtx (m : xmi_element NameMap.t) (vtx_no:int) : (xmi_element NameMap.t*int) =
  let vtx_of_vtx_option (vtx_option:vtx option) (vtx_no:int) : (vtx*int) = 
    match vtx_option with
      Some vtx -> (vtx,vtx_no)
    | None     -> nextvtx vtx_no in
  let fill_primset (primset:primset) (vtx_no:int) : (primset*int) =
    match primset with
      SetofInt(s)-> let (s,vtx_no) = 
     (*	SetofInt.fold (fun (i,vto) (s,vtx_no) ->
	let (vt,vtx_no) = vt_of_vto vto vtx_no in
	SetofInt.add (i,Some vt) s,vtx_no) s (SetofInt.empty,vtx_no) *) 
	fill_set (module SetofInt : Set.S with type elt = (int*vto) and type t = SetofInt.t) s vtx_no
      in (SetofInt(s),vtx_no)
    | SetofStr(s)-> let (s,vtx_no) = 
	fill_set (module SetofStr : Set.S with type elt = (string*vto) and type t = SetofStr.t) s vtx_no
    in (SetofStr(s),vtx_no)
    | SetofFlt(s)-> let (s,vtx_no) = 
	fill_set (module SetofFlt : Set.S with type elt = (float*vto) and type t = SetofFlt.t) s vtx_no
    in (SetofFlt(s),vtx_no)
    | SetofBol(s)-> let (s,vtx_no) = 
	fill_set (module SetofBol : Set.S with type elt = (bool*vto) and type t = SetofBol.t) s vtx_no
    in (SetofBol(s),vtx_no) in
  let fill_attrmap (attrmap:attrmap) (vtx_no:int) : (attrmap*int) =
    NameMap.fold (fun aname (kname,primset) (am,vtx_no) ->
      let (primset,vtx_no) = fill_primset primset vtx_no in
      (NameMap.add aname (kname,primset) am,vtx_no)) attrmap (NameMap.empty,vtx_no) in
  let fill_childmap_refmap (map: (NameVtxSet.t NameMap.t)) (vtx_no:int) : ((NameVtxSet.t NameMap.t)*int) = 
    NameMap.fold (fun fname nm_vtx_set  (m,vtx_no) ->
      let (nm_vtx_set,vtx_no) = 
	NameVtxSet.fold (fun ((tr:name),vtx_option,vtx_option') (nvS,vtx_no)->
	  let (dst,vtx_no) = vtx_of_vtx_option vtx_option vtx_no in
	  (NameVtxSet.add (tr,Some dst,vtx_option') nvS,vtx_no)) nm_vtx_set (NameVtxSet.empty,vtx_no) in
      (NameMap.add fname nm_vtx_set m,vtx_no)) map (NameMap.empty,vtx_no) in
  NameMap.fold (fun xmi_id ({attrmap=attrmap;refmap=refmap;childmap=childmap;xe_pivot=vtx_option} as xe) (m,vtx_no) ->
    let (pivot,vtx_no) = vtx_of_vtx_option vtx_option vtx_no in
    let (attrmap, vtx_no) = fill_attrmap         attrmap  vtx_no in
    let (refmap,  vtx_no) = fill_childmap_refmap refmap   vtx_no in
    let (childmap,vtx_no) = fill_childmap_refmap childmap vtx_no in
    (NameMap.add xmi_id ({xe with attrmap=attrmap;refmap=refmap;childmap=childmap;xe_pivot=Some pivot}) m,vtx_no)) m (NameMap.empty,vtx_no)
    
let a_of_option (a_option : 'a option) : 'a   =
  match a_option with Some a -> a | None -> failwith "a_of_option: None"

let allbl_of_int i    = ALInt i
let allbl_of_string s = ALStr s
let allbl_of_float f  = ALFlt f
let allbl_of_bool b   = ALBol b
(** @param m      input object graph
    @param root   root node
    @param vtx_no starting number of node IDs *)
let objectGraph2g (m : xmi_element NameMap.t) (root : vtx) (vtx_no : int) : graph =
  let primset2g (pivot:vtx) (aname:name) (primset:primset) : graph =
   let aname = (* escape xmi:id *) if aname="xmi:id" then (* "xmi_id" *) "__xmiID__" else aname in
  let primset_type_sng kname allbl_of_type (x,vto) = 
    let (v1,v2,v3) = a_of_option vto in
    {emptyGraph with
     v = SetofVtx.fromList [v1;v2;v3];
     e = SetofEdge.fromList [
     (pivot,(ALLbl aname),v1);
     (v1,(ALLbl kname),v2);
     (v2,(allbl_of_type x), v3)];} in
    match primset with
      SetofInt(s)-> SetofInt.hom evalg_simple_union emptyGraph 
	  (primset_type_sng "Integer" allbl_of_int) s 
    | SetofStr(s)-> SetofStr.hom evalg_simple_union emptyGraph
	  (primset_type_sng "String"  allbl_of_string) s 
    | SetofFlt(s)-> SetofFlt.hom evalg_simple_union emptyGraph
	  (primset_type_sng "Float" allbl_of_float)  s
    | SetofBol(s)-> SetofBol.hom evalg_simple_union emptyGraph
	  (primset_type_sng "Boolean"  allbl_of_bool) s  in
  let attrmap2g (attrmap:attrmap) (pivot:vtx)  =
    NameMap.fold (fun aname (kname,primset) ->
      let g_primset = primset2g pivot aname primset in
      evalg_simple_union g_primset) attrmap emptyGraph in
  (* graph generated by childmap/refmap needs target vtx filled *)
  (* starting with zero? *)
  let (m,vtx_no) = fill_vtx m vtx_no in
  let childmap_refmap2g (map: (NameVtxSet.t NameMap.t)) (pivot:vtx) : graph =
    NameMap.fold (fun fname xmi_id_vtx_option_set ->
      let nameVtxSet_g = NameVtxSet.fold (fun  (xmi_id,vtx_option,_) ->
	let dest = a_of_option vtx_option in
	let (kname,tgt_pivot_option) = match (NameMap.find_some xmi_id m) with
	  Some {xe_kname=kname;xe_pivot=pivot_option} -> kname,pivot_option
	| None -> failwith ("childmap_refmap2g: xmi_id " ^ xmi_id ^ " not found") in
	let tgt_pivot = a_of_option tgt_pivot_option in
	evalg_simple_union {emptyGraph with 
			    v = SetofVtx.singleton dest;
			    e = SetofEdge.fromList [
			    (pivot,ALLbl fname,dest);
			    (dest, ALLbl kname,tgt_pivot)]}) xmi_id_vtx_option_set emptyGraph in
      evalg_simple_union nameVtxSet_g) map emptyGraph in
  let g = NameMap.fold (fun xmi_id {xe_kname=kname;xe_is_top=is_top;attrmap=attrmap;refmap=refmap;childmap=childmap;xe_pivot=vtx_option} ->
    let pivot = a_of_option vtx_option in
    evalg_simple_union 
      (evalg_simple_union 
	 (evalg_simple_union (attrmap2g attrmap pivot) {emptyGraph with v=SetofVtx.singleton pivot})
	 (evalg_simple_union (childmap_refmap2g refmap pivot)
	    (evalg_simple_union (childmap_refmap2g childmap pivot)
	       (if is_top then {emptyGraph with
				e=SetofEdge.singleton (root,ALLbl kname,pivot)} 
	       else emptyGraph))))) m emptyGraph in
  {g with v=SetofVtx.add root g.v;
          i=SetofInodeR.singleton ("&",root);
          o=SetofOnodeR.empty}

let lookup_xmi_id_from_attrmap (attrmap:attrmap) : string = 
  let primset = match (NameMap.find_some "xmi:id" attrmap)
  with Some (_,primset) -> primset | None -> failwith "lookup_xmi_id_from_attrmap: xmi:id attribute not found" in
  match primset with
    SetofStr(s) ->
      (match SetofStr.cardinal s with
	1 -> let (xmi_id,_) = SetofStr.choose s in xmi_id
      | _ -> failwith "lookup_xmi_id_from_attrmap: non-singleton xmi_id")
  | _ -> failwith "lookup_xmi_id_from_attrmap: non-string xmi_id"

let vtx_map_to_xmi_id_map (m:xmi_element VMap.t) =
  let m = VMap.map (fun xmi_element ->
    let attrmap = NameMap.endomap_kv (fun aname -> if aname=(* "xmi_id" *) "__xmiID__" then "xmi:id" else aname) id xmi_element.attrmap in
    {xmi_element with attrmap=attrmap}) m in
  VMap.fold (fun vtx xmi_element ->
    let xmi_id = lookup_xmi_id_from_attrmap xmi_element.attrmap in
    let amend_map = NameMap.mapi (fun aname name_vtx_set ->
      NameVtxSet.map (fun (kname,vtx_option',vtx_option) ->
	let tgt_vtx = a_of_option vtx_option in
	let tgt_xmi_element = match (VMap.find_some tgt_vtx m) with Some e -> e | None -> failwith "ammend_map: pointed element not found" in
	let tgt_xmi_id = lookup_xmi_id_from_attrmap tgt_xmi_element.attrmap in
	(tgt_xmi_id,vtx_option',vtx_option)) name_vtx_set) in
    NameMap.add xmi_id {xmi_element with refmap=amend_map xmi_element.refmap;childmap=amend_map xmi_element.childmap;}
    ) m NameMap.empty


let put_primset orig_primset xmi_primset vtx_no = 
  match (orig_primset,xmi_primset) with 
    SetofInt(s),SetofInt(s') ->
      (match (SetofInt.cardinal s,SetofInt.cardinal s') with 
	(1,1) -> let ((str,vto),(str',_)) = (SetofInt.choose s,SetofInt.choose s') in 
	(SetofInt(SetofInt.singleton (str',vto)),vtx_no)
      | _     -> failwith "put_primset: non-singleton or cardinality changed")
  | SetofStr(s),SetofStr(s') -> 
      (match (SetofStr.cardinal s,SetofStr.cardinal s') with 
	(1,1) -> let ((str,vto),(str',_)) = (SetofStr.choose s,SetofStr.choose s') in 
	(SetofStr(SetofStr.singleton (str',vto)),vtx_no)
      | _     -> failwith "put_primset: non-singleton or cardinality changed")
  | SetofFlt(s),SetofFlt(s') -> 
      (match (SetofFlt.cardinal s,SetofFlt.cardinal s') with 
	(1,1) -> let ((str,vto),(str',_)) = (SetofFlt.choose s,SetofFlt.choose s') in 
	(SetofFlt(SetofFlt.singleton (str',vto)),vtx_no)
      | _     -> failwith "put_primset: non-singleton or cardinality changed")
  | SetofBol(s),SetofBol(s') -> 
      (match (SetofBol.cardinal s,SetofBol.cardinal s') with 
	(1,1) -> let ((str,vto),(str',_)) = (SetofBol.choose s,SetofBol.choose s') in 
	(SetofBol(SetofBol.singleton (str',vto)),vtx_no)
      | _     -> failwith "put_primset: non-singleton or cardinality changed")
  | _ -> failwith "put_primset: unmatched type"


(* FIXME: Only in-place updates are supported at present *)
let put_attrmap (orig_attrmap:attrmap) (xmi_attrmap:attrmap) (vtx_no:int) : attrmap =
  let cc x y = true in (* consistency checker always returns true, 
			  treating bindings with identical key identical  *)
  let inter_m = NameMap.inter cc orig_attrmap xmi_attrmap in
  let added_m = NameMap.diff  cc xmi_attrmap orig_attrmap in
  let del_m   = NameMap.diff  cc orig_attrmap xmi_attrmap in
  let (inter_m,_) = NameMap.fold (fun aname (kname,primset) (am,vtx_no) ->
    let (_,orig_primset) = NameMap.find aname orig_attrmap in
    let (_,xmi_primset)  = NameMap.find aname  xmi_attrmap in
    let (primset,vtx_no) = put_primset orig_primset xmi_primset vtx_no in
    (NameMap.add aname (kname,primset) am,vtx_no)) inter_m (NameMap.empty,vtx_no) in
  NameMap.diff cc (NameMap.union cc inter_m added_m) del_m
  
(* merge xmi_objectGraph with orig_objectGraph, by 
   1. Allocating new node ID for inserted elements
   2. Allocating new node ID for inserted references in existing elements
   *)
(* FIXME: Only in-place updates for attributes are supported *)
let put (orig_objectGraph:xmi_element NameMap.t) (xmi_objectGraph:xmi_element NameMap.t) : xmi_element NameMap.t =
  let cc x y = true in (* consistency checker always returns true, 
			  treating bindings with identical key identical  *)
  let inter_m = NameMap.inter cc orig_objectGraph xmi_objectGraph in
  let added_m = NameMap.diff  cc xmi_objectGraph orig_objectGraph in
  let del_m   = NameMap.diff  cc orig_objectGraph xmi_objectGraph in
  (* check in-place updates *)
  let inter_m = NameMap.mapi (fun xmi_id xmi_element ->
    let orig_xmi_element = NameMap.find xmi_id orig_objectGraph in
    let xmi_xmi_element  = NameMap.find xmi_id xmi_objectGraph in
    let {attrmap=orig_attrmap; refmap = orig_refmap; childmap=orig_childmap;} = orig_xmi_element in
    let {attrmap=xmi_attrmap; refmap = xmi_refmap; childmap=xmi_childmap;} = xmi_xmi_element in
    {orig_xmi_element with attrmap=put_attrmap orig_attrmap xmi_attrmap 2000000}
    ) inter_m in
  let (added_m,_) = fill_vtx added_m 1000000 (* tentative *) in
  NameMap.diff cc (NameMap.union cc inter_m added_m) del_m
  
(** 
   [xmi2dot orig_dot_file pname km3_file validate_flag xmi_file  dot_file]
   converts XMI file [xmi_file] to dot file [dot_file] via object graph.
   No UnCAL expression is involved.
   Node IDs in [orig_dot_file] is used if provided, or node id starts from
   zero otherwise. *)
let xmi2dot (orig_dot_file:string option) pname km3_file (validate_flag:bool) (xmi_file:string)  (dot_file:string) =
  let xml = Xml.parse_file xmi_file in
  let km3 = match km3_file with None -> None | Some km3_file -> Some (parseKm3_file km3_file) in
  (* let g = xmi2g km3 xml in *)
  let xmi_objectGraph = xmi2objectGraph km3 xml in
  let g = match orig_dot_file with
    None -> (* create mode *)  objectGraph2g xmi_objectGraph (Bid 0) 1
  | Some orig_dot_file -> (* backward mode *)
      (*
	Backward transformation from XMI to DOT using original DOT file:
	1. Generate object graph from original UnCAL graph.
	2. Convert the object graph to map from xmi:id to xmi_element.
	3. Generate object graph from XMI.
	4. Compare object graphs from 1 and 3 to produce updated DOT file.
       *)
      let orig_dot = TestUnCALutil.parseDot_file orig_dot_file in
      let orig_g   = dot2g orig_dot in
      let (root,m) = 
	let (pname,km3) = match (pname,km3) with (Some pname,Some km3) -> (pname,km3) | _ -> failwith "xmi2dot: backward transformation needs KM3 metamodel" in
	G2objectGraph.g2vtx2xmi_element_Map orig_g pname km3 in
      let orig_objectGraph = vtx_map_to_xmi_id_map m in
      let updated_objectGraph = put orig_objectGraph xmi_objectGraph in
      objectGraph2g updated_objectGraph root 100000 (* tentative *) in
  if validate_flag then
    (match (pname,km3) with
      (Some pname,Some km3) -> validate_and_print "Output validation" true g pname km3
    | _ -> ());
  let dot = g2dot g in
  dumpDot dot dot_file

