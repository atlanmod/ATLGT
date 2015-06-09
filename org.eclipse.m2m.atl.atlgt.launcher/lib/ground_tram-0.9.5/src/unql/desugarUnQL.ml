(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
open UnQL
open PrintUnQL


(** Desugaring from UnQL exp. to UnCAL exp. consists of two phases. *)
(* fst_desugar:                                                    *)
(* input UnQL                output UnQL                           *)
(*    SELECT(`query)           SELECT simplified_where             *)
(*    REPLACE(`replace_in)     sfun with SELECT simplified_where   *)
(*    DELETE(`delete_in)       sfun with SELECT simplified_where   *)
(*    EXTEND(`extend_in)       EXTEND simplified_where             *)

(* simplifyWhere: *)

 
(* snd_desugar: *)

(** fresh() is used for generating a fresh name *)
let fresh, init =
  let c = ref 0 in
  (fun() -> incr c; !c),
  (fun() -> c := 0)

(** initial annotation for UnQL expressions is unit *)
let initAnno = ()

(* nfa and non_epsilon_nfa are defined as follows *)
(** state used in Automata *)
type state = int

(** alphabet used in Automata *)
type label_a = string

(** edge used in Automata *)
type edge= state * label_a * state

module State = struct type t = state let compare = compare end


module StateS = Set.Make (State) 
module StateSS = Set.Make (StateS)
module Alphabet = struct type t = label_a let compare = compare end
module AlphabetS = Set.Make (Alphabet)
module LabelStateS = struct type t = label_a * StateS.t let compare = compare end
module L_sS = Set.Make (LabelStateS)
module Trans = struct type t = state * L_sS.t let compare = compare end
module TransS = Set.Make (Trans)
module Dtrans = struct type t = StateS.t * ((label_a * StateS.t) list) let compare = compare end 
module DtransS = Set.Make (Dtrans)

(** nfa=(sigma, setOfstate, edge_list, init, final) 
    sigma      : set of alphabet (set of label)
    setOfstate : set of state
    edge_list  : (state * label_a * state) list
    init       : start state
    final      : set of accept states
*)
type nfa = {
  sigma: AlphabetS.t;
  setOfstate : StateS.t;
  edge_list : edge list;
  init: state;
  final: StateS.t;
}

let fresh_state, initialize_state =
  let c = ref 0 in
  (fun() -> incr c; !c),
  (fun() -> c := 0)



(** non_eps_nfa=(n_sigma, stateS, transS, n_init, n_final) 
    n_sigma : set of alphabet (set of label)
    stateS  : set of state
    transS  : set of (state * set of (label_a * set of state)) 
    n_init  : start state
    n_final : set of accept states
*)
type non_eps_nfa = {
  n_sigma: AlphabetS.t;
  stateS : StateS.t;
  transS : TransS.t;
  n_init: state;
  n_final: StateS.t;
}

(** dfa=(dsigma, dsates, dtrans, dinit, dfinal)
    dsigma  : set of alphabet (set of label)
    dstates : set of set of state
    dtrans  : set of (set of satate * (label * set of state) list
    dinit   : set of state
    dfinal  : set of set of state
*)
type dfa = {
  dsigma: AlphabetS.t; (** alphabet (set of label) *)
  dstates: StateSS.t;
  dtrans: DtransS.t;
  dinit: StateS.t;
  dfinal: StateSS.t;
}


(** pretty printer *)
let pr_state ppf (s:state) = Format.fprintf ppf "%d" s
let pr_label_a ppf (l:label_a) = Format.fprintf ppf "%s" l
let pr_edge  ppf ((s1,l,s2):edge)  = 
  Format.fprintf ppf "(%a, %a, %a)" pr_state s1 pr_label_a l pr_state s2 
let pr_list pr_elem ppf lst =
  let v = ref lst in
  while (!v <> []) 
  do
    Format.fprintf ppf "%a" pr_elem (List.hd (!v));
    v := (List.tl (!v));
    if (!v <> []) then Format.fprintf ppf ";@ ";
  done
let pr_edge_list ppf (es:edge list) =
  Format.fprintf ppf "[@[%a@]]" (pr_list pr_edge) es
let pr_StateS ppf (sS:StateS.t) = 
  Format.fprintf ppf "{@[%a@]}" (pr_list pr_state) (StateS.elements sS)
let print_StateS (ss:StateS.t) = Format.fprintf Format.std_formatter "%a@?" pr_StateS ss
let pr_StateSS ppf (sSS:StateSS.t) =
  Format.fprintf ppf "{@[%a@]}" (pr_list pr_StateS) (StateSS.elements sSS)
let pr_AlphabetS ppf (lS:AlphabetS.t) =
  Format.fprintf ppf "{@[%a@]}" (pr_list pr_label_a) (AlphabetS.elements lS)
let pr_one_delta ppf (((s,l),sS):((state*label_a)*StateS.t)) =
  Format.fprintf ppf "@[((%a, %a)-> %a)@]" pr_state s pr_label_a l pr_StateS sS 
let pr_L_sS ppf ((l,sS):(label_a*StateS.t)) =
  Format.fprintf ppf "(@[%a -> %a@])" pr_label_a l pr_StateS sS
let pr_Setofl_ss ppf (l_sS:L_sS.t) = 
  Format.fprintf ppf "{@[%a@]}" (pr_list pr_L_sS) (L_sS.elements l_sS)
let pr_trans ppf ((s,l_sS):Trans.t) =
  Format.fprintf ppf "(@[%a, %a@])@ " pr_state s pr_Setofl_ss l_sS
let pr_TransS ppf (dS:TransS.t) =
  Format.fprintf ppf "{@[%a@]}" (pr_list pr_trans) (TransS.elements dS)
let pr_nfa ppf (m:nfa) =
  Format.fprintf ppf "@[sigma=%a@]@\n@[setOfstate=%a@]@\n@[edge_list=%a@]@\n@[init=%a@]@\n@[final=%a@]"
    pr_AlphabetS m.sigma pr_StateS m.setOfstate pr_edge_list m.edge_list pr_state m.init pr_StateS m.final
let pr_non_eps_nfa ppf (m:non_eps_nfa) =
  Format.fprintf ppf "@[stateS=%a@]@\n@[transS=%a@]@\n@[init=%a@]@\n@[final=%a@]"
    pr_StateS m.stateS pr_TransS m.transS pr_state m.n_init pr_StateS m.n_final
let pr_state_list ppf (ss:state list) = 
  Format.fprintf ppf "[@[%a@]]" (pr_list pr_state) ss
let pr_label_list ppf (ls:label_a list) =
  Format.fprintf ppf "[@[%a@]]" (pr_list pr_label_a) ls
let pr_dtrans ppf ((ss,l_sS):Dtrans.t) =
  Format.fprintf ppf "(@[%a, %a@])@\n" pr_StateS ss (pr_list pr_L_sS) l_sS
let pr_Setofdtrans ppf (dS:DtransS.t) =
  Format.fprintf ppf "{@[%a@]}" (pr_list pr_dtrans) (DtransS.elements dS)
let pr_dfa ppf (m:dfa) =
  Format.fprintf ppf "@[stateS=[%a]@]@\n@[transS=%a@]@\n@[init=%a@]@\n@[final=%a@]"
    (pr_StateSS) m.dstates (pr_Setofdtrans) m.dtrans pr_StateS m.dinit (pr_StateSS) m.dfinal


(* the following functions are defined for converting rpp2non_eps_nfa via rpp2nfa *)
let rec rpp2nfa (r:'a rpp) : nfa =
  let (start:state)=fresh_state() in
  let (finish:state)=fresh_state() in
(*   let (start,finish) = (1,2) *)
  let m = {sigma=AlphabetS.empty;
	   setOfstate=StateS.add finish (StateS.add start StateS.empty);
	   edge_list=[];
	   init=start;
	   final=StateS.add finish (StateS.empty);
	  } in
  let rec r2nfa (rp:'a rpp) (m1:nfa) (s:state) (f:state) :nfa =
    match rp with
	`label (_,l) ->
	  {m1 with
	     edge_list=
	      (m1.edge_list)@[(s,l,f)];
	     sigma=
	      AlphabetS.add l m1.sigma;
	  }
      | `any ->
	  {m1 with
	     edge_list=
	      (m1.edge_list)@[(s,"_",f)];
	     sigma=
	      AlphabetS.add "_" m1.sigma;
	  }
      | `eps -> 
(* 	  let new_state=newstate m1 in *)
	  let new_state=fresh_state() in
	  {m1 with
	     setOfstate = StateS.add new_state m1.setOfstate;
	     edge_list= m1.edge_list@[(s,"",new_state);(new_state,"",f)];
	  } 
	     
      | `concat (r1, r2) ->
(* 	  let new_state = newstate m1 in *)
	  let new_state = fresh_state() in
	  let new_m={m1 with setOfstate=StateS.add new_state m1.setOfstate} in
	  let m_r1 = r2nfa r1 new_m s new_state in
	    r2nfa r2 m_r1 new_state f
      | `union (r1,r2) ->
	  r2nfa r2 (r2nfa r1 m1 s f) s f
      | `star r1 ->
(* 	  let new_state=newstate m1 in *)
	  let new_state=fresh_state() in
	  let new_m={m1 with
		       setOfstate = StateS.add new_state m1.setOfstate;
		       edge_list= m1.edge_list@[(s,"",new_state);(new_state,"",f)];
		    } in
	    r2nfa r1 new_m new_state new_state
      | `plus r1 ->
          r2nfa (`concat(r1,`star r1)) m1 s f
      | `option r1 ->
	  let m_r1 = r2nfa r1 m1 s f in
	    {m_r1 with
	       edge_list=m_r1.edge_list@[s,"",f];
	    }
      | `not r1 ->
          failwith "rpp2nfa: not implemented yet"
  in  resolve_any (r2nfa r m start finish)

and resolve_any (m:nfa) : nfa =
  let rec instantiate_any (m1:nfa) (edge_list:edge list) : nfa = begin match edge_list with
    | [] -> m1
    | (s,alpha,d)::rest ->
	let m' = instantiate_any m1 rest in
	  if alpha = "_" then
	    {m' with
	       edge_list=
		(m'.edge_list)@(AlphabetS.fold (instantiate_alpha s d) (AlphabetS.remove "_" m1.sigma) [])
	    }
	  else m'
  end
  in instantiate_any m m.edge_list

and instantiate_alpha (s:state) (d:state) (alphabet:label_a) (edge_list:edge list) : edge list =
  List.append [(s,alphabet,d)] edge_list

and newstate (m:nfa) :state = (StateS.max_elt m.setOfstate) +1 

and rpp2non_eps_nfa (r:'a rpp) :non_eps_nfa =
  non_epsilon_nfa (rpp2nfa r) 

and non_epsilon_nfa (m:nfa) :non_eps_nfa =
  {n_sigma = m.sigma;
   stateS = m.setOfstate;
   n_init = m.init;
   n_final =
      if StateS.is_empty (StateS.inter m.final (eps_closure m m.init)) then
	m.final
      else
	StateS.add m.init m.final;
   transS=make_transS m;
  }

and one_delta (s:state) (l:label_a) ((s1,l1,s2):edge) (ss:StateS.t) : StateS.t = 
  let ss1 = 
    if (s1=s && (l1=l)) 
    then 
      StateS.singleton s2 
    else 
      StateS.empty in
    StateS.union ss1 ss 

and dlt (es:edge list) (l:label_a) (s:state) (ss:StateS.t) :StateS.t =
  StateS.union (List.fold_right (one_delta s l) es StateS.empty) ss

and delta_set (m:nfa) (ss:StateS.t) (l:label_a): StateS.t =
  StateS.fold (dlt m.edge_list l) ss StateS.empty

and eps_closure_set (ss:StateS.t) (m1:nfa) (result_set:StateS.t) =
  if StateS.is_empty ss then
    result_set
  else 
    let r_set = delta_set m1 ss "" in
      eps_closure_set (StateS.diff r_set result_set) m1 (StateS.union result_set r_set)
	
and eps_closure (m:nfa) (s:state) : StateS.t =
  eps_closure_set (StateS.add s StateS.empty) m (StateS.add s StateS.empty) 

and make_one_delta (q:state) (m:nfa) (l:label_a) (l_sS:L_sS.t) : L_sS.t =
  let ecl_set=eps_closure m q in
  let s_set=eps_closure_set (delta_set m ecl_set l) m (delta_set m ecl_set l) in
    L_sS.add (l, s_set) l_sS
      

and make_one_state_delta (q:state) (sigma:AlphabetS.t) (m:nfa) :Trans.t =
  (q, (AlphabetS.fold (make_one_delta q m) sigma L_sS.empty))

and make_dl (m:nfa) (sigma:AlphabetS.t) (s:state) (ds:TransS.t) :TransS.t = 
  TransS.add (make_one_state_delta s sigma m) ds 

and make_transS (m:nfa):TransS.t =
  StateS.fold (make_dl m m.sigma) m.setOfstate TransS.empty 

let rec non_eps_nfa2dfa (m:non_eps_nfa) : dfa =
  let stateSS=pSet m.stateS in 
  {
    dsigma=m.n_sigma;
    dstates=StateSS.remove StateS.empty stateSS;
    dtrans=make_dtrans m.transS;
    dinit=StateS.add m.n_init StateS.empty;
    dfinal=StateSS.remove StateS.empty (make_dfinal m.n_final stateSS);
  }

and pSet (ss:StateS.t) : StateSS.t = 
  let h = 
    try StateS.choose ss 
    with Not_found -> 0 in
    if h=0 then
      StateSS.add StateS.empty StateSS.empty
    else 
      let p=pSet (StateS.remove h ss) in
	StateSS.union (StateSS.fold (fun x y -> StateSS.add ((fun z -> StateS.add h z )x) y) p StateSS.empty) p

and make_dtrans (transS:TransS.t) : DtransS.t = 
  let (s,l_sS) =
    try TransS.choose transS
    with Not_found -> (0, L_sS.empty) in
    if s=0 then
      DtransS.add (StateS.empty, []) DtransS.empty
    else 
      let (dtrans:DtransS.t) = make_dtrans (TransS.remove (s,l_sS) transS) in
	DtransS.union (DtransS.fold (fun x y -> DtransS.add ((fun z -> merge_dtrans (s,l_sS) z )x) y) dtrans DtransS.empty) dtrans
  
and merge_dtrans ((s,sS):Trans.t) ((ss,l_sS):Dtrans.t) : Dtrans.t =
  let (l_sS1:(label_a*StateS.t) list)=L_sS.elements sS in
    if StateS.is_empty ss then
      (StateS.add s ss, l_sS1)
    else 
      (StateS.add s ss, List.map (merge_label l_sS1) l_sS)

and merge_label (l_sS:(label_a*StateS.t) list) ((l,sS):(label_a*StateS.t)) : (label_a*StateS.t) =
  (l,(StateS.union (List.assoc l l_sS) sS))

and make_dfinal (d_final:StateS.t) (stateSS:StateSS.t) : StateSS.t =
  StateSS.fold (fun x y -> StateSS.add ((one_dfinal d_final) x) y) stateSS StateSS.empty

and one_dfinal (d_final:StateS.t) (ss:StateS.t) : StateS.t =
  if StateS.is_empty (StateS.inter d_final ss) then
    StateS.empty
  else 
    ss

let rec minDFA (m:dfa) : dfa =
  let (seed:StateSS.t) = StateSS.add m.dinit StateSS.empty in 
  let (trans:Dtrans.t list) = DtransS.elements m.dtrans in
  let ss=min_states seed trans in
  {
    m with
      dstates=ss;
      dtrans=DtransS.remove (StateS.empty, []) (min_dtrans m.dtrans ss m.dinit);
      dfinal=StateSS.inter ss m.dfinal;
  }
and min_states (ss:StateSS.t) (trans:Dtrans.t list) : StateSS.t =
  let (ss1:StateSS.t) = StateSS.union ss (one_step ss trans) in
(*     (pr_StateSS Format.std_formatter ss);(Format.print_string "\n***\n");(pr_StateSS Format.std_formatter ss1); *)
    if StateSS.equal ss1 ss then ss
    else 
(*       (Format.print_string "\nss2=");(pr_StateSS Format.std_formatter ss);(Format.print_string "\n"); *)
      min_states (StateSS.union ss ss1) trans 

and one_step (ss:StateSS.t) (trans:Dtrans.t list) : StateSS.t =
  StateSS.fold (fun s y -> StateSS.union ((fun s trans -> List.fold_right (fun x y -> StateSS.add (snd x) y) (find s trans) StateSS.empty)s trans) y ) 
    ss 
    StateSS.empty

and find (s:StateS.t) (trans:Dtrans.t list) : (label_a*StateS.t) list = 
  match trans with
    | [] -> failwith "not found in find: minDFA in desugarUnQL"
    | (s1,result)::rest -> if StateS.equal s1 s then result else find s rest

and min_dtrans (transS:DtransS.t) (ss:StateSS.t) (initS:StateS.t) : DtransS.t =
  let dtransS = DtransS.fold (fun trans transS -> DtransS.add ((fun trans ss -> if StateSS.mem (fst trans) ss then trans else (StateS.empty, []))trans ss) transS) transS DtransS.empty in
    refine_dtransS dtransS initS

and refine_dtransS (dtransS:DtransS.t) (initS:StateS.t) : DtransS.t = 
(*   let initT = initTrans dtransS initS in  *)
(*     DtransS.fold (fun x y -> DtransS.add ((fun z -> z) x) y) (DtransS.remove initT dtransS) DtransS.empty *)
  DtransS.fold (fun x y -> DtransS.add ((fun z -> z) x) y) dtransS DtransS.empty

and initTrans (dtransS:DtransS.t) (initS:StateS.t) : Dtrans.t = 
  let (dtrans:Dtrans.t) = 
    try DtransS.choose dtransS
    with Not_found -> failwith "not found in initTrans: minDFA in desugarUnQL" in
    match dtrans with
      | (sS, _) -> if sS = initS then dtrans else initTrans (DtransS.remove dtrans dtransS) initS

and isSameTrans ((s1,l_sS1):Dtrans.t) ((s2,l_sS2):Dtrans.t) : bool =
    try 
      List.fold_right2 (fun (l1,sS1) (l2,sS2) b -> (l1 = l2) && (StateS.equal sS1 sS2) && b) l_sS1 l_sS2 true 
    with Invalid_argument _ -> false

let rpp2dfa (r:'a rpp) : dfa =
  minDFA (non_eps_nfa2dfa (non_epsilon_nfa (rpp2nfa r)))


let rec dfa2non_epsilon_nfa (d:dfa) : non_eps_nfa =
  let (stateS_state_list:((StateS.t*state) list)) = 
    StateSS.fold (fun ss ss_s_list -> List.append [(ss, (List.length ss_s_list + 1))] ss_s_list) d.dstates ([]:(StateS.t*state) list) in
  {
    n_sigma=d.dsigma;
    stateS=List.fold_right (fun x y -> StateS.add (snd x) y) stateS_state_list StateS.empty;
(*     transS= elimEmpTrans (remove_dead_state (dt2nt d.dtrans stateS_state_list)); *)
    transS= remove_dead_state (dt2nt d.dtrans stateS_state_list);
    n_init=ss2s d.dinit stateS_state_list;
    n_final=make_nfinal stateS_state_list d.dfinal;
  } 

and ss2s (ss:StateS.t) (ss_s_list:((StateS.t*state) list)) : state =
  match ss_s_list with
    | [] -> (print_StateS ss; failwith "NotFound in ss2s")
    | (ss',s)::rest -> if StateS.equal ss ss' then s else ss2s ss rest

and dt2nt (dt:DtransS.t) (ss_s_list:((StateS.t*state) list)) : TransS.t =
  DtransS.fold (fun (ds:Dtrans.t) (ntrans:TransS.t) 
		  -> TransS.add (foo ds ss_s_list) ntrans) dt TransS.empty 

and foo ((ss,l_s_list):Dtrans.t) (ss_s_list:((StateS.t*state) list)) : Trans.t =
  (ss2s ss ss_s_list,
   List.fold_right (fun (l,ss') l_sS -> L_sS.add (l, StateS.add (ss2s ss' ss_s_list) StateS.empty) l_sS) l_s_list L_sS.empty)

and make_nfinal (ss_s_list:(StateS.t*state) list)  (ss:StateSS.t) : StateS.t = 
  let s =
    try StateSS.choose ss
    with Not_found -> StateS.empty in
    if StateS.is_empty s then
      s
    else 
      let state = ss2s s ss_s_list in
	StateS.add state (make_nfinal ss_s_list (StateSS.remove s ss))

and remove_dead_state (tS:TransS.t) : TransS.t =
  TransS.fold (fun t tS' -> TransS.add (eliminate_dead_state t tS) tS') tS TransS.empty

and eliminate_dead_state ((s,(l_sS)) as t:Trans.t) (tS:TransS.t) : Trans.t =
  let new_l_sS = L_sS.fold (fun l_s l_sS' -> L_sS.add (remove_dead_s l_s tS) l_sS') l_sS L_sS.empty in
    (s,new_l_sS)

and remove_dead_s ((l,sS) as l_s:LabelStateS.t) (tS:TransS.t) : LabelStateS.t = 
  match StateS.elements sS with 
    | s::[] -> 
	if (TransS.fold (fun (s',_) b -> (s=s') || b) tS false) then
	  l_s
	else 
	  (l,StateS.empty)
    | _ -> failwith "error in remove_dead_s"

and elimEmpTransFromNFA (m:non_eps_nfa) : non_eps_nfa = 
  {m with transS=elimEmpTrans m.transS }

and elimEmpTrans (tS:TransS.t) : TransS.t = 
  let rec elimEmp (tS:TransS.t) (tS':TransS.t) = 
    let ((s,l_sS) as t) = 
      try TransS.choose tS 
      with Not_found -> (-1,L_sS.empty) in 
      if s = -1 then
	tS'
      else 
	if (L_sS.fold (fun (_,sS) b -> (StateS.is_empty sS) && b) l_sS true)
	then elimEmp (TransS.remove t tS) tS'
	else elimEmp (TransS.remove t tS) (TransS.add t tS')
  in elimEmp tS TransS.empty


(* the following functions are defined for desugaring *)
(* The desugaring consists of two phases. *)
(* 1. fst_desugar performs simplifying where expressions according to section 2.4 in the UnQL paper. *)

let rec fst_desugar (withOpt:bool) (e:'a expr) : 'a expr = match e.action with
  | `query (a,t) -> (* SELECT t *)
      { action = `query(a, fst_desugar_t withOpt t);
        where = 
          if withOpt 
          then pushing_selection (simplifyWhere withOpt e.where)
          else simplifyWhere withOpt e.where }
  | `delete_in (a,r,v,t) -> (* DELETE r->v IN t => REPLACE r->v BY {} IN t *)
      fst_desugar withOpt {action=(`replace_in(a,r,v,(`tree(initAnno,[]):>'a template),t));
			   where=e.where}
  | `extend_in (a,r,v,t1,t2) -> (* EXTEND r->v WITH t1 IN t2 *)
      {action = `extend_in (a,r,v,fst_desugar_t withOpt t1, fst_desugar_t withOpt t2);
        where =
          if withOpt
          then pushing_selection (simplifyWhere withOpt e.where)
          else simplifyWhere withOpt e.where }

  | `replace_in(a,r,v,t1,t2) -> (* REPLACE r->v BY t1 IN t2 *)
      {action = `query (initAnno,fst_desugar_t withOpt (rep2t {action=`replace_in(a,r,v,t1, t2);
							     where =e.where;}));
       where = []}
(* The followings are old syntax for updating *)
  | `delete (a,v) -> (* old syntax for delete G where ... => replace G by {} *)
      {action = `query (initAnno, r2t {action=`replace (a,v,`tree(initAnno,[]));
				   where=simplifyWhere false e.where});
       where = []}
  | `extend (a,v,t) -> (* old syntax for extend G with G1 where ... => replace G with G U G1 where ... *)
      begin match v with
	| (#variable as v) ->
	    {action = `query (initAnno, r2t {action=`replace (a, v,`union(initAnno, (v:>'a template),fst_desugar_t withOpt t));
					 where=simplifyWhere false e.where});
	     where = []}
	| `tree (#variable as v1, (#variable as v2)) ->
	    {action = `query (initAnno, r2t {action=`replace (a, v,`union(initAnno, (`tree(initAnno,[(v1,v2)]):>'a template),fst_desugar_t withOpt t));
					 where=simplifyWhere false e.where});
	     where = []}
	| `tree _ -> failwith "old extend does not have {const:var}"
	| `under _ -> failwith "old extend does not have under construct"
      end
  | `replace(a,v,t) -> (* old syntax for replace v by t *)
      {action = `query (initAnno, r2t {action=`replace (a,v,fst_desugar_t withOpt t);
				   where=simplifyWhere false e.where});
       where = []}

and fst_desugar_t (withOpt:bool) (t:'a template) : 'a template = match t with
  | `tree (a,tts) -> `tree (a,(List.map (fun(l,t) -> (l, (fst_desugar_t withOpt) t)) tts))
  | #variable -> t
  | `expr (a,e) -> `expr(a, fst_desugar withOpt e)
  | `union(a,t1,t2) -> `union(a,fst_desugar_t withOpt t1,fst_desugar_t withOpt t2)
  | `app_exp(a,f,t) -> `app_exp(a,f, fst_desugar_t withOpt t)
  | `let_exp (a,d,t) -> `let_exp (a,fst_desugar_d withOpt d,fst_desugar_t withOpt t)            
  | `letrec_exp (a,ds,t) -> `letrec_exp (a,(List.map (fst_desugar_d withOpt)) ds,fst_desugar_t withOpt t) 
  | `template_list (a,ts) -> `template_list (a, List.map (fst_desugar_t withOpt) ts)
  | `filter (a,bl,t) -> `filter (a,bl, fst_desugar_t withOpt t)
  | `ifcond (a,bl,t1,t2) -> `ifcond (a,bl, fst_desugar_t withOpt t1, fst_desugar_t withOpt t2)
  | `letvalue (a,v,t1,t2) -> `letvalue (a,v,fst_desugar_t withOpt t1,fst_desugar_t withOpt t2)              
  | `i_marker(a,m,t) -> `i_marker(a,m,fst_desugar_t withOpt t)
  | `o_marker(a,m) -> `o_marker(a,m)
  | `graph_empty a -> `graph_empty a                                  
  | `graph_union(a,t1,t2) -> `graph_union(a,fst_desugar_t withOpt t1,fst_desugar_t withOpt t2) 
  | `graph_append(a,t1,t2) -> `graph_append(a,fst_desugar_t withOpt t1,fst_desugar_t withOpt t2) 
  | `graph_cycle (a,t) -> `graph_cycle (a,fst_desugar_t withOpt t)
  | `srec(a,f,t) -> `srec(a,f,fst_desugar_t withOpt t)
	
and fst_desugar_d (withOpt:bool) (`def bs) = `def (List.map (fst_desugar_b withOpt) bs)

and fst_desugar_b (withOpt:bool) (`branch(f,a,t)) = `branch(f,a,fst_desugar_t withOpt t)

and simplifyWhere (withOpt:bool) (bclist: 'a bcond list) : 'a bcond list =
  match bclist with
    | (#bind_cond as b)::rest -> (* bind_cond -> call simplifyPat *)
	(simplifyPat withOpt b)@(simplifyWhere withOpt rest) 
    | (#bool_cond as a)::rest -> (* bool_cond -> stay *)
	[a]@(simplifyWhere withOpt rest)
    | []              -> []

(* the following five rules for simplifying where exp: 
   where (bind_cond, rest) 
   bind_cond ::= Pat in Template (original bind_cond ::= Pat in Var)

   rule 1 and rule 4 are original with new bind_cond definition.
   rule 2 is to represent a compositional expression with letvalue.
   rule 3 and rule 5 are to lift a constant leaf node up to an edge.

   rule 1: where {PE1:Pat1,...,PEn:Patn} in Var      -> where {PE1:Pat1} in Var, ..., {PEn:Patn} in Var
   rule 2: where {PE1:Pat1,...,PEn:Patn} in Template -> NewVar in Template, {PE1:Pat1} in NewVar, ..., {PEn:Patn} in NewVar
   rule 3: where {PE:const} in Template              -> where {PE:NewVar} in Template, {const:AnyVar} in NewVar 
   rule 4: where {PE:Pat} in Template                -> where {PE:NewVar} in Template, Pat in NewVar 
   rule 5: where Const in Template                   -> where {Const : {}} in Template
*)

(* simplifyPat is to apply 1st rule and 2nd rule to {PE:Pat} for simplifying where exp *)
and simplifyPat (withOpt:bool) (`pat_in (p,t):'a bind_cond) : 'a bcond list = match p with
  | `tree pps -> begin match (pps, t) with 
      | ([`concat (_,_) as r, v],t) -> (* rpp which cosists only with concat is decomposed to labels *)
	  if all_concat r then
	    match normr r with
	      |	`concat(`label l, r2) ->
		  let patternV:'a pattern = `tree[((r2 :> 'a pat_label),v)] in
		  let pattern2:'a pattern = `tree[((`label l :> 'a pat_label), patternV)] in
		  simplifyPat withOpt (`pat_in(pattern2, fst_desugar_t withOpt t))
	      |	`concat(`any, r2) ->
		  let patternV:'a pattern = `tree[((r2 :> 'a pat_label),v)] in
		  let lvar = `var (initAnno, ("$L"^(string_of_int (fresh())))) in
		  let pattern2:'a pattern = `tree[((lvar :> 'a pat_label), patternV)] in
		  simplifyPat withOpt (`pat_in(pattern2, fst_desugar_t withOpt t))
	      | _ -> failwith "not all concat in simplifyPat"
	  else
	    [`pat_in (p, fst_desugar_t withOpt t)]
      | ([_,#variable], #variable) -> (* {PE:Var} in Var -> do nothing *)
	  [`pat_in (p,t)]
      | ([pl,(#const as c)],_) -> (* rule 3 {pl:Const} in t -> {pl:newvar} in t, {Const:anyv} in newvar  *)
	  let fv = `var(initAnno, "$fv"^(string_of_int (fresh()))) in 
	  let anyFv = `var(initAnno, "$anyv"^(string_of_int (fresh()))) in
	  [(`pat_in (`tree[(pl, fv)], fst_desugar_t withOpt t))]
	  @[`pat_in (`tree[(`label_const c, anyFv)], fv) ]
      | ([pl,`tree pt], _) -> (* rule 4 {pl:{pt}} in template/var -> {pl:newvar} in template/var, pt in newvar *)
	  let fv = `var(initAnno,"$fv"^(string_of_int (fresh()))) in
	  [(`pat_in ((`tree[(pl,fv)]), fst_desugar_t withOpt t))]
	    @simplifyPat withOpt (`pat_in (`tree pt,fv))
      | ([_],_) -> 
	  [`pat_in (p, fst_desugar_t withOpt t)]
      | (p1::ps1,_) -> (* {PE1:Pat1, ..., PEn:Patn} in Template *)
	  (match t with
	       (#variable as v) -> (* rule 1 {PE1:Pat1,...,PEn:Patn} in Var *)
		 simplifyPat withOpt (`pat_in ((`tree [p1]),v)) @ simplifyPat withOpt (`pat_in (`tree(ps1),v))
	     | _ -> (* rule 2 {PE1:Pat1,...,PEn:Patn} in Template *)
		 let fv1= `var(initAnno, "$fv"^(string_of_int (fresh()))) in 
		 let head=[`pat_in(fv1, t)] in 
		 head@simplifyPat withOpt (`pat_in((`tree[p1],fv1)))
		 @ simplifyPat withOpt (`pat_in (`tree(ps1), fv1))
	  )
      | ([],_) -> [] end
  | #const as c -> (* rule 5 Const in Template *)
      [`pat_in (`tree [(`label_const c,`tree[])], fst_desugar_t withOpt t)]
	(* 	[`pat_in (`tree [(c,`tree[])], fst_desugar_t t)] *)
  | #variable -> (* do nothing *)
      [`pat_in (p,fst_desugar_t withOpt t)] 

and all_concat (r:'a rpp) :bool =
  match r with 
      `concat (r1,r2) -> 
	(all_concat r1) && (all_concat r2) 
    | `label _ -> 
	true
    | `any ->
	true
    | _ -> 
	false 

and normr (r:'a rpp) :'a rpp = 
  match r with 
    | `concat (`label l, `concat(r1,r2)) -> 
	`concat (`label l, normr (`concat(r1,r2)))
    | `concat (`any, `concat(r1,r2)) -> 
	`concat (`any, normr (`concat(r1,r2)))
    | `concat (`concat (r1,r2), r3) -> 
	normr (`concat (r1, `concat(r2,r3))) 
    | x -> x 

and pushing_selection (bclist:'a bcond list) : 'a bcond list =
	bclist
	

(* rep2t takes replace_in and results in template *)
and rep2t (e:'a expr) : 'a template = match e.action with
  | `delete _ | `extend _ | `query _ | `replace _ ->
      failwith "rep2t takes only new replace_in construct"
  | `delete_in(a,r,tgt,t1) -> failwith "Currently, delete_in is transfomed into replace_in"
  | `extend_in(a,r,tgt,with_t,in_t) -> failwith "Currently, rep2t does not take extend_in"
  | `replace_in(a,r,tgt,by_t,in_t) -> (* REPLACE r->tgt BY by_t IN in_t WHERE e.where *)
      let (m:non_eps_nfa) = elimEmpTransFromNFA (dfa2non_epsilon_nfa (minDFA (non_eps_nfa2dfa(rpp2non_eps_nfa r)))) in
      let (state_fname_list:((state*fun_name) list)) = StateS.fold make_funname m.stateS ([]:(state*fun_name) list) in
      let (test:'a template) = `expr (initAnno, {action=`query(initAnno, `tree(initAnno, [(((`label (initAnno,"FOUND")):>'a tree_label),`tree(initAnno, []))]));
					     where=e.where}) in
      let (rep_by:'a template) = `expr (initAnno, {action=`query (initAnno, by_t);
					       where=e.where}) in
      let (vL,vT) = (`var (initAnno, ("$L"^(string_of_int (fresh())))),`var (initAnno, ("$G"^(string_of_int (fresh()))))) in
      let def_list = TransS.fold (def4replace m state_fname_list vL vT tgt test rep_by m.transS) m.transS ([]:'a definition list) in
	`letrec_exp(initAnno, def_list,
		    `app_exp(initAnno, List.assoc m.n_init state_fname_list, in_t))

and make_funname (s:state) (s_f_list:(state*fun_name) list) :(state*fun_name) list   =
  List.append [(s,`fun_name ("h"^(string_of_int (fresh()))))] s_f_list

and has_any (blist:'a branch list) (fn:fun_name) (ar:'a argument) : bool = 
  match blist with
      (`branch(fn1,ar1,_))::rest -> 
	 if (fn1=fn && ar1=ar) then
	   true
	 else 
	   has_any rest fn ar
    | [] -> false
	
and def4replace
    (m:non_eps_nfa)
    (s_f_list:((state*fun_name) list))
    vL
    vT
    tgt
    (test:'a template)
    (rep_by:'a template)
    (trans:TransS.t)
    ((s,setofl_sS):Trans.t)
    (ds:'a definition list)
    : 'a definition list =
  let fname=List.assoc s s_f_list in
  let branch_list = L_sS.fold (branch4replace fname s_f_list vL vT tgt test rep_by m.n_final trans) setofl_sS ([]:'a branch list) in
      begin match tgt with
	| #variable as tgt -> 
	    let vT = tgt in 
	      if has_any branch_list fname ((`argument (vL,vT)):>'a argument) then
		List.append [`def (mv_any_last branch_list ((`argument (vL,vT):>'a argument)))] ds
	      else
		List.append [`def (branch_list@[`branch(fname, (`argument (vL, vT):>'a argument), `tree (initAnno, [((vL:>'a tree_label),(vT:>'a template))]))])] ds
	| `tree (((`label _)  ), vT') -> 
	    if has_any branch_list fname ((`argument (vL,vT)):>'a argument) then
	      List.append [`def (mv_any_last branch_list ((`argument (vL,vT):>'a argument)))] ds
	    else
	      List.append [`def (branch_list@[`branch(fname, (`argument (vL, vT):>'a argument), `tree (initAnno, [((vL:>'a tree_label),(vT:>'a template))]))])] ds
	| `tree (((`label_const _) ), vT') -> failwith "not implemented for rpp->{const:var} in replace_in"
	| `tree _ -> failwith "not implemented for rpp->{var:var} in replace_in"
	| `under _ -> failwith "not implemented for UNDER constructs in REPLACE"
      end 


and mv_any_last (bs:'a branch list) (ar:'a argument): 'a branch list =
  let last_b =
    let rec get_any = function
      | ((`branch(fn1,ar1,_)) as b)::rest ->
	  if ar1=ar then b
	  else get_any rest
      | [] -> failwith "error in get_any" in
      get_any bs in
  let newbs =
    let rec remove_any = function
      | ((`branch(fn1,ar1,_)) as b)::rest ->
	  if ar1=ar then remove_any rest
	  else List.append [b] (remove_any rest)
      |[] -> [] in
      remove_any bs in
    newbs@[last_b]

and branch4replace
    (fname:fun_name)
    (s_f_list:(state*fun_name) list)
    vL
    vT
    tgt
    (test:'a template)
    (rep_by:'a template)
    (finalS:StateS.t)
    (trans:TransS.t)
    ((l,sS):(label_a*StateS.t))
    (bs:'a branch list) : 'a branch list =
  if StateS.is_empty sS then (* no transition for label l *)
    bs
  else
    let label = if l="_" then vL else (`label (initAnno,l)) in
    let (fbody:'a template) =
      match (StateS.elements sS) with
	| s::[] ->
	    if (StateS.is_empty (StateS.inter finalS sS)) then (* Not Final *)
		begin match tgt with
		  | #variable as tgt -> 
		      let vT = tgt in 
			`tree(initAnno,[((label:>'a tree_label), `app_exp(initAnno, List.assoc s s_f_list, (vT:>'a template)))])
		  | `tree (((`label _)  as label'), vT') ->
			  `tree(initAnno,[((label:>'a tree_label), `app_exp(initAnno, List.assoc s s_f_list, (vT:>'a template)))])
		  | `tree _ -> failwith "not implemented for rpp->{var:var} in replace_in"
		  | `under _ -> failwith "not implemented for UNDER constructs in REPLACE"
		end 
	    else (* Final *)
	      let (vG:'a variable)=`var (initAnno, ("$G"^(string_of_int(fresh())))) in
		begin match tgt with
		  | #variable as tgt -> 
		      let vT = tgt in 
		      let ifExpr =
			if (TransS.fold (fun (s',_) b -> (s=s') || b) trans false) then 
			  `ifcond(initAnno, `unary (initAnno, `IsEmpty, (vG:>'a value_expr)),
				  `tree(initAnno, [((label:>'a tree_label), `app_exp(initAnno, List.assoc s s_f_list, (vT:>'a template)))]),
				  `tree(initAnno, [((label:>'a tree_label), rep_by)])) 
			else 
			  `ifcond(initAnno, `unary (initAnno, `IsEmpty, (vG:>'a value_expr)),
				  `tree(initAnno, [((label:>'a tree_label), (vT:>'a template))]),
				  `tree(initAnno, [((label:>'a tree_label), rep_by)])) 
		      in `letvalue(initAnno, vG,test,ifExpr)
		  | `tree (((`label _)  as label'), vT') ->
		      let ifExpr =
			if (TransS.fold (fun (s',_) b -> (s=s') || b) trans false) then 
			  `ifcond(initAnno, `unary (initAnno, `IsEmpty, (vG:>'a value_expr)),
				  `app_exp(initAnno, List.assoc s s_f_list, (vT:>'a template)),
				  rep_by)
			else 
			  `ifcond(initAnno, `unary (initAnno, `IsEmpty, (vG:>'a value_expr)),
				  (vT:>'a template),
				  rep_by)
		      in 
		      let letval = `letvalue(initAnno, vG,test,ifExpr) in
		      let vL' = `var (initAnno, ("$L"^(string_of_int (fresh())))) in
		      let (nestFun:fun_name) = `fun_name ("h"^(string_of_int (fresh()))) in
		      let (arg1:'a argument) = `argument ((label':>'a pat_label),(vT':>'a pattern)) in 
		      let (arg2:'a argument) = `argument ((vL':>'a pat_label),(vT':>'a pattern)) in 
		      let (branch1:'a branch) = `branch (nestFun, arg1, letval) in 
		      let (branch2:'a branch) = `branch (nestFun, arg2, `tree (initAnno, [((vL':>'a tree_label),(vT':>'a template))])) in 
			`let_exp(initAnno,`def[branch1;branch2], `tree(initAnno, [(label:>'a tree_label),`app_exp(initAnno,nestFun,(vT:>'a template))]))
		  | `tree _ -> failwith "not implemented for rpp->{var:var} in replace_in"
		  | `under _ -> failwith "not implemented for UNDER constructs in REPLACE"
		end 
	| _ -> failwith "error in branch"
    in
      begin match tgt with
	| #variable as tgt -> 
	    let vT = tgt in 
	      List.append [`branch(fname, `argument((label:>'a pat_label),(vT:>'a pattern)), fbody)] bs
	| `tree (((`label _)  as label'), vT') ->
	    List.append [`branch(fname, `argument((label:>'a pat_label),(vT:>'a pattern)), fbody)] bs
	| `tree _ -> failwith "not implemented for rpp->{var:var} in replace_in"
	| `under _ -> failwith "not implemented for UNDER constructs in REPLACE"
      end 



(* (1)                                             *)
(* replace tgt by t where {l:{}} in $t1, bl, rest  *)
(* =>                                              *)
(* let sfun h1{$L:$G} =                            *)
(*     if $L=l and isEmpty($G) and bl then         *)
(*        replace tgt by t where rest              *)
(*     else                                        *)
(*        {$L:$G}                                  *)
(* in h1($t1)                                      *)

(* (2)                                             *)
(* replace tgt by t where {$L:{}} in $t1, bl, rest *)
(* =>                                              *)
(* let sfun h1{$L:$G} =                            *)
(*     if isEmpty($G) and bl then                  *)
(*        replace tgt by t where rest             *)
(*     else                                        *)
(*        {$L:$G}                                  *)
(* in h1(t1)                                      *)

(* (3)                                              *)
(* replace $v by t where {l:$v'} in $t1, bl, rest *)
(* => {condition: v /= v'}                       *)
(* let sfun h1{$l':$v'} =                            *)
(*     if $l'=l and bl then                          *)
(*        {$l':(replace $v by t where rest)}      *)
(*     else                                         *)
(*        {$l':$v'}                                  *)
(* in h1($t1)                                        *)

(* (4) *)
(* replace $v by t where {$l:$v'} in $t1, bl, rest *)
(* => {condition: v /= v'}                         *)
(* let sfun h1({$l:$v'}) = *)
(*     if bl then *)
(*        {$l':(replace $g1 by $g2 where rest)} *)
(*     else *)
(*        {$l':$v'} *)
(* in h1($t1) *)

(* (5)                                                  *)
(* replace $v by t where {l:$v'} in $t1, bl, rest       *)
(* =>{condition: v = v'}                                *)
(* let sfun h1({$l':$v'}) =                             *)
(*     if $l'=l and bl then                             *)
(*        letval $g1 = select {l:{}} where rest in      *)
(*        letval $g2 = select t where rest in           *)
(*        if isEmpty($g1) then {$l':$v'} else {$l':$g2} *)
(*     else                                             *)
(*        {$l':$v'}                                     *)
(* in h1($t1)                                           *)

(* (6)                                                  *)
(* replace $v by t where {$l:$v'} in $t1, bl, rest      *)
(* =>{condition: v = v'}                                *)
(* let sfun h1({$l:$v'}) =                              *)
(*     if bl then                                       *)
(*        letval $g1 = select {label:{}} where rest in  *)
(*        letval $g2 = select t where rest in           *)
(*        if isEmpty($g1) then {$l:$v'} else {$l:$g2}   *)
(*     else                                             *)
(*        {$l:$v'}                                      *)
(* in h1($t1)	                                        *)

(* (7)                                                     *)
(* replace {$vL:$v} by t where {$l:$v'} in $t1, bl, rest   *)
(* =>{condition: v = v'}                                   *)
(* let sfun h1({$l:$v'}) =                                 *)
(*     if bl then                                          *)
(*        letval $g1 = select {label:{}} where rest in     *)
(*        letval $g2 = select t where rest in              *)
(*        if isEmpty($g1) then {$l:$v'} else $g2           *)
(*     else                                                *)
(*        {$l:$v'}                                         *)
(* in h1($t1)                                              *)


(* (8)                                                    *)
(* replace {$vL:$v} by t where {$l:$v'} in $t1, bl, rest  *)
(* =>{condition: v /= v'}                                 *)
(* let sfun h1({$l:$v'}) =                                *)
(*     if bl then                                         *)
(*        {$l':(replace {$vL:$v} by t where rest)}        *)
(*     else                                               *)
(*        {$l':$v'}                                       *)
(* in h1($t1)                                             *)

(* (9)                                                    *)
(* replace {$vL:$v} by t where {l:$v'} in $t1, bl, rest   *)
(* =>{condition: v = v'}                                  *)
(* let sfun h1($l':$v'} =                                 *)
(*     if $l'=l and bl then                               *)
(*        letval $g1 = select {label:{}} where rest in    *)
(*        letval $g2 = select t where rest in             *)
(*        if isEmpty($g1) then {$l:$v'} else $g2          *)
(*     else                                               *)
(*        {$l:$v'}                                        *)
(* in h1($t1)                                             *)
       

(* (10)                                                   *)
(* replace {$vL:$v} by t where {l:$v'} in $t1, bl, rest   *)
(* =>{condition: v /= v'}                                 *)
(* let sfun h1({$l':$v'}) =                               *)
(*     if $l'=l and bl then                               *)
(*        {$l':(replace {$vL:$v} by t where rest)}        *)
(*     else                                               *)
(*        {$l':$v'}                                       *)
(* in h1($t1)                                             *)
and r2t (e:'a expr) : 'a template = match e.action with
  | `delete _ | `extend _ | `query _ | `replace_in _ | `delete_in _ | `extend_in _ ->
      failwith "r2t takes only replace construct"
  | `replace(a,tgt,t) -> begin match e.where with
      | (#bool_cond)::rest -> (* where bool_cond, rest *)
	  failwith "(bool_cond::rest) not the normalized form"
      | [] -> (* where [] *)
	  failwith "r2t: where must have at lease one condition"
      | (`pat_in (pat,(#template as t1)))::rest -> (* where p in t1, rest *)
	  let (fname:fun_name) = `fun_name ("h"^(string_of_int (fresh()))) in
	  (* In the presense of non-unit annotations, variable name comparison should
	     disregard this annotation. So default equality test (= and <>) is replaced
	     by the following. *)
	  let vname_eq (v1:'a variable) (v2:'a variable) : bool = match (v1,v2) with
	      `var (_,n1), `var (_,n2) -> n1 = n2
	    | `doc (_,s1), `doc (_,s2) -> s1 = s2 
	    | `database _, `database _ -> true
	    | _                        -> false in
	  let (=%)  = vname_eq in
	  let (<>%) = fun a b -> not (vname_eq a b) in 
	  let ((bl,rest'):('a bool_cond*'a bcond list)) = get_blcond (`bool (initAnno,true), rest) in begin match pat with
	    | (`tree[((#label as l),      (`tree []))]) ->        (* replace G1 by t where {l:{}} in t1, bl, rest *)
		let ((v',g'):('a variable*'a variable)) =
		  (`var (initAnno,("$G"^(string_of_int(fresh())))), `var (initAnno,("$G"^(string_of_int(fresh()))))) in
		let (eqcond:'a bool_cond) = `binary (initAnno, `EQ, (v':>'a value_expr), (l:>'a value_expr)) in
		let (blcond:'a bool_cond) = `binary (initAnno, `AND, (`unary (initAnno, `IsEmpty, (g':>'a value_expr))), bl) in
		let (t2:'a template) = r2t {action=`replace(a,tgt,t);
					 where=rest'} in
		let (t3:'a template) = (`tree(initAnno, [((v':>'a tree_label),(g':>'a template))])) in
		let (fbody:'a template)=`ifcond(initAnno, `binary(initAnno, `AND, eqcond, blcond),t2,t3) in
		let (arg:'a argument) = `argument((v':>'a pat_label),(g':>'a pattern)) in
		let (branch:'a branch)=`branch(fname,arg,fbody) in
		  `let_exp
		    (initAnno,`def[branch],`app_exp (initAnno, fname, t1))
	    | `tree[((#variable as v'), (`tree []))]  ->        (* replace G1 by G2 where {$v':{}} in t1, bl, rest *)
		let (g':'a variable) = `var (initAnno, ("$G"^(string_of_int(fresh())))) in
		let (blcond:'a bool_cond) = `binary (initAnno, `AND, (`unary (initAnno, `IsEmpty, (g':>'a value_expr))), bl) in
		let (t2:'a template) = r2t {action=`replace(a,tgt,t);
					 where=rest'} in
		let (t3:'a template) = (`tree(initAnno, [((v':>'a tree_label),(g':>'a template))])) in
		let (fbody:'a template)=`ifcond(initAnno,blcond,t2,t3) in
		let (arg:'a argument) = `argument((v':>'a pat_label),(g':>'a pattern)) in
		let (branch:'a branch)=`branch(fname,arg,fbody) in
		  `let_exp
		    (initAnno,`def[branch],`app_exp (initAnno,fname, t1))
	    | `tree[((#label as l),     (#variable as v'))] ->  begin match tgt with (* replace G1 by G2 where {l:$v'} in t1, bl, rest *)
		| (#variable as v)                                   (* replace $v by t where {l:$v'} in t1, b1, rest *)
		| `tree(#variable, (#variable as v)) when (v <>% v') -> (* replace {$L:$v} by t where {l:v'} in t1, bl, rest *)
		    let (l':'a variable) = `var (initAnno, ("$L"^(string_of_int(fresh())))) in
		    let (blcond1:'a bool_cond) = `binary (initAnno,`EQ, (l':>'a value_expr), (l:>'a value_expr)) in
		    let (blcond4:'a bool_cond) = `binary (initAnno,`AND, blcond1, bl) in
		    let (t2:'a template) = r2t {action=`replace(a,tgt,t);where=rest'} in
		    let (t3:'a template) = (`tree(initAnno, [((l':>'a tree_label),(v':>'a template))])) in
		    let (fbody:'a template)=
		      `ifcond(initAnno, blcond4,`tree(initAnno, [((l':>'a tree_label),t2)]),t3) in
		    let (arg:'a argument) = `argument((l':>'a pat_label),(v':>'a pattern)) in
		    let (branch:'a branch)=`branch(fname,arg,fbody) in
		      `let_exp(initAnno, `def[branch],`app_exp (initAnno, fname, t1))
		| (#variable as v) when (v =% v') -> (* replace $v by g2 where {l:$v'} in t1, b1, rest *)
		    let (l':'a variable) = `var (initAnno, ("$L"^(string_of_int(fresh())))) in
		    let (blcond1:'a bool_cond) = `binary (initAnno, `EQ, (l':>'a value_expr), (l:>'a value_expr)) in
		    let (blcond4:'a bool_cond) = `binary (initAnno, `AND, blcond1, bl) in
		    let ((g1,g2):('a variable*'a variable)) =
		      (`var (initAnno, ("$G"^(string_of_int(fresh())))),
		       `var (initAnno, ("$G"^(string_of_int(fresh()))))) in
		    let (t22:'a template) =
		      `ifcond (initAnno, `unary (initAnno, `IsEmpty, (g1:>'a value_expr)),
			       `tree(initAnno, [((l':>'a tree_label),(v':>'a template))]),
			       `tree(initAnno, [((l':>'a tree_label),(g2:>'a template))])) in
		    let (q1:'a template) = `expr (initAnno,{action=`query (initAnno,t);where=rest'}) in
		    let (t21:'a template) = `letvalue(initAnno, g2,q1,t22) in
		    let (q2:'a template) = `expr (initAnno,{action=`query(initAnno, `tree(initAnno, [((l:>'a tree_label),`tree(initAnno, []))]));
							where=rest'}) in
		    let (t2:'a template) = `letvalue (initAnno, g1,q2,t21) in
		    let (t3:'a template) = `tree(initAnno, [((l':>'a tree_label),(v':>'a template))]) in
		    let (fbody:'a template)=`ifcond(initAnno, blcond4,t2,t3) in
		    let (arg:'a argument) = `argument((l':>'a pat_label),(v':>'a pattern)) in
		    let (branch:'a branch)=`branch(fname,arg,fbody) in
		      `let_exp(initAnno, `def[branch],`app_exp (initAnno, fname, t1))
		| `tree((#variable as vL),(#variable as vG)) when (vG=%v') -> (* replace {$vL:$vG} by t where {l:v'} in t1, bl, rest *)
		    let (l':'a variable) = `var (initAnno, ("$L"^(string_of_int(fresh())))) in
		    let (blcond1:'a bool_cond) = `binary (initAnno, `EQ, (l':>'a value_expr), (l:>'a value_expr)) in
		    let (blcond4:'a bool_cond) = `binary (initAnno, `AND, blcond1, bl) in
		    let ((g1,g2):('a variable*'a variable)) =
		      (`var (initAnno, ("$G"^(string_of_int(fresh())))),
		       `var (initAnno, ("$G"^(string_of_int(fresh()))))) in
		    let (t22:'a template) =
		      `ifcond (initAnno, `unary (initAnno, `IsEmpty, (g1:>'a value_expr)),
			       `tree(initAnno, [((l:>'a tree_label),(v':>'a template))]),
			       (g2:>'a template)) in
		    let (q1:'a template) = `expr (initAnno,{action=`query (initAnno,t);where=rest'}) in
		    let (t21:'a template) = `letvalue (initAnno, g2,q1,t22) in
		    let (q2:'a template) = `expr (initAnno,{action=`query(initAnno, `tree(initAnno, [((l:>'a tree_label),`tree(initAnno,[]))]));
							where = rest'}) in
		    let (t2:'a template) = `letvalue (initAnno, g1,q2,t21) in
		    let (t3:'a template) = `tree(initAnno, [((l:>'a tree_label),(v':>'a template))]) in
		    let (fbody:'a template)=`ifcond(initAnno, blcond4,t2,t3) in
		    let (arg:'a argument) = `argument((l:>'a pat_label),(v':>'a pattern)) in
		    let (branch:'a branch)=`branch(fname,arg,fbody) in
		      `let_exp
			(initAnno, `def[branch],`app_exp (initAnno, fname, t1))
		| _ -> failwith "fatal error in r2t (1)"
	      end
	    | `tree[((#variable as l),  (#variable as v'))] ->  begin match tgt with (* replace G1 by t where {$l:$v'} in t1, bl, rest *)
		| (#variable as v)                                  (* replace $v by t where {$l:$v'} in t1, bl, rest *)
		| `tree(#variable,(#variable as v)) when (v<>%v') -> (* replace {$vL:$v} by t where {$l:$v'} in $g, bl, rest *)
		    let (t2:'a template) = r2t {action=`replace(a,tgt,t);where=rest'} in
		    let (t3:'a template) = (`tree(initAnno, [((l:>'a tree_label),(v':>'a template))])) in
		    let (fbody:'a template)=
		      `ifcond(initAnno, bl,`tree(initAnno, [((l:>'a tree_label),t2)]),t3) in
		    let (arg:'a argument) = `argument((l:>'a pat_label),(v':>'a pattern)) in
		    let (branch:'a branch)=`branch(fname,arg,fbody) in
		      `let_exp(initAnno, `def[branch],`app_exp (initAnno, fname, t1))
		| (#variable as v) when (v=%v') -> (* replace $v by t where {$l:$v'} in t1, bl, rest *)
		    let ((g1,g2):('a variable*'a variable)) =
		      (`var (initAnno,("$G"^(string_of_int(fresh())))),
		       `var (initAnno, ("$G"^(string_of_int(fresh()))))) in
		    let (t22:'a template) =
		      `ifcond (initAnno, `unary (initAnno, `IsEmpty, (g1:>'a value_expr)),
			       `tree(initAnno, [((l:>'a tree_label),(v':>'a template))]),
			       `tree(initAnno, [((l:>'a tree_label),(g2:>'a template))])) in
		    let (q1:'a template) = `expr (initAnno,{action=`query (initAnno,t);where=rest'}) in
		    let (t21:'a template) = `letvalue(initAnno, g2,q1,t22) in
		    let (q2:'a template) = `expr (initAnno,{action=`query(initAnno, `tree(initAnno, [(((`label (initAnno,"label")):>'a tree_label),`tree(initAnno,[]))]));
							where=rest'}) in
		    let (t2:'a template) = `letvalue (initAnno, g1,q2,t21) in
		    let (t3:'a template) = `tree(initAnno, [((l:>'a tree_label),(v':>'a template))]) in
		    let (fbody:'a template)=`ifcond(initAnno,bl,t2,t3) in
		    let (arg:'a argument) = `argument((l:>'a pat_label),(v':>'a pattern)) in
		    let (branch:'a branch)=`branch(fname,arg,fbody) in
		      `let_exp(initAnno, `def[branch],`app_exp (initAnno, fname, t1))
		| `tree((#variable as vL),(#variable as vG)) when (vG=%v') -> (* replace {$vL:$vG} by t where {$l:$v'} in $g, bl, rest   *)
		    let ((g1,g2):('a variable*'a variable)) =
		      (`var (initAnno, ("$G"^(string_of_int(fresh())))),
		       `var (initAnno, ("$G"^(string_of_int(fresh()))))) in
		    let (t22:'a template) =
		      `ifcond (initAnno, `unary (initAnno, `IsEmpty, (g1:>'a value_expr)),
			       `tree(initAnno, [((l:>'a tree_label),(v':>'a template))]),
			       (g2:>'a template)) in
		    let (q1:'a template) = `expr (initAnno,{action=`query (initAnno,t);where=rest'}) in
		    let (t21:'a template) = `letvalue (initAnno, g2,q1,t22) in
		    let (q2:'a template) = `expr (initAnno,{action=`query(initAnno,`tree(initAnno, [(((`label (initAnno,"label")):>'a tree_label),`tree(initAnno, []))]));
					       where = rest'}) in
		    let (t2:'a template) = `letvalue (initAnno, g1,q2,t21) in
		    let (t3:'a template) = `tree(initAnno, [((l:>'a tree_label),(v':>'a template))]) in
		    let (fbody:'a template)=`ifcond(initAnno, bl,t2,t3) in
		    let (arg:'a argument) = `argument((l:>'a pat_label),(v':>'a pattern)) in
		    let (branch:'a branch)=`branch(fname,arg,fbody) in
		      `let_exp
			(initAnno, `def[branch],`app_exp (initAnno, fname, t1))
		| _ -> failwith "fatal error in r2t (2)"
	      end
	    | `tree[((#rpp as r),        _)]                ->  (* replace G1 by G2 where {rpp:_} in t1, bl, rest *)
		failwith "Sorry, not implement full rpp in replace.\n Please use only concatinations"
	    | `tree _                                       ->
		failwith "where is not simplified, desugaring error"
	    | #variable as v'                               -> (* replace G1 by t where $v' in t1, bl, rest' *)
		failwith "not implement replace $v1 by Template where $v1 in Template, rest"
	    | #const  ->
		failwith "{PE:const} in t: not applied wheresimplify"
	    end
    end 

and get_blcond ((bll,bcl):('a bool_cond*'a bcond list)) : ('a bool_cond*'a bcond list) =
  match bcl with
    | (#bind_cond):: rest ->
	(bll,bcl)
    | (#bool_cond as bl)::rest  ->
	get_blcond (`binary(initAnno,`AND, bl, bll), rest)
    | [] ->
	(bll,bcl)





let rec non_eps_nfa2letrec (t1:'a template) (m:non_eps_nfa) (with_id:bool) (repT:'a template) (vT:'a variable) :'a template =
  let (state_fname_list:((state*fun_name) list)) = StateS.fold make_funname m.stateS ([]:(state*fun_name) list) in
  let vL=`var (initAnno, ("$L"^(string_of_int (fresh())))) in
  let def_list = TransS.fold (one_def m state_fname_list vL vT with_id repT) m.transS ([]:'a definition list) in
    `letrec_exp(initAnno, def_list, 
		`app_exp(initAnno, List.assoc m.n_init state_fname_list, t1))

and replace_t (with_id:bool) (#variable as v1) (#variable as vT) (#variable as vL) (t:'a template) : 'a template = 
  if with_id then
    let (branch:'a branch)=`branch(`fun_name "id", 
				   `argument (vL, vT), 
				   `tree(initAnno, [(vL, `app_exp(initAnno, `fun_name "id", vT))])) in
    let (def:'a definition)=`def[branch] in 
    let idvT = `let_exp (initAnno, 
			 def,
			 `app_exp(initAnno, `fun_name "id", vT)) in
      replace_t_t1_by_t2 v1 idvT t 
  else 
    t

(* replace occurences of t1 by t2 in t *)
and replace_t_t1_by_t2 (t1:'a template) (t2:'a template) (t:'a template) : 'a template = 
  if t=t1 then t2 else match t with
    | `tree (a,tts) -> `tree (a, (List.map (fun(l,t) -> (l, (replace_t_t1_by_t2 t1 t2) t)) tts))
    | #variable ->  t
    | `expr (a,e) -> begin match e.action with
	| `query (a',t') -> `expr (a,{e with action=`query (a', replace_t_t1_by_t2 t1 t2 t')})
	| _ -> failwith "error in replace_t: not query"    end 
    | `union(a,t1',t2') -> `union(a,replace_t_t1_by_t2 t1 t2 t1', replace_t_t1_by_t2 t1 t2 t2')
    | `app_exp(a,f,t) -> `app_exp(a,f, replace_t_t1_by_t2 t1 t2 t)
    | `let_exp (a,d,t) -> `let_exp (a,replace_d_t1_by_t2 t1 t2 d,replace_t_t1_by_t2 t1 t2 t)            
    | `letrec_exp (a,ds,t) -> `letrec_exp (a,(List.map (replace_d_t1_by_t2 t1 t2)) ds,replace_t_t1_by_t2 t1 t2 t) 
    | `template_list (a,ts) -> `template_list (a, List.map (replace_t_t1_by_t2 t1 t2) ts)
    | `filter (a,bl,t) -> `filter (a,bl, replace_t_t1_by_t2 t1 t2 t)
    | `ifcond (a,bl,t1',t2') -> `ifcond (a,bl, replace_t_t1_by_t2 t1 t2 t1', replace_t_t1_by_t2 t1 t2 t2')
    | `letvalue (a,v,t1',t2') -> `letvalue (a,v,replace_t_t1_by_t2 t1 t2 t1',replace_t_t1_by_t2 t1 t2 t2')              
    | `i_marker(a,m,t) -> `i_marker(a,m,replace_t_t1_by_t2 t1 t2 t)
    | `o_marker(a,m) -> `o_marker(a,m)
    | `graph_empty a -> `graph_empty a                                  
    | `graph_union(a,t1',t2') -> `graph_union(a,replace_t_t1_by_t2 t1 t2 t1',replace_t_t1_by_t2 t1 t2 t2') 
    | `graph_append(a,t1',t2') -> `graph_append(a,replace_t_t1_by_t2 t1 t2 t1',replace_t_t1_by_t2 t1 t2 t2') 
    | `graph_cycle (a,t) -> `graph_cycle (a,(replace_t_t1_by_t2 t1 t2 t))
    | `srec(a,f,t) -> `srec(a,f,replace_t_t1_by_t2 t1 t2 t)

and replace_d_t1_by_t2 (t1:'a template) (t2:'a template) (`def bs) = `def (List.map (replace_b_t1_by_t2 t1 t2) bs)

and replace_b_t1_by_t2 (t1:'a template) (t2:'a template) (`branch(f,a,t)) = `branch(f,a,replace_t_t1_by_t2 t1 t2 t)

and one_def 
    (m:non_eps_nfa) 
    (s_f_list:((state*fun_name) list)) 
    vL 
    (#variable as vT) 
    (with_id:bool) 
    (repT:'a template)
    ((s,setofl_sS):Trans.t) 
    (ds:'a definition list) =
  let fname=List.assoc s s_f_list in 
  let branch_list=L_sS.fold (one_branch fname s_f_list vL vT with_id m.n_final repT) setofl_sS ([]:'a branch list) in
    if has_any branch_list fname (`argument (vL,vT)) then 
      List.append [`def branch_list] ds 
    else 
      List.append [`def (branch_list@[`branch(fname, `argument (vL, vT), `tree (initAnno,[]))])] ds 

and one_branch 
    (fname:fun_name) 
    (s_f_list:(state*fun_name) list) 
    vL 
    (#variable as vT) 
    (with_id:bool) 
    (finalS:StateS.t)
    (repT:'a template)
    ((l,sS):(label_a*StateS.t))
    (bs:'a branch list) =
  if StateS.is_empty sS then (* no transition for label l *)
    bs
  else 
    let not_final = (StateS.is_empty (StateS.inter finalS sS)) in
    let (fbody:'a template)=
      let rec f_body = function
	| s::[] ->
	    if not_final then (* not include final state*)
	      `app_exp(initAnno, List.assoc s s_f_list, vT)
	    else (* include final state *)
	      if with_id then
		`union(initAnno, `app_exp (initAnno, List.assoc s s_f_list, vT), repT)
	      else 
		`union(initAnno, `app_exp (initAnno, List.assoc s s_f_list, vT), repT)
	| s::rest ->
	    `union(initAnno, `app_exp(initAnno, List.assoc s s_f_list, vT), (f_body rest))
	| [] ->  
	    failwith "cannot make function body in function_body"
      in f_body (StateS.elements sS) 
    in
      if l="_" then (* `any *)
	List.append [`branch(fname, `argument(vL,vT), fbody)] bs 
      else 
	List.append [`branch(fname, `argument(`label (initAnno,l),vT), fbody)] bs 
	  
and make_funname (s:state) (s_f_list:(state*fun_name) list) :(state*fun_name) list   =
  List.append [(s,`fun_name ("h"^(string_of_int (fresh()))))] s_f_list

and has_any (blist:'a branch list) (fn:fun_name) (ar:'a argument) : bool = 
  match blist with
      (`branch(fn1,ar1,_))::rest -> 
	 if (fn1=fn && ar1=ar) then
	   true
	 else 
	   has_any rest fn ar
    | [] -> false
	

and def
    (m:non_eps_nfa)
    (s_f_list:((state*fun_name) list))
    vL
    (#variable as vT)
    (test:'a template)
    (rep_by:'a template)
    ((s,setofl_sS):Trans.t)
    (ds:'a definition list)
    : 'a definition list =
  let fname=List.assoc s s_f_list in
  let branch_list = L_sS.fold (branch fname s_f_list vL vT test rep_by m.n_final) setofl_sS ([]:'a branch list) in
    if has_any branch_list fname ((`argument (vL,vT)):>'a argument) then
      List.append [`def (mv_any_last branch_list ((`argument (vL,vT):>'a argument)))] ds
    else
      List.append [`def (branch_list@[`branch(fname, (`argument (vL, vT):>'a argument), `tree (initAnno, [((vL:>'a tree_label),(vT:>'a template))]))])] ds

and def_extend
    (m:non_eps_nfa)
    (s_f_list:((state*fun_name) list))
    vL
    (#variable as vT)
    (test:'a template)
    (with_t:'a template)
    (where:'a where)
    ((s,setofl_sS):Trans.t)
    (ds:'a definition list)
    : 'a definition list =
  let fname=List.assoc s s_f_list in
  let branch_list = L_sS.fold (branch_extend fname s_f_list vL vT test with_t m.n_final where) setofl_sS ([]:'a branch list) in
    if has_any branch_list fname ((`argument (vL,vT)):>'a argument) then
      List.append [`def (mv_any_last branch_list ((`argument (vL,vT):>'a argument)))] ds
    else
      List.append [`def (branch_list@[`branch(fname, (`argument (vL, vT):>'a argument), `tree (initAnno, [((vL:>'a tree_label),(vT:>'a template))]))])] ds

and mv_any_last (bs:'a branch list) (ar:'a argument): 'a branch list =
  let last_b =
    let rec get_any = function
      | ((`branch(fn1,ar1,_)) as b)::rest ->
	  if ar1=ar then b
	  else get_any rest
      | [] -> failwith "error in get_any" in
      get_any bs in
  let newbs =
    let rec remove_any = function
      | ((`branch(fn1,ar1,_)) as b)::rest ->
	  if ar1=ar then remove_any rest
	  else List.append [b] (remove_any rest)
      |[] -> [] in
      remove_any bs in
    newbs@[last_b]

and branch
    (fname:fun_name)
    (s_f_list:(state*fun_name) list)
    vL
    (#variable as vT)
    (test:'a template)
    (rep_by:'a template)
    (finalS:StateS.t)
    ((l,sS):(label_a*StateS.t))
    (bs:'a branch list) : 'a branch list =
  if StateS.is_empty sS then (* no transition for label l *)
    bs
  else
    let label = if l="_" then vL else (`label (initAnno,l)) in
    let (fbody:'a template) =
      match (StateS.elements sS) with
	| s::[] ->
	    if (StateS.is_empty (StateS.inter finalS sS)) then (* Not Final *)
	      `tree(initAnno,[((label:>'a tree_label), `app_exp(initAnno, List.assoc s s_f_list, vT))])
	    else (* Final *)
	      let (vG:'a variable)=`var (initAnno, ("$G"^(string_of_int(fresh())))) in
	      let ifExpr =
	      `ifcond(initAnno, `unary (initAnno, `IsEmpty, (vG:>'a value_expr)),
		      `tree(initAnno, [((label:>'a tree_label), `app_exp(initAnno, List.assoc s s_f_list, vT))]),
		      `tree(initAnno, [((label:>'a tree_label), rep_by)])) in
		`letvalue(initAnno, vG,test,ifExpr)
	| _ -> failwith "error in branch"
    in
      List.append [`branch(fname, `argument((label:>'a pat_label),vT), fbody)] bs
      
and branch_extend
    (fname:fun_name)
    (s_f_list:(state*fun_name) list)
    vL
    (#variable as vT)
    (test:'a template)
    (with_t:'a template)
    (finalS:StateS.t)
    (where:'a where)
    ((l,sS):(label_a*StateS.t))
    (bs:'a branch list) : 'a branch list =
  if StateS.is_empty sS then (* no transition for label l *)
    bs
  else
    let label = if l="_" then vL else (`label (initAnno,l)) in
    let (fbody:'a template) =
      match (StateS.elements sS) with
	| s::[] ->
	    if (StateS.is_empty (StateS.inter finalS sS)) then (* Not Final *)
	      `tree(initAnno, [((label:>'a tree_label), `app_exp(initAnno, List.assoc s s_f_list, vT))])
	    else (* Final *)
	      let (vG:'a variable)=`var (initAnno, ("$G"^(string_of_int(fresh())))) in
	      let rep_by =`expr (initAnno,{action=`query (initAnno, `union(initAnno, with_t, `app_exp(initAnno, List.assoc s s_f_list, vT)));
				       where=where}) in
	      let ifExpr =
	      `ifcond(initAnno, `unary (initAnno, `IsEmpty, (vG:>'a value_expr)),
		      `tree(initAnno, [((label:>'a tree_label), `app_exp(initAnno, List.assoc s s_f_list, vT))]),
		      `tree(initAnno, [((label:>'a tree_label), rep_by)])) in
		`letvalue(initAnno, vG,test,ifExpr)
	| _ -> failwith "error in branch"
    in
      List.append [`branch(fname, `argument((label:>'a pat_label),vT), fbody)] bs
      
      

(*
the following flatten is to apply flatten nested select into flat select
select {a: (select t1 where bs1 U select t2 where bs2)}
where bs3
==>
select {a:$v}
*)

(*
the following distributive is to apply distributive law to select
select t1 
where bc1,
      pat in (t2 U t3),
      bc2
==>
select t1
where bc1,
      pat in t2,
      bc2
U
select t1
where bc1,
      pat in t3,
      bc2
*)
let rec distributiveS_e (e:'a expr) : 'a expr = match e.action with
  | `query (_,t) ->
      let (bs_result,bs) = find_union ([], distributiveS_bs e.where) in 
	begin match bs with 
	  | [] -> (* not having union *)
	      e
	  | (`pat_in(p,`union (_,t1,t2)))::rest ->
	      let (select1:'a template)=`expr (initAnno, {action=`query (initAnno, distributiveS_t t); 
						       where=bs_result@[`pat_in(p,t1)]@rest}) in
	      let (select2:'a template)=`expr (initAnno, {action=`query (initAnno, distributiveS_t t); 
						       where=bs_result@[`pat_in(p,t2)]@rest}) in
		distributiveS_e {action=`query (initAnno, `union(initAnno, select1,select2)); where=[]}
	  | _ -> failwith "error"
	end 
  | _ -> failwith "after fst_desugaring we only have select: in distributiveS_e"

and find_union ((bs_result,bs):('a bcond list * 'a bcond list)) : ('a bcond list * 'a bcond list) = match bs with
  | []  -> (bs_result,bs)
  | (`pat_in(p,`union (_,t1,t2)))::rest -> 
      (bs_result,bs)
  | (#bind_cond as b)::rest | (#bool_cond as b)::rest ->
      find_union (bs_result@[b], rest)

and distributiveS_bs (bs:'a bcond list) : 'a bcond list = match bs with
  | [] -> []
  | (`pat_in(p,t))::rest ->
      [`pat_in(p,distributiveS_t t)]@(distributiveS_bs rest)
  | (#bool_cond as b)::rest ->
      [b]@(distributiveS_bs rest)

and distributiveS_t (t:'a template) : 'a template = match t with
  | `tree (a,tts) -> `tree (a,(List.map (fun(l,t) -> (l, distributiveS_t t)) tts))
  | #variable -> t
  | `expr (a,e) -> `expr (a, distributiveS_e e)
  | `union(a,t1,t2) -> `union(a,distributiveS_t t1,distributiveS_t t2)
  | `app_exp(a,f,t) -> `app_exp(a,f, distributiveS_t t)
  | `let_exp (a,d,t) -> `let_exp (a,distributiveS_d d,distributiveS_t t)            
  | `letrec_exp (a,ds,t) -> `letrec_exp (a,(List.map distributiveS_d) ds,distributiveS_t t) 
  | `template_list (a,ts) -> `template_list (a,List.map distributiveS_t ts)
  | `filter (a,bl,t) -> `filter (a,bl, distributiveS_t t)
  | `ifcond (a,bl,t1,t2) -> `ifcond (a,bl, distributiveS_t t1, distributiveS_t t2)
  | `letvalue (a,v,t1,t2) -> `letvalue (a,v,distributiveS_t t1,distributiveS_t t2)              
  | _ -> failwith "cannot apply distributiveS_t to internal UnQL"

and distributiveS_d (`def bs) = `def(List.map distributiveS_b bs)

and distributiveS_b (`branch(f,a,t)) = `branch(f,a,distributiveS_t t)

(* 
the following associativeS is to apply associative law to select with neseted where into flat select
select t1 
where bs1,
      pat in select t2 where bs2,
      bs3
=>
select t1
where bs1,
      bs2,
      pat in t2,
      bs3
*)
let rec associativeS_e (e:'a expr) : 'a expr = match e.action with
  | `query (_,t) -> 
      {action = `query (initAnno,associativeS_t t); where = associativeS_bs e.where;}
  | _ -> failwith "after fst_desugaring we only have select: in associativeS_e"

and associativeS_bs (bs:'a bcond list) : 'a bcond list = match bs with
  | [] -> []
  | (`pat_in(p,`expr (_,{action=`query (_,t'); where=bs'})))::rest -> 
      (associativeS_bs bs')@[`pat_in(p,t')]@(associativeS_bs rest)
  | (`pat_in(p,t))::rest -> 
      [`pat_in(p,associativeS_t t)]@(associativeS_bs rest)
  | (#bool_cond as b)::rest -> 
      [b]@(associativeS_bs rest)

and associativeS_t (t:'a template) : 'a template = match t with
  | `tree (a,tts) -> `tree (a,(List.map (fun(l,t) -> (l, associativeS_t t)) tts))
  | #variable -> t
  | `expr (a,e) -> `expr (a, associativeS_e e)
  | `union(a,t1,t2) -> `union(a, associativeS_t t1,associativeS_t t2)
  | `app_exp(a,f,t) -> `app_exp(a,f, associativeS_t t)
  | `let_exp (a,d,t) -> `let_exp (a,associativeS_d d,associativeS_t t)            
  | `letrec_exp (a,ds,t) -> `letrec_exp (a,(List.map associativeS_d) ds,associativeS_t t) 
  | `template_list (a,ts) -> `template_list (a, List.map associativeS_t ts)
  | `filter (a,bl,t) -> `filter (a,bl, associativeS_t t)
  | `ifcond (a,bl,t1,t2) -> `ifcond (a,bl, associativeS_t t1, associativeS_t t2)
  | `letvalue (a,v,t1,t2) -> `letvalue (a,v,associativeS_t t1,associativeS_t t2)              
  | _ -> failwith "cannot apply associativeS_t to internal UnQL"

and associativeS_d (`def bs) = `def(List.map associativeS_b bs)

and associativeS_b (`branch(f,a,t)) = `branch(f,a,associativeS_t t)


let rec snd_desugar (onlyletrec:bool) (withID:bool) (e:'a expr) : 'a expr = match e.action with
  | `query (a,t) -> 
      let e' = {e with action = `query(a, snd_desugar_t onlyletrec withID t)} in
	{action=`query(initAnno,q2let_exp onlyletrec withID e');
	 where=[]}
  | `extend_in (a,r,v,with_t,in_t) -> 
      let e' = {action = `extend_in(a,r,v, snd_desugar_t onlyletrec withID with_t,
				    snd_desugar_t onlyletrec withID in_t);
		where = e.where} in
	{action = `query(initAnno,extend2letrec onlyletrec withID e');
	 where=[]}
  | _ -> failwith "snd_desugar takes only `query : not apply fst desugar to edit expressions"
      
and snd_desugar_t (onlyletrec:bool) (withID:bool) (t:'a template) : 'a template = match t with
  | `tree (a,tts) -> `tree (a, (List.map (fun(l,t) -> (l, (snd_desugar_t onlyletrec withID) t)) tts))
  | #variable -> t
  | `expr (a,e) -> begin match e.action with
      | `query _ -> `expr(a, snd_desugar onlyletrec withID e)
      | `extend_in _ -> `expr(a, snd_desugar onlyletrec withID e)
      | _ -> failwith "snd_desugar_t takes select or extend_in"
    end
  | `union(a,t1,t2) -> `union(a,snd_desugar_t onlyletrec withID t1,snd_desugar_t onlyletrec withID t2)
  | `app_exp(a,f,t) -> `app_exp(a,f, snd_desugar_t onlyletrec withID t)
  | `let_exp (a,d,t) -> `let_exp (a, snd_desugar_d onlyletrec false d,snd_desugar_t onlyletrec withID t)
  | `letrec_exp (a,ds,t) -> `letrec_exp (a, (List.map (snd_desugar_d onlyletrec false)) ds,snd_desugar_t onlyletrec withID t)
  | `template_list (a,ts) -> `template_list (a,List.map (snd_desugar_t onlyletrec withID) ts)
  | `filter (a,bl,t) -> `filter (a, bl, snd_desugar_t onlyletrec withID t)
  | `ifcond (a,bl,t1,t2) -> `ifcond (a, bl, snd_desugar_t onlyletrec withID t1, snd_desugar_t onlyletrec withID t2)
  | `letvalue (a,v,t1,t2) -> `letvalue (a,v,snd_desugar_t onlyletrec withID t1,snd_desugar_t onlyletrec withID t2)
  | `i_marker(a,m,t) -> `i_marker(a,m,snd_desugar_t onlyletrec withID t)
  | `o_marker(a,m) -> `o_marker(a,m)
  | `graph_empty a -> `graph_empty a
  | `graph_union(a,t1,t2) -> `graph_union(a,snd_desugar_t onlyletrec withID t1,snd_desugar_t onlyletrec withID t2)
  | `graph_append(a,t1,t2) -> `graph_append(a,snd_desugar_t onlyletrec withID t1,snd_desugar_t onlyletrec withID t2)
  | `graph_cycle (a,t) -> `graph_cycle (a,snd_desugar_t onlyletrec withID t)
  | `srec(a,f,t) -> `srec(a,f,snd_desugar_t onlyletrec withID t)
      
and snd_desugar_d (onlyletrec:bool) (withID:bool) (`def bs) = `def (List.map (snd_desugar_b onlyletrec withID) bs)

and snd_desugar_b (onlyletrec:bool) (withID:bool) (`branch(f,a,t)) = `branch(f,a,snd_desugar_t onlyletrec withID t)


(* q2let_exp is to transform select-where style expressions to structural recursion with filter and *)
(* rule A: select e where ({PE:T} in e', rest ) -> let sfun h({PE:T}) = (select e where rest) in h(e')
   rule B: select e where (Var in e', rest)     -> letval Var := e' in (select e where rest) 
   rule C: select e where (BoolCond, rest)      -> filter (BoolCond, (select e where rest))
   rule D: select e where ()                    -> e

 rule B is for our extension
*)

and q2let_exp (onlyletrec:bool) (withID:bool) (e:'a expr) : 'a template =  match e.where with
  | `pat_in (p,(#template as t))::bs -> (* bind_cond -> let_exp *)
      let fname = "h"^(string_of_int (fresh())) in
	begin match p with
	  | `tree [(patlabel,pattern)] -> (* rule A: {patlabel:pattern} in t *)
	      (match patlabel with
                 | #variable | `label_const _  |`label _ -> (* let_exp: `label needs to join this branch *)
		     if onlyletrec then (* this branch is for letrec_exp *)
		     `letrec_exp
		       (initAnno, 
			[`def
			   [`branch
			      (`fun_name fname,
			       `argument (patlabel,pattern),
			       q2let_exp onlyletrec withID {e with where=bs}
			      )
			   ]],
			`app_exp (initAnno, (`fun_name fname), snd_desugar_t onlyletrec withID t)
		       )
		     else 
		     `let_exp
		       (initAnno,
			`def
			  [`branch
			     (`fun_name fname,
			      `argument (patlabel,pattern),
			      q2let_exp onlyletrec withID {e with where=bs}
			     )
			  ],
			`app_exp (initAnno, (`fun_name fname), snd_desugar_t onlyletrec withID t)
		       )
		 | #rpp as r -> (* {rpp:pattern} in t -> letrec *)
		     (match pattern with
			| (#variable as v1) ->
(* 			    let m:non_eps_nfa=rpp2non_eps_nfa r in *)
			    let m:non_eps_nfa=(dfa2non_epsilon_nfa (minDFA (non_eps_nfa2dfa(rpp2non_eps_nfa r)))) in
			    let repT = q2let_exp onlyletrec withID {e with where=bs} in
			    let (desugared_t:'a template) = snd_desugar_t onlyletrec withID t in
			      if StateS.mem m.n_init m.n_final then
				let (vG:'a variable) = `var (initAnno, ("$G"^(string_of_int (fresh())))) in
				let (result2:'a template) = non_eps_nfa2letrec (vG:>'a template) m withID repT v1 in
				let (result1:'a template) = replace_t_t1_by_t2 v1 (vG:>'a template) repT in
				let (union12:'a template) = `union(initAnno, result1,result2) in
				  `letvalue (initAnno, vG, desugared_t, union12)
			      else 
				non_eps_nfa2letrec desugared_t m withID repT v1
			| `tree _ ->
			    failwith "{rpp: `tree } in q2let_exp, Not applied fst_desugar"			    
			| const ->
			    failwith "{rpp: const } in q2let_exp, Not applied fst_desugar"			    
		     )			    
	      )      
	  | `tree _ ->
	      failwith "{PE1:Pat1,...,PEN:PatN} in t, or {} in t  Not applied fst_desugar in rule 1,2"
	  | #variable as v1 -> (* rule B Var in t *)
	      `letvalue(initAnno, v1, snd_desugar_t onlyletrec withID t, (q2let_exp onlyletrec withID {e with where=bs}))
	  | #const ->
	      failwith "{PE:const} in t: not applied fst_desugar"
	end
  | (#bool_cond as bc)::bs -> (* rule C bool_cond -> filter *)
      `filter (initAnno, bc, (q2let_exp onlyletrec withID {e with where=bs}))
  |[] -> (* rule D *)
     match e.action with
       | `query (_,t) -> snd_desugar_t onlyletrec withID t
       | `extend_in (a,r,v,with_t,in_t) -> snd_desugar_t onlyletrec withID with_t
(*        | `replace_in (r,tgt,by_t,in_t) -> by_t *)
       | _ -> failwith "q2let_exp: not implemented yet"
           
and extend2letrec (onlyletrec:bool) (withID:bool) (e:'a expr) : 'a template = match e.action with
  | `extend_in(a,r,v,with_t, in_t) -> begin match v with 
      | (#variable as vT) -> 
	  let m:non_eps_nfa=(dfa2non_epsilon_nfa (minDFA (non_eps_nfa2dfa(rpp2non_eps_nfa r)))) in
	  let repT = q2let_exp onlyletrec withID e in
	    if StateS.mem m.n_init m.n_final then
	      let (vG:'a variable) = `var (initAnno, ("$G"^(string_of_int (fresh())))) in
	      let (result2:'a template) = non_eps_nfa2letrec_extend (vG:>'a template) m withID repT vT in
	      let (result1:'a template) = replace_t_t1_by_t2 vT (vG:>'a template) repT in
	      let (union12:'a template) = `union(initAnno,result1,result2) in
		`letvalue (initAnno, vG, in_t, union12)
	    else 
	      non_eps_nfa2letrec_extend in_t m withID repT vT
      | `tree (l,v) -> failwith "not implemented for rpp->{label:var} in EXTEND"
      | `under(_,_,_) -> failwith "not implemented for UNDER constructs in EXTEND"
  end
  | _ -> failwith "etend2letrec only takes EXTEND"

and non_eps_nfa2letrec_extend (t1:'a template) (m:non_eps_nfa) (with_id:bool) (t:'a template) (vT:'a variable) :'a template =
  let (state_fname_list:((state*fun_name) list)) = StateS.fold make_funname m.stateS ([]:(state*fun_name) list) in
  let vL=`var (initAnno, ("$L"^(string_of_int (fresh())))) in
  let repT = replace_t with_id vT vT vL t in
  let def_list = TransS.fold (def4extend m state_fname_list vL vT with_id repT) m.transS ([]:'a definition list) in
    `letrec_exp(initAnno, def_list, 
		`app_exp(initAnno, List.assoc m.n_init state_fname_list, t1))

and def4extend 
    (m:non_eps_nfa) 
    (s_f_list:((state*fun_name) list)) 
    vL 
    (#variable as vT) 
    (with_id:bool) 
    (repT:'a template)
    ((s,setofl_sS):Trans.t) 
    (ds:'a definition list) =
  let fname=List.assoc s s_f_list in 
  let branch_list=L_sS.fold (branch4extend fname s_f_list vL vT with_id m.n_final repT) setofl_sS ([]:'a branch list) in
    if has_any branch_list fname (`argument ((vL:>'a pat_label),vT)) then 
      List.append [`def branch_list] ds 
    else 
      List.append [`def (branch_list@[`branch(fname, `argument ((vL:>'a pat_label), vT), 
					      `tree (initAnno,[(vL:>'a tree_label),(vT:>'a template)]))])] ds 

and branch4extend 
    (fname:fun_name) 
    (s_f_list:(state*fun_name) list) 
    vL 
    (#variable as vT) 
    (with_id:bool) 
    (finalS:StateS.t)
    (repT:'a template)
    ((l,sS):(label_a*StateS.t))
    (bs:'a branch list) =
  if StateS.is_empty sS then (* no transition for label l *)
    bs
  else 
    let not_final = (StateS.is_empty (StateS.inter finalS sS)) in
    let (fbody:'a template)=
      let rec f_body = function
	| s::[] ->
	    if not_final then (* not include final state*)
	      `app_exp(initAnno, List.assoc s s_f_list, vT)
	    else (* include final state *)
	      if with_id then
		`union(initAnno,`app_exp (initAnno, List.assoc s s_f_list, vT), repT)
	      else 
		`union(initAnno,`app_exp (initAnno, List.assoc s s_f_list, vT), repT)
	| s::rest ->
	    `union(initAnno,`app_exp(initAnno, List.assoc s s_f_list, vT), (f_body rest))
	| [] ->  
	    failwith "cannot make function body in function_body"
      in f_body (StateS.elements sS) 
    in
      if l="_" then (* `any *)
	List.append [`branch(fname, `argument((vL:>'a pat_label),vT), (`tree(initAnno,[((vL:>'a tree_label),fbody)]):>'a template))] bs 
      else 
	List.append [`branch(fname, `argument(`label (initAnno,l),vT), (`tree(initAnno,[((`label (initAnno,l):>'a tree_label),fbody)]):>'a template))] bs 


and snd_desugar_i (e:'a expr) =
  snd_desugar false true e

and desugar (e:'a expr) : 'a expr =
  snd_desugar false true (fst_desugar false e)

and desugar_i (e:'a expr) : 'a expr =
  snd_desugar false false (fst_desugar false e)




and desugar_letrec (e:'a expr) : 'a expr =
  snd_desugar true false (fst_desugar false e)

and desugar_with_id (with_id:bool) (e:'a expr) : 'a expr =
  if with_id then (* caution !! *)
    desugar e
  else
    desugar_i e













(**********************************************************************)
(* The following one_pass_expr is developed for the open-nii project. *)
(**********************************************************************)
(* one_pass_expr takes the following as input               *)
(* SELECT unql+ WHERE bind_cond list                        *)
(* where, unql+ is extend/replace/delete without where-exp. *)

(* A typical input exp. for one_pass_expr is *)
(* SELECT                                   *)
(*   (EXTEND tl.tl -> $u3 WITH {hd:$s3} IN  *)
(*    (EXTEND tl.hd -> $u1 WITH {S2:{}} IN  *)
(*     (DELETE tl.hd.tl -> $u IN $db)))     *)
(* WHERE                                    *)
(*   {tl.hd:$s3} IN $db                     *)

type editType = [       
  | `replace            (* REPLACE rpp -> {label:$v} BY t IN ... *)
  | `replace_with_label (* REPLACE rpp -> $v BY t IN ...*)
  | `extend             (* EXTEND rpp -> {label:$v} WITH t IN ... *)
  | `extend_with_label  (* EXTEND rpp -> $v WITH t IN ... *)
  | `select
(* delete editting is transfromed into replace editting in e2r_t *)
]

and 'a action_tree = [
| `atree of ('a label * 'a action_tree * bool * (editType*'a template) list) list
| `leaf 
]

let leaf = -1
type 'a a_edge = (int * ('a label * int * bool * (editType*'a template) list) list)
type 'a alist = 'a a_edge list  
let (empty_g:'a template) = `tree (initAnno, [])

(* type 'a const_label = [ *)
(* | `label_const of 'a const *)
(* ] *)

(* type 'a rpp_c = [ *)
(* | 'a rpp *)
(* | `concat of 'a rpp * 'a const_label *)
(* ] *)



let rec one_pass_expr (e: 'a expr) : 'a expr = 
  let (e1, where) = match e.action with
    | `query (_, `expr(_, e1)) -> (e1, e.where)
    | _ -> failwith "not select-exp. in one_pass_expr"
  in
  let (es:'a expr list) = e2es e1 [] in
  let (r_ts:('a rpp * editType * 'a template) list) = es2r_ts es in
  let (ats:'a action_tree list) = r_ts2ats r_ts in 
  let (at:'a action_tree) = ats2at ats in
  let (ts:'a alist) = atree2alist at (fresh()) in
  let (edit_t:'a template) = alist2letrec ts in
  let (result_t:'a template) = one_pass_sr where edit_t in
    sr2expr result_t

and one_pass_sr (bs:'a bcond list) (t:'a template) : 'a template = match bs with
  | [] -> t
  | (#bind_cond as b)::rest -> `letvalue (initAnno, fst (b2v_t b), snd (b2v_t b), (one_pass_sr rest t))
  | (#bool_cond as b)::[] -> t
  | _ -> failwith "not bind_cond in one_pass_sr"

and b2v_t (`pat_in (p,t):'a bind_cond) : ('a variable*'a template) = match p with
  | `tree pps -> begin match (pps, t) with 
      | ([`concat (_,_) as r, (#variable as v)], (`database _ as inputdb)) -> 
	  if all_concat r then
	    let right_deep_r = normr r in
	    let (vL,vT) = (`var (initAnno, ("$L"^(string_of_int (fresh())))),`var (initAnno, ("$G"^(string_of_int (fresh()))))) in	      
	      begin match fun_name_list right_deep_r with
		| (f::fs) -> 
		    let (ds:'a definition list)= r_deep2ds4select right_deep_r (f::fs) vL vT in
		      (v, `letrec_exp(initAnno, ds, `app_exp(initAnno, f, inputdb)))
		| [] -> failwith "rpp is empty in b2v_t"
	      end 
	   else 
	     failwith "not all concat in b2v_t"
      | _ -> failwith "not concat or not $db in b2v_t"
    end 
  | _ -> failwith "not `tree pps in b2v_t"

and r_deep2ds4select (r:'a rpp) (fs:fun_name list) vL vT : 'a definition list = match (r,fs) with
  | ((`label _ as l), f::[]) -> [`def ([`branch(f, 
						(`argument (vL, vT):>'a argument), 
						`ifcond (initAnno, 
							 `binary(initAnno,`EQ,(vL:>'a value_expr), (l:>'a value_expr)),
							 (vT:>'a template),
							 empty_g))])]
  | (`concat((`label _ as l),r'), f::f'::rest) -> 
      List.append 
	[`def ([`branch(f,
			(`argument (vL, vT):>'a argument), 
			`ifcond (initAnno, 
				 `binary(initAnno,`EQ,(vL:>'a value_expr), (l:>'a value_expr)),
				 `app_exp(initAnno, f', (vT:>'a template)),
				 empty_g))])]
	(r_deep2ds4select r' (f'::rest) vL vT)
      | _ -> failwith "not all concat nor $db in "

and fun_name_list (r:'a rpp) : fun_name list = match r with
  | `label _  -> [`fun_name("h"^(string_of_int(fresh())))]
  | `concat(`label _ , r') -> List.append [`fun_name("h"^(string_of_int(fresh())))] (fun_name_list r')
  | _ -> failwith "not all concat in fun_name_list"
  
and e2es (expr:'a expr) (expr_list:'a expr list) : 'a expr list =
  let (e1, es1) =
    let rec e2list (e:'a expr) (es:'a expr list) : ('a expr*'a expr list) =
      match e.action with
	| `delete_in (_,_,_,in_t) 
	| `extend_in (_,_,_,_,in_t) 
	| `replace_in (_,_,_,_,in_t) ->
	    let new_es = List.append [e] es in
	      begin match in_t with
		| `expr (_,e') -> e2list e' new_es
		| #variable  -> (e,new_es)
		| _  -> failwith "not expr nor variable in in_t in e2list"
	      end
	| _ -> failwith "not UnQL+ in e2list"
    in e2list expr []
  in es1

and e_from_q (e:'a expr) : 'a expr =
  match e.action with
    | `query(_,t) -> 
	begin match t with
	  | `expr (_,e') -> e'
	  | _ -> failwith "not expr in e_from_q"
	end 
    | _ -> failwith "not query in e_from_q" 
	
and es2r_ts (es:'a expr list) : ('a rpp * editType * 'a template) list =
  List.fold_right (fun e es' -> (e2r_t e)::es')  es []

and get_last (r:'a rpp) : 'a label =
  match r with 
    | #label as l -> l
    | `concat (`label l, r') -> 
	get_last r'
    | `concat (`any, r') -> 
	get_last r'
    | _ -> failwith "not right_deep_r in get_last"


and e2r_t (e:'a expr) : ('a rpp * editType * 'a template) =
  match e.action with
    | `replace_in (a,r,tgt,by_t,in_t) -> 
	if all_concat r then
	  begin match tgt with
	    | #variable -> 
		let right_deep_r = normr r in 
		  (right_deep_r, `replace_with_label, by_t)
	    | `tree(((`label _) as label'), _) -> 
		let (r1:'a rpp) =  `concat (r,label') in 
		  (normr r1, `replace, by_t)
	    | `tree _ -> failwith "not implement for REPLACE rpp->{xxx:var} in e2r_t"
	    | `under _ -> failwith "not implement for REPLACE ... UNDER constructs in e2r_t"
	  end 
	else failwith "not all concat in rpp in e2r_t"
    | `delete_in (a,r,tgt,in_t) -> 
	if all_concat r then
	  begin match tgt with
	    | #variable -> 
		let right_deep_r = normr r in 
		  (right_deep_r,`replace_with_label,(`tree(initAnno,[]):>'a template))
	    | `tree(((`label _) as label'), _) -> 
		let (r1:'a rpp) =  `concat (r,label') in 
		  (normr r1, `replace, (`tree(initAnno,[]):>'a template))
	    | `tree _ -> failwith "not implement for DELETErpp->{xxx:var} in e2r_t"
	    | `under _ -> failwith "not implement for DELETE ... UNDER constructs in e2r_t"
	  end 
	else failwith "not all concat in rpp in e2r_t"
    | `extend_in (a,r,tgt,with_t,in_t) -> 
	if all_concat r then
	    begin match tgt with
	      | #variable -> 
		  let right_deep_r = normr r in 
		    (right_deep_r, `extend_with_label, with_t)
	      | `tree(((`label _) as label'), _) -> 
		  let (r1:'a rpp) =  `concat (r,label') in 
		    (normr r1, `extend, with_t)
	      | `tree _ -> failwith "not implement for rpp->{xxx:var} in e2r_t"
	      | `under _ -> failwith "not implement for UNDER constructs in e2r_t"
	    end 
	else failwith "not all concat in rpp in e2r_t"
    | _ -> failwith "not replace_in in e2r_t"

and r_ts2ats (r_ts:('a rpp * editType * 'a template) list) : 'a action_tree list =
  List.map atree r_ts 

and atree ((r,etype,t):('a rpp * editType * 'a template)) : 'a action_tree =
  let rec rpp2at (r1:'a rpp) : ('a action_tree) = match r1 with
    | `concat ((`label _ as label1),(`label _ as label2)) -> 
	`atree([label1,`atree([label2,`leaf,true,[(etype,t)]]),false,[]])
    | `concat ((`label (a1, l1) as label1),((`concat _ ) as c)) ->
	`atree([(label1, rpp2at c, false, [])])
    | (`label _ as label1) ->
	`atree([label1,`leaf,true,[(etype,t)]])
    | _ -> failwith "rpp does not all concat in r2at"
  in rpp2at r 


and ats2at (ats:'a action_tree list) : 'a action_tree = 
  List.fold_right margeAtree ats `leaf 

(* margeAtree: merge t1 on t2  *)
and margeAtree (t1:'a action_tree) (t2:'a action_tree) : 'a action_tree = match t2 with 
  | `leaf -> t1
  | `atree _ -> mrgAt t1 t2
and mrgAt (t1:'a action_tree) (t2:'a action_tree) : 'a action_tree = 
  match (t1,t2) with
    | (`atree(s1),`atree(ss)) -> begin  match s1 with 
	| s::[] -> `atree (mrgAtH s ss)
	| _ -> failwith "s1 is not singleton in mrgAt"
      end 
    | _ -> failwith "not atree atree in mrgAt"
and mrgAtH ((label1,a1,b1,ts1):('a label*'a action_tree*bool* (editType*'a template) list)) ss = 
    match ss with
  | ((label2, a2, b2,ts2) as s)::rest -> 
      if label1 = label2 then begin match (a1,b1,a2,b2) with
	| (`leaf,_,`leaf,_) -> 
	    List.append [(label2, a2, true, List.append ts1 ts2)] rest 
	| (`atree _, true, `leaf, _) ->
	    List.append [(label2, a1, true, List.append ts1 ts2)] rest 
	| (`atree _, false, `leaf, _) ->
	    List.append [(label2, a1, true, ts2)] rest 
	| (`leaf, _, `atree _, true) ->
	    List.append [(label2, a2, true, List.append ts1 ts2)] rest 
	| (`leaf, _, `atree _, false) ->
	    List.append [(label2, a2, true, ts1)] rest 
	| (`atree _, true, `atree _, true) ->
	    List.append [(label2, mrgAt a1 a2, true, List.append ts1 ts2)] rest 
	| (`atree _, true, `atree _, false) ->
	    List.append [(label2, mrgAt a1 a2, true, ts1)] rest 
	| (`atree _, false, `atree _, true) ->
	    List.append [(label2, mrgAt a1 a2, true, ts2)] rest 
	| (`atree _, false, `atree _, false) ->
	    List.append [(label2, mrgAt a1 a2, false, ts1)] rest 
      end 
      else 
	List.append [s] (mrgAtH (label1,a1,b1,ts1) rest)
  | [] -> [(label1,a1,b1,ts1)]

and atree2alist (t:'a action_tree) (i:int) : 'a alist = match t with
  | `atree (es)  ->  ss2list es i
  | `leaf -> []
and ss2list (es:('a label*'a action_tree*bool*(editType*'a template) list) list) (i:int) : 'a a_edge list = 
  let t_als = List.map edge2s es in 
  let (ts, als) = List.split t_als in 
    List.append [(i,ts)] (List.flatten als)
and edge2s ((l,t,b,es):('a label*'a action_tree*bool*(editType*'a template) list)) : (('a label*int*bool*(editType*'a template) list) * 'a a_edge list) =
  match t with
    | `leaf ->
	  ((l,leaf,b,es),[]) 
    | `atree _ -> 
	let i = fresh() in 
	let rest = atree2alist t i in
	((l,i,b,es),rest)
	  

and alist2letrec (ts:'a alist) : 'a template =
  let (vL,vT) = (`var (initAnno, ("$L"^(string_of_int (fresh())))),`var (initAnno, ("$G"^(string_of_int (fresh()))))) in
  let (root, _) = List.hd ts in 
  let (apply_sfun:fun_name) = `fun_name("h"^(string_of_int(root))) in 
  let (input_db:'a template) = `database initAnno in 
  let (def_list:'a definition list) = List.fold_right (def41pass vL vT) ts ([]:'a definition list) in
    `letrec_exp(initAnno, def_list, 
		`app_exp(initAnno, apply_sfun, input_db))
and def41pass vL vT ((current,ss):'a a_edge) (ds:'a definition list) : 'a definition list =
  let fname = `fun_name("h"^(string_of_int(current))) in 
  let branch = branch41pass fname vL vT ss in 
    List.append [`def [branch]] ds

and branch41pass (fname:fun_name) vL vT (ss :('a label*int*bool*(editType*'a template) list) list): 'a branch = 
  let (last_t:'a template) = `tree (initAnno, [((vL:>'a tree_label),(vT:>'a template))]) in 
    `branch(fname, (`argument (vL, vT):>'a argument), ifexpr_from_ss vL vT last_t ss)

and ifexpr_from_ss vL vT last_t ss : 'a template = match ss with 
  | [] -> last_t
  | (l,next,b,ts)::rest -> `ifcond (initAnno, 
				    `binary(initAnno,`EQ,(vL:>'a value_expr), (l:>'a value_expr)),
				    (then_from_s (l,next,b,ts) vL vT),  
				    ifexpr_from_ss vL vT last_t rest)
and then_from_s ((l,next,b,ts):('a label*int*bool*(editType*'a template) list)) vL vT : 'a template = 
  let nextfun = `fun_name("h"^(string_of_int(next))) in
  if b then 
    let new_ts =
      let rec refine_ts (ts:(editType*'a template) list) : (editType*'a template) list = match ts with
	  (*    | t::[] -> ts *)
	| (_, _)::(`replace, t)::rest -> refine_ts ((`replace,t)::rest)
	| (_, _)::(`replace_with_label, t)::rest -> refine_ts ((`replace_with_label,t)::rest)
	| (`extend, t1)::(`extend,t2)::rest -> refine_ts ((`extend, `union(initAnno, t1, t2))::rest)
	| (`extend_with_label, t1)::(`extend_with_label,t2)::rest -> refine_ts ((`extend_with_label, `union(initAnno, t1, t2))::rest)
	| (`replace, t1)::(`extend, t2)::rest ->  refine_ts ((`replace, `union(initAnno, t1, t2))::rest)
	| (`replace_with_label, t1)::(`extend_with_label, t2)::rest ->  refine_ts ((`replace_with_label, `union(initAnno, t1, t2))::rest)
(* 	| (`replace_with_label, t1)::(`extend_with_label, t2)::rest ->  refine_ts ((`replace, `tree(initAnno, [((l:>'a tree_label), `union(initAnno, t1, t2))]))::rest) *)
	| _  -> ts
      in refine_ts ts
    in begin match new_ts with
      | (etype,t)::[] ->
	  if etype = `replace then
	    t
	  else if etype=`replace_with_label then
	    `tree(initAnno,[((vL:>'a tree_label),t)])
	  else if etype=`extend_with_label then
	    if next=leaf then
	      `tree(initAnno,[((vL:>'a tree_label),`union (initAnno,(vT:>'a template),t))])
	    else (* intemediate nodes *)
	      `tree(initAnno,[((vL:>'a tree_label),`union (initAnno,`app_exp(initAnno, nextfun, (vT:>'a template)),t))])
	  else if etype = `extend then (* etype = `extend *)
	    if next=leaf then
	      `union (initAnno,(vT:>'a template),t)
	    else (* intemediate nodes *)
				   `union (initAnno,`app_exp(initAnno, nextfun, (vT:>'a template)),t)
	  else (* etype = `select *)
	    failwith "etype=`select in then_form_s" 
      | _ -> failwith "not implemented multiple editting on single node in action trees, in branch41pass"
	  
      end
  else
    `tree(initAnno, [((vL:>'a tree_label), `app_exp(initAnno, nextfun, (vT:>'a template)))])

and sr2expr (t:'a template) : 'a expr = 
  {action=`query(initAnno, t);
   where=[]}

(**************************************)
(* The follwoing is for labeled sfun. *)
(**************************************)

(* let alist2letrec (ts:'a alist) : 'a template = *)
(*   let (vL,vT) = (`var (initAnno, ("$L"^(string_of_int (fresh())))),`var (initAnno, ("$G"^(string_of_int (fresh()))))) in *)
(*   let (root, _) = List.hd ts in  *)
(*   let (apply_sfun:fun_name) = `fun_name("h"^(string_of_int(root))) in  *)
(*   let (input_db:'a template) = `database initAnno in  *)
(*   let (def_list:'a definition list) = List.fold_right (def41pass vL vT) ts ([]:'a definition list) in *)
(*     `letrec_exp(initAnno, def_list,  *)
(* 		`app_exp(initAnno, apply_sfun, input_db)) *)
(* and def41pass vL vT ((current,ss):'a a_edge) (ds:'a definition list) : 'a definition list = *)
(*   let fname = `fun_name("h"^(string_of_int(current))) in  *)
(*   let branch_list = List.fold_right (branch41pass fname vL vT) ss ([]:'a branch list) in *)
(*     List.append [`def (branch_list@[`branch(fname, (`argument (vL, vT):>'a argument), `tree (initAnno, [((vL:>'a tree_label),(vT:>'a template))]))])] ds *)

(* and branch41pass (fname:fun_name) vL vT ((l,next,b,ts):('a label*int*bool*(editType*'a template) list)) (bs:'a branch list) : 'a branch list =  *)
(*   let nextfun = `fun_name("h"^(string_of_int(next))) in   *)
(*     if b then  *)
(*     let new_ts =  *)
(*       let rec refine_ts (ts:(editType*'a template) list) : (editType*'a template) list = match ts with *)
(* 	  (\*    | t::[] -> ts *\) *)
(* 	| (_, _)::(`replace, t)::rest -> refine_ts ((`replace,t)::rest) *)
(* 	| (_, _)::(`replace_with_label, t)::rest -> refine_ts ((`replace_with_label,t)::rest) *)
(* 	| (`extend, t1)::(`extend,t2)::rest -> refine_ts ((`extend, `union(initAnno, t1, t2))::rest) *)
(* 	| (`extend_with_label, t1)::(`extend_with_label,t2)::rest -> refine_ts ((`extend_with_label, `union(initAnno, t1, t2))::rest) *)
(* 	| (`replace, t1)::(`extend, t2)::rest ->  refine_ts ((`replace, `union(initAnno, t1, t2))::rest) *)
(* 	| (`replace_with_label, t1)::(`extend_with_label, t2)::rest ->  refine_ts ((`replace, `tree(initAnno, [((l:>'a tree_label), `union(initAnno, t1, t2))]))::rest) *)
(* 	| _  -> ts *)
(*       in refine_ts ts  *)
(*     in  *)
(*       match new_ts with *)
(* 	| (etype,t)::[] ->  *)
(* 	    if etype = `replace then   *)
(* 	      	List.append [`branch(fname, *)
(* 				     `argument((l:>'a pat_label),(vT:>'a pattern)), *)
(* 				     t)] *)
(* 		  bs *)
(* 	      else if etype=`replace_with_label then *)
(* 	      	List.append [`branch(fname, *)
(* 				     `argument((l:>'a pat_label),(vT:>'a pattern)), *)
(* 				     `tree(initAnno,[((l:>'a tree_label),t)]))] *)
(* 		  bs *)
(* 	      else if etype=`extend_with_label then *)
(* 		if next=leaf then  *)
(* 		  List.append [`branch(fname, *)
(* 				       `argument((l:>'a pat_label),(vT:>'a pattern)), *)
(* 				       `tree(initAnno,[((l:>'a tree_label),`union (initAnno,(vT:>'a template),t))]))] *)
(* 		    bs  *)
(* 		else (\* intemediate nodes *\) *)
(* 		  List.append [`branch(fname, *)
(* 				       `argument((l:>'a pat_label),(vT:>'a pattern)), *)
(* 				       `tree(initAnno,[((l:>'a tree_label),`union (initAnno,`app_exp(initAnno, nextfun, (vT:>'a template)),t))]))] *)
(* 		    bs  *)
(* 	      else (\* etype = `extend *\) *)
(* 		if next=leaf then  *)
(* 		  List.append [`branch(fname, *)
(* 				       `argument((l:>'a pat_label),(vT:>'a pattern)), *)
(* 				       `union (initAnno,(vT:>'a template),t))] *)
(* 		    bs *)
(* 		else (\* intemediate nodes *\) *)
(* 		  List.append [`branch(fname, *)
(* 				       `argument((l:>'a pat_label),(vT:>'a pattern)), *)
(* 				       `union (initAnno,`app_exp(initAnno, nextfun, (vT:>'a template)),t))] *)
(* 		    bs *)
(* 	  | _ -> failwith "not implemented multiple editting on single node in action trees, in branch41pass" *)
(*   else  *)
(*       List.append [`branch(fname, *)
(* 			   `argument((l:>'a pat_label),(vT:>'a pattern)), *)
(* 			   `tree(initAnno, [((l:>'a tree_label), `app_exp(initAnno, nextfun, (vT:>'a template)))]))] *)
(* 	bs *)


