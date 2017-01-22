(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
open UnCALDM
val contract : graph -> graph 
val contract_opt : graph -> graph 
val contract_opt_with_map : graph -> graph * vtx MapofVtx.t * edge MapofEdge.t
val bisimilar_opt : graph -> graph -> bool
val bisimilar_opt_org : graph -> graph -> bool
val evalg_ABisim : graph -> graph -> bool
val bisimilar_opt_aux : graph -> graph -> bool
val bisimv_opt : vtx -> vtx -> graph -> bool
val build_bisimv_opt : graph -> vtx * vtx -> bool
