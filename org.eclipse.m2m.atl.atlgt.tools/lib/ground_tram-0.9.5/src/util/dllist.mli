(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
exception Empty
exception Out_of_boundary
open Format

type 'a t 

type 'a cell

val create : unit -> 'a t
val clear : 'a t -> unit

val cell2content : 'a cell -> 'a
val add : 'a -> 'a t -> 'a cell
val add_cell : 'a cell -> 'a t -> unit
val push : 'a -> 'a t -> 'a cell
val push_cell : 'a cell -> 'a t -> unit


val singleton : 'a -> 'a t

val insert_head : 'a -> 'a t -> 'a cell
val insert_head_cell : 'a cell -> 'a t -> unit
val take : 'a t -> 'a
val pop : 'a t -> 'a
val take_cell : 'a t -> 'a cell
val pop_cell : 'a t -> 'a cell

val peek : 'a t -> 'a
val peek_cell : 'a t -> 'a cell
val top : 'a t -> 'a
val top_cell : 'a t -> 'a cell

val is_empty : 'a t -> bool
val length : 'a t -> int
val position    : 'a t -> int

val at_head : 'a t -> bool
val at_tail : 'a t -> bool
val goto_head : 'a t -> unit
val goto_tail : 'a t -> unit
val goto_next : 'a t -> unit
val goto_prev : 'a t -> unit
val peek_current : 'a t -> 'a
val peek_current_cell : 'a t -> 'a cell
val take_current : 'a t -> 'a
val take_current_cell : 'a t -> 'a cell
val take_at_cell : 'a cell -> 'a t -> unit
val insert_current : 'a -> 'a t -> 'a cell
val insert_current_cell : 'a cell -> 'a t -> unit

val copy : 'a t -> 'a t
val iter : ('a -> unit) -> 'a t -> unit
val riter : ('a -> unit) -> 'a t -> unit
val iter_cell : ('a cell -> unit) -> 'a t -> unit
val riter_cell : ('a cell -> unit) -> 'a t -> unit
val fold : ('a -> 'b -> 'a) -> 'a -> 'b t -> 'a
val rfold : ('a -> 'b -> 'a) -> 'a -> 'b t -> 'a
val fold_cell : ('a -> 'b cell -> 'a) -> 'a -> 'b t -> 'a
val rfold_cell : ('a -> 'b cell -> 'a) -> 'a -> 'b t -> 'a

val transfer : 'a t -> 'a t -> 'a t
val concat : 'a t * 'a t -> 'a t
val split_current : 'a t -> 'a t * 'a t

val pr_t :
  (formatter -> 'a -> unit) -> formatter -> 'a t -> unit

val toList : 'a t -> 'a list
val map2list : ('a -> 'b) -> 'a t -> 'b list
val filter2list : ('a -> bool) -> 'a t -> 'a list
val filter2list_cell : ('a cell -> bool) -> 'a t -> 'a cell list
val fromList : 'a list -> 'a t

