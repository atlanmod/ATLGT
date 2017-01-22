open Km3util
open Km3
open ExtSetMap
open Fputil
open UnCALDM
open UnCALDMutil
open Format
open Print
open TestUnCALutil
open Dotutil
open ObjectGraph
open G2objectGraph

(* render graph that conforms to a given KM3 metamodel as a diagram *)

let pp_float fmt = fprintf fmt "%f"
let parseKm3_file = Parse.parse_file ~parse:ParseKm3.entry ~lex:LexKm3.token 

let g2dot_diagram (g:graph) (pname:name) (mm:metamodel) (dot_file:string) : unit =
  let (_,mapV,_) = clean_id_aux g in
  let vtx2id vtx = 
    let n = match (MapofVtx.find vtx mapV) with Bid n -> n | _ -> failwith "g2dot_diagram: invalid node structure" in 
    string_of_int n in
  (* let vtx2id vtx = string_of pr_vtx vtx in *)
  let (root,m) = g2vtx2xmi_element_Map g pname mm in
  let pp_string fmt = fprintf fmt "\\\"%s\\\"" in
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
  let refmap2edge_list v_src refmap =
    (* convert refmap to list of triple representing edge: (src,label,dst) *)
    let src_id = vtx2id v_src in
    NameMap.fold (fun fname nameVtxSet xs ->
      (NameVtxSet.fold (fun (tname,_,vtx_option) xs ->
	  let vtx = vtx_of_vtx_option vtx_option in  
         (src_id,fname,vtx2id vtx)::xs) nameVtxSet [])
       @xs) refmap [] in
  let childmap2edge_list v_src childmap = 
    let src_id = vtx2id v_src in
    (* convert childmap to list of triple representing edge: (src,lalebl,dst)a  *)
    NameMap.fold (fun fname nameVtxSet xs ->
      (NameVtxSet.fold (fun (tname,_,vtx_option) xs ->
        let vtx = vtx_of_vtx_option vtx_option in  
        (src_id,fname,vtx2id vtx)::xs) nameVtxSet [])
       @xs) childmap [] in
  let pp_xmi_vtx_element fmt ((v:vtx),({xe_kname=name;xe_is_top=is_top;attrmap=attrmap;refmap=refmap;childmap=childmap;xe_pivot=rootvtx_opt}:xmi_element)) =
    (**** emit node *****)
    fprintf fmt "%S [ label=\"{" (vtx2id v);
      (* emit record element for name *)
      fprintf fmt "%s" name;
      (* emit record elements for attributes *)
      List.iter (fun (aname,avalue) ->
	fprintf fmt "|%s=%s" aname avalue
      )  (attrmap2attrlist attrmap);
    fprintf fmt "}\" ]\n";
    (**** emit edges for references ****)
    List.iter (fun (src,lbl,dst) ->
       fprintf fmt "%S -> %S [ label = %S ]\n" src dst lbl;
     ) (refmap2edge_list v refmap);
    (**** emit edges for children ****)
    List.iter (fun (src,lbl,dst) ->
       fprintf fmt "%S -> %S [ label = %S ]\n" src dst lbl;
     ) (childmap2edge_list v childmap) in
  let oc = open_out dot_file in
  let fmt = Format.formatter_of_out_channel oc in
  fprintf fmt "@[<hov 4>digraph \"element_diagram\" {@;";
  fprintf fmt "node [ shape=record ]@.";
  VMap.iter (fun v (xmi_element:xmi_element) ->
     fprintf fmt "%a" pp_xmi_vtx_element (v,xmi_element);
   ) m;
  fprintf fmt "@]@\n}@.";
  close_out oc

let dot2dot_diagram (dot_file:string) (km3_file:string) (pname:name) (target_dot_file:string) =
  let dot = parseDot_file dot_file in
  let km3 = parseKm3_file km3_file in
  let g = dot2g dot in
  g2dot_diagram g pname km3 target_dot_file
