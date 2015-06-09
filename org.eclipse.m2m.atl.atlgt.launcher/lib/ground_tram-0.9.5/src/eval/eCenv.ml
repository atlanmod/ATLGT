(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
open UnCALDM
open UnCALDMutil
open UnCALenv
(* eta environment that maps graph variables to map of equivalance classes
   and label variables to its equivalence classes. If equivalence 
   class is not available, the entry of the map will be None *)

type ecenv = ((edge option) MapofEdge.t, edge option) glenv

(* ecenv initializer *)
(* identity map as equivalence class *)


let create_id_ecmap (eS: SetofEdge.t) :  edge option MapofEdge.t
 = edgeSet2Map (fun edge -> Some edge) eS

(* create initial map for $db from input graph *)
let create_initenv_from_db (db:graph) : ecenv =
  intern_gv_aux "$db" (create_id_ecmap db.e) emptyEnv_aux
