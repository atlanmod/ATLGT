(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
(**
 Wrapper of Set/Map module for better interface 
 *)

open Format
open Print

(* pretty printer *)
module SetAux = struct
  module type OrderedType = sig type t val compare : t -> t -> int end
  module type S = sig 
    include Set.S

    (** pretty printer with (user-specified) set name *)	
    val pp_t :
      string -> (Format.formatter -> elt -> unit) -> Format.formatter -> t -> unit

    (** pretty printer *)	
    val pr :    (Format.formatter -> elt -> unit) -> Format.formatter -> t -> unit

    val addl :       elt list -> t -> t (** adding list of elements *)
    val unionl :       t list -> t -> t (** unify  list of elements *)
    val map :    (elt -> elt) -> t -> t (** apply function on each element *)
    val setmap : (elt -> t)   -> t -> t (** union results of function application on each element *)
    val fromList :  elt list       -> t (** conversion from list to set *)
    val fromLSet :  t   list       -> t (** conversion from list of set to set *)
    val hom : ('a -> 'a -> 'a) -> 'a -> (elt -> 'a) -> t -> 'a (** homomorphism to monoid *)
    val hom1 : ('a -> 'a -> 'a) -> (elt -> 'a) -> t -> 'a (** homomorphism to monoid (without zero) *)
    val maptoList : (elt -> 'a) -> t -> 'a list (** map to list *)
  end
  module Make(Ord:OrderedType) : S with type elt = Ord.t
  = struct
    module S = Set.Make(Ord)
    include S
    let pp_t set_name pp_elt fmt set =
      fprintf fmt "@[<2>%s{@," set_name;
      ignore (S.fold (fun elt is_fst ->
                        if is_fst then pp_elt fmt elt
                        else fprintf fmt ",@,%a" pp_elt elt;
                        false) set true);
      fprintf fmt "}@]"
    let pr pr_data ppf s =
      fprintf ppf "{@[%a@]}" (pp_list pr_data) (S.elements s)
    let addl             = List.fold_right S.add
    let unionl           = List.fold_right S.union
    let map    f     set = S.fold (fun x -> S.add   (f x)) set S.empty
    let setmap f     set = S.fold (fun x -> S.union (f x)) set S.empty
    let fromList lst     = addl   lst S.empty
    let fromLSet lst     = unionl lst S.empty
    let rec hom bin zero sing = function
	[]      -> zero
      | [x]     -> sing x
      | (x::xs) -> bin (sing x) (hom bin zero sing xs)
    let hom bin zero sing s = hom bin zero sing (S.elements s)
    let rec hom1 bin sing = function
      | [x]     -> sing x
      | (x::xs) -> bin (sing x) (hom1 bin sing xs)
      | []      -> failwith "hom1: empty set"
    let hom1 bin sing s = hom1 bin sing (S.elements s)
    let cons x y = (x::y) (* to get sectioned version *)
    let (@@) f g x =  f (g x) (* function composition *)
    let maptoList f s = S.fold (fun e -> cons (f e)) s []
  end
end


module MapAux = struct
  module type S = sig
    include Map.S
    module Ord' : Map.OrderedType
    val find_some : key -> 'a t -> 'a option
    val pp_t :
      string -> (Format.formatter -> key -> unit) ->
      (Format.formatter -> 'a -> unit) ->
      Format.formatter -> 'a t -> unit
    val pr :    (Format.formatter -> key -> unit) -> 
      (Format.formatter -> 'a -> unit) -> 
      Format.formatter -> 'a t -> unit

    (** [update f key map] updates value [v] of key [key] in a map [map] with [f v] *)
    val update : ('a -> 'a) -> key -> 'a t -> 'a t

    (** add entries from a list of key-value pairs  *)
    val addl : (key * 'a) list -> 'a t -> 'a t 
    val unionl :   ('a->'a->bool)-> 'a t list -> 'a t -> 'a t (** unify  list of maps *)
    val fromLMap : ('a->'a->bool)-> 'a t list         -> 'a t (** conversion from list of maps to map *)
    val fromList : (key * 'a) list -> 'a t (** create a map from a list of key-value pairs *)

    (** [uadd sng cons key v m] registers (cons v ent) assuming ent 
       as the previous value associated with key. If ent is not
       found, then (sng v) is registered instead. *)
    val uadd : ('b -> 'a) -> ('b -> 'a -> 'a) -> key -> 'b -> 'a t -> 'a t
    val invert : key t -> key t  (** invert map (injectivity not checked) *)
    val compose : key t -> 'a t -> 'a t (** compose two maps (composability not checked) *)
    (* val compositional : (module Set.S with type elt = key and type t = 'a) -> key t -> key t -> bool *)
    val compositional : key t -> key t -> bool     (** checks composability of two maps *)
    val injective : key t -> bool (** check injectivity *)
    val disjoint_union : 'a t -> 'a t -> 'a t (** union with key overlapping check *)
    val union :('a -> 'a -> bool) -> 'a t -> 'a t -> 'a t (** union        with consistency check *)
    val inter :('a -> 'a -> bool) -> 'a t -> 'a t -> 'a t (** intersection with consistency check *)
    val diff : ('a -> 'a -> bool) -> 'a t -> 'a t -> 'a t (** difference   with consistency check *)
  end
  module Make(Ord:Map.OrderedType) : S with type key = Ord.t
  = struct
    module M = Map.Make(Ord)
    include M
    module Ord' = Ord (* export Ord module to reuse the comparison function *)
    let find_some key t = try Some(M.find key t) with Not_found -> None
    let pp_t map_name pp_key pp_a fmt map =
      fprintf fmt "@[<2>%s{@," map_name;
      let pp_each key fmt v = fprintf fmt "@[<2>%a => @,%a@]" pp_key key pp_a v in
      ignore (M.fold (fun key v is_fst ->
                        if is_fst then pp_each key fmt v
                        else fprintf fmt ";@;%a" (pp_each key) v;
                        false) map true);
      fprintf fmt "}@]"
    let pr pr_key pr_data ppf m =
      let lst = M.fold (fun v mv ms -> ((v,mv)::ms)) m [] in
      Format.fprintf ppf "{@[%a@]}" (pp_list (pp_pair pr_key pr_data)) lst
    let update f key t = 
      let orig = try (M.find key t) with
	Not_found -> failwith "update: Not_found" in
      M.add key (f orig) t
    let addl lst = List.fold_right (fun (k,v) -> M.add k v) lst
    let fromList lst = addl lst M.empty
    let uadd sng cons key v m =
      M.add key
	(match (find_some key m) with
	  None   -> sng v
	| Some e -> cons v e) m
    (* add key ent = uadd (fun v -> v) (fun v _ -> v) key ent *)
    let flip f x y = f y x 
    let invert t = M.fold (flip M.add) t M.empty
    let compose t1 t2 = (*  If t1 maps x to y , t2 maps y to z, then the result maps x to z *)
         M.map (fun v -> M.find v t2) t1
     (* check if range of t1 is a subset of the domain of t2 *)
(*    let compositional (type setofkey) ms (m1 : key t) (m2 : key t) =
      let module SetofKey = (val ms : Set.S with type elt = key and type t = setofkey) in
      let domain_m2 = collect_key (module SetofKey : Set.S with type elt = key and type t = setofkey) m2 in
      let range_m1  = M.fold (fun _ v -> SetofKey.add v) m1 SetofKey.empty in 
      SetofKey.subset range_m1 domain_m2 *)
    let compositional m1 m2 = M.for_all (fun _ v ->  M.mem v m2) m1
    let injective m = M.cardinal m = M.cardinal (invert m)
    let union eq ma mb =
      let merge_check k va vb =
	match (va,vb) with
	  Some a,None   -> Some a
	| None,  Some b -> Some b
	| Some a,Some b -> if eq a b then Some a else failwith "Duplicate key found with different values in union."
	| None,  None   -> None in
      M.merge merge_check ma mb
    let disjoint_union ma mb =
      let merge_check k va vb =
	match (va,vb) with
	  Some a,None   -> Some a
	| None,  Some b -> Some b
	| Some _,Some _ -> failwith "Duplicate Key found in disjoint union."
	| None,  None   -> None in
      M.merge merge_check ma mb
                (** Implementation using merge (don't lookup mb) to iterate over
        both mappings.
        Expected to be efficient when |ma|>|mb|. *)
    let diff_merge eq ma mb =
      let unify k va_opt vb_opt =
	match (va_opt,vb_opt) with
	  Some va,Some vb -> if eq va vb then None (* binding removed *)
	  else failwith "Duplicate key found with different values in diff."
	| Some va,None    -> Some va (* binding remains *)
	| None   ,_       -> None in
      M.merge unify ma mb
    (** Implementation using lookup of mb for each ma element.
        Expected to be efficient when |ma|<|mb|. *)
    let diff_lookup eq ma mb =
      let intersect k_a v_a =
	match (find_some k_a mb) with
	  Some v_b -> if eq v_a v_b then true
          else failwith "ExtSetMap.diff:Duplicate key found with different values in diff."
	| None -> false in
      let (_,disjoint) = M.partition intersect ma in
      disjoint
    let diff eq ma mb =
      if (M.cardinal ma > M.cardinal mb)
      then diff_merge  eq ma mb
      else diff_lookup eq ma mb
    let fsplit (f,g) = fun a -> (f a,g a)
    let diff_aux (inter_p:bool) eq ma mb =
      if (0=M.cardinal ma) then M.empty
      else if (0=M.cardinal mb) then (if inter_p then M.empty else ma) else
      let (ka_min,_),(ka_max,_) = fsplit (M.min_binding,M.max_binding) ma in
      let (kb_min,_),(kb_max,_) = fsplit (M.min_binding,M.max_binding) mb in
      if (kb_max < ka_min) || (ka_max < kb_min) then ma (* no intersection in domains  *)
      else
	let intersect k_a v_a =
	  if (k_a < kb_min) || (kb_max < k_a) then false (* no intersection *) 
	  else match (find_some k_a mb) with
	    Some v_b -> if eq v_a v_b then true
            else failwith "ExtSetMap.diff:Duplicate key found with different values in diff."
	  | None -> false in
	let (common,disjoint) = M.partition intersect ma in
	if inter_p then common else disjoint
    let inter eq = diff_aux true  eq
    let diff eq  = diff_aux false eq
    let unionl eq ml m  = List.fold_right (union eq) ml m
    let fromLMap eq lst = unionl eq lst M.empty
  end
end

(* bootstrap *)
module Set = struct
  module type OrderedType = sig type t val compare : t -> t -> int end
  module type S = sig 
    include SetAux.S
    val mapto : (module Set.S with type elt = 'a and type t = 'b) -> (elt -> 'a) -> t -> 'b (** map to other set *)
    val setmapto :(module Set.S with type t = 'a) -> (elt -> 'a) -> t -> 'a                 (** map to other set *)
    module SHom (ST : Set.S) : sig
      val setmap :  (elt -> ST.t)   -> t -> ST.t   (** map to other set *)
      val maps   :  (elt -> ST.elt) -> t -> ST.t   (** map to other set *)
    end
    module MHom (MT : MapAux.S) : sig
      val setmap : ('a->'a->bool)->(elt->'a MT.t)          ->t->'a MT.t (** convert to other map *)
      val map_kv :                 (elt->MT.key)->(elt->'a)->t->'a MT.t (** convert to other map *)
    end 
  end
  module Make(Ord:OrderedType) : S with type elt = Ord.t
  = struct
    module S = SetAux.Make(Ord)
    include S
    let (@@) f g x =  f (g x) (* function composition *)
    let mapto (type et) (type st) mst (f : elt -> et) s : st =
      let module ST = (val mst : Set.S with type elt = et and type t = st) in
      S.fold (  ST.add @@ f) s  ST.empty
    let setmapto (type st) mst (f : elt -> st) s =
      let module ST = (val mst : Set.S with type t = st) in
      S.fold (  ST.union @@ f) s  ST.empty 
    module SHom (ST : Set.S) = struct
      let setmap f s =  S.fold (  ST.union @@ f) s  ST.empty
      let maps   f s =  S.fold (  ST.add   @@ f) s  ST.empty
    end
    module MHom (MT : MapAux.S) = struct
      let setmap  eq f       s =  S.fold (fun v -> MT.union eq (f v))      s MT.empty
      let map_kv     f_k f_v s =  S.fold (fun v -> MT.add (f_k v) (f_v v)) s MT.empty
    end
  end
end

(* bootstrap *)
module Map = struct
  module type S = sig
    include MapAux.S
    module SetofKey' : sig include Set.S with type elt = key end  (** for Src->Powerset(Tgt) inversion *)
    module SHom (ST : Set.S) : sig
      val setmap :  (key -> 'a -> ST.t)   -> 'a t -> ST.t   (** convert to other set *)
      val maps   :  (key -> 'a -> ST.elt) -> 'a t -> ST.t   (** convert to other set *)
    end
    module MHom (MT : MapAux.S) : sig

       
      (** for Src->Powerset(Tgt) inversion *)
      module SetofKeyofMT : sig include Set.S with type elt = MT.Ord'.t (* MT.key *) end

      val map_kv    :                 (key->MT.key)->('a->'b)-> 'a t -> 'b MT.t (** map to other map *)
      val setmap_kv : ('b->'b->bool)->(key->'a  ->   'b MT.t)-> 'a t -> 'b MT.t (** map to other map *)
      val compose_right : MT.key t -> 'b MT.t -> 'b t  (** compose other map to the right *)
      val compose_left  : key MT.t -> 'a t  -> 'a MT.t (** compose other map to the left  *)
      val invert_m2s : (module Set.S with type elt = MT.key and type t = 'a) -> 'a t -> SetofKey'.t MT.t

     (** for Src->Powerset(Tgt) inversion *)
    (* val invert_m2s' : SetofKeyofMT.t t -> SetofKey'.t MT.t *)
    end
    val endomap_kv :                    (key->key)->('a->'b)->'a t->'b t (** map over both key and value *)
    val endosetmap_kv : ('b->'b->bool)->(key->'a->     'b t)->'a t->'b t (** map to other map *)

    (** [set2map Set f s] creates a map from set [s] of module [Set] that maps element x of [s] to ([f] x) *)
    val set2map :    (module Set.S with type elt = key and type t = 'a) -> (key -> 'b) -> 'a  -> 'b t 
    val collect_key :(module Set.S with type elt = key and type t = 'a) -> 'b t -> 'a (** returns set of keys *)

    (** [invert_m2s Set m] inverts a 'map [m] to set of module [Set]' *)
    val invert_m2s : (module Set.S with type elt = key and type t = 'a) -> 'a t -> 'a t 

    (** [invert2m2s Set m] inverts an endomap [m] and returns a map to set [Set] *)
    val invert2m2s : (module Set.S with type elt = key and type t = 'a) -> key t -> 'a t 

    (** similar to [set2map] but takes a function from element to a map fragment *)
    val set2maps :   (module Set.S with type elt = key and type t = 'a) ->('b->'b->bool) -> (key -> 'b t) -> 'a  -> 'b t 
  end
  module Make(Ord:Map.OrderedType) : S with type key = Ord.t
  = struct
    module M = MapAux.Make(Ord)
    include M
    module SetofKey' = Set.Make(Ord) (** for Src->Powerset(Tgt) inversion *)
    module SHom (ST : Set.S) = struct
      let setmap f m =  M.fold (fun k v -> ST.union (f k v)) m ST.empty
      let maps   f m =  M.fold (fun k v -> ST.add   (f k v)) m ST.empty
    end
    let flip f x y = f y x 
    module MHom (MT : MapAux.S) = struct

             (** for Src->Powerset(Tgt) inversion *)
      module SetofKeyofMT = Set.Make((* struct type t = MT.key let compare (x:t) (y:t) = MT.Ord'.compare x y end *) MT.Ord')

      let map_kv f_key f_val  m    = M.fold (fun k v -> MT.add (f_key k) (f_val v))  m MT.empty
      let setmap_kv eq f_key_val m = M.fold (fun k v -> MT.union eq (f_key_val k v)) m MT.empty
      let compose_right t1 t2 =
        M.map (fun v -> MT.find v t2) t1
      let compose_left t1 t2 =
        MT.map (fun v -> M.find v t2) t1

      let invert_m2s (type setofkeyofMT') ms (m: setofkeyofMT' M.t) =
      	let module SetofKeyofMT' = (val ms : Set.S with type elt = MT.key and type t = setofkeyofMT') in
       	let uadd' = MT.uadd SetofKey'.singleton SetofKey'.add in
       	M.fold (fun key -> SetofKeyofMT'.fold (fun keyofmt -> uadd' keyofmt key)     ) m  MT.empty

      (** for Src->Powerset(Tgt) inversion *)
       (* error on the use of keyofmt *)
       (* Error: This expression has type SetofKeyofMT.elt = MT.Ord'.t
          but an expression was expected of type MT.key *)
      (*
      let invert_m2s' m =
        (* let uadd' (key : MT.Ord'.t) v m' = MT.uadd SetofKey'.singleton SetofKey'.add key v m' in *)
        let uadd' key v m =
        MT.add key
	(match (MT.find_some key m) with
	  None   -> SetofKey'.singleton v
	| Some e -> SetofKey'.add v e) m  in
       	M.fold (fun key -> SetofKeyofMT.fold (fun (keyofmt:keyofMT) m' -> uadd' keyofmt key m')  ) m MT.empty
*)
    end
    module EndoMHom = MHom(M)
    (* let endomap_kv f_key f_val m = M.fold (fun v br -> M.add (f_key v) (f_val br)) m M.empty *)
    let endomap_kv    = EndoMHom.map_kv
    let endosetmap_kv = EndoMHom.setmap_kv
    let set2map (type setofkey) (type b) ms (f : key -> b) (eS : setofkey) : b t =
      let module SetofKey = (val ms : Set.S with type elt = key and type t = setofkey) in
      SetofKey.fold (fun v -> M.add v (f v)) eS  M.empty
    let collect_key (type setofkey) ms m : setofkey =
      let module SetofKey = (val ms : Set.S with type elt = key and type t = setofkey) in
      M.fold (fun key _ -> SetofKey.add key) m SetofKey.empty
    let invert_m2s (type setofkey) ms (m : setofkey M.t) =
      let module SetofKey = (val ms : Set.S with type elt = key and type t = setofkey) in
      let mapofkey_uadd = uadd SetofKey.singleton SetofKey.add in
      M.fold (fun key -> SetofKey.fold ((flip mapofkey_uadd) key)) m M.empty
    let invert2m2s (type setofkey) ms (m : key M.t) = 
      let module SetofKey = (val ms : Set.S with type elt = key and type t = setofkey) in
      let m2s = M.map SetofKey.singleton m in
      invert_m2s (module SetofKey : Set.S with type elt = key and type t = setofkey) m2s
    (* similar to set2map but takes function from element to a map fragment *)
    let set2maps (type setofkey) (type b) ms eq (f : key -> b t) (eS : setofkey) : b t =
      let module SetofKey = (val ms : Set.S with type elt = key and type t = setofkey) in
      SetofKey.fold (fun v -> M.union eq (f v)) eS M.empty
  end
end

module Bag = struct
  module type OrderedType = sig type t val compare : t -> t -> int end
  module type B = sig

    (** the type of the bag elements *)
    type elt

    (** the type of bags *)
    type t

    (** empty bag *)
    val empty : t

    (** [is_empty b] returns true if bag b is empty *)
    val is_empty : t -> bool

    (** [mem x b] returns [true] if element [x] is in bag  [b] *)
    val mem : elt -> t -> bool

    (** [add x b] adds element x in bag b. *)
    val add : elt -> t -> t

    (** [singleton x] returns a bag b with one element [x]. *)
    val singleton : elt -> t

    (** [multiplicity x b] returns multiplicity of x in bag b. Returns 0 if x is not in b. *)
    val multiplicity : elt -> t -> int

    (** [union b1 b2] unifies bags [b1] and [b2]. 
         multiplicity(x)=multiplicity_b1(x)+multiplicity_b2(x) *)
    val union : t -> t -> t

    (** [remove x b] removes element [x] from bag [b]. *)
    val remove : elt -> t -> t

   (** pretty printer with bag name *)
    val pp_t : string -> (Format.formatter -> elt -> unit) ->
      Format.formatter -> t -> unit
   (** pretty printer *)
    val pr :             (Format.formatter -> elt -> unit) -> 
      Format.formatter -> t -> unit

    (** [inter b1 b2] : Bag intersection. multiplicity(x)=min(multiplicity_b1(x),multiplicity_b2(x) *)
    val inter : t -> t -> t

    (** [diff b1 b2] : Bag difference. multiplicity(x)=max(0,multiplicity_b1(x)-multiplicity_b2(x)) *)
    val diff : t -> t -> t

    (** [compare b1 b2] is implemented by their multiplicity functions using Map.compare *) 
    val compare : t -> t -> int

    (** [equal b1 b2] returns [true] if two bags have equal elements with equal multiplicities *)
    val equal : t -> t -> bool

    (** [subset b1 b2] returns [true] if b1 is a subset (submultiset) of b2, i.e., 
        for all x in b1, x is in b2 and has multiplicity no bigger than that in b2.  *)
    val subset : t -> t -> bool

    (** [iter f b] : Similar to Set.iter except that function [f] is given 
	the multiplicity of the element as its second argument. *)
    val iter : (elt -> int -> unit) -> t -> unit

    (** [fold f e b] : Similar to Set.fold except that function [f] is given 
	the multiplicity of the element as its second argument. *)
    val fold : (elt -> int -> 'a -> 'a) -> t -> 'a -> 'a

    val for_all : (elt -> bool) -> t -> bool
    val exists : (elt -> bool) -> t -> bool
    val filter : (elt -> bool) -> t -> t
    val partition : (elt -> bool) -> t -> t * t
    val cardinal : t -> int
    val elements : t -> (elt * int) list
    val min_elt : t -> elt
    val max_elt : t -> elt
    val choose : t -> elt
 
   (** [split x b] is similar to Set.split except that it returns [(l,data,r)] where 
       [data] is [None] if [x] is not in [b], otherwise [Some m] where [m] is the multiplicity 
       of x in [b] *)
    val split : elt -> t -> t * int option * t
    val fromList : elt list -> t
    val fromSet : (module Set.S with type elt = elt and type t = 'a) -> 'a -> t 
  end 
  module Make(Ord:OrderedType) : B with type elt = Ord.t
  = struct
    module M = Map.Make(Ord)
    type elt = Ord.t
    type t = int M.t (* A bag is represented by a map from elt to integers *)
    let empty = M.empty
    let is_empty = M.is_empty
    let mem = M.mem
    let multiplicity elt b = try (M.find elt b) with Not_found -> 0
    let add elt b =
      let count = multiplicity elt b in
      M.add elt (count+1) b
    let singleton elt = M.singleton elt 1
    let union b1 b2 =
      M.fold (fun elt1 count1 acc ->
        let count2 = multiplicity elt1 b2 in
	M.add elt1 (count1 + count2) acc) b1 b2
    let remove elt b =
      let count = multiplicity elt b in
      if count = 1 then M.remove elt b else M.add elt (count - 1) b
    let pp_t bag_name pp_elt fmt bag = M.pp_t bag_name pp_elt pp_print_int fmt bag
    let pr            pp_elt fmt bag = M.pr            pp_elt pp_print_int fmt bag
    let inter_merge key count1 count2 =
	match (count1,count2) with
	  Some _, None    -> None
	| None,   Some _  -> None
	| Some c1,Some c2 -> Some (min c1 c2)
	| None,   None    -> None 
    let inter b1 b2 = M.merge inter_merge b1 b2
    let diff_merge key count1 count2 =
	match (count1,count2) with
	  Some _, None    -> count1
	| None,   Some _  -> None
	| Some c1,Some c2 -> 
	    let count = c1-c2 in 
	    if count = 0 then None else Some count
	| None,   None    -> None
    let diff b1 b2 = M.merge diff_merge b1 b2
    let compare b1 b2 = M.compare Pervasives.compare b1 b2
    let equal b1 b2 = M.equal (=) b1 b2
    let subset b1 b2 =
      M.for_all (fun elt1 count1 -> 
        (* invariant : 1 <= count1 *)
	let count2 = multiplicity elt1 b2 in
	count1 <= count2) b1
    let iter = M.iter
    let fold = M.fold
    let for_all p = M.for_all (fun key _ -> p key)
    let exists  p = M.exists  (fun key _ -> p key)
    let filter  p = M.filter  (fun key _ -> p key)
    let partition p = M.partition (fun key _ -> p key)
    let cardinal b = M.fold (fun _ value acc -> acc + value) b 0
    let elements = M.bindings 
    let min_elt b = fst (M.min_binding b)
    let max_elt b = fst (M.max_binding b)
    let choose b =  fst (M.choose b)
    let split x b = M.split x b 
    let fromList l = List.fold_right add l empty
    let fromSet (type set_t) mss (s : set_t) = 
      let module SS = (val mss : Set.S with type elt = elt and type t = set_t) in
      SS.fold (fun x -> M.add x 1) s M.empty
  end
end    
