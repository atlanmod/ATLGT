open Km3util
open Km3
open Fputil
open UnCALDM
open UnCALDMutil
open PrintUnCALDM
open Xml
open Format
open Print
open PrintKm3
open TestUnCALutil
open Dotutil
open ObjectGraph
open G2objectGraph

let pp_triple pp_a pp_b pp_c fmt (x,y,z) =
  fprintf fmt "@[<1>(%a,@,%a,@,%a)@]" pp_a x pp_b y pp_c z
let pp_NameVtxOption = pp_triple pp_name (pp_option pp_vtx) (pp_option pp_vtx)
let pp_NameVtxOptionSet = NameVtxSet.pp_t "" pp_NameVtxOption
let pp_NameVtxOptionSetMap = NameMap.pp_t "" pp_name pp_NameVtxOptionSet
let pp_childmap = pp_NameVtxOptionSetMap
let pp_refmap = pp_NameVtxOptionSetMap
let pp_float fmt = fprintf fmt "%f"
let pp_vto = (pp_option (pp_triple pp_vtx pp_vtx pp_vtx))
let pp_primset fmt x = match x with
    SetofInt iset -> fprintf fmt "SetofInt %a" (SetofInt.pp_t "" (pp_pair pp_int    pp_vto)) iset
  | SetofStr sset -> fprintf fmt "SetofStr %a" (SetofStr.pp_t "" (pp_pair pp_string pp_vto)) sset
  | SetofFlt fset -> fprintf fmt "SetofFlt %a" (SetofFlt.pp_t "" (pp_pair pp_float  pp_vto)) fset
  | SetofBol bset -> fprintf fmt "SetofBol %a" (SetofBol.pp_t "" (pp_pair pp_bool   pp_vto)) bset
let pp_attrmap = NameMap.pp_t "" pp_name (pp_pair pp_name pp_primset)

let pp_xmi_element fmt (name,attrmap,refmap,childmap) = 
  fprintf fmt "@[<1>(%a,@,%a,@,%a,@,%a)@]" pp_name name pp_attrmap attrmap pp_refmap refmap pp_childmap childmap

let pp_vtx2xmi_element_Map = VMap.pp_t "" pp_vtx pp_xmi_element

(*
   {Bid(39) => ("Attribute",
     {"multiValued" => ("Boolean",SetofBol {false});"name" => ("String",SetofStr {"name"})},
     {"owner" => {("Class",Bid(47))}; "type" => {("DataType",Bid(49))}},{});
    Bid(40) => ("Attribute",
     {"multiValued" => ("Boolean",SetofBol {true});"name" => ("String",SetofStr {"members"})},
     {"owner" => {("Class",Bid(47))}; "type" => {("Class",Bid(48))}},{});
    Bid(41) => ("Attribute",
     {"multiValued" => ("Boolean",SetofBol {false});"name" => ("String",SetofStr {"firstName"})},
     {"owner" => {("Class",Bid(48))}; "type" => {("DataType",Bid(49))}},{});
    Bid(42) => ("Attribute",{"multiValued" => ("Boolean",SetofBol {false});
"name" => ("String",SetofStr {"family"})},{"owner" => {("Class",Bid(48))}; "type" => {("Class",Bid(47))}},{});
    Bid(47) => ("Class",
     {"isAbstract" => ("Boolean",SetofBol {false});"name" => ("String",SetofStr {"Family"})},
     {"super" => {}},
     {"attr" => {("Attribute",Bid(39)),("Attribute",Bid(40))}});
    Bid(48) => ("Class",
     {"isAbstract" => ("Boolean",SetofBol {false});"name" => ("String",SetofStr {"Person"})},
     {"super" => {}},
     {"attr" => {("Attribute",Bid(41)),("Attribute",Bid(42))}});
    Bid(49) => ("DataType",
     {"name" => ("String",SetofStr {"String"})},{},{})}
*)

(* top-level only graph test  *)

