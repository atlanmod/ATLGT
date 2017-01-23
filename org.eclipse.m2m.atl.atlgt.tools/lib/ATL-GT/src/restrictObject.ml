open UnCALDM
open Km3
open PrintKm3
open ObjectGraph
open Format

(** If true, debug write by {!dprintf} is enabled *)
let restrictObject_verbose = ref false

let dprintf ?(verbose:bool = false) =
  if (!restrictObject_verbose || verbose)
  then Format.printf
  else Format.ifprintf std_formatter

let pp_name_element_Map = NameMap.pp_t "" pp_name Dot2xmi.pp_xmi_element

let myfail (s:string) = failwith ("restrictObject.ml:" ^ s)

let merge_refmaps (og1':xmi_element NameMap.t) (refmap':NameVtxSet.t NameMap.t) (refmap:NameVtxSet.t NameMap.t)
  : NameVtxSet.t NameMap.t = 
   (NameMap.merge (fun fname nvtxopt' nvtxopt ->
        match (nvtxopt',nvtxopt) with
        None, None       -> None
      | None, Some nvtx  -> (* feature deletion  *) None
      | Some nvtxp',None -> (* feature insertion OR reference to nonBX part *)
       let s = NameVtxSet.filter (fun (name,_,_) ->
         if (NameMap.mem name og1') then
           (* reference to BX part inserted, which is not supported *) 
           myfail ("feature insertion not implemented yet : feature" ^ fname)
         else (* reference to nonBX part. discard *)
           false 
         ) nvtxp' in
        if NameVtxSet.is_empty s then None else Some s
      | Some nvtx',Some nvtx ->
         let s = NameVtxSet.setmap (fun (name,vtxo1,vtxo2) ->
          if (NameMap.mem name og1') then
           (* reference to BX part *)
           let s' = NameVtxSet.filter (fun (n,_,_) -> n = name) nvtx in
           match NameVtxSet.cardinal s' with
               0 -> myfail ("feature insertion not implemented yet: feature" ^ fname)
             | 1 -> NameVtxSet.singleton (NameVtxSet.choose s')
             | _ -> myfail ("duplicate reference to the same model element is not supported: feature" ^ fname)
         else 
           (* reference to nonBX part: discard *)
            NameVtxSet.empty
           ) nvtx' in
         if NameVtxSet.is_empty s then None else Some s
                         ) refmap' refmap)

(** m2|m1 :  Restrict model m2 relative to m1.  *)
let restrict_object (og1:xmi_element NameMap.t) (og2:xmi_element NameMap.t) : xmi_element NameMap.t = 
  (* Currently m2 before update is not considered, so insertion cannot be precisely detected *)
  let is_in_og1 key = NameMap.mem key og1 in
  (* step1 : compute the elements among m2 that are considered *)
  let og1'= NameMap.merge (fun xmi_id e2opt e1opt ->
    match (e2opt,e1opt) with
      Some e2,None    -> (* included in m2 but not in m1  : nonBX   element : discard it.  *)
	dprintf "restrict_object: discarding model element outside submodel %a@." Dot2xmi.pp_xmi_element e2;
	None
    | None   ,Some e1 -> (* included in m1 but not in m2  : deleted element : descard it.  *) 
	dprintf "restrict_object: discarding deleted model element %a@." Dot2xmi.pp_xmi_element e1;
	None 
    | Some e2,Some e1 -> (* included in both              : possibly upated : keep in this step *) Some e2 
  | None   ,None    -> None) og2 og1 in
  let og1''= NameMap.merge  (fun xmi_id e1opt' e1opt ->
  match (e1opt',e1opt) with
    None    ,None    -> None
  | Some _  ,None    -> myfail "assertion failed."
  | None    ,Some _  -> None (* Deleted model element had been discarded by the previous step *)
  | Some e1',Some e1 -> 
     (* keep e1' value but inherit trace of e1, take care of partiality, remove dangling reference *)
     (Some { e1' with
     attrmap =  (** map of non-structured attributes *)
     (NameMap.merge (fun fname npopt' npopt ->
        match (npopt',npopt) with
        None, None    -> None
      | None, Some np -> (* feature deletion : is it possible? 
                 even if feature is statically discarded by the compiler, does ObjectGraph builder
                  still create an entry or entirely misses it ?*)
                 None (*  myfail "feathre itself should not be deleted" *)
      | Some np',None -> (* feature insertion : currently not supported *) myfail "feature insertion not implemented yet"
      | Some np',Some np ->
       let ((clname,primset'),(_,primset)) = (np',np) in
        Some (clname, (* value of primset' should be taken whereas trace of primset is taken *)
               let (ps,_) = Xmi2dot_generic.put_primset primset primset' 3000000 in
               ps)
            ) e1'.attrmap e1.attrmap);
     refmap = (** map of non-containment references *)
       merge_refmaps og1' e1'.refmap e1.refmap; 
     childmap = (** map of containment references *)
       merge_refmaps og1' e1'.childmap e1.childmap; })
  ) og1' og1 in
   og1''
    
    
  

    
