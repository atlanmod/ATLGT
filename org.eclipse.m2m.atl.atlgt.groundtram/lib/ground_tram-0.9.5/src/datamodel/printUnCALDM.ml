(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
open Format
open Fputil
open UnCAL
open PrintUnCAL
open UnCALDM

(* conversion to string *)

let rec vtx2str:(vtx -> string) = function
    Bid (i)      -> "Bid(" ^ string_of_int i ^ ")"
  | S1 (v,x)     -> "S1(" ^ vtx2str v ^ "," ^ marker2str x  ^ ")"
  | S2 (u,a,v,w) -> "S2(" ^ vtx2str u ^ "," ^ allit2str a ^ "," ^ 
      vtx2str v ^ "," ^ vtx2str w ^ ")"
  | Hub (v,x,i)  -> "Hub(" ^ vtx2str v ^ "," ^ marker2str x ^ "," ^ string_of_int i ^ ")"
  | FrE (v,e,i)  -> "FrE(" ^ vtx2str v ^ "," ^ edge2str   e ^ "," ^ string_of_int i ^ ")"
  | InT (i)      -> "InT(" ^ string_of_int i ^ ")"
  | ImT (i,x)    -> "ImT(" ^ string_of_int i ^ "," ^ marker2str x ^ ")"
  | IaT (i,v)    -> "IaT(" ^ string_of_int i ^ "," ^ vtx2str v ^ ")"
and edge2str   ((u,a,v):edge) = "(" ^ vtx2str u ^ "," ^ allit2str a ^ "," ^ vtx2str v ^ ")"
let inodeR2str ((m,v):inodeR) = "(" ^ marker2str m ^ "," ^ vtx2str v ^ ")"
let onodeR2str ((v,m):onodeR) = "(" ^ vtx2str v ^ "," ^ marker2str m ^ ")"

let setofVtx2str    setV = "{" ^ String.concat "," (List.map vtx2str (SetofVtx.elements setV)) ^ "}"
let setofEdge2str   setE = "{" ^ String.concat "," (List.map edge2str (SetofEdge.elements setE)) ^ "}"
let setofInodeR2str setI = "{" ^ String.concat "," (List.map inodeR2str (SetofInodeR.elements setI)) ^ "}"
let setofOnodeR2str setO = "{" ^ String.concat "," (List.map onodeR2str (SetofOnodeR.elements setO)) ^ "}"

let graph2str g = "("
  ^ setofVtx2str    g.v ^ "\n"
  ^ setofEdge2str   g.e ^ "\n"
  ^ setofInodeR2str g.i ^ "\n"
  ^ setofOnodeR2str g.o ^ "\n"
 ^ ")\n"


(* pretty printer *)
(* TODO: these printers should have been implemented using single functor *)

let rec pr_vtx ppf = function
    Bid (i)      -> fprintf ppf "Bid %i" i
  | S1 (v,x)     -> fprintf ppf "S1 (@[%a,@ %a@])" pr_vtx v pr_marker x
  | S2 (u,a,v,w) -> fprintf ppf "S2 (@[%a,@ %a,@ %a,@ %a@])" pr_vtx u pr_allit a pr_vtx v pr_vtx w
  | Hub (v,x,i)  -> fprintf ppf "Hub (@[%a,@ %a,@ %i@])" pr_vtx v pr_marker x i 
  | FrE (v,e,i)  -> fprintf ppf "FrE (@[%a,@ %a,@ %i@])" pr_vtx v pr_edge   e i
  | InT (i)      -> fprintf ppf "InT %i" i
  | ImT (i,x)    -> fprintf ppf "ImT (@[%i,@ %a@])" i pr_marker x
  | IaT (i,v)    -> fprintf ppf "IaT (@[%i,@ %a@])" i pr_vtx    v
and pr_edge ppf = function
   (u,a,v) -> fprintf ppf "(@[%a,@ %a,@ %a@])"  pr_vtx u pr_allit a pr_vtx v



let pr_ionode_pair pr_a pr_b ppf (a,b) =
  Format.fprintf ppf "(@[%a,@ %a@])" pr_a a pr_b b

let pr_inodeR = pr_ionode_pair pr_marker pr_vtx
let pr_onodeR = pr_ionode_pair pr_vtx pr_marker

let pr_SetofVtx    =    SetofVtx.pp_t "" pr_vtx
let pr_SetofEdge   =   SetofEdge.pp_t "" pr_edge
let pr_SetofMarker = SetofMarker.pp_t "" pr_marker
let pr_SetofInodeR = SetofInodeR.pp_t "" pr_inodeR
let pr_SetofOnodeR = SetofOnodeR.pp_t "" pr_onodeR


let pr_graph ppf g =
  fprintf ppf "(@[v=%a,@ e=%a,@ i=%a,@ o=%a@])" 
    pr_SetofVtx g.v  pr_SetofEdge g.e pr_SetofInodeR g.i pr_SetofOnodeR g.o

let pr_rgraph ppf rg = pr_graph ppf !rg

let pr_mEdge ppf mE =
  fprintf ppf "(@[sourceV=%a,@ xlabel=%a,@ destV=%a@])" 
    pr_vtx mE.sourceV  pr_allit mE.xlabel pr_vtx mE.destV

let pr_SetofMEdge  =  SetofMEdge.pr  pr_mEdge
let pr_SetofPVtx   =   SetofPVtx.pr  (pr_pair pr_vtx pr_vtx)
let pr_SetofAllit  =  SetofAllit.pp_t "" pr_allit
let pr_SetofPAllit = SetofPAllit.pr  (pr_pair pr_allit pr_allit)

let pr_mVtx ppf mV = 
  fprintf ppf "(@[id=%a,@ incomE=%a,@ outgoE=%a,@ imarks=%a,@ omarks=%a@])" 
    pr_vtx mV.id  pr_SetofMEdge mV.incomE pr_SetofMEdge mV.outgoE
    pr_SetofMarker mV.imarks  pr_SetofMarker mV.omarks

let pr_MapofVtxToGraph		= MapofVtx.pr pr_vtx pr_graph
let pr_MapofVtxToRGraph		= MapofVtx.pr pr_vtx pr_rgraph
let pr_MapofVtxToMarker		= MapofVtx.pr pr_vtx pr_marker
let pr_MapofVtxToSetofVtx	= MapofVtx.pr pr_vtx pr_SetofVtx
let pr_MapofVtxToVtx		= MapofVtx.pr pr_vtx pr_vtx
let pr_MapofVtxToAExpr pp_a	= MapofVtx.pr pr_vtx (ppr_aexpr ~pp_a)
let pr_MapofVtxToMVtx		= MapofVtx.pr pr_vtx pr_mVtx


let pr_MapofEbodyToGraph  = MapofEbody.pr (pr_pair pr_allit pr_vtx) pr_graph 

let pr_MapofPVtxToSEdge  = MapofPVtx.pr (pr_pair pr_vtx pr_vtx) pr_SetofEdge

let pr_MapofEdgeToEdge   = MapofEdge.pr pr_edge pr_edge
let pr_MapofEdgeToGraph  = MapofEdge.pr pr_edge pr_graph 
let pr_MapofEdgeToSEdge  = MapofEdge.pr pr_edge pr_SetofEdge
let pr_MapofEdgeToEdgeOpt = MapofEdge.pr pr_edge (Print.pp_option pr_edge)

let pr_editop ppf = function
     EMod (org,rev) -> fprintf ppf "EMod %a=>%a" pr_allit org pr_allit rev
  |  EDel           -> fprintf ppf "EDel"
  |  EAdd           -> fprintf ppf "EAdd"

let pr_MapofEdgeToeditop = MapofEdge.pr pr_edge pr_editop

(* loading and storing graphs using Marshal standard library *)
(* graph to file *)
let g2file (g:graph) (file:string) : unit = 
  let oc = open_out_bin file  in
  Marshal.to_channel oc g [];
  close_out oc
(* file to graph *)
let file2g (file:string) : graph = 
  let is = open_in_bin file in
  let  d = (Marshal.from_channel is : graph) in
  close_in is;
  d
