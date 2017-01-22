(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
open ExtSetMap
type name = string
type literal = name
type bounds = [ `range of int * int | `to_many of int ]
module Name : sig type t = name val compare : 'a -> 'a -> int end
module NameSet : Set.S with type elt = Name.t
module NameMap : Map.S with type key = Name.t
type feature = [ `attribute of _feature | `reference of reference ]
and reference = {
  feature : _feature;
  is_container : bool;
  opposite_of : name option;
}
and _feature = { multiplicity : multiplicity; typeref : name; }
and multiplicity =
    [ `ordered of bounds | `range of int * int | `to_many of int ]
type metamodel = package list
and package = { pname : name; classifiers : classifier list; }
and klasse = {
  is_abstract : bool;
  kname : name;
  supertypes : name list;
  features : feature NameMap.t;
}
and classifier =
    [ `datatype of name
    | `enumeration of name * literal list
    | `klasse of klasse ]
