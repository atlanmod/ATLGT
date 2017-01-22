(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
open PrintUnCALDM
open UnCALDM
open Fputil
open UnCALMAST
open PrintUnCAL
open Format
open UnCALdynenv
open UnCALSA

let pr_maexpr ?pp_a ppf e =
  fprintf ppf "{@[graph=%a;@ taexpr=%a;@ daexpr=... @]}" pr_graph e.graph (ppr_taexpr ?pp_a) e.taexpr

let pr_MapofEbodyToDynEnv = MapofEbody.pr (pr_pair pr_allit pr_vtx) pr_dynenv
let pr_MapofEbodyToMaexpr ?pp_a = MapofEbody.pr (pr_pair pr_allit pr_vtx) (pr_maexpr ?pp_a)

let pr_MapofEdgeToDynEnv = MapofEdge.pr pr_edge pr_dynenv
let pr_MapofEdgeToMaexpr ?pp_a = MapofEdge.pr pr_edge (pr_maexpr ?pp_a)


let pr_mbody = pr_MapofEdgeToMaexpr

