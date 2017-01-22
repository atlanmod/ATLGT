(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
(* $id: km3.ml,v 1.4 2008/07/18 10:32:31 ksk exp $ *)

open ExtSetMap

type name = string
type literal = name 
type bounds = [
| `range of int * int
| `to_many of int (* more than or equal to N *)
(* We can encode following constructs by `range and `to_many *)
(* | `one *)
(* | `many *)
]

module Name = struct type t = name let compare = compare end
module NameSet = Set.Make(Name)
module NameMap = Map.Make(Name)

type feature = [
| `attribute of _feature
| `reference of reference
]
and reference = {
  feature: _feature;
  is_container: bool;
  opposite_of: name option;
}
and  _feature = {
  multiplicity: multiplicity;
  typeref: name;
}
and multiplicity = [
| bounds
| `ordered of bounds
]

type metamodel = package list

and package = { pname: name; classifiers: classifier list }

(* Since 'class' is reserved in OCaml, we use Germany. *)
and klasse = { is_abstract: bool;
               kname: name;
               supertypes: name list;
               features: feature NameMap.t }

and classifier = [
| `klasse of klasse
| `datatype of name
| `enumeration of
    (* enumeration name *) name *
    (* literals *) literal list
]

