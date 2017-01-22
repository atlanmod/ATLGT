(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
(* graph visualization *)
(* TODO: Render graphs that has no edge. Currently, {} is not rendered as you expect. -> DONE *)

open Format
open Fputil
open UnCAL
open PrintUnCAL
open UnCALDM
open UnCALDMutil
open Dot

let markerLists2attr_strForElliptic nlstr iml oml : string =
  let ppr_marker ppf m = fprintf ppf "%s" m in
  let pr_ListofMarkerForElliptic ppf mL = 
    fprintf ppf "{@[%a@]}" (pr_list ppr_marker) mL in
  let (ims,oms) = mapT2 (toStr pr_ListofMarkerForElliptic) (iml,oml) in
  let ims = if (ims <> "{}") then ims ^ "\\n" else "" in
  let oms = if (oms <> "{}") then "\\n" ^ oms else "" in
  let ls = "\"" ^ ims ^ nlstr ^ oms ^ "\"" in
  fprintf str_formatter "label = %s" ls;flush_str_formatter ()

let g2dot_file_light ?(noclean=false) ?(expnl=false) (g:graph) (file:string) =
  let g = if noclean then g else clean_id g in
  let marker2str (m:marker) = m in
  let allit2str = function
      ALLbl (l) -> l
    | ALStr (s) -> "\"" ^ s ^ "\""
    | ALInt (i) -> string_of_int i
    | ALFlt (f) -> string_of_float f
    | ALBol (b) -> string_of_bool b
    | ALUkn     -> "?"
    | ALEps     -> "!"
  in  

  let rec skolemV2str = function
      Bid i        -> string_of_int i
    | S1 (v,x)     -> "S1(" ^ skolemV2str v ^ "," ^ marker2str x  ^ ")"
    | S2 (u,a,v,w) -> "S2(" ^ skolemV2str u ^ "," ^ allit2str a ^ "," ^ 
      skolemV2str v ^ "," ^ skolemV2str w ^ ")"
    | Hub (v,x,i)  -> "Hub(" ^ skolemV2str v ^ "," ^ marker2str x ^ "," ^ string_of_int i ^ ")"
    | FrE (v,e,i)  -> "FrE(" ^ skolemV2str v ^ "," ^ edge2str   e ^ "," ^ string_of_int i ^ ")"
    | InT (i)      -> "InT(" ^ string_of_int i ^ ")"
    | ImT (i,x)    -> "ImT(" ^ string_of_int i ^ "," ^ marker2str x ^ ")"
    | IaT (i,v)    -> "IaT(" ^ string_of_int i ^ "," ^ skolemV2str v ^ ")"
  and edge2str ((u,a,v):edge) = "(" ^ skolemV2str u ^ "," ^ allit2str a ^ "," ^ skolemV2str v ^ ")"
  in
  let vtx2nid v = 
    let is = skolemV2str v in
    fprintf str_formatter "%S" is;flush_str_formatter () in
  let vtx2str v =
    let is = skolemV2str v in
    let pm = markersV g v in
    let (iml,oml) = mapT2 SetofMarker.elements pm (* pair of list of markers *) in
    let nlstr = if expnl 
      then let unquote str = String.sub str 1 (String.length str-2) in unquote (vtx2nid v) 
      else "\\N" in
    let attr_str = markerLists2attr_strForElliptic nlstr iml oml in
    fprintf str_formatter "%S [ %s ]" is attr_str;flush_str_formatter ()  in
  let edge2rule ((u,a,v):edge) =
  let allit2str = function
    | ALStr (s) -> "\\\"" ^ s ^ "\\\""
    | l         -> allit2str l
    in 
    vtx2nid  u ^ " -> " ^ vtx2nid v ^ " [label = \"" ^ allit2str a ^ "\"]" 
  in 
  let oc = open_out file in
  Printf.fprintf oc "digraph \"test\" {\n";
  Printf.fprintf oc "  %s" 
    (String.concat "\n  " 
       ((List.map vtx2str (SetofVtx.elements g.v))
	@ (List.map edge2rule (SetofEdge.elements g.e))));
  Printf.fprintf oc "\n}\n";
  close_out oc

let dotf2imagef (format:string) (dot_file:string) (image_file:string) : unit = 
  let com = "dot -T" ^ format ^ " -o " ^ image_file ^ " " ^ dot_file in
  let status = gtm_command com in 
  if status <> 0 then failwith ("command " ^ com ^ " failed.")

(*
let dotf2pngf (dot_file:string) (png_file:string) : unit = 
  let com = "dot -Tpng -o " ^ png_file ^ " " ^ dot_file in
  let status = Sys.command com in 
  if status <> 0 then failwith ("command " ^ com ^ " failed.")
*)

let dotf2pngf = dotf2imagef "png"


(* remove_dot_file: If set to false, dot file as an intermediate result is left.
   dot_file:        Used for intermediate dot file. if unspecified or set to empty string,
                    temporary file name is used. *)
let g2png_light ?(remove_dot_file = true) ?(dot_file = "") (g:graph) (png_file:string) : unit = 
  let dot_file = if (dot_file = "") then gtm_temp_file "g2png_light" ".dot" else dot_file in
  let _ = g2dot_file_light g dot_file in
  let _ = dotf2pngf dot_file png_file in
  if remove_dot_file then
    Sys.remove dot_file

let pr_stmt_list pr_elem ppf lst =
  let v = ref lst in
  while (!v <> [])
  do
    fprintf ppf "%a" pr_elem (List.hd (!v));
    v := (List.tl (!v));
    if (!v <> []) then fprintf ppf "@\n" 
  done

let pr_attr_list = pr_stmt_list

let node_id2str i =  "\"" ^ "n" ^ (string_of_int i) ^ "\""

let check_elabel al : unit = 
  let is_elabel = function
      DELabel _ -> true
    | _         -> false  in
  if (not (List.exists is_elabel al)) then failwith "check_elabel: not found"

let check_nlabel al : unit =
  let is_nlabel = function
      DNLabel _ -> true
    | _         -> false in
  if (not (List.exists is_nlabel al)) then failwith "check_nlabel: not found"

let shape2str : shape -> string = function
  | `ellipse -> "ellipse" 
  | `plaintext -> "plaintext"
  | `point -> "point"
  | `record -> "record"

(* print dot in reloadable dot file format *)
(* aux functions *)
let ppr_marker = 
  if Sys.os_type="Win32" || Sys.os_type = "Cygwin"
  then (fun ppf m -> fprintf ppf "&%s" m)
  else (fun ppf m -> fprintf ppf "%s" m)

let allit2str = function
    ALLbl (l) -> l
  | ALStr (s) -> "\\\"" ^ s ^ "\\\"" (*  "\"" ^ s ^ "\"" *) 
  | ALInt (i) -> string_of_int   i
  | ALFlt (f) -> string_of_float f
  | ALBol (b) -> string_of_bool  b
  | ALUkn     -> "?"
  | ALEps     -> "!"                
let pp_allit fmt (lit:allit) = let s = allit2str lit in fprintf fmt "%s" s

let rec pp_skolemV fmt = function
  | Bid i        -> fprintf fmt "%i" i
  | S1 (v,x)     -> fprintf fmt "S1(%a,%a)" pp_skolemV v ppr_marker x
  | S2 (u,a,v,w) -> fprintf fmt "S2(%a,%a,%a,%a)" pp_skolemV u pp_allit a pp_skolemV v pp_skolemV w 
  | Hub (v,x,i)  -> fprintf fmt "Hub(%a,%a,%i)" pp_skolemV v ppr_marker x i 
  | FrE (v,e,i)  -> fprintf fmt "FrE(%a,%a,%i)" pp_skolemV v pp_edge    e i
  | InT (i)      -> fprintf fmt "InT(%i)" i
  | ImT (i,x)    -> fprintf fmt "ImT (%i,%a)" i ppr_marker x
  | IaT (i,v)    -> fprintf fmt "IaT (%i,%a)" i pp_skolemV v
and pp_edge fmt (u,a,v) = fprintf fmt "(%a,%a,%a)"  pp_skolemV u pp_allit a pp_skolemV v

(* main function *)
(* print sequence with delimiter "delim" in-between *)
(* altough statements and attribute equations can be delimited
   by ';' and ',' respectively, dotty do not use them.
   To keep dot file reloadable after editing with dotty we align 
   with format emitted by dotty *)
(* prefix_n : prepend "n" to node id to align to dotty *)
let pp_dot ?(shape=`record) ?(prefix_n = false)
    ?(expnl = false) ?(is_uncal=true) fmt (d:dot) = 
  let node_prefix = if prefix_n then "n" else "" in
  let pr_ListofMarker ppf mL =
    fprintf ppf "@[%a@]" (pr_list ppr_marker) mL in
  let pp_attr_value fmt attr_value = fprintf fmt "%S" attr_value in
  let pp_DAttr fmt ((st,attr_val): string*attr_value) =
    fprintf fmt "%s@ = %a" st pp_attr_value attr_val in
  let pp_DNLabel nlstr = match shape with
    | `record ->
        (fun fmt iml oml ->
           fprintf fmt "label@ = \"{%a|%s|%a}\""
             pr_ListofMarker iml nlstr pr_ListofMarker oml)
    | `ellipse | `plaintext | `point ->
        (fun fmt iml oml ->
           fprintf fmt "%s" (markerLists2attr_strForElliptic nlstr iml oml)) in
  let pp_node_attr ?(nlstr="\\N") fmt = function
    | DAttr (str, attr_val) -> fprintf fmt "%a" pp_DAttr (str,attr_val)
    | DELabel _ -> failwith "DElabel in node attr"
    | DNLabel (iml,oml) -> pp_DNLabel nlstr fmt iml oml in
  let pp_DANode fmt attrlist =
    fprintf fmt "node @[<2>[@;%a@;]@]" (pr_attr_list pp_node_attr) attrlist in
  let pp_edge_attr fmt = function
    | DAttr (str, attr_val) -> pp_DAttr fmt (str,attr_val)
    | DNLabel _ -> failwith "DNLabel in edge attr"
    | DELabel a -> let s = allit2str a in fprintf fmt "label@ = \"%s\"" s in
  let pp_DAEdge fmt attrlist =
    fprintf fmt "edge @[<2>[@;%a@;]@]" (pr_attr_list pp_edge_attr) attrlist in
  let pp_graph_attr fmt = function
      DAttr (str, attr_val) -> pp_DAttr fmt (str,attr_val)
    | DNLabel _ -> failwith "DNLabel in edge attr"
    | DELabel _ -> failwith "DELabel in graph attr" in
  let pp_DAGraph fmt attrlist = 
    fprintf fmt "graph @[<2>[@;%a@;]@]" (pr_attr_list pp_graph_attr) attrlist in
  let pp_node_id fmt (nid:dot_id) = match nid with
    | DRaw s -> fprintf fmt "%s" s
    | DVtx(Bid i) -> let s = (node_prefix ^ (string_of_int i)) in fprintf fmt "%S" s
    | DVtx vtx -> 
        fprintf fmt "\"%a\"" pp_skolemV vtx in
  let pp_uq_node_id (nid:dot_id) =
    let unquote str = String.sub str 1 (String.length str-2) in
    let s = toStr pp_node_id nid in unquote s in
  let pp_DNode fmt ((nid,attrlist) : node_id * (attr list)) = 
    if is_uncal then check_nlabel attrlist;
    let pp_node_attr fmt = 
        if expnl then pp_node_attr fmt ~nlstr:(pp_uq_node_id nid) else pp_node_attr fmt in
    fprintf fmt "%a @[<2>[@;%a@;]@]" pp_node_id nid (pr_attr_list pp_node_attr) attrlist in
  let pp_DEdge fmt ((is,al,it):(node_id * (attr list) * node_id)) = 
    if is_uncal then check_elabel al;
    fprintf fmt "%a -> %a @[<2>[@;%a@;]@]" pp_node_id is pp_node_id it
      (pr_attr_list pp_edge_attr) al  in
  let rec pp_stmt fmt = function 
      DAGraph al	-> pp_DAGraph fmt al
    | DANode  al	-> pp_DANode fmt al
    | DAEdge  al	-> pp_DAEdge fmt al
    | DNode(n,al)	-> pp_DNode fmt (n,al)
    | DEdge(ns,al,nt)	-> pp_DEdge fmt (ns,al,nt)
    | DGroup(al,sl)	->
        fprintf fmt "@[<2>{ %a@;%a@;}@]"
          (pr_attr_list pp_graph_attr) al (pr_stmt_list pp_stmt) sl in
  fprintf fmt "@[<hov 4>digraph %S {@;%a@]@\n}@." d.graph_id (pr_stmt_list pp_stmt) d.stmt_list
