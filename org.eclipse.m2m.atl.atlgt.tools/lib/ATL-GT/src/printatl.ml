open Fputil
open Atl
open Format

let ppr_seq_comma_nl pp_a fmt xs =
  fprintf fmt "@[";
  begin match xs with
    | [] -> ()
    | x::xs -> pp_a fmt x; List.iter (fprintf fmt ",@\n%a" pp_a) xs end;
  fprintf fmt "@]"

let ppr_seq_nl pp_a fmt xs =
  fprintf fmt "@[";
  begin match xs with
    | [] -> ()
    | x::xs -> pp_a fmt x; List.iter (fprintf fmt "@\n%a" pp_a) xs end;
  fprintf fmt "@]"

let ppr_seq_delim pp_a fmt (delim:string) xs =
  fprintf fmt "@[";
  begin match xs with
    | [] -> ()
    | x::xs -> pp_a fmt x; List.iter (fprintf fmt "%s%a" delim pp_a) xs end;
  fprintf fmt "@]"


let rec ppr_atl_module ppf = function
    Module (id,oclModel_list1,oclModel_list2,moduleElement_list) ->
     (*    Module of id * oclModel list * oclModel list * moduleElement list *)
      fprintf ppf "@[module %a;@\ncreate %a from %a;@\n%a @]"
        ppr_id id ppr_oclModel_list oclModel_list1 ppr_oclModel_list oclModel_list2 ppr_moduleElement_list moduleElement_list
and ppr_id ppf = function
    id -> fprintf ppf "%s" id
and ppr_oclModel_list ppf oclModel_list = 
   List.iter (fun ocl_Model ->
      fprintf ppf "%a" ppr_oclModel ocl_Model) oclModel_list
and ppr_oclModel ppf = function
 OclModel(id1,id2) -> fprintf ppf "%a : %a" ppr_id id1 ppr_id id2
and ppr_moduleElement_list ppf moduleElement_list = 
   (* List.iter (fun moduleElement ->
      fprintf ppf "%a" ppr_moduleElement moduleElement) moduleElement_list *)
    ppr_seq_nl ppr_moduleElement  ppf moduleElement_list
and ppr_moduleElement ppf = function 
  Rule rule -> fprintf ppf "%a" ppr_rule rule
and ppr_rule ppf = function
  MatchedRule (id,inPattern,outPatternOpt) -> 
    fprintf ppf "@[<hov 2>rule %a {@\n@[%a%a@]@]@\n}" ppr_id id ppr_inPattern inPattern ppr_outPatternOpt outPatternOpt
and ppr_outPatternOpt ppf = function
  Some outPattern -> fprintf ppf "@\n@[<hov 2>%a@]" ppr_outPattern outPattern
| None            -> fprintf ppf ""
and ppr_outPattern ppf = function
 To (opel) -> 
   fprintf ppf "to@\n";
   (* List.iter (fun ope -> fprintf ppf "%a" ppr_outPatternElement ope) opel *)
   ppr_seq_comma_nl ppr_outPatternElement ppf opel
and ppr_outPatternElement ppf = function
   OutPat(id,oclType,idOpt,blo) ->
     fprintf ppf "%a : %a %a %a" ppr_id id ppr_oclType oclType ppr_in_id_opt idOpt ppr_binding_list_option blo
and ppr_in_id_opt ppf = function
  Some id -> fprintf ppf "in %a" ppr_id id
| None    -> fprintf ppf ""
and ppr_binding_list_option ppf = function
  Some binding_list -> fprintf ppf "@\n@[<hov 1>(@\n@[<hov>%a@]@]@\n)" ppr_binding_list binding_list
| None ->              fprintf ppf "" 
and ppr_binding_list ppf  = function
  binding_list -> 
    (* List.iter (fun binding -> fprintf ppf "%a" ppr_binding binding ) binding_list *)
    ppr_seq_comma_nl ppr_binding ppf binding_list
and ppr_binding ppf = function
 Bind (id,oclExp) -> fprintf ppf "@[%a <- %a@]" ppr_id id ppr_oclExp oclExp
