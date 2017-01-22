(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
open Format
open Print
open Km3

let pp_name = pp_string
let pp_literal = pp_name
let pp_bounds fmt (b:bounds) = match b with
(*   | `one -> fprintf fmt "`one" *)
  | `range(i,j) -> fprintf fmt "`range(%d,%d)" i j
  | `to_many i -> fprintf fmt "`to_many %d" i
(*   | `many -> fprintf fmt "`many" *)

let rec pp_feature fmt (ft:feature) = match ft with
  | `attribute _f -> fprintf fmt "@[<2>`attribute@,%a@]" pp__feature _f
  | `reference r -> fprintf fmt "@[<2>`reference@,%a@]" pp_reference r

and pp_reference fmt r =
  pp_record [ pp_field "feature" pp__feature r.feature;
              pp_field "is_container" pp_bool r.is_container;
              pp_field "opposite_of" (pp_option pp_name) r.opposite_of ] fmt
    
and pp__feature fmt _f =
  pp_record [ pp_field "multiplicity" pp_multiplicity _f.multiplicity;
              pp_field "typeref" pp_name _f.typeref ] fmt

and pp_multiplicity fmt (m:multiplicity) = match m with
  | #bounds as b -> pp_bounds fmt b
  | `ordered b -> fprintf fmt "`ordered(%a)" pp_bounds b

let pp_name_map_t pp_a = NameMap.pp_t "NameMap" pp_name pp_a

let pp_features = pp_name_map_t pp_feature

let rec pp_metamodel fmt = pp_list pp_package fmt

and pp_package fmt pkg =
  pp_record [ pp_field "pname" pp_name pkg.pname;
              pp_field "classfiers" (pp_list pp_classifier) pkg.classifiers ] fmt

and pp_klasse fmt kls =
  pp_record [ pp_field "is_abstract" pp_bool kls.is_abstract;
              pp_field "kname" pp_name kls.kname;
              pp_field "supertypes" (pp_list pp_name) kls.supertypes;
              pp_field "features" pp_features kls.features ] fmt

and pp_classifier fmt (cls:classifier) = match cls with
  | `klasse kls -> fprintf fmt "@[<2>`klasse@,%a@]" pp_klasse kls
  | `datatype name -> fprintf fmt "`datatype %a" pp_name name
  | `enumeration(name,lits) ->
      fprintf fmt "`enumeration(%a,@,%a)" pp_name name (pp_list pp_literal) lits

let pp_name_set_t = NameSet.pp_t "NameSet" pp_name
