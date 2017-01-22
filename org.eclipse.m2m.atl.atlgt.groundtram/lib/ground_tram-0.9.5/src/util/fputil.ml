(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
(* utilities for functional programming *)
let cons x y = (x::y) (* to get sectioned version *)
let fsplit (f,g) = fun    a  -> (f a,g a)
let flip f x y = f y x 

let id x = x
let (@@) f g x =  f (g x) (* function composition *)
let cross (f,g) = function (a,b) -> (f a,g b)
(* let mapT2 f = function (a,b) -> (f a,f b) *)
let mapT2 f = cross (f,f)

let cross3 (f,g,h) = function (a,b,c) -> (f a,g b,h c) 

let uncurry f p = f (fst p) (snd p)
let curry f a b = f (a,b)

let uncurry3 f (a,b,c) = f a b c
let   curry3 f a b c   = f (a,b,c)

let uncurry4 f (a,b,c,d) = f a b c d
let   curry4 f a b c d  = f (a,b,c,d)


let fold_right3 : ('a -> 'b -> 'c -> 'd -> 'd) -> 'a list -> 'b list -> 'c list -> 'd -> 'd =
 fun f la lb lc il ->
   List.fold_right2 (fun (a,b) c d -> f a b c d) (List.combine la lb) lc il

let rec fold_right1 f = function
    [x]     -> x
  | (x::xs) -> f x (fold_right1 f xs)
  | []      -> failwith "Fputil.fold_right1: empty list"

let fold_left1 f = function
  | (x::xs) -> List.fold_left f x xs
  | []      -> failwith "Fputil.fold_left1: empty list"

(* Useful to implement fuctions given in the form of list comprehension *)
let concatMap f x = List.concat (List.map f x)

(* check if all member has equal value of prop *)
(* eqv : equivalence predicate *)
let uniform (eqv:'b -> 'b -> bool) (prop: 'a -> 'b) (x:'a list) : bool =
  match x with
    []      -> true 
  | (x::xs) -> 
      let p = prop x in
      List.for_all (fun e -> eqv p (prop e)) xs

(*   [[x11;x12; ...;x1n];[x21;x22; ... ; x2n]; ... [xm1;xm2; ... ; xmn]]
  => [[x11;x21; ...;xm1];[x12;x22; ... ; xm2]; ... [x1n;x1n; ... ; xmn]] *)
let  transpose (m: 'a list list) : 'a list list =
  if not (uniform (=) List.length m) 
  then failwith "transpose: non-uniform input."
  else
    let rec tr m = match m with
      []      -> []
    | (x::xs) -> match x with 
	[]     -> []
      |	(_::_) -> (List.map List.hd m)::(tr (List.map List.tl m)) in
    tr m

let replaceif org rev n  = if (n = org) then rev else n

let compareOrd i j = 
       if (i < j) then -1
       else if (i > j) then 1
       else 0

let toStr pr_elem arg = 
  Format.fprintf Format.str_formatter "%a" pr_elem arg;Format.flush_str_formatter ()

(* print sequence with delimiter "delim" in-between *)
let pr_seq (delim:string) pr_elem ppf lst  =
  let v = ref lst in
  while (!v <> []) 
  do
    Format.fprintf ppf "%a" pr_elem (List.hd (!v));
    v := (List.tl (!v));
    if (!v <> []) then Format.fprintf ppf "%s@ " delim
  done

let pr_list pr_elem = pr_seq ";" pr_elem

let pr_pair pr_a pr_b ppf (a,b) =
  Format.fprintf ppf "(@[%a@],@[%a@])" pr_a a pr_b b

(* generic printer for map *)
(*
let pr_Map fold pr_key pr_data ppf m =
  let lst = fold (fun v mv -> cons (v,mv)) m [] in
  Format.fprintf ppf "{@[%a@]}" (pr_list (pr_pair pr_key pr_data)) lst
*)
(* added definition that would be incorporated to extSetMap.ml would be
   val pr : (Format.formatter -> key -> unit) -> (Format.formatter -> 'a -> unit)
       -> Format.formatter -> 'a t -> unit
   let pr pr_key pr_data ppf m =
     let lst = M.fold (fun v mv -> cons (v,mv)) m [] in
     Format.fprintf ppf "{@[%a@]}" (pr_list (pr_pair pr_key pr_data)) lst
*)


(* generic printer for set *)
(*
let pr_Set elements pr_data ppf s =
  Format.fprintf ppf "{@[%a@]}" (pr_list pr_data) (elements s)
*)
(* added definition that would be incorporated to extSetMap.ml would be
   val pr : (Format.formatter -> elt -> unit)
       ->    Format.formatter -> t -> unit
   let pr pr_data ppf s = 
   Format.fprintf ppf "{@[%a@]}" (pr_list pr_data) (S.elements s)
*)

(* generic adder of list of elements for set *)
(*
let addl_Set adder = List.fold_right adder
*)
(* added definition that would be incorporated to extSetMap.ml would be
   val addl : elt list -> t -> t
   let addl elist set = List.fold_right S.add elist set 
*)

(* generic map for set *)
(*
let map_Set folder adder empty f set = folder (adder @@ f) set empty
*)
(* added definition that would be incorporated to extSetMap.ml would be
   val map : (elt -> elt) -> t -> t
   let map f set = S.fold (S.add @@ f) set S.empty
*)

(* timing function
   argument expression has to be wrapped with 'lazy'  *)
let print_time ?(prefix = "Evaluation") (e: ('a Lazy.t)) : 'a  = 
  let fs0 = Sys.time () in (* for calibration *)
  let fs  = Sys.time () in 
  let res = Lazy.force e in
  let fd  = Sys.time () in 
  Printf.fprintf stdout  "%s took %f CPU seconds\n%!" prefix ((fd -. fs) -. (fs -. fs0));
  res

(* Simple (thread-unsafe) stopwatch *)
module GlobalSW : sig
  val reset : unit -> unit
  val start : unit -> unit
  val stop  : unit -> unit
  val lap   : unit -> unit
end = struct
  let get_time () = Sys.time () 
  (* let get_time () =  Unix.gettimeofday () *) (* for wall-clock time *)
  let is_running = ref false
  let cumul_time = ref 0.0  (* cumulative time *)
  let lupdt_time = ref 0.0  (* last update time *)
  let lap_time   = ref 0.0  (* lap time *)
  let reset () = is_running := false; cumul_time := 0.0; lap_time := 0.0 (* reset timer *)
  let start () = is_running := true;  lupdt_time := get_time ()
  let update () = 
    if !is_running then 
      let st = get_time () in
      (cumul_time := !cumul_time +. st  -. !lupdt_time;
       lap_time   := !lap_time   +. st  -. !lupdt_time;
       lupdt_time := st)
    else ()
  let print_time () =
    Printf.fprintf stdout  "GlobalSW: lap: %f total: %f [cpusec]\n%!" !lap_time !cumul_time
  let stop  () = 
    update (); print_time (); is_running := false
  let lap () =
    update (); print_time (); 
    if !is_running then lap_time := 0.0
end


(* get extension from filename *)
let get_suffix fname:string = 
  let prefix = Filename.chop_extension fname in
  let lprefix = String.length prefix in
  let lsufix = (String.length fname) - lprefix - 1 in
  String.sub fname (lprefix + 1) lsufix

let gtm_temp_file =
  if Sys.os_type="Win32" || Sys.os_type = "Cygwin" then 
    (* change temporary directory to current directory
       and strip the directory part to avoid problems related
       to pathname *)
   (fun prefix suffix ->
     Format.printf "gtm_temp_file: prefix=%s,suffix=%s@." prefix suffix;
     let envname = "TEMP" in
     let putenv = Unix.putenv envname in
     let temp_file = fun () -> Filename.basename (Filename.temp_file prefix suffix) in
     try
       let tmpdir_org = Unix.getenv envname in
       let _= putenv "." in
       let fname = temp_file ()  in
       let _= putenv tmpdir_org in
       Format.printf "gtm_temp_file: fname = %s@." fname;
    fname
     with Not_found -> temp_file ())
  else (fun prefix suffix -> Filename.temp_file prefix suffix)
   
let gtm_command =
  if Sys.os_type="Win32" || Sys.os_type = "Cygwin" then 
    fun com -> 
      let cwd = Sys.getcwd () in
      let ret = match (Unix.system com) with
	Unix.WEXITED r -> r
      | Unix.WSIGNALED r -> r
      | Unix.WSTOPPED r -> r in
      let _   = Sys.chdir cwd in
      ret
  else
    Sys.command
   
   
   
   
      
      
