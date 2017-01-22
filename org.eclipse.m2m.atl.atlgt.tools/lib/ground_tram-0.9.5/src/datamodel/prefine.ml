(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
(*  Robert Paige and Robert Tarjan. Three partition refinement
   algorithms. SIAM Journal of Computing, 16:973--988, 1987. *)

open ExtSetMap
open Format
exception Dummy_scc


let pt_Debug = ref false (* if set to true, debug messages are printed *) 

module type NLGsig =
  sig
    module SLNode : sig include Set.S end 
    module SULEdge : Set.S with type elt = (SLNode.elt * SLNode.elt)
    module SSLNode : Set.S with type elt = SLNode.t
    val pr_SLNode : Format.formatter -> SLNode.t -> unit
    val pr_SSLNode : Format.formatter -> SSLNode.t -> unit 
  end

module PT (NLG : NLGsig) = struct
  module SLNode  = NLG.SLNode
  module SULEdge = NLG.SULEdge
  module SSLNode = NLG.SSLNode
  let pr_SLNode  = NLG.pr_SLNode
  let pr_SSLNode = NLG.pr_SSLNode

module MLNode = Map.Make (struct 
    type t = SLNode.elt
    let compare = Pervasives.compare
  end )

  let lnodeSet2Map f = MLNode.set2map (module SLNode : Set.S with type elt = MLNode.key and type t = SLNode.t) f

  let build_ngraph_preimage_map nv ne =
    let initMap = lnodeSet2Map (fun v -> SLNode.empty) nv in
    let pmap = SULEdge.fold
	(fun (u,v) -> MLNode.update (SLNode.add u) v)
	ne initMap in
    (fun v -> MLNode.find v pmap)

  (* u: U (set of nodes)  e: E (set of edges) p: P (given initial partition) *)
  let paige_tarjan (u:SLNode.t) (e:SULEdge.t) (p:SSLNode.t) =
    let lookup_preimage = build_ngraph_preimage_map u e  in
    let split_block splitter block = 
      let preimage_nodes = lookup_preimage in
      let preimage = SLNode.setmap preimage_nodes splitter in
      if SLNode.is_empty preimage then SSLNode.singleton block
      else 
	let intersection = SLNode.inter preimage block in
	let rest = SLNode.diff block intersection in
	let candidate = SSLNode.fromList [intersection;rest] in
	let (_,non_empty_sets) = SSLNode.partition SLNode.is_empty candidate in
	let _ = if !pt_Debug then fprintf std_formatter
	    "Splitting block %a by preimage %a of splitter %a into %a\n%!" 
	    pr_SLNode block pr_SLNode  preimage pr_SLNode splitter pr_SSLNode non_empty_sets in 
	non_empty_sets in
    let split splitter partition = 
      SSLNode.setmap (split_block splitter) partition in
    let _ = if !pt_Debug then fprintf std_formatter 
	"Given partition P = %a\n%!" pr_SSLNode p in
    (* initial partition *)
    let p = split u p in (* set aside leaf nodes *)
    (* discard empty set *)
    let (_,p) = SSLNode.partition SLNode.is_empty p in
    let _ = if !pt_Debug then fprintf std_formatter 
	"Initial partition P:%a\n%!" pr_SSLNode p in
    let q = ref p in
    let x = ref (SSLNode.singleton u) in
    let find_s_and_b () =
      let (_,candidates) = SSLNode.partition (fun s -> SSLNode.mem s !q) !x in
      let s = SSLNode.choose candidates in
      let _ = if !pt_Debug then fprintf std_formatter 
	  "find_s_and_b: SSLNode.mem S%a Q%a = %B\n%!"
	  pr_SLNode s pr_SSLNode !q (SSLNode.mem s !q) in
      let size_s = SLNode.cardinal s in
      let _ = if !pt_Debug then fprintf std_formatter 
	  "find_s_and_b seletcted S:%a out of X:%a with size %d that is not a block of Q:%a\n%!" 
	  pr_SLNode s pr_SSLNode !x size_s pr_SSLNode !q in
      let threshold = size_s / 2 in
      let filter_b b =  
	SLNode.subset b s &&  (SLNode.cardinal b) <= threshold in
      let candidate = SSLNode.filter filter_b !q in
      let b = SSLNode.choose candidate in
      let _ = if !pt_Debug then fprintf std_formatter "find_s_and_b -> (S:%a,B:%a)\n%!" 
	  pr_SLNode s pr_SLNode b in
      (s,b) in
    (try
      if 0 = SSLNode.compare !q !x then 
	begin
	  if !pt_Debug then fprintf std_formatter
	      "Q:%a and X:%a is equal so nothing to be done\n%!" pr_SSLNode !q pr_SSLNode !x;
	  raise Dummy_scc 
	end 
      else 
	(while true do
	  let _ = if !pt_Debug then 
	    fprintf std_formatter "Q:%a, X:%a" pr_SSLNode !q pr_SSLNode !x in
	  let (s,b) = find_s_and_b () in
	  let sminusb = (SLNode.diff s b) in
	  x := SSLNode.remove s !x;
	  x := SSLNode.add    b !x;
	    x := SSLNode.add sminusb !x;
	  if !pt_Debug then fprintf std_formatter
	      "X is updated to %a by splitting block S:%a into B:%a and S-B%a\n%!"
	      pr_SSLNode !x pr_SLNode s pr_SLNode b pr_SLNode sminusb;
	  q := split sminusb (split b !q);
	  if 0 = SSLNode.compare !q !x then raise Dummy_scc else 
	  (if !pt_Debug then fprintf std_formatter
	      "Q:%a and X:%a is still different\n%!" pr_SSLNode !q pr_SSLNode !x);
	  q := split sminusb (split b !q);
	done)
    with Dummy_scc -> ()
    | e -> print_endline "Abnormal termination\n"; raise e);
    !q
end
