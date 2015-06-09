(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
open Format
open UnCAL
open UnCALDM
open UnCALDMutil
open Dotutil
open ParseUnCAL

(* let prefix = "Bid" *)
let prefix = ""

let pp_allit fmt (a:allit) = match a with
  | ALLbl l -> fprintf fmt "%s" l
  | ALStr s -> fprintf fmt "\"\\\"%s\\\"\"" s
  | ALInt i -> fprintf fmt "%d" i
  | ALFlt f -> (* 'fprintf fmt "%f" f' returns 1.20000 instead of 1.2 *)
      fprintf fmt "%s" (string_of_float f)
  | ALBol b -> fprintf fmt "%B" b
  | ALUkn -> fprintf fmt "ukn"
  | ALEps -> fprintf fmt "eps"

let pp_vtx fmt (v:vtx) = match v with
  | Bid i -> fprintf fmt "%s%d" prefix i
  | _ -> fprintf fmt "non Bid"

let pp_edge ?(upward=false) fmt ((u,a,v):edge) =
  if upward then
    fprintf fmt "%a -> %a [dir = back, label = %a]" pp_vtx v pp_vtx u pp_allit a
  else
    fprintf fmt "%a -> %a [label = %a]" pp_vtx u pp_vtx v pp_allit a

let pp_graph ?(ops=[]) fmt (g:graph) =
  let es = (clean_id g).e in
  let opvs =
    SetofEdge.fold
      (fun (_,a,v) vs -> if List.mem a ops then SetofVtx.add v vs else vs)
      es SetofVtx.empty in
  fprintf fmt "digraph test @[<2>{@;";
  ignore (SetofEdge.fold (fun ((u,a,v) as e) is_fst ->
                            let upward = SetofVtx.mem u opvs || SetofVtx.mem v opvs in
                            (* let upward = List.mem a ops in *)
                            if is_fst then pp_edge ~upward fmt e
                            else fprintf fmt ";@;%a" (pp_edge ~upward) e;
                            false) es true);
  fprintf fmt "@;}@]@."

let g2viz_org ?ops (g:graph) (file:string) =
  let fmt = formatter_of_out_channel (open_out file) in
  pp_graph ?ops fmt g

let g2viz ?(ops = []) (g:graph) (file:string) =
  g2dot_file ~shape:`ellipse ~gray_unreachable:true ~ops:ops g file