and ppr_oclExp ppf = function
  | Vref(id) -> fprintf ppf "%a" ppr_id id
  | OclUndef -> fprintf ppf "OclUndefined"  (* OclUndefined *)
  | Int(i) -> fprintf ppf "%d" i
  | Rea(f) -> fprintf ppf "%f" f
  | Bl(b)  -> fprintf ppf "%B" b
  | Str(s) -> fprintf ppf "'%s'" s
  | If(c,e1,e2) -> fprintf ppf "@[<hov>if @[%a@]@ then @[%a@]@ else @[%a@] endif@]" ppr_oclExp c ppr_oclExp e1 ppr_oclExp e2
  | Super -> fprintf ppf "super"
  | Enum(i) -> fprintf ppf "#%a" ppr_id i
  | Bag(l)  -> fprintf ppf        "Bag {%a}" ppr_oclExp_list l
  | Set(l)  -> fprintf ppf        "Set {%a}" ppr_oclExp_list l
  | OSet(l) -> fprintf ppf "OrderedSet {%a}" ppr_oclExp_list l
  | Seq(l)  -> fprintf ppf   "Sequence {%a}" ppr_oclExp_list l
  | Map(l)  -> fprintf ppf        "Map {%a}" ppr_map_list l
  | Tup(l) ->  fprintf ppf      "Tuple {%a}" ppr_tuplePart_list l
  | Dot(e,one)-> fprintf ppf "%a.%a" ppr_oclExp e ppr_op_navi_exp one
  | Arr(e,ice)-> fprintf ppf "%a->%a" ppr_oclExp e ppr_it_col_exp ice
  | Ot(t) -> fprintf ppf "%a" ppr_oclType t (* oclType *)
  | Not(e) -> fprintf ppf "not %a" ppr_oclExp e (*TODO priority*) (* not *)
  | Neg(e) -> fprintf ppf "-%a" ppr_oclExp e (*TODO priority*) (* unary - *)
  | Bin(e1,o,e2) -> fprintf ppf "%a %a %a" ppr_oclExp e1 ppr_oclBinOp o ppr_oclExp e2
  | Let(vd,e) -> fprintf ppf "let %a in %a" ppr_variableDeclaration vd ppr_oclExp e (* letExp *)
and ppr_oclBinOp ppf = function
  | Mul  -> fprintf ppf "*" (* * *)
  | Quot -> fprintf ppf "/" (* / *)
  | Div  -> fprintf ppf "div" (* div *)
  | Mod  -> fprintf ppf "mod"  (* mod *)
  | Plus -> fprintf ppf "+" (* + *)
  | Minus -> fprintf ppf "-" (* - *)
  | Eq -> fprintf ppf  "="  (* = *)
  | Gt -> fprintf ppf ">"   (* > *)
  | Lt -> fprintf ppf "<"   (* < *)
  | Ge -> fprintf ppf ">="   (* >= *)
  | Le-> fprintf ppf  "<="   (* <= *)
  | Ne -> fprintf ppf "<>"   (* <> *)
  | And-> fprintf ppf "and"
  | Or-> fprintf ppf  "or"
  | Xor-> fprintf ppf "xor"
  | Implies-> fprintf ppf "immplies"

and ppr_it_col_exp ppf = function
    Iterator(id,idl,e) -> fprintf ppf "%a(%a |@, %a)" ppr_id id ppr_id_list idl ppr_oclExp e (* iteratorExp *)
  | Iterate(idl,vd,e) -> fprintf ppf "iterate (%a;%a|%a)" ppr_id_list idl ppr_variableDeclaration vd ppr_oclExp e(* iterateExp *)
  | COCall(id,el) -> fprintf ppf "%a(%a)" ppr_id id ppr_oclExp_list el (* collectionOperationCallExp *)
and ppr_variableDeclaration ppf = function
    Vdecl(id,t,e) -> fprintf ppf "%a : %a = %a" ppr_id id ppr_oclType t ppr_oclExp e

