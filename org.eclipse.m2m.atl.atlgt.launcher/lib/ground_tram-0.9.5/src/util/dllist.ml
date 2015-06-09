(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
(* Doubly linked list with cursor for O(1) cost insertion, 
   deletion, concatenation and splitting. *)
(* Interface is made as close as possible to ocaml standard Queue library *)

(* 
   Cursor points nothing when created. When an element is 
   first inserted, then it points to that element.
   User can explicitly locate it to either head or tail of the list.

   [Insertion/deletion and cursor]

   add/push inserts element at the tail. If operates on empty list,
   then the cursor points to that element. Even if cursor had been 
   at the tail, the cursor still points to the same element.
   
   Ex: add 1 []        => [<1>]
   Ex: add 4 [1;2;<3>] => [1;2;<3>;4]

   take/pop removes and returns the element at the head. If the
   removed element is pointed by the cursor, the cursor is moved to
   the next cell. Otherwise, the cursor points the same element.

   Ex: take [<1>;2;3] = 1 => [<2>;3]
   Ex: take [1;<2>;3] = 1 => [<2>;3]
   
   take_current removes element pointed by the cursor. The cursor is
   moved to the next cell. If the cursor had been pointing to the
   tail cell, then the cursor points to the new tail cell.

   Ex: take_current [1;<2>;3] => [1;<3>]
   Ex: take_current [1;2;<3>] => [1;<2>]

   insert_current inserts element just before the cursor. The cursor
   still points to the same element.

   Ex: insert_current 4 [1;2;<3>] => [1;2;4;<3>]

   [Operations on the cursor]

   goto_head/goto_tail moves the cursor to the head or tail of the list.
   If the list is empty, Empty exception is raised.

   Ex: goto_head [1;<2>;3] => [<1>;2;3]
   Ex: goto_tail [1;<2>;3] => [1;2;<3>]

   goto_next/goto_prev moves the cursor to the next or previous element
   of the list. If the list is empty, Empty exception is raised.
   When the cursor is already on the boundary (head or tail) and
   goto_prev or goto_next is called, then Out_of_boundary exception 
   is raised.

   Ex: goto_next [1;<2>;3] => [1;2;<3>]
   Ex: goto_prev [1;<2>;3] => [<1>;2;3]

   [Concatenation/splitting]
   
   concat (l1,l2), which is equivalent to transfer l2 l1 
   concatenates l2 to the end of l1 and clears l2. If l1 is
   empty, then cursor is inherited from that of l2. Otherwise,
   cursor points to the same position as in l1.
   let (l1,l2) = split_current l splits list l into two lists such that
   concat (split_current l) = l holds. Note that the converse,
   split_current (concat (l1,l2)) = (l1,l2) does not always hold since
   cursor of l2 is lost in concat operation. split_current sets the 
   cursor of l2 to the head position.

   Ex: concat []        [4;<5>;6] => [4;<5>;6]
   Ex: concat [1;<2>;3] [4;<5>;6] => [1;<2>;3;4;5;6]
   Ex: split_current [1;2;<3>;4;5;6] => ([1;2;<3>],[<4>;5;6]


   [Properties on the cursor]

   - When the list is non-empty, the cursor is always point to some element.
   - If user does not touch the cursor, and does not use insert_current,
     then the cursor always point to the head of the list while it is
     non-empty.

   [Implementation note]

   To avoid inconsistency caused by exception, emptiness test
   is performed first for transaction.
 *) 

open Format
exception Empty
exception Out_of_boundary

type 'a cell = {
    mutable prev : 'a cell option;
    content: 'a;
    mutable next : 'a cell option;
  }

type 'a t = {
    mutable length: int;
    mutable pos:    int; (* 1-oriented position *)
    mutable head:   'a cell option;
    mutable tail:   'a cell option;
    mutable cursor: 'a cell option;

 }

let create () = {
  length = 0;
  pos    = 0;
  head   = None;
  tail   = None;
  cursor = None;
}

let clear l =
  l.length <- 0;
  l.pos    <- 0;
  l.head   <- None;
  l.tail   <- None;
  l.cursor <- None

let fromSome = function
    Some x -> x
  | None   -> failwith "dereferening None"

let cell2content = function 
    { content=c } -> c

let goto_head l =
  if l.length = 0 then raise Empty
  else (l.cursor <- l.head; l.pos <- 1)

let goto_tail l =
  if l.length = 0 then raise Empty
  else (l.cursor <- l.tail; l.pos <- l.length)


let add_cell cell l =
  l.length <- l.length + 1;
  if l.length = 1 
  then
    (cell.next <- None;
     cell.prev <- None;
     l.tail <- Some cell;
     l.head <- Some cell;
     l.cursor <- Some cell;
     l.pos  <- 1)
  else
    let tail = l.tail in
    cell.prev <- tail;
    cell.next <- None;
    assert (tail <> None);
    (fromSome tail).next <- Some cell;
    l.tail <- Some cell

