(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
(* Paige-Tarjan refinement with their optimized data structures *)

open Fputil
open Format

let pt_Debug = ref false (* if set to true, debug messages are printed *) 

(* since ifprintf seems to execute formatting, it is not zero-overhead *)
let dbg_printf fmt =
  if !pt_Debug then fprintf std_formatter fmt 
  else  ifprintf std_formatter fmt

let dbg_call f = if !pt_Debug then f () else ()


module type ONLGsig =
  sig
    type nid
    module SetofEdg : Set.S with type elt = (nid * nid)
    val pp_nid : Format.formatter -> nid -> unit
  end

module OPT (NLG : ONLGsig) = struct
  module SetofEdg = NLG.SetofEdg
  type nid    = NLG.nid
  let pp_nid fmt (n:nid) = NLG.pp_nid fmt n

  module MapofNode = Map.Make (struct 
    type t = nid
    let compare = Pervasives.compare
  end )


(* since a field of record in OCaml is already a pointer, ref 
   is not necessary *)

(* Don't maintain list of Q because removing blocks from it makes implementation
   more complicated. Since final result is a collection of simple blocks in X,
   Q is not necessary. In addition, members of X monotonically increases
   and never deleted, we don't need to maintain reference to cell in X 
   Also note that we never scan Q for block D to split. D that is split
   is always accessible from elements x *)
   
type 'nid elemx = {  (* element x of U *)
    nid : 'nid;            (* node id *)
    mutable marked: bool; (* mark for E^{-1}(B) and E^{-1}(B)-E^{-1}(S-B) computation *)
    mutable count_xS_Fx: count_x_S; (* ptr to count(x,S) *) 
    mutable preimage: 'nid xEy list;  (* list of incoming edges *)
    mutable parentB: ('nid blockB) Dllist.cell; (* ptr to cell of block in Q *)
  }
and 'nid xEy = { (* xEy *)
    mutable count_xS_FxEy: count_x_S; (* ptr to count(x,S) *)
    elemx_FxEy: ('nid elemx) Dllist.cell; (* ptr to cell of x in block of Q *)
 }
and 'nid blockB = { (* block B of partition Q *)
    memsB: 'nid elemx Dllist.t; (* size can be read from Dllist *)
    mutable parentS: 'nid blockS;   (* block of X that contains me *)
    mutable assocD: 'nid blockB option; (* unused *) (* block D that is associated with *) 
    mutable dprime: (('nid blockB) Dllist.cell) option; (* block D' assocciated *)
}
and 'nid blockS = { (* block S of partition X *)
    memsS: 'nid blockB Dllist.t; (* blocks of Q that I contain *)
    mutable inC: bool;  (* true if it is in list C *)
}
and count_x_S = {  (* count(x,S) *)
    mutable count: int;
}