(* generate xmi file *)
let g2xmi (g:graph) (pname:name) (mm:metamodel) =
  let (_,mapV,_) = clean_id_aux g in
  (* let vtx2id vtx = string_of pr_vtx vtx in *)
  let (root,m) = g2vtx2xmi_element_Map g pname mm in
  let vtx2id vtx = 
    let n = match (MapofVtx.find vtx mapV) with Bid n -> n | _ -> failwith "g2xmi: invalid node ID" in 
    string_of_int n in
  let fix_xmi_id = function
     (* "xmi_id" *) "__xmiID__" -> "xmi:id"
    | s        -> s in
  let m = VMap.map (fun xmi_element ->
    {xmi_element with attrmap=NameMap.endomap_kv fix_xmi_id id xmi_element.attrmap})  m in
  (* starting point is a set of top-level nodes *)
  let top_vs = imageVS g root in
  let pp_string fmt = fprintf fmt "%s" in
  let ppr_primset fmt x = match x with
    SetofInt iset -> fprintf fmt "%a" (pr_seq " " pp_int)    (List.map fst (SetofInt.elements iset))
  | SetofStr sset -> fprintf fmt "%a" (pr_seq " " pp_string) (List.map fst (SetofStr.elements sset))
  | SetofFlt fset -> fprintf fmt "%a" (pr_seq " " pp_float)  (List.map fst (SetofFlt.elements fset))
  | SetofBol bset -> fprintf fmt "%a" (pr_seq " " pp_bool)   (List.map fst (SetofBol.elements bset)) in
  let attrmap2attrlist attrmap =
    NameMap.fold (fun fname (tname,primset) xs ->
      let s_primset = string_of ppr_primset primset in
      (fname,s_primset)::xs)  attrmap [] in
  let vtx_of_vtx_option : vtx option -> vtx = function
      Some vtx -> vtx | None -> failwith "vtx_of_vtx_option: no value" in
  let refmap2attrlist refmap =
    NameMap.fold (fun fname nameVtxSet xs ->
      (NameVtxSet.fold (fun (tname,_,vtx_option) xs ->
	let vtx = vtx_of_vtx_option vtx_option in
	let {attrmap=attrmap} = VMap.find vtx m in
	(* As the target of the reference, reuse the xmi:id attribute 
	   if exists, otherwise, generate by node id. *)
	let refval =
	  if NameMap.mem "xmi:id" attrmap 
	  then string_of ppr_primset (snd (NameMap.find "xmi:id" attrmap))
	  else vtx2id vtx in
        (fname,refval)::xs) nameVtxSet [])
       @xs) refmap [] in
  let rec childmap2xml childmap = 
    NameMap.fold (fun fname nameVtxSet xs ->
      (NameVtxSet.fold (fun (tname,_,vtx_option) xs ->
	 let vtx = vtx_of_vtx_option vtx_option in
         let xmi_element = VMap.find vtx m in
	 let {xe_kname=kname;attrmap=attrmap;refmap=refmap;childmap=childmap} = xmi_element in
	 let attrmap = (* complement type information with xsi:type attribute *)
	   if NameMap.mem "xsi:type" attrmap then attrmap else 
	      NameMap.add "xsi:type" ("String",SetofStr(SetofStr.singleton (pname ^ ":" ^ kname,None)))  attrmap in
	 (xmi_element2xml vtx (fname,attrmap,refmap,childmap))::xs) nameVtxSet [])
       @xs) childmap []
  and xmi_element2xml v (name,attrmap,refmap,childmap) =
    (* As for the xmi:id, don't regenerate if already exists,
       otherwise generate by node id. *)
    let xmi_id_attrlist = 
      if NameMap.mem "xmi:id" attrmap then [] else [("xmi:id",vtx2id v)] in
    Xml.Element (name,xmi_id_attrlist@(attrmap2attrlist attrmap)@(refmap2attrlist refmap),childmap2xml childmap) in
  let top_children =
  SetofVtx.fold (fun v xs ->
    let xmi_element = VMap.find v m in
    let {xe_kname=name;attrmap=attrmap;refmap=refmap;childmap=childmap} = xmi_element in
    let xmi_element = (pname ^":" ^name,attrmap,refmap,childmap) in
    (xmi_element2xml v xmi_element)::xs
  ) top_vs [] in
  Xml.Element ("xmi:XMI",[("xmi:version", "2.0"); ("xmlns:xmi", "http://www.omg.org/XMI");
			  ("xmlns:xsi", "http://www.w3.org/2001/XMLSchema-instance"); 
			  ("xmlns:" ^ pname, pname)],
	       top_children)

let parseKm3_file = Parse.parse_file ~parse:ParseKm3.entry ~lex:LexKm3.token 

let dot2xmi (dot_file:string) (km3_file:string) (pname:name) (xmi_file:string) =
  let dot = parseDot_file dot_file in
  let km3 = parseKm3_file km3_file in
  let g = dot2g dot in
  let xmi = g2xmi g pname km3 in
  let oc = open_out xmi_file in
  let fmt = Format.formatter_of_out_channel oc in
  let xmldecl="<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>" in
  fprintf fmt "%s\n%s@." xmldecl (Xml.to_string_fmt xmi);
  close_out oc