let add x l =
  let cell = {
    content = x;
    next = None;
    prev = None } in
  add_cell cell l; cell

let push      = add
let push_cell = add_cell

let singleton a =
  let l = create () in
  ignore (add a l); l

let peek_cell l = 
  if l.length = 0 then raise Empty
  else (
    assert (l.head <> None);
    fromSome l.head)


let take_cell l =
  if l.length = 0 then raise Empty;
  l.length <- l.length - 1;
  assert (l.head <> None);
  let head_cell = fromSome l.head in
  l.head <- head_cell.next;
  (match l.head with
    None   -> l.tail <- None
  | Some c -> c.prev <- None);
  (* adjust cursor *)
  (* assert (l.cursor <> None); *)
  (match l.cursor with
    None   -> failwith "take: null cursor for non-empty dllist"
  | Some cursor_cell ->
      if cursor_cell == head_cell then 
	l.cursor <- head_cell.next
      else 
	l.pos <- l.pos -1 );
  head_cell

let peek l = (peek_cell l).content
let take l = (take_cell l).content

let top      = peek
let top_cell = peek_cell

let pop      = take
let pop_cell = take_cell

let copy l = 
  if l.length = 0 then
    create ()
  else
    let cursor_cell =
      match l.cursor with
	None ->   failwith "copy: source has null cursor"
      | Some c -> c in
    let newl = {
      length = 0; pos = 0;
      head = None; cursor = None; tail = None;
    } in
    let rec copy prev cell = 
      match cell with
	None   -> newl.tail <- prev; None
      | Some c ->
	  (let new_cell = {
	    prev = prev;
	    content = c.content;
	    next = None;
          } in 
	  if cursor_cell == c then newl.cursor <- Some new_cell;
          new_cell.next <- copy (Some new_cell) c.next;
          Some new_cell) in
    newl.head <- copy None l.head;
    newl.length <- l.length;
    newl.pos    <- l.pos;
    newl


let is_empty l = l.length = 0
let length   l = l.length
let position l = l.pos


(* what we truely need is a remove function 
   that remove element at an arbitrary position!  
   so we need to expose a reference to the cell.
   cursor is required to represent current 
   position while scanning.
 *)


(* return cell that is pointed by a cursor *)
let peek_current_cell l =
  match l.cursor with
    None -> raise Empty
  | Some cell -> cell

