(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
(**
  Internal Schema Language for MSO-based Typechecking.
 
 Our typechecking is implemented on this schema language.
  To support other schemas, we need conversion to this intermal format.
 {[
     <ischema> ::= roottype <itype> where (<name> -> <decl>)*
     <itype>   ::= <name> or <name> or ... or <name>
     <idecl>   ::= { (<edgename> -> <itype>)* }
 ]}
   Currently,
 {[
     <idecl> ::= { (<edgename> -> <itype>)* *}
 ]}
   form (allowance of unmentioned edges) is not supported.
 *)
open Print
open Format
open Km3
open ExtSetMap
open MsoTcUtil
open Mona



(* ******************************** AST *********************************** *)

(** whole schema *)
type internal_schema =
	| ISchema of internal_type * internal_decl NameMap.t

(** type declaration: map from edgename to type *)
and internal_decl =
	| IDecl of internal_type NameMap.t

(** type: name1 UNION name2 UNION ... UNION nameN *)
and internal_type =
	| IType of name list





(* ******************************* Pretty Printer ************************** *)

module MsoTcSchemaPrint = struct
	(** Details of the pretty printer *)

	let rec pp_join sep pp_a ppf = function
		| []   -> fprintf ppf ""
		| [e]  -> fprintf ppf "%a" pp_a e
		| e::t -> fprintf ppf "%a %s %a" pp_a e sep (pp_join sep pp_a) t

	let rec pp_internal_schema ppf (ISchema (rt, decls)) =
		fprintf ppf "roottype (%a) where%a"
		   pp_type rt
		   (pp_join "" pp_binding) (NameMap.bindings decls)

	and pp_binding ppf (k, IDecl v) =
		fprintf ppf "@,@;<2 2>@[  type %s {%a}@]" k (pp_join "," pp_et) (NameMap.bindings v)

	and pp_et ppf (e, t) =
		fprintf ppf "%s:(%a)" e pp_type t

	and pp_type ppf (IType namelist) =
		fprintf ppf "%a" (pp_join "|" pp_string) namelist

	and pp_string ppf s =
		fprintf ppf "%s" s
end



(* ***************************** accessors *********************************** *)

(** The set of names used as edge-labels *)
let edges_of_schema (ISchema (rt, decls)) : NameSet.t =
	NameMap.fold (fun _ (IDecl decl) acc ->
		NameMap.fold (fun edg typ acc ->
			NameSet.add edg acc
		) decl acc
	) decls NameSet.empty

(** The set of names used as type-names *)
let types_of_schema (ISchema (rt, decls)) : NameSet.t =
	NameMap.fold (fun t (IDecl edges) acc ->
		NameSet.add t acc
	) decls NameSet.empty


(** The list of names used as edge-labels *)
let edgenames_of_schema scm : name list =
	NameSet.elements (edges_of_schema scm)

(** The list of names used as type-names *)
let typenames_of_schema scm : name list =
	NameSet.elements (types_of_schema scm)

(** The type of the root node *)
let roottype_of_schema (ISchema (IType rts, decls)) : name list =
	rts

(** TODO: make a type T to T*... *)
let starize e = e









(* ***************************** loaders *********************************** *)

module Km3ToInternalSchema = struct
	(** Details of the KM3 to MSO-Typecheck-Schema conversion. *)

	let rec km3pkg_to_schema (pkg: Km3.package) (rt: string option) : internal_schema =
		let roottype = match rt with None -> roottype_from pkg | Some s -> IType [s] in
		let decls    = decls_from    pkg in
			ISchema (roottype, decls)

	and roottype_from (pkg: Km3.package) : internal_type =
		let classes = List.filter (function `klasse _->true | _ -> false) pkg.classifiers in
			match classes with
			| []               -> failwith "[ERROR] At least one class must be defined in the KM3"
			| (`klasse c) :: _ -> IType [headtype_name c]
			| _                -> failwith "[BUG] should not happen :: in roottype_from"

	and decls_from (pkg: Km3.package) : internal_decl NameMap.t =
		List.fold_left (fun theMap -> function 
			| `datatype s when s="String" or s="Int"
		                         -> NameMap.addl [
			                          headdatatype_name s, headdatatype_decl s;
			                          bodydatatype_name s, bodydatatype_decl s;
			                          emptytype_name (),   emptytype_decl ()
			                        ] theMap
			| `klasse   c        -> NameMap.addl [
			                          headtype_name c, class_to_headtype_decl c;
			                          bodytype_name c, class_to_bodytype_decl c
			                        ] theMap
			| _ -> failwith "[RESTRICTION] currently only String and Int is supported as datatype"
		) NameMap.empty pkg.classifiers

	and e name = "E" ^ name
	and headtype_name (c: Km3.klasse) : name = "H" ^ c.kname
	and bodytype_name (c: Km3.klasse) : name = "B" ^ c.kname
	and headdatatype_name (s: string) : name = "H" ^ s
	and bodydatatype_name (s: string) : name = "B" ^ s
	and emptytype_name () : name = "EmptyT"

	and emptytype_decl () : internal_decl =
		IDecl NameMap.empty

	and headdatatype_decl (s: string) : internal_decl =
		IDecl (NameMap.add (e s) (IType [bodydatatype_name s]) NameMap.empty)

	and bodydatatype_decl (s: string) : internal_decl =
		IDecl (NameMap.add ("D"^s) (IType [emptytype_name ()]) NameMap.empty)

	and class_to_headtype_decl (c: Km3.klasse) : internal_decl =
		IDecl (NameMap.add (e c.kname) (IType [bodytype_name c]) NameMap.empty)

	and class_to_bodytype_decl (c: Km3.klasse) : internal_decl =
		IDecl (NameMap.fold
			(fun edgename edgetype theDecl ->
				match edgetype with
				| `attribute {typeref="String"; multiplicity=(`to_many 0)}
				| `reference {feature = {typeref="String"; multiplicity=(`to_many 0)}} ->
					NameMap.add (e edgename) (IType [headdatatype_name "String"]) theDecl
				| `attribute {typeref="Int";    multiplicity=(`to_many 0)}
				| `reference {feature = {typeref="Int";    multiplicity=(`to_many 0)}} ->
					NameMap.add (e edgename) (IType [headdatatype_name "Int"]) theDecl
				| `attribute {typeref=desttype; multiplicity=(`to_many 0)}
				| `reference {feature = {typeref=desttype; multiplicity=(`to_many 0)}} ->
					NameMap.add (e edgename) (IType ["H" ^ desttype]) theDecl
				| `attribute {typeref=_; multiplicity=_}
				| _  -> failwith "[RESTRICTION] currently, multiplicity other than [0-*] is not allowed"
			)
			c.features NameMap.empty
		)
end

(**
  KM3 to Internal Schema.

  A subset of KM3 metamodel can be converted to our internal schema.
  Current encoding will yield from
 {[
        package My {
          class Foo { reference aaa[0-*] : Bar; }
          class Bar { reference bbb[0-*] : Foo;
                      reference ccc[0-*] : String; }
          datatype String;
        }
 ]}
   the schema as below:
 {[
        roottype HFoo where
           type HFoo  { Foo: BFoo }               -- Header of Foo
           type BFoo  { aaa: HBar }               -- Body of Foo
           type HBar  { Bar: BBar }               -- Header of Bar
           type BBar  { bbb: HFoo, ccc: HString } -- Body of Bar
           type HString { String: DString }       -- Header of String
           type DString { DString: EmptyT }       -- Body of String, with "DString" edge
           type EmptyT {}
 ]}
 - restricted to a single-package KM3
 - the first class serves as the root type
 - cardinality support is for [0-*] only
 - class names are assumed to occur explicity in the graphs
*)
let rec km3_to_schema (km3: Km3.metamodel) (roottype: string option) : internal_schema =
	match km3 with
	| []
	| _ :: _ :: _  -> failwith "[RESTRICTION] multi-package KM3 is not supported yet"
	| [pkg]        -> Km3ToInternalSchema.km3pkg_to_schema pkg roottype


let global_config_paths : (string list) ref = ref []

(** Load KM3 into the internal schema format

    By separating with spaces like "foo.km3 HFoo", the root type can be manually
    specified. If omitted, the first class is used as the root type
 *)
let load_schema_from_file (filename: string) : internal_schema =
	let filename, root =
		try
			let i = String.index filename ' ' in
				(String.sub filename 0 i, Some (String.sub filename (i+1) (String.length filename-i-1)))
		with _ ->
			(filename, None)
	in
	try
		let filename = FileUtil.find_file !global_config_paths filename in
			km3_to_schema (Parse.parse_file ~parse:ParseKm3.entry ~lex:LexKm3.token filename) root
	with _ ->
		failwith_error ("Schema file <"^filename^"> cannot be opened as KM3 file")
