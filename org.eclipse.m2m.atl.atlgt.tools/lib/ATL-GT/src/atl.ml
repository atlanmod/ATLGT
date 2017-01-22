(* AST for ATL-Minimal.bnf *)

(*
  BNF           OCaml
  IDENTIFIER    id
  INTEGER       int
  STRING        string
  FLOAT         float
*)

type id = string

type oclBinOp =
  | Mul   (* * *)
  | Quot  (* / *)
  | Div   (* div *)
  | Mod   (* mod *)
  | Plus  (* + *)
  | Minus (* - *)
  | Eq    (* = *)
  | Gt    (* > *)
  | Lt    (* < *)
  | Ge    (* >= *)
  | Le    (* <= *)
  | Ne    (* <> *)
  | And
  | Or
  | Xor
  | Implies

type oclExp = (* oclExpresssion *)
  | Vref of id
  | OclUndef (* OclUndefined *)
  | Int of int
  | Rea of float
  | Bl  of bool
  | Str of string
  | If  of oclExp * oclExp * oclExp 
  | Super (* superExp *)
  | Enum of id (* enumLiteralExp *)
  | Bag  of oclExp list
  | Set  of oclExp list
  | OSet of oclExp list
  | Seq  of oclExp list
  | Map  of (oclExp * oclExp) list
  | Tup  of (id * oclType option * oclExp) list
  | Dot  of oclExp * op_navi_exp
  | Arr  of oclExp * it_col_exp
  | Ot   of oclType (* oclType *)
  | Not  of oclExp (* not *)
  | Neg  of oclExp (* unary - *)
  | Bin  of oclExp * oclBinOp * oclExp
  | Let  of variableDeclaration * oclExp (* letExp *)
and op_navi_exp =
  | OpCall of id * oclExp list (* operationCallExp *)
  | NvCall of id               (* navigationOrAttributeCallExp *)
and it_col_exp = 
    Iterator of id * id list * oclExp (* iteratorExp *)
  | Iterate  of id list * variableDeclaration * oclExp (* iterateExp *)
  | COCall   of id * oclExp list (* collectionOperationCallExp *)
and variableDeclaration =
    Vdecl of id * oclType * oclExp
and binding = Bind of id * oclExp
and oclType = 
    OclModelElement of id * id
  | OclAny
  | TupleType of tupleTypeAttribute list
  | MapType   of oclType * oclType
  | Integer (* numeric *) (* primitive *)
  | Real    (* numeric *) (* primitive *)
  | Boolean (* primitive *)
  | String  (* primitive *)
  | BagType         of oclType (* collectionType *)
  | SetType         of oclType (* collectionType *)
  | OrderedSetType  of oclType (* collectionType *)
  | SequenceType    of oclType (* collectionType *)
  | CollectionType  of oclType (* collectionType *)
  | OclType                    (* oclType_abstractContents *)
and tupleTypeAttribute = 
   TupTypAttr of id * oclType  (* tupleTypeAttribute *)

type outPatternElement = OutPat of id * oclType * id option * (binding list) option
type outPattern        = To     of outPatternElement list
type inPatternElement  =  InPat of id * oclType * id option
type inPattern         = From   of inPatternElement * oclExp option
type rule              = MatchedRule of id * inPattern * outPattern option
type moduleElement     = Rule of rule
type oclModel = OclModel of id * id
type atl_module =
   Module of id * oclModel list * oclModel list * moduleElement list



