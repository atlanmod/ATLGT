(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
(* symbols that is exported from doc/kztk/insertion-handling/testInsert.ml *)
open UnCAL
open UnCALSAST
open UnCALDM
open UnCALdynenv

type ins_unit = 
    {
      dst   : SetofVtx.t; (* dst *)
      src   : SetofVtx.t; (* src *)
      graph : graph;      (* graph to be inserted *)
    }
val insEmpty : ins_unit
val liftOption : ('a -> 'b) -> 'a option -> 'b option
val liftOption2 : ('a -> 'b -> 'c) -> 'a option -> 'b option -> 'c option
val fromSome : 'a option -> 'a
val bindOption : 'a option -> ('a -> 'b option) -> 'b option

val test_get1 : unit -> graph option
val test_put1 : unit -> graph
val test_uncal2 : 'a option aexpr

val test_ev : 'a option aexpr -> string ->graph option * (graph -> ins_unit list -> dynenv)

type test_mode = TestExp | TestFwd | TestBwd

val bdIverbose : bool ref

val test :  ?fwd_dot_file:string ->  ?bwd_dot_file:string ->  ?write_dot:bool ->  ?out_graph:graph ->
  ?insertion_units:ins_unit list -> 'a option UnCAL.aexpr ->  graph ->
  test_mode ->
  [> `TestBwd of graph
   | `TestExp of 'a option taexpr
   | `TestFwd of graph ]


val test_exp1 : unit -> 'a option taexpr
val test_exp2 :
  unit ->
  [> `TestBwd of graph
   | `TestExp of 'a option taexpr
   | `TestFwd of graph ]
val test_fwd2 :
  unit ->
  [> `TestBwd of graph
   | `TestExp of 'a option taexpr
   | `TestFwd of graph ]
val test_fwd2b :
  unit ->
  [> `TestBwd of graph
   | `TestExp of 'a option taexpr
   | `TestFwd of graph ]
val test_bwd2a :
  unit ->
  [> `TestBwd of graph
   | `TestExp of 'a option taexpr
   | `TestFwd of graph ]
val test_bwd2b :
  unit ->
  [> `TestBwd of graph
   | `TestExp of 'a option taexpr
   | `TestFwd of graph ]
val test_bwd2c :
  unit ->
  [> `TestBwd of graph
   | `TestExp of 'a option taexpr
   | `TestFwd of graph ]
val test_bwd2d :
  unit ->
  [> `TestBwd of graph
   | `TestExp of 'a option taexpr
   | `TestFwd of graph ]

val test_nc_put1 : unit -> graph


val ins2file : ins_unit -> string -> unit
val file2ins : string -> ins_unit

(* from insertionTemplate.ml *)
type ins_between = 
    {
      ib_dst   : SetofVtx.t; (* dst *)
      ib_src   : SetofVtx.t; (* src *)
    }


type it_test_mode = 
  | ITTestExp 
  | ITTestFwd
  | ITTestBwd
  | ITTestTmp

val it_test : ins_between list -> 'a option aexpr -> graph -> it_test_mode ->
  [> `TestExp of 'a option taexpr
   | `TestFwd of graph
   | `TestTmp of graph list ]
