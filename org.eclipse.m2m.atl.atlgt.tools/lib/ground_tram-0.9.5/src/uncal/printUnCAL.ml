(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
(**
  Pretty printer for UnCAL
 *)
open Fputil
open UnCAL
open Format

let allit2str = function
    ALLbl (l) -> "ALLbl(" ^ "\"" ^ l ^ "\"" ^ ")"
  | ALStr (s) -> "ALStr(" ^ "\"" ^ s ^ "\"" ^ ")"
  | ALInt (i) -> "ALInt(" ^ string_of_int i ^ ")"
  | ALFlt (f) -> "ALFlt(" ^ string_of_float f ^ ")"
  | ALBol (b) -> "ALBol(" ^ string_of_bool b ^ ")"
  | ALUkn     -> "ALUkn"
  | ALEps     -> "ALEps"

let pr_allit ppf = function
    ALLbl (l) -> fprintf ppf "ALLbl %s" l
  | ALStr (s) -> fprintf ppf "ALStr %S" s
  | ALInt (i) -> fprintf ppf "ALInt %i" i
  | ALFlt (f) -> fprintf ppf "ALFlt %f" f
  | ALBol (b) -> fprintf ppf "ALBol %B" b
  | ALUkn     -> fprintf ppf "ALUkn"
  | ALEps     -> fprintf ppf "ALEps"

let marker2str (m:marker) = "\"" ^ m ^ "\""
let pr_marker ppf m = fprintf ppf "%S" m

let pr_vname ppf v = fprintf ppf "%S" v
let pr_lname ppf l = fprintf ppf "%S" l
    
(* toward normal form
   arbitrariness found in UnCAL expression, which should be eliminated:
  Union : sri 
  Disjoint union: 
  Marker name : impose some order encoded in marker name *)


let pr_SetofVname = SetofVname.pp_t "" pr_vname
let pr_SetofLname = SetofLname.pp_t "" pr_lname

(* ppr_* function is for re-loadable representation by UnCAL parser 
   whereas pr_* function is for re-loadable representation by OCaml interpreter *)

let ensugar = ref true (* whether {L1:E1} U {L2:E2} U {L3:E3} and x ++ y ++ z should be 
    printed (x,y,z) and {L1:E1,L2:E2,L3:E3}, respectively *)
let pr_forest pr_elem = pr_seq "," pr_elem

(* operator precedence for boolean expressions *)
let abexpr_gt (be1:'a abexpr) (be2:'a abexpr) = match (be1,be2) with
  ANot    _   ,   ANot _          -> false
| AAnd (_,_,_),   AAnd (_,_,_)    -> false
| AOr  (_,_,_),   AOr  (_,_,_)    -> false
| AOr  (_,_,_),   ANot _          -> true
| AAnd (_,_,_),   ANot _          -> true
| ALcmp (_,_,_,_),ALcmp (_,_,_,_) -> false
| ATrue _,        ATrue _         -> false
| AFalse _ ,       AFalse _       -> false
| AOr  (_,_,_),   AAnd  (_,_,_)   -> true
| _,_                             -> false


let albinop_gt = function
    ALAdd,ALMul -> true
  | ALAdd,ALDiv -> true
  | ALAdd,ALMod -> true
  | ALSub,ALMul -> true
  | ALSub,ALDiv -> true
  | ALSub,ALMod -> true
  | _    ,_     -> false

(** Annotation printing					
    @param pp_a (optional) pretty printer for annotation		
    @param ppr pretty printing function for contents without annotation		
           which takes formatter and unit					
    @param ppf pretty printing formatter					
    @param annot annotation							*)
let with_annot ?pp_a ?(paren=true) ppr ppf annot = match pp_a with
  | None -> ppr ppf ()
  | Some pp_a ->
    if paren then fprintf ppf "(%a) %s %a" ppr () "@@" pp_a annot
    else fprintf ppf "(%a) %s %a" ppr () "@@" pp_a annot

let rec ppr_aexpr ?pp_a ppf = function 
  | AETEmp a -> with_annot ?pp_a ~paren:false (fun ppf () -> fprintf ppf "{}") ppf a
  | AEEdg(a,pat,e) ->
    with_annot ?pp_a ~paren:false 
      (fun ppf () -> match e with 
	| AETEmp _ -> fprintf ppf "{%a}" ppr_alpat pat
        |  _       -> fprintf ppf "{@[%a: @[%a@]@]}" ppr_alpat pat (ppr_aexpr ?pp_a) e)
      ppf a
  | AEUni(a,e1,e2) as f ->
    if !ensugar then
      let lst = (toList_GT (assocr_GT f)) in
      if List.for_all (function AEEdg (_,_,_) -> true | _ -> false) lst
      then
        with_annot ?pp_a ~paren:false
          (fun ppf () ->
            fprintf ppf "{@[%a@]}" (pr_forest (ppr_SugaredAEdg ?pp_a)) lst) ppf a
      else
        with_annot ?pp_a
          (fun ppf () ->
            fprintf ppf "%a@ U %a"  (ppr_aexpr ?pp_a) e1 (ppr_aexpr ?pp_a) e2) ppf a
    else
      with_annot ?pp_a
        (fun ppf () ->
          fprintf ppf "%a@ U %a"  (ppr_aexpr ?pp_a) e1 (ppr_aexpr ?pp_a) e2) ppf a
  | AEIMrk(a,m,e) ->
    with_annot ?pp_a
      (fun ppf () ->
        fprintf ppf "@[<2>%a := @[%a@]@]" ppr_marker m (ppr_aexpr ?pp_a) e) ppf a
  | AEOMrk(a,m) ->
    with_annot ?pp_a ~paren:false (fun ppf () -> fprintf ppf "%a" ppr_marker m) ppf a
  | AEGEmp a -> with_annot ?pp_a ~paren:false (fun ppf () -> fprintf ppf "%s" "()") ppf a
  | AEDUni(a,e1,e2) as f ->
    if !ensugar
    then 
      let lst = (toList_GT (assocr_GT f)) in
      with_annot ?pp_a ~paren:false
        (fun ppf () -> fprintf ppf "(@[%a@])" (pr_forest (ppr_aexpr ?pp_a)) lst) ppf a
    else
      with_annot ?pp_a
        (fun ppf () ->
          fprintf ppf "%a@ ++ %a" (ppr_aexpr ?pp_a) e1 (ppr_aexpr ?pp_a) e2) ppf a
  | AEApnd(a,e1,e2) ->
    with_annot ?pp_a
      (fun ppf () ->
        fprintf ppf "%a@ @@ %a" (ppr_aexpr ?pp_a) e1 (ppr_aexpr ?pp_a) e2) ppf a
  | AECyc(a,e) ->
    with_annot ?pp_a ~paren:false
      (fun ppf () -> fprintf ppf "cycle(@[%a@])" (ppr_aexpr ?pp_a) e) ppf a
  | AEVar(a,vn) ->
    with_annot ?pp_a ~paren:false
      (fun ppf () -> fprintf ppf "%a" ppr_vname vn) ppf a
  | AEDoc(a,s) ->
    with_annot ?pp_a ~paren:false (fun ppf () -> fprintf ppf "doc(%S)" s) ppf a
  | AEIf(a,be,et,ef) ->
    with_annot ?pp_a
      (fun ppf () -> fprintf ppf "@[<hv>if @[%a@]@ then @[%a@]@ else @[%a@]@]"
	(ppr_abexpr ?pp_a) be (ppr_aexpr ?pp_a) et (ppr_aexpr ?pp_a) ef) ppf a
  | AERec(a,l,la,v,va,e1,e2) ->
    with_annot ?pp_a ~paren:false
      (fun ppf () ->
        fprintf ppf "@[<hov 2>rec(\\ (%a,%a).@,@[%a@])@]@,(@[%a@])"
          (with_annot ?pp_a ~paren:false (fun ppf () -> ppr_lname ppf l)) la
          (with_annot ?pp_a ~paren:false (fun ppf () -> ppr_vname ppf v)) va
          (ppr_aexpr ?pp_a) e1 (ppr_aexpr ?pp_a) e2) ppf a
  | AELet (a,v,va,e1,e2) -> 
    with_annot ?pp_a
      (fun ppf () ->
        fprintf ppf "@[<hov 2>let %a =@ %a in@]@\n%a"
	  (with_annot ?pp_a ~paren:false (fun ppf () -> ppr_vname ppf v)) va
          (ppr_aexpr ?pp_a) e1 (ppr_aexpr ?pp_a) e2) ppf a
  | AELLet (a,l,la,lp,e) ->
    with_annot ?pp_a
      (fun ppf () ->
        fprintf ppf "@[<hov 2>llet %a =@ %a in@]@\n%a"
	  (with_annot ?pp_a ~paren:false (fun ppf () -> ppr_lname ppf l)) la
          ppr_alpat lp (ppr_aexpr ?pp_a) e) ppf a
and ppr_SugaredAEdg ?pp_a ppf = function
  | AEEdg(a,pat,e) -> begin match e with 
      | AETEmp a0 -> (* TODO : how should we print double annotation? *)
        begin match pp_a with
          | None -> ()
          | Some pp_a -> eprintf "An inner annotation %a is not printed." pp_a a0 end;
        with_annot ?pp_a ~paren:false (fun ppf () -> fprintf ppf "%a" ppr_alpat pat) ppf a
      | _ ->
        with_annot ?pp_a
          (fun ppf () ->
            fprintf ppf "@[%a: @[%a@]@]" ppr_alpat pat (ppr_aexpr ?pp_a) e) ppf a
  end
  | _ -> failwith "ppr_SugaredAEdg: cant' print inside {}"
and ppr_abexpr ?pp_a ppf (be0:'a abexpr) = match be0 with 
  | AIsemp(a,e) ->
    with_annot ?pp_a ~paren:false
      (fun ppf () -> fprintf ppf "isempty(%a)" (ppr_aexpr ?pp_a) e) ppf a
  | ABisim(a,e1,e2) ->
    with_annot ?pp_a ~paren:false
      (fun ppf () ->
        fprintf ppf "bisimilar(%a,@ %a)" (ppr_aexpr ?pp_a) e1 (ppr_aexpr ?pp_a) e2) ppf a
  | ANot(a,be) ->
    with_annot ?pp_a
      (fun ppf () ->
        if abexpr_gt be be0
        then fprintf ppf "not (%a)" (ppr_abexpr ?pp_a) be
        else fprintf ppf "not %a" (ppr_abexpr ?pp_a) be) ppf a
  | AAnd(a,be1,be2) ->
    with_annot ?pp_a
      (fun ppf () ->
        if (abexpr_gt be1 be0) && (abexpr_gt be2 be0)
        then fprintf ppf "(%a)@ and (%a)" (ppr_abexpr ?pp_a) be1 (ppr_abexpr ?pp_a) be2
        else if (abexpr_gt be1 be0) 
        then fprintf ppf "(%a)@ and %a" (ppr_abexpr ?pp_a) be1 (ppr_abexpr ?pp_a) be2
        else if (abexpr_gt be2 be0) 
        then fprintf ppf "%a@ and (%a)" (ppr_abexpr ?pp_a) be1 (ppr_abexpr ?pp_a) be2
        else fprintf ppf "%a@ and %a" (ppr_abexpr ?pp_a) be1 (ppr_abexpr ?pp_a) be2) ppf a
  | AOr(a,be1,be2) ->
    with_annot ?pp_a
      (fun ppf () ->
        fprintf ppf "%a@ or %a" (ppr_abexpr ?pp_a) be1 (ppr_abexpr ?pp_a) be2) ppf a
  | ALcmp (a,p1,op,p2) ->
    with_annot ?pp_a
      (fun ppf () -> fprintf ppf "%a@ %a %a" ppr_alpat p1 ppr_alcmp op ppr_alpat p2) ppf a
  | ATrue a ->
    with_annot ?pp_a ~paren:false (fun ppf () -> fprintf ppf "%s" "true") ppf a
  | AFalse a ->
    with_annot ?pp_a ~paren:false (fun ppf () -> fprintf ppf "%s" "false") ppf a
  | ALpred(a,alpt,p) ->
    with_annot ?pp_a ~paren:false
      (fun ppf () -> fprintf ppf "%a(%a)" ppr_alptype alpt ppr_alpat p) ppf a
and ppr_alptype ppf = function
    ALPLbl -> fprintf ppf "%s" "isLabel"
  | ALPStr -> fprintf ppf "%s" "isString"
  | ALPInt -> fprintf ppf "%s" "isInt"
  | ALPFlt -> fprintf ppf "%s" "isFloat"
  | ALPBol -> fprintf ppf "%s" "isBool"
and ppr_alcmp ppf = function
    ALOEq -> fprintf ppf "%s" "="
  | ALOLt -> fprintf ppf "%s" "<"
  | ALOGt -> fprintf ppf "%s" ">"
and ppr_vname ppf vn = fprintf ppf "%s" vn
and ppr_marker ppf m = fprintf ppf "%s" m
and ppr_alpat ppf = function
    ALVar  (_,lname )  -> fprintf ppf "%a" ppr_lname lname
  | ALLit  (_,lit)     -> fprintf ppf "%a" ppr_allit lit
  | ALBin (_,lp1,op,lp2) ->
      match (lp1,lp2) with
	ALBin (_,_,op1,_),ALBin (_,_,op2,_) ->
	  if (albinop_gt (op1,op)) && (albinop_gt (op2,op))
	  then fprintf ppf "(%a)@ %a (%a)" ppr_alpat lp1 ppr_albinop op ppr_alpat lp2
	  else if (albinop_gt (op1,op))
	  then fprintf ppf "(%a)@ %a %a" ppr_alpat lp1 ppr_albinop op ppr_alpat lp2
	  else if (albinop_gt (op2,op))
	  then fprintf ppf "%a@ %a (%a)" ppr_alpat lp1 ppr_albinop op ppr_alpat lp2
	  else fprintf ppf "%a@ %a %a" ppr_alpat lp1 ppr_albinop op ppr_alpat lp2
      |	ALBin (_,_,op1,_), _ ->
	  if (albinop_gt (op1,op))
	  then fprintf ppf "(%a)@ %a %a" ppr_alpat lp1 ppr_albinop op ppr_alpat lp2
	  else fprintf ppf "%a@ %a %a" ppr_alpat lp1 ppr_albinop op ppr_alpat lp2
      | _,ALBin (_,_,op2,_) ->
	  if (albinop_gt (op2,op))
	  then fprintf ppf "%a@ %a (%a)" ppr_alpat lp1 ppr_albinop op ppr_alpat lp2
	  else fprintf ppf "%a@ %a %a" ppr_alpat lp1 ppr_albinop op ppr_alpat lp2
      |    _              ->
	  fprintf ppf "%a@ %a %a" ppr_alpat lp1 ppr_albinop op ppr_alpat lp2
and ppr_albinop ppf = function
    ALAdd ->     fprintf ppf "%s" "+"
  | ALSub ->     fprintf ppf "%s" "-"
  | ALMul ->     fprintf ppf "%s" "*"
  | ALDiv ->     fprintf ppf "%s" "/"
  | ALMod ->     fprintf ppf "%s" "%%"
  | ALConc ->    fprintf ppf "%s" "^"
and ppr_allit ppf = function
    ALLbl (l) -> fprintf ppf "%s" l
  | ALStr (s) -> fprintf ppf "%S" s
  | ALInt (i) -> fprintf ppf "%i" i
  | ALFlt (f) -> fprintf ppf "%f" f
  | ALBol (b) -> fprintf ppf "%B" b
  | ALUkn     -> fprintf ppf "%s" "?"
  | ALEps     -> fprintf ppf "%s" "!"
and ppr_lname ppf l = fprintf ppf "%s" l
and assocr_GT = function
    AEDUni (al,AEDUni (ar,x,y),z) -> assocr_GT (AEDUni (al,x, AEDUni (ar,y,z)))
  | AEDUni (a,x,y)                -> AEDUni (a,assocr_GT x, assocr_GT y)
  | AEUni  (al,AEUni  (ar,x,y),z) -> assocr_GT (AEUni  (al,x, AEUni  (ar,y,z)))
  | AEUni (a,x,y)                 ->  AEUni  (a,assocr_GT x, assocr_GT y)
  | x                             -> x
and toList_GT = function
    AEGEmp _                            -> []
  | AEDUni (_,x,(AEDUni (_,_,_) as xs)) -> x::toList_GT xs
  | AEDUni (_,x,AEGEmp _)               -> [x]
  | AEDUni (_,x,y)                      -> [x;y]
  | AETEmp _                            -> []
  | AEUni  (_,x,(AEUni  (_,_,_) as xs)) -> x::toList_GT xs
  | AEUni (_,x,AETEmp _)                -> [x]
  | AEUni (_,x,y)                       -> [x;y]
  | x                                   -> [x]

let ppr_a_aexpr f e = ppr_aexpr f e

(** printer to standard output *)
let print_aexpr ?pp_a = fprintf std_formatter "%a@." (ppr_aexpr ?pp_a)


let vname2str = toStr pr_vname
let lname2str = toStr pr_lname