(* after reomval, cursor will point to the next cell *)
let take_current_cell l = 
  match l.cursor with
    None -> raise Empty
  | Some cell ->
      (match cell.prev with
	None   -> l.head <- cell.next (* removing head *)
      | Some c -> c.next <- cell.next);
      (match cell.next with
	None   -> l.tail <- cell.prev (* removing tail *)
      | Some c -> c.prev <- cell.prev);
      l.length <- l.length - 1;
      l.cursor <- cell.next;
      if l.cursor = None && cell.prev <> None then
	(* don't let the cursor go beyond the boundary *)
	(l.cursor <- cell.prev; l.pos <- l.pos - 1);
      cell

let peek_current l = (peek_current_cell l).content
let take_current l = (take_current_cell l).content
  
(* Remove given cell in O(1) cost. If cell that is not belong to the list,
   the result is undefined. 
   Since it costs more than constant to update pos properly
   because  position of cell relative to cursor is unknown, cursor is 
   relocated to the front if it is still non-empty after removal. 
   content is not returned because it can be obtained from given
   cell via cell2content *)

let iter_cell f l =
  if l.length > 0 then
    let rec iter = function
	None -> ()
      | Some cell ->
	  f cell;
	  iter cell.next in
    iter l.head

(* iteration in reverse order *)
let riter_cell f l =
  if l.length > 0 then
    let rec riter = function
	None -> ()
      | Some cell ->
	  f cell;
	  riter cell.prev in
    riter l.tail

let iter  f  = iter_cell (fun c -> f c.content)
let riter f = riter_cell (fun c -> f c.content)

let fold_cell f accu l =
  let rec fold accu = function
      None      -> accu
    | Some cell -> fold (f accu cell) cell.next
  in fold accu l.head

let rfold_cell f accu l =
  let rec fold accu = function
      None      -> accu
    | Some cell -> fold (f accu cell) cell.prev
  in fold accu l.tail

let  fold f =  fold_cell (fun accu cell -> f accu cell.content)
let rfold f = rfold_cell (fun accu cell -> f accu cell.content)

let check_cell_existence cell l = 
  fold_cell (fun accu c -> accu || (cell == c)) false l
  
let take_at_cell cell l = 
  if l.length = 0 then raise Empty else
  assert (true = check_cell_existence cell l);
  l.cursor <- Some cell;
  let content = take_current l in
  if l.length <> 0 then goto_head l


(* returns true if cursor is at the head *)
let at_head l = 
  if l.length = 0 then false
  else
    match l.cursor with
    None -> false
  | Some cell -> (assert (l.head <> None)); cell == fromSome (l.head) 

(* returns true if cursor is at the tail *)
let at_tail l = 
  if l.length = 0 then false
  else
    match l.cursor with
    None -> false
  | Some cell -> (assert (l.tail <> None)); cell == fromSome (l.tail) 


let insert_current_cell new_cell l = 
  match l.cursor with
    None -> raise Empty
  | Some cell ->
      l.length <- l.length + 1;
      new_cell.prev <- cell.prev;
      new_cell.next <- l.cursor;
      (match cell.prev with
	None   -> l.head <- Some new_cell (* cursor is at the head *)
      | Some c -> c.next <- Some new_cell);
      cell.prev <- Some new_cell;
      l.pos <- l.pos + 1

(* insertion to position just before the cursor  *)
let insert_current x l = 
  let new_cell = {
    prev = None;
    content = x;
    next = None  }  in
  insert_current_cell new_cell l; new_cell
      

let insert_head_cell cell l =
  if l.length = 0 then
    add_cell cell l
  else
    let (tmp,pos) = (l.cursor,l.pos) in
    goto_head l;
    insert_current_cell cell l;
    l.cursor <- tmp;
    l.pos    <- pos + 1
  
(* insertion to head *)
let insert_head x l = 
  let cell = {
    prev = None;
    content = x;
    next = None } in
  insert_head_cell cell l; cell

let goto_next l = 
  match l.cursor with
    None -> raise Empty
  | Some cell -> 
      match cell.next with
	None   -> raise Out_of_boundary
      | Some _ -> (l.cursor <- cell.next; l.pos <- l.pos + 1)

let goto_prev l = 
  match l.cursor with
    None -> raise Empty
  | Some cell ->
      match cell.prev with
	None   -> raise Out_of_boundary
      | Some _ -> (l.cursor <- cell.prev; l.pos <- l.pos - 1)


let transfer l1 l2 =
  (match l2.tail with
    None -> (* l2 is empty *)
      l2.cursor <- l1.cursor;
      l2.pos    <- l1.pos;
      l2.head   <- l1.head;
  | Some tail_cell ->
      tail_cell.next <- l1.head);
  (match l1.head with
    None -> (* l1 is empty *)
      ()
  | Some head_cell ->
      head_cell.prev <- l2.tail);
  l2.tail <- l1.tail;
  l2.length <- l2.length + l1.length;
  clear l1; l2

let concat (l1,l2) = transfer l2 l1

(*   concat (split_current l) = l *)
let split_current l =
  let l2 =
    {head=None;length=0;pos=0;cursor=None;tail=l.tail} in
  l.tail <- l.cursor;
  (match l.cursor with
    None      -> ()
  | Some cell ->
      begin
	l2.head   <- cell.next;
	l2.cursor <- cell.next;
	cell.next <- None;
      end
       );
  l2.length <- l.length - l.pos;
  l.length  <- l.pos;
  (match l2.head with
    None   -> ()
  | Some c -> c.prev <- None; l2.pos  <- 1);
  (l,l2)


let pr_t pp_elt fmt l = 
  let ptr = ref l.head in
  let pp_cell = 
    if l.cursor = None then
      fun fmt cell -> pp_elt fmt cell.content 
    else 
      fun fmt cell -> 
	assert (l.cursor <> None);
	if (fromSome l.cursor) == cell 
	then begin fprintf fmt "@[";
	  fprintf fmt "<%a@@%i>" pp_elt cell.content l.pos;
	  fprintf fmt "@]"
	 end
	else fprintf fmt "%a"            pp_elt cell.content in
  fprintf fmt "@[<1>[";
  if l.length >= 1
  then begin 
    (assert (!ptr <> None));
    pp_cell fmt (fromSome !ptr);
    ptr := (fromSome !ptr).next;
  end;
  while (!ptr <> None) do
    fprintf fmt ",@,%a" pp_cell (fromSome !ptr);
    ptr := (fromSome !ptr).next
  done;
  fprintf fmt "]@]"  

let toList     l = rfold (fun acc x ->     x::acc) [] l
let map2list f   = rfold (fun acc x -> (f x)::acc) []

let filter2list_cell p = rfold_cell (fun acc x -> if (p x) then (x::acc) else acc) []
let filter2list      p = rfold      (fun acc x -> if (p x) then (x::acc) else acc) []


let fromList lst =
  let l = create () in
  List.iter (fun x -> ignore (add x l)) lst;
  l