let isCompound         (s: 'a blockS) = Dllist.length s.memsS > 1
let blockB_isEmpty     (b: 'a blockB) = Dllist.is_empty b.memsB
let blockB_length      (b: 'a blockB) = Dllist.length b.memsB
let blockB_isSingleton (b: 'a blockB) = (1 = blockB_length b)
let blockS_length      (s: 'a blockS) = Dllist.length s.memsS
let blockS_isEmpty     (s: 'a blockS) = Dllist.is_empty s.memsS
let cell2content  = Dllist.cell2content
  
(* pretty printers for nid=int *)
(* let pp_nid = pp_print_int *)

let pp_count_x_S fmt count_x_S = 
  fprintf fmt "@[<1>{"; 
  fprintf fmt "cnt=%d" count_x_S.count;
  fprintf fmt "}@]"

let pp_xEy fmt xEy = 
  fprintf fmt "@[<1>{"; 
  let x = cell2content xEy.elemx_FxEy in
  fprintf fmt "count_x_S=%a@;" pp_count_x_S xEy.count_xS_FxEy;
  fprintf fmt "elemx=%a" pp_nid x.nid;
  fprintf fmt "}@]"
  
let pp_elemx fmt elemx =
  fprintf fmt "@[<1>{"; 
  fprintf fmt "id=%a@;" pp_nid elemx.nid;
  fprintf fmt "marked=%b@;" elemx.marked;
  fprintf fmt "count_x_S=%a@;" pp_count_x_S elemx.count_xS_Fx;
  fprintf fmt "preimage=[%a]" (Fputil.pr_list pp_xEy) elemx.preimage;
  fprintf fmt "}@]"

let pp_preimage_cells fmt cells =
  let pp_xcell fmt cell = fprintf fmt "%a" pp_elemx (cell2content cell) in
  fprintf fmt "[%a]" (Fputil.pr_list pp_xcell) cells


let pp_DllistOfElemx = Dllist.pr_t pp_elemx

let pp_blockB fmt blockB = 
  fprintf fmt "@[<1>{"; 
  fprintf fmt "memsB=%a" pp_DllistOfElemx blockB.memsB;
  fprintf fmt "}@]"

let pp_DllistOfBlockB = Dllist.pr_t pp_blockB

let pp_blockS fmt blockS = 
  fprintf fmt "@[<1>{"; 
  fprintf fmt "memsS=%a@;" pp_DllistOfBlockB blockS.memsS;
  fprintf fmt "inC=%b@;" blockS.inC;
  fprintf fmt "}@]"
  
let pp_DllistOfBlockS = Dllist.pr_t pp_blockS

let add_to_S (b: 'a blockB) (s: 'a blockS) : 'a blockB Dllist.cell = 
  Dllist.add b s.memsS

let top_from_S (s: 'a blockS) : 'a blockB =
  Dllist.top s.memsS

(* when we copy B to B', make sure the parentB
   entry will not point to B'. Don't redirect!!
   B'' is just for backup of node list *)
let copyB (b: 'nid blockB) : 'nid blockB = 
  let dummy_s = { memsS=Dllist.create (); inC=false } in
  let newmemsB = Dllist.copy b.memsB in
  let newB = { memsB=newmemsB; parentS=dummy_s; assocD=None; dprime=None} in 
  ignore (add_to_S newB dummy_s);
  (* let dummy_cell = peek_cell memsS in 
     iter (fun x -> x.parentB <- dummy_cell) newB.memsB; *)
  dbg_call (fun () -> printf "copying done for B:%a@." pp_blockB b);
  newB


(* initialization *)
(* 'nid  = int *)
(* build single block of the universe U *)
(* general case would be ...
  receive map from something to set of nodes that is hosted by the same block.
  set of set is expected to cost high, so should be avoided.
  In that sense, map target can be lists, instead of sets. *)
let initialize nLL eS =
  let s = { memsS=Dllist.create (); (* blocks in S *) inC=false } in
  let m = List.fold_left (fun m1 nL ->
    let memsB = Dllist.create () in (* nodes in a block *)
    let b = { memsB=memsB; parentS=s; assocD=None; dprime=None} in 
    let bcell = add_to_S b s in
    List.fold_left (fun m0 n ->
      let elemx = {
	nid = n;
	marked = false;
	count_xS_Fx = { count = 0; };
	preimage = [];
	parentB = bcell;
      } in MapofNode.add n (Dllist.add elemx memsB) m0) m1 nL)
      MapofNode.empty nLL in
  let _ =
    SetofEdg.iter (fun (x,y) ->
      let xcell = MapofNode.find x m in
      let ycell = MapofNode.find y m in
      let (elemx,elemy) = mapT2 cell2content (xcell,ycell) in
      let xEy = {
	count_xS_FxEy = elemx.count_xS_Fx;
	elemx_FxEy = xcell; } in
      (elemx.count_xS_Fx).count <- (elemx.count_xS_Fx).count + 1;
      elemy.preimage <- xEy::elemy.preimage) eS in
  s 

(* move x from D to D' *)
(* since xEy want to point to the original cell after 
   moving, it is not desirable to put x in a new cell.
   Therefore, we want Dllist to have interface that 
   insert cell instead of content *)

let move_xcell xcell d dprimecell =
  let x = cell2content xcell in
  let dprime = cell2content dprimecell in
  Dllist.take_at_cell xcell d.memsB;
  Dllist.add_cell     xcell dprime.memsB;
  x.parentB <- dprimecell

(* move cell of blockB of srcS to dstS *)
let move_blockB bcell srcS dstS : unit =
  let blockB = cell2content bcell in
  Dllist.take_at_cell bcell srcS.memsS;
  Dllist.add_cell     bcell dstS.memsS;
  blockB.parentS <- dstS;
  (* redirect parentB of the moved members to the new block *)
  Dllist.iter (fun elemx ->
    (dbg_call (fun () -> printf "redirecting for elemx:%a@." pp_elemx elemx));
    elemx.parentB <- bcell) blockB.memsB;
  dbg_call (fun () -> printf "redirections done for members of B:%a@." pp_blockB blockB)

let select_smaller_B s = 
  let bcell1 = Dllist.goto_head s.memsS;Dllist.peek_current_cell s.memsS in
  let bcell2 = Dllist.goto_next s.memsS;Dllist.peek_current_cell s.memsS in
  let (b1,b2) = mapT2 cell2content (bcell1,bcell2) in
  if (blockB_length b1) < (blockB_length b2) 
  then  (bcell1,b1)  else  (bcell2,b2)

let add_to_C (s: 'a blockS) (c: 'a blockS Dllist.t) : unit =
  ignore (Dllist.add s c); s.inC <- true

let take_from_C (c: 'a blockS Dllist.t)  : 'a blockS = 
  let s = Dllist.take c in s.inC <- false; s

let add_to_X (s: 'a blockS) (x: 'a blockS Dllist.t) : unit =
  ignore (Dllist.add s x)

let update_X bcell s x c : unit =
  let sprime = { memsS=Dllist.create (); inC=false } in
  move_blockB bcell s sprime;
  add_to_X sprime x;
  if isCompound s then 
    (add_to_C s c;
     dbg_call (fun () -> printf "S just put back in step 2:%a@." pp_blockS s);
    )

let blockB_xEy_iter f b : unit = 
  Dllist.iter (fun elemx -> List.iter f elemx.preimage) b.memsB

let compute_preimage_B b =
  let preimage_B = ref [] in
  blockB_xEy_iter (fun xEy ->
    let xcell = xEy.elemx_FxEy in
    let x = (cell2content xcell) in
    if x.marked = false then (
      x.marked <- true;
      preimage_B := xcell:: !preimage_B;
      x.count_xS_Fx <- { count = 1 }
     ) else (
      (x.count_xS_Fx).count <- (x.count_xS_Fx).count + 1
     )) b;
  !preimage_B


let compute_preimage_SminusB bprime = 
  let preimage_SminusB = ref [] in
  blockB_xEy_iter (fun xEy ->
    let xcell = xEy.elemx_FxEy in
    let x = cell2content xcell in
    if x.count_xS_Fx.count = xEy.count_xS_FxEy.count && x.marked = false then
      (x.marked <- true;
       preimage_SminusB := xcell:: !preimage_SminusB)
	      ) bprime;
  !preimage_SminusB

let update_counts bprime : unit = 
  blockB_xEy_iter (fun xEy ->
    let xcell = xEy.elemx_FxEy in
    let x = cell2content xcell in
    let count_xS_FxEy = xEy.count_xS_FxEy in
    count_xS_FxEy.count <- count_xS_FxEy.count - 1;
    if count_xS_FxEy.count = 0 then 
      xEy.count_xS_FxEy <-  x.count_xS_Fx;
		  ) bprime

let fromSome = function
    Some x -> x
  | None   -> failwith "dereferencing None"


let compute_splitBlocks preimagecells blockname : (('a blockB) Dllist.cell) list = 
  let splitBlocks = ref [] in
  List.iter (fun xcell ->
    let x = cell2content xcell in
    let dcell = x.parentB in
    let d = cell2content dcell in  (* Don't skip singleton block *)
    let parentS = d.parentS in
    let dprimecell =
      if d.dprime = None then (* no associated D' *)
	let dprime = { memsB = Dllist.create ();
		       parentS = parentS; 
		       assocD = Some d;
		       dprime = None; } in
	let dprimecell = add_to_S dprime parentS in
	d.dprime <- Some dprimecell;
	splitBlocks := dcell :: !splitBlocks;
	dprimecell
      else fromSome d.dprime in
    (* move x from d to dprime *)
    dbg_call (fun () -> printf "moving x(%a) from D:%a@." pp_nid x.nid pp_blockB d);
    move_xcell xcell d dprimecell;
    x.marked <- false
	    ) preimagecells;
  dbg_call (fun () -> printf "there are %d block(s) that are split by %s@."
      (List.length !splitBlocks) blockname);
  !splitBlocks

let process_splitBlocks splitBlocks c : unit = 
  List.iter (fun dcell ->
    let d = cell2content dcell in
    let dprimecell = fromSome (d.dprime) in
    let dprime = cell2content dprimecell in
    let parentS = d.parentS in
    dbg_call (fun () -> printf 
	"(by dcell) selected parentS=%a@." pp_blockS parentS);
    dprime.assocD <- None;
    d.dprime <- None;
    if blockB_isEmpty d then (
      dbg_call (fun () -> printf "removing (from S) D:%a@." pp_blockB d);
      Dllist.take_at_cell dcell parentS.memsS;
      dbg_call (fun () -> printf "after removal of D, S=%a@." pp_blockS parentS));
    if (not parentS.inC) && isCompound parentS then
      (dbg_call (fun () -> printf 
	  "(in step4/6) putting back (to C) parentS:%a@." pp_blockS parentS);
       add_to_C parentS c)
	    ) splitBlocks

let split_by preimagecells blockname c : unit =   (* step 4 and 6 *)
  dbg_call (fun () -> printf 
      "Refine Q with respect to preimage (cells) of %s: %a@." 
      blockname pp_preimage_cells preimagecells);
  let splitBlocks = compute_splitBlocks preimagecells blockname in
  (* process the list of split blocks *)
  process_splitBlocks splitBlocks c

(* split leaf nodes in d  *)
let split_leaf d = 
  (* collect leaf nodes *)
  let leaf_count = ref 0 in
  let is_leaf xcell =
    let res:bool = (cell2content xcell).count_xS_Fx.count = 0 in
    (if res then leaf_count := !leaf_count+1); res in
  let leaf_list = Dllist.filter2list_cell is_leaf d.memsB in
  if 0 = !leaf_count
  then
    (dbg_call (fun () -> printf "No leaf so nothing to be done@."))
  else if !leaf_count = blockB_length d then 
    (dbg_call (fun () -> printf "Leaf nodes only, so nothing to be done@."))
  else
    (* move leaf nodes from d to dprime *)
    let parentS = d.parentS in
    let dprime = { memsB=Dllist.create (); parentS=parentS; assocD=None; dprime=None} in
    let dprimecell = add_to_S dprime parentS in
    List.iter (fun xcell -> move_xcell xcell d dprimecell) leaf_list


let paige_tarjan_opt nLL eS  =
  let s = initialize nLL eS in
  let c = Dllist.create () in (* C: list of compound elements *)
  let x = Dllist.create () in

  if (not (blockS_isEmpty s)) then 
    (add_to_X s x;
     (if isCompound s then add_to_C s c
     else
       let d = top_from_S s in
       let _ = split_leaf d in
       if isCompound s then add_to_C s c;));

  (* main loop *)
  while (not (Dllist.is_empty c)) do
   
    (* step 1 (select a refining block) *)
    let s = take_from_C c in
    dbg_call (fun () -> printf "Selected S=%a@." pp_blockS s);
    if (not (isCompound s)) then failwith "selected S is  not compound.";
    let (bcell,b) = select_smaller_B s in (* select B *)

    (* step 2 (update X) *)
    dbg_call (fun () -> printf "selected B:%a@." pp_blockB b);
    update_X bcell s x c;

    (* step 3 (compute E^{-1}(B)) *)
    dbg_call (fun () -> printf "entering step 3@.");
    let bprime = copyB b in
    let preimage_B = compute_preimage_B b in

    (* step 4 (refine Q with respect to B) *)
    dbg_call (fun () -> printf "entering step 4@.");
    split_by preimage_B "B" c;

    (* step 5 (compute E^{-1}(B)-E{-1}(S-B)) *)
    let preimage_SminusB = compute_preimage_SminusB bprime in

    (* step 6 (refine Q with respect to S-B) *)
    split_by preimage_SminusB "S-B" c;

    (* step 7 (update counts) *)
    update_counts bprime;
  done;
  (* print outputs *)
  dbg_call (fun () -> printf "Refinement DONE@.@[<1>{memsS=%a}@]@." pp_DllistOfBlockS x);
  Dllist.map2list (fun s ->
    let b = top_from_S s in
    Dllist.map2list (fun elemx -> elemx.nid) b.memsB) x 
end
