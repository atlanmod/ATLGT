(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
(**
  Utility functions and modules used inside chkuncal
 *)
open ExtSetMap

(** identity *)
let id x = x

(** the list of integers [a, b) *)
let rec fromTo a b =
	if a<b then a::fromTo (a+1) b else []

(** Standard state monad *)
module StateMonad = struct
	(** Standard bind operation *)
	let (>>=) (s: 's -> 's*'a) (f : 'a -> 's -> 's*'b) : 's -> 's*'b =
		fun g0 -> let (g1,v1) = s g0 in  f v1 g1

	(** Standard return operation *)
	let return (v: 'a)  : 's -> 's*'a =
		fun g0 -> (g0, v)

	(** Standard get operation *)
	let state_get : 's -> 's*'s =
		fun g0 -> (g0, g0)

	(** Standard set operation *)
	let state_set (g0: 's) : 's -> 's*unit =
		fun _ -> (g0, ())

	(** Standard modify operation *)
	let state_modify (f: 's->'s) : 's -> 's*unit =
		fun g0 -> (f g0, ())

	(** Fold_left, lifted to the monad *)
	let stateful_fold (lst: 'a list) (v: 'b) (f: 'a -> 'b -> ('s -> 's*'b)) : 's -> 's*'b =
		fun g -> List.fold_left (fun (g,v) elem -> f elem v g) (g,v) lst
end


(** Throws an exception when an unsupported feature is demanded. *)
let failwith_unsupported (msg: string) : 'noreturn  =
	failwith ("[UNSUPPORTED in Typecheck] " ^ msg)

(** Throws an exception when an IMPLEMENTATION BUG is revealed. *)
let failwith_bug (msg: string) : 'noreturn  =
	failwith ("[BUG in Typecheck] " ^ msg)

(** Throws an exception when a feature that is not implemented YET. *)
let failwith_todo (msg: string) : 'noreturn  =
	failwith ("[TODO in Typecheck] " ^ msg)

(** Throws an exception when a user made some mistake. *)
let failwith_error (msg: string) : 'noreturn  =
	failwith ("[ERROR in Typecheck] " ^ msg)

(** Alias for Format.sprintf *)
let sprintf = Format.sprintf




(** enumerate all n(n-1)/2 combinations of elements *)
let rec pairs_of (xs: 'a list) : ('a * 'a) list =
	let rec iter = function
		| []    -> []
		| x::xs -> List.fold_right (fun y zs -> (x,y)::zs) xs (iter xs)
	in
		iter xs

(** find the first occurence *)
let findi (pred: int -> 'a -> bool) (lst: 'a list) : int * 'a =
	let rec impl i = function
		| []                   -> raise Not_found
		| h :: t when pred i h -> (i, h)
		| _ :: t               -> impl (i+1) t
	in
		impl 0 lst





