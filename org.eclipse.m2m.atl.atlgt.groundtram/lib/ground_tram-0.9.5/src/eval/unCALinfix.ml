(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
open UnCAL
open UnCALSA

(* syntactic expressioon equivalence was tested using builtin 
   '=' before introducing annotation.
   Now we should disregard annotation for testing the original
   semantics of equivalence.
   To do so, annotation is first eliminated *)
let eqB e1 e2 = 
  let e1 = map_infoB (fun _ -> {annot=None}) e1 in
  let e2 = map_infoB (fun _ -> {annot=None}) e2 in
  e1 = e2
(* concatenate annotation *)
let (<|^|>) a1 a2 = 
  let (a1,a2) = (a1.annot,a2.annot) in
  let a =  match (a1,a2) with 
    (None,None)       -> None
  | (None,a2)         -> a2
  | (a1,None)         -> a1
  | (Some s1,Some s2) -> Some s1 (* FIXME: just pick the first *) 
  in {annot=a}

(* logical and *)
let (<&>) e1 e2 = match e1 with
  | ATrue _  -> e2
  | AFalse a -> AFalse a
  | ANot (a,e) when eqB e e2 -> AFalse a (* FIXME: just pick the annotation of ANot *)
  | _ -> match e2 with
      | ATrue _  -> e1
      | AFalse a -> AFalse a
      | ANot (a,e) when eqB e e1 -> AFalse a (* FIXME: just pick the annotation of ANot *)
      | _ -> if eqB e1 e2 then e1 else AAnd({annot=None},e1,e2)

(* logical or *)
let (<|>) e1 e2 = match e1 with
  | ATrue a -> ATrue a
  | AFalse _ -> e2
  | ANot (a,e) when eqB e e2 -> ATrue a (* FIXME: just pick the annotation of ANot *)
  | _ -> match e2 with
      | ATrue a  -> ATrue a
      | AFalse _ -> e1
      | ANot (a,e) when eqB e e1 -> ATrue a (* FIXME: just pick the annotation of ANot *)
      | _ -> if eqB e1 e2 then e1 else AOr({annot=None},e1,e2)

let (<|=|>) e1 e2 = 
  let e1 = map_info (fun _ -> {annot=None}) e1 in
  let e2 = map_info (fun _ -> {annot=None}) e2 in
  e1 = e2

(* union *)
let (<+>) e1 e2 = match e1 with
  | AETEmp _ -> e2
  | _ -> match e2 with
      | AETEmp _ -> e1
      | _ -> if e1 <|=|> e2 then e1 else AEUni({annot=None},e1,e2)

(* disjoint union *)
let (<++>) e1 e2 = match e1 with
  | AETEmp _ -> e2
  | _ -> match e2 with
      | AETEmp _ -> e1
      | _ -> AEDUni({annot=None},e1,e2)
