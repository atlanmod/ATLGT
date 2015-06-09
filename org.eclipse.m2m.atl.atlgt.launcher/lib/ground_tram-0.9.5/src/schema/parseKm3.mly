/* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 */
%{
open Parse
open Km3
%}

%token EOF
%token PACKAGE ABSTRACT CLASS EXTENDS COMMA LBRACE RBRACE
%token ATTRIBUTE REFERENCE ORDERED COLON OPPOSITE_OF SEMICOLON
%token LBRACKET RBRACKET MINUS STAR CONTAINER DATATYPE ENUMERATION 
%token LITERAL
%token <int> INT
%token <string> STRING QUOTED

%start entry
%type <Km3.metamodel> entry
%type <[>Km3.classifier]> klasse
%type <[>Km3.classifier]> enumeration
%type <[>Km3.bounds]> bounds
%%
entry:
| packages EOF
{ return ~ntsym:"EntryPoint" $1 }

packages:
| package
{ return ~ntsym:"packages" [$1] }
| package packages
{ return ~ntsym:"packages" ($1::$2) }

package:
| PACKAGE name LBRACE classifiers RBRACE
{ return ~ntsym:"package" { pname = $2; classifiers = $4 } }


classifiers:
|
{ return ~ntsym:"classfiers" [] }
| classifier classifiers
{ return ~ntsym:"classfiers" ($1::$2) }

classifier:
| klasse
{ return ~ntsym:"classifier" $1 }
| datatype
{ return ~ntsym:"classifier" $1 }
| enumeration
{ return ~ntsym:"classifier" $1 }

klasse:
| is_abstract CLASS name supertypes LBRACE features RBRACE
{ let k = { is_abstract = $1; kname = $3; supertypes = $4; features = $6 } in
  return ~ntsym:"classifier" (`klasse k) }

is_abstract:
|
{ return ~ntsym:"is_abstract" false }
| ABSTRACT
{ return ~ntsym:"is_abstract" true }

supertypes:
|
{ return ~ntsym:"supertypes" [] }
| EXTENDS typelist
{ return ~ntsym:"supertypes" $2 }

typelist:
| typeref
{ return ~ntsym:"typelist" [$1] }
| typeref COMMA typelist
{ return ~ntsym:"typelist" ($1::$3) }

features:
|
{ return ~ntsym:"features" NameMap.empty }
| feature features
{ let name, ft = $1 in
  return ~ntsym:"features" (NameMap.add name ft $2) }

feature:
| attribute
{ return ~ntsym:"feature" $1 }
| reference
{ return ~ntsym:"feature" $1 }

attribute:
| ATTRIBUTE name multiplicity COLON typeref SEMICOLON
{ return ~ntsym:"attribute" ($2, `attribute { multiplicity = $3;
                                               typeref = $5 }) }

reference:
| REFERENCE name multiplicity is_container
  COLON typeref opposite_of SEMICOLON
{ return ~ntsym:"reference" ($2, `reference { feature = { multiplicity = $3;
                                                           typeref = $6 };
                                               is_container = $4;
                                               opposite_of = $7 }) }

multiplicity:
| bounds
{ return ~ntsym:"multiplicity" $1 }
| bounds ORDERED
{ return ~ntsym:"multiplicity" (`ordered $1) }

bounds:
|
{ return ~ntsym:"bounds" (`range(1,1)) (* `one *) }
| LBRACKET INT MINUS INT RBRACKET
{ return ~ntsym:"bounds" (`range($2,$4)) }
| LBRACKET INT MINUS STAR RBRACKET
{ return ~ntsym:"bounds" (`to_many $2) }
| LBRACKET STAR RBRACKET
{ return ~ntsym:"bounds" (`to_many 0) (* `many *) }

is_container:
|
{ return ~ntsym:"is_container" false }
| CONTAINER
{ return ~ntsym:"is_container" true }

opposite_of:
|
{ return ~ntsym:"opposite_of" None }
| OPPOSITE_OF name
{ return ~ntsym:"opposite_of" (Some $2) }

datatype:
| DATATYPE name SEMICOLON
{ return ~ntsym:"datatype" (`datatype $2) }

enumeration:
| ENUMERATION name LBRACE literals RBRACE
{ return ~ntsym:"enumeration" (`enumeration($2,$4)) }

literals:
|
{ return ~ntsym:"literals" [] }
| literal literals
{ return ~ntsym:"literals" ($1::$2) }

literal:
| LITERAL name SEMICOLON
{ return ~ntsym:"literal" $2 }

typeref:
| name
{ return ~ntsym:"typeref" $1 }

name:
| STRING
{ return ~ntsym:"name" $1 }
| QUOTED
{ return ~ntsym:"name" (unquote $1) }