and ppr_id_list ppf = function
  l -> List.iter (fun id -> fprintf ppf "%a" ppr_id id) l
and ppr_op_navi_exp ppf = function
  | OpCall (id,el) -> fprintf ppf "%a(%a)" ppr_id id ppr_oclExp_list el (* operationCallExp *)
  | NvCall (id)    -> fprintf ppf "%a" ppr_id id  (* navigationOrAttributeCallExp *)


and ppr_tuplePart_list ppf = function
  l -> (* List.iter (fun (id,tOpt,e) ->
       fprintf ppf "%a %a = %a" ppr_id id ppr_oclTypeOpt tOpt ppr_oclExp e) l *)
   ppr_seq_delim ppr_tuplePart ppf ", " l 
and ppr_tuplePart ppr = function
 (id,tOpt,e) -> fprintf ppr "%a %a = %a" ppr_id id ppr_oclTypeOpt tOpt ppr_oclExp e
and ppr_oclTypeOpt ppf = function
  Some t -> fprintf ppf ":%a" ppr_oclType t
 |None   -> fprintf ppf ""
and ppr_map_list ppf = function
  l -> (*List.iter (fun (k,v) -> fprintf ppf "%a -> %a" ppr_oclExp k ppr_oclExp v) l*)
   ppr_seq_delim ppr_map_elem ppf ", " l 
and ppr_map_elem ppf = function
  (k,v) -> fprintf ppf "%a -> %a" ppr_oclExp k ppr_oclExp v
and ppr_oclExp_list ppf = function
  oclel -> List.iter (fun oclExp -> fprintf ppf "%a" ppr_oclExp oclExp) oclel
and ppr_inPattern ppf = function
  From (inPatternElement,oclExpOpt) ->
    fprintf ppf "@[<hov 1>from@, @[<hov 1>%a %a@]@]" ppr_inPatternElement inPatternElement ppr_oclExpOpt oclExpOpt
and ppr_oclExpOpt ppf = function
  Some e  -> fprintf ppf "@\n@[@[<hov 1>(%a)@]@]" ppr_oclExp e
| None -> fprintf ppf ""
and ppr_inPatternElement ppf = function
  InPat (id,oclType,idOpt) ->
    fprintf ppf "%a : %a %a" ppr_id id ppr_oclType oclType ppr_idOpt idOpt
and ppr_idOpt ppf = function
   Some id -> fprintf ppf " : %a" ppr_id id
 | None    -> fprintf ppf "" 
and ppr_oclType ppf = function 
    OclModelElement (id1,id2) -> fprintf ppf "%a!%a" ppr_id id1 ppr_id id2
  | OclAny -> fprintf ppf "OclAny"
  | TupleType (tupleTypeAttribute_list) ->
    List.iter (fun tupleTypeAttribute ->
      fprintf ppf "%a" ppr_tupleTypeAttribute tupleTypeAttribute) tupleTypeAttribute_list
  | MapType (oclType1,oclType2) ->
      fprintf ppf "map(%a,%a)" ppr_oclType oclType1 ppr_oclType oclType2
  | Integer -> fprintf ppf "integer"
  | Real    -> fprintf ppf "real"
  | Boolean -> fprintf ppf "bool"
  | String  -> fprintf ppf "string"
  | BagType(t)        -> fprintf ppf        "Bag {%a}" ppr_oclType t
  | SetType(t)        -> fprintf ppf        "Set {%a}" ppr_oclType t
  | OrderedSetType(t) -> fprintf ppf "OrderedSet {%a}" ppr_oclType t
  | SequenceType(t)   -> fprintf ppf   "Sequence {%a}" ppr_oclType t
  | CollectionType(t) -> fprintf ppf "Collection {%a}" ppr_oclType t
  | OclType           -> fprintf ppf    "OclType"
and ppr_tupleTypeAttribute ppf = function
    TupTypAttr (id,t) -> fprintf ppf "%a : %a" ppr_id id ppr_oclType t


    
 
    
   
 
    
  
