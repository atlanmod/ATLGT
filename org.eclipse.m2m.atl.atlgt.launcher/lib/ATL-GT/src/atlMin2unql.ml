open UnQL
open Atl
open Km3
open Km3util
open PrintKm3
open Format

let parseatl_file = Parse.parse_file ~parse:Parseatl.entry ~lex:Lexatl.token
let parseKm3_file = Parse.parse_file ~parse:ParseKm3.entry ~lex:LexKm3.token


type gamma = 
 { modulename_env : (string * string) list;
   vartype_env    : (string * (string*string)) list;
   rulename_env   : (string * string) list;
   mmdic_env      : (string * mm_dictionary) list;
 }

let empty_gamma = 
 { modulename_env = [];
   vartype_env    = [];
   rulename_env   = [];
   mmdic_env      = [];
 }

(* 
 Type environment should distinguish the variables from the input metamodel 
 and that from the output metamodel.
 The package (like 'ClassDiagram') is currently working for that purpose.
 So the resolution process for the symbol should be:
  - symbol table lookup should first lookup the entry to resolve the 
    package, and then resolve the detail by looking up the MM dictionary
    by this package.
 *)

let intern_mmdic pkg  mmdic gamma = {gamma with mmdic_env = (pkg,mmdic) :: gamma.mmdic_env }

let lookup_mmdic pkg gamma =
  try (List.assoc pkg gamma.mmdic_env) with
  e -> failwith ("mmdic for package " ^ pkg ^ " is not registered")

let intern_modulename name gamma = {gamma with modulename_env = ("id_m",name) :: gamma.modulename_env }

let lookup_modulename gamma = 
  try (List.assoc "id_m" gamma.modulename_env) with
  e -> failwith "Module name is not registered"

let intern_rulename name gamma = {gamma with rulename_env = ("id_r",name) :: gamma.rulename_env }

let lookup_rulename gamma =
  try (List.assoc "id_r" gamma.rulename_env) with
  e -> failwith "Rule name is not registered"

let intern_vartype var (pkg,name) gamma = {gamma with vartype_env = (var,(pkg,name)) :: gamma.vartype_env}
let lookup_vartype var gamma =
  try (List.assoc var gamma.vartype_env) with
  e -> failwith ("var name " ^ var ^ " is not registered")

let (@@) f g x =  f (g x) (* function composition *)
let zip = List.combine
let unzip = List.split

type a2u_type =
    A2URef  of string * string   (** package name, type name *)
  | A2UPrim of a2u_primtypes     (**  int|float|string|bool *)
and a2u_primtypes =
   A2UInt
 | A2UStr
 | A2UFlt
 | A2UBol

let str2primtypes (typ:string) : a2u_primtypes =
  match typ with
  | "String"  ->  A2UStr
  | "Boolean" ->  A2UBol
  | "Int"     ->  A2UInt
  | "Float"   ->  A2UFlt
  | _ -> failwith ("Unknown primitive type: " ^ typ)


let lookup_classifier (pkg,oclType) (gamma : gamma) : classifier = 
  let mmdic = lookup_mmdic pkg gamma in
  try (NameMap.find oclType mmdic.classifier) with
      Not_found -> failwith (sprintf "classifier %s unknown." oclType)

let feature2type feature (pkg,oclType) (gamma : gamma) : a2u_type =
  let mmdic = lookup_mmdic pkg gamma in
  let kls_entry = lookup_classifier (pkg,oclType) gamma in
  let features = match kls_entry with
    `klasse {is_abstract = _; kname = _; supertypes = _; features = f} -> f
  | _ -> failwith "attribute with non_classifier?" in
  let feature = try (NameMap.find feature features) with
    Not_found -> failwith (sprintf "feature %s for kname %s not found" feature oclType) in
  match feature with
    `attribute {multiplicity = _; typeref = tr}   ->
      let kls_entry = try (NameMap.find tr mmdic.classifier) with
	Not_found -> failwith (sprintf "attribute classifier %s unknown." tr) in
      (match kls_entry with
	`datatype s ->
	  Format.printf ": resolved typeref %s to datatype %s@." tr s;
	  A2UPrim (str2primtypes s)
      | _ -> failwith (sprintf ": structured attribute for %s@." tr))
  | `reference {feature = {multiplicity = _; typeref = tr}; 
		is_container = _; opposite_of = _} -> A2URef (pkg,tr)


let rec resolve_ref ref gamma =
  match ref with
    Vref name ->
      let (pkg,oclType) = lookup_vartype name gamma in
      (pkg,oclType)
  | Dot (ref, NvCall feature) ->
      let (pkg,oclType) = resolve_ref ref gamma in
      (match feature2type feature (pkg,oclType) gamma with
	A2URef  (pkg,typ) -> (pkg,typ)
      | A2UPrim  prim ->
	  Format.printf "feature %s is primitive@." oclType;
	  failwith "resolve_ref: unsupportedReference")
  | _ -> failwith "resolve_ref: unsupportedReference"

let rec ref2type (ref : oclExp) (gamma : gamma) : a2u_type =
  match ref with
    Vref name ->
      let (pkg,oclType) = lookup_vartype name gamma in
      A2URef (pkg,oclType)
  | Dot (ref, NvCall feature) ->
      let (pkg,oclType) = resolve_ref ref gamma in
      feature2type feature (pkg,oclType) gamma
  | Dot (e1,OpCall ("concat", [e2])) ->
      (match (ref2type e1 gamma,ref2type e2 gamma) with
	(A2UPrim A2UStr,A2UPrim A2UStr) -> A2UPrim A2UStr
      | _ -> failwith "ref2type: unmatched operand type(s) for 'concat'")
  | Str s ->  A2UPrim A2UStr
  | Int i ->  A2UPrim A2UInt
  | Rea r ->  A2UPrim A2UFlt
  | Bl  b ->  A2UPrim A2UBol
  | Bin (e1,Plus,e2) ->
      (match (ref2type e1 gamma,ref2type e2 gamma) with
	(A2UPrim A2UStr,A2UPrim A2UStr) -> A2UPrim A2UStr
      | _ -> failwith "ref2type: non-string operand for + is not supported yet")
  | _ -> failwith "ref2type: unsupported reference"

(* typable -> bxable *)
let isBxOclExp (e : oclExp) (gamma : gamma) : bool =
  try (match ref2type e gamma with
        t -> true)
  with e -> false

let da = () (* default annotation *)

let ref2sfuns target_feature id_t (pkg_t,oclType_t) (ref : oclExp) gamma : (unit template * (unit definition) list) =
  let id_r = lookup_rulename gamma in
  let id_m = lookup_modulename gamma in
  let is_final (fnToCall : fun_name) : bool = (fnToCall = `fun_name id_m) in
  (* when the call to r2s is the final one, fun_name is equal to `fun_name id_m,
     which means the result of traversal should be passed to main function *)
  (* r2s
     fnToCall is the name of the function which the defined function
     returned should call at the final step.
     The function name in the pair returned is the name of the function 
     that is called from outside.
     Given OCL expression ((((s).f1).f2)...).fN, the graph traversal starts 
     from innermost outwards, so initial function 
     to call is determined in the innermost OCL expression. It is then passed
     to the outermost level. So, in the inductive case,
       1. receives the name of the sfun to call from caller of r2s,
          and produce the sfun that makes the call to the sfun.
       2. tne name of the sfun generated is the one that should
          be called from the sfuns generated by the inner OCL, so pass the
          name to the r2s for the inner OCL.
       3. pass the function name retured from r2s for the inner OCL 
         to the caller as is.
     An automata-based explanation will be
       OCL : s.f1.f2. ... fN
         s.f1._.f2. ... _.fN
      states : 
         {s, sf1, sf1skip, sf1skipf2,  ... }
      initial state: s
      final state: sf1skipf2...fN 
      transitions: {(s,f1,sf1),(sf1,_,sf1skip),(sf1skip,f2,sf1skipf2),...}
      sfuns:
       letrec sfun s      ({f1:$g}) = sf1      ($g)
                 | s      ({$l:$g}) = {}            (* other case produce empty *)
       and    sfun sf1    ({$l:$g}) = sf1skip  ($g) 
       and    sfun sf1skip({f2:$g}) = sf1skipf2($g)
                 | sf1skip({$l:$g}) = {}
       ...
       and    sfun sf1...({fN:$g}) = {target_feature:id_m($g)}
   *)
  let rec r2s (fnToCall : fun_name) (ref : oclExp)  : (fun_name * (unit definition) list) = match ref with
  | Dot (Vref name, NvCall feature) ->
      let (`fun_name fun_name) = fnToCall in
      let entry_name =
	if (is_final fnToCall) then feature ^ "_" ^ id_r else feature ^ "_" ^ fun_name in
      let fnToCall' = `fun_name entry_name in
      (fnToCall',
       [`def [
	`branch (fnToCall',
		 `argument (`label_const (`label (da,feature)), `var (da,"$g")),
		  (fun app_exp ->
		    if (is_final fnToCall) then
		      `tree (da,[`label (da,target_feature), app_exp ])
		    else
		    app_exp) (`app_exp (da, fnToCall, `var (da,"$g")))
		 );
	(* catch all default clause with empty graph output *)
	`branch (fnToCall',`argument (`var (da,"$l"), `var (da,"$g")),
	      `tree (da,[]))] ])
  | Dot (ref, NvCall feature) ->
      let (`fun_name fun_name) = fnToCall in
      let intermediate_name =
	if (is_final fnToCall) then feature ^ "_" ^ id_r else feature ^ "_" ^ fun_name in
      let fnToCall' = `fun_name ("skip_" ^ intermediate_name) in
      let (fnToCall'', defs) = r2s fnToCall' ref in
      (fnToCall'',
       defs @ [`def [
	(* skip one step unconditionally *)
	`branch ( fnToCall',
		  `argument (`var (da,"$l"), `var (da,"$g")),
                   `app_exp (da, `fun_name intermediate_name, `var (da,"$g")))];
	`def [
	`branch ( `fun_name intermediate_name,
		  `argument (`label_const (`label (da,feature)),`var (da,"$g")),
		  
		  let app_exp = `app_exp (da, fnToCall, `var (da,"$g")) in
		  if (is_final fnToCall) then
		    `tree (da,[`label (da,target_feature), app_exp ])
		  else 
		    app_exp
		 );
	(* catch all default clause with empty graph output *)
	`branch (`fun_name intermediate_name,`argument (`var (da,"$l"), `var (da,"$g")),
		  `tree (da,[]))]])
  | _ -> failwith "ref2type: unsupported reference"
  in
  match ref with
    Vref name -> (`tree (da,[`label (da,target_feature), `app_exp (da, `fun_name id_m, `var (da,"$g"))]),[])
  | ref      -> 
      let (fname,defs) = r2s (`fun_name id_m) ref in
      (`app_exp (da, fname, `var (da,"$g")),defs)

(* newID  *)
module type GENVID = 
  sig 
    val next : unit -> int
  end

module GenVId : GENVID = 
  struct
    let c = ref 0
    let next () = incr c ; !c
  end

let newgvname () : string = "$g" ^ (string_of_int (GenVId.next ()))
let newlvname () : string = "$l" ^ (string_of_int (GenVId.next ()))

let oclExp2unqlBinds (p : unit pattern) (ref : oclExp) (gamma : gamma) : unit where =
  let rec o2b (p : unit pattern) (ref : oclExp) : unit where =
    match ref with
      Vref name -> [`pat_in (p, `var (da,"$g"))] (* should use the name of the ATL variable *)
     (* Dot case should be split into two cases, general and with skip *)
    | Dot (Vref name as vs, NvCall v) ->
	let gv = newgvname () in 
	(o2b (`var (da,gv)) vs) @ 
	[`pat_in (`tree [(  `concat (`label (da,v), `any),p)], `var (da,gv))]
    | Dot (vs, NvCall v) ->
	let gv = newgvname () in 
	(o2b (`var (da,gv)) vs) @ 
	[`pat_in (`tree [(`concat (`label (da,v),`any) ,p)], `var (da,gv))]
    | Str s -> [`pat_in (p, `tree (da,[`string (da,s),`tree (da,[]) ]))]
    | Dot (e1,OpCall ("concat", [e2])) | Bin (e1,Plus,e2)  ->
	let l1 = newlvname () in
	let l2 = newlvname () in
	(o2b (`tree [(`var (da,l1), `tree [])]) e1)
        @
	(o2b (`tree [(`var (da,l2), `tree [])]) e2)
        @
	[`pat_in (p, `tree (da,[(`binary (da,`CONCAT,`var (da,l1),`var (da,l2)), `tree (da,[]) )]))]
    | _ -> failwith "oclExp2unqlBinds: unsupported OCL expression"
  in o2b p ref

let a2u_primtypes2tagname (prim : a2u_primtypes) : string =
  match prim with
    A2UStr -> "String"  
  | A2UInt -> "Int"
  | A2UFlt -> "Float"
  | A2UBol -> "Boolean" 

let bind2unql id_t (pkg_t,oclType_t) (target_feature, ref) (gamma : gamma) : (unit template) = 
  let tag = `label (da, 
    match (ref2type ref gamma) with
      A2UPrim  prim -> a2u_primtypes2tagname prim
    | A2URef  (pkg,typ) -> failwith "bind2unql: reference type should not come here") in
  let gv = newgvname () in 
  `expr (da,
	{action =
	 `query (da, `tree (da, [`label (da,target_feature),`tree (da,  [tag,  `var (da,gv)])]) );
	 where = oclExp2unqlBinds (`var (da,gv)) ref  gamma })

let fix_xmiid (s : string) : string = 
   match s with 
  "__xmiID__" -> (* "xmi_id" *) s
 | _          -> s 
  
let rec fixOclExp (e : oclExp) : oclExp =
  match e with
  | Vref  id -> Vref (fix_xmiid id)
  | Dot (e1, nav) -> Dot (fixOclExp e1,fix_op_navi_exp nav)
  | If  (e1,e2,e3) -> If (fixOclExp e1,fixOclExp e2, fixOclExp e3)
  | Not e -> Not (fixOclExp e)
  | Neg e -> Neg (fixOclExp e)
  | Bin(e1,op,e2) -> Bin(fixOclExp e1,op,fixOclExp e2)
  | Let (Vdecl (id,t,ebind), ebody) ->Let (Vdecl (id,t,fixOclExp ebind), fixOclExp ebody)
  | _  -> e
and fix_op_navi_exp e = match e with
  OpCall (id,oclExp_list) -> OpCall (id,List.map fixOclExp oclExp_list)
| NvCall id -> NvCall (fix_xmiid id)


let b2mp id_t (pkg_t,oclType_t) gamma binding : (unit template) * ((unit definition) list) = 
  match binding with
    Bind (id,oclExp) -> match (fix_xmiid id,fixOclExp oclExp) with
   (* 
      ("__xmiID__",
             Dot (Str str_IN,
              OpCall ("concat",
               [Dot (Dot (Vref str_vref  (* "s" *), NvCall "__xmiID__"),
                 OpCall ("concat", [Str str_rulename_targetvarname (* ".Attribute2Column.t" *)]))]))) ->
		   (`expr (da,
			{action =
			 `query (da, `tree (da,  [`label (da,"xmi_id"), 
					       `tree (da,  [`label (da,"String"), 
						  `tree (da, [`binary (da, `CONCAT,
									`string (da,str_IN),
								        `binary (da, `CONCAT,
								          `var (da,"$id"),
							  	         `string (da,str_rulename_targetvarname)) )
							,`tree (da,[])] ) ]  ) ]   ) );
		         where =
			  [`pat_in (`tree [(`concat (`label (da,"xmi_id"),`label (da,"String")),
					   `tree [(`var (da,"$id"),`var (da,"dummy"))])],`var (da,"$g"))];}),[])
   *) 
     (target_feature, ref)  ->
        let _ = Format.printf "target_feature = %s@." target_feature in
	if (isBxOclExp ref gamma) then
	let t = ref2type ref gamma in
	match t with
	  A2URef  (pkg,typ) -> 
	    let (tmpl,deflist) = ref2sfuns target_feature id_t (pkg_t,oclType_t) ref gamma in
	    (tmpl, deflist)
	| A2UPrim  prim ->
	    let templ = bind2unql id_t (pkg_t,oclType_t) (target_feature, ref) gamma in
	    (templ, [])
(*	
      (target_feature, Dot (Vref source_vref, NvCall source_feature))
       ->  (* "type -> s.type" *)
	 (* is target_feature primitive ? *)
	 let _ = 
	   (match feature2type target_feature (pkg_t,oclType_t) gamma with
	     A2URef  (pkg,typ) ->
	       Format.printf "feature %s is a reference to %s@." target_feature typ;
	   | A2UPrim  prim ->
	       Format.printf "feature %s is primitive@." target_feature;)
	 in 
      let id_r = lookup_rulename gamma in
      let id_m = lookup_modulename gamma in
        (`app_exp (da, `fun_name (target_feature ^ "_" ^ id_r), `var (da,"$" ^ source_vref)),
   [`def [
    `branch ( `fun_name (target_feature ^ "_" ^ id_r),
              `argument (`label_const (`label (da,source_feature)), `var (da,"$g")),
	      `tree (da,[`label (da,target_feature), `app_exp (da, `fun_name id_m, `var (da,"$g")) ]));
    (* catch all default clause with empty graph output *)
    `branch ( `fun_name (target_feature ^ "_" ^ id_r),`argument (`var (da,"$l"), `var (da,"$g")),
	      `tree (da,[]))] ]
	) (* TODO *) *)
	else (`tree (da,[]),[])


let bundle_template_list (tl: unit template list) : unit template =
  let uni x y =  
    match (x,y) with
      `tree (a,[]), `tree (b,[]) -> `tree (a,[])
    | `tree (a,[]), tb -> tb
    | ta, `tree (b,[]) -> ta
    | _ -> `union (da,x,y) in
  match tl with
      []    -> `tree (da,[])
  | (t::ts) -> List.fold_left (fun xs x  -> uni xs x) t ts



let op2mp gamma op : ((unit template) * ((unit definition) list)) =
  match op with
    OutPat (id_t,oclType_t, id_option, binding_list_option) ->
      let (pkg_t,oclType_t) = match oclType_t with
	OclModelElement (pkg_t,oclType_t) -> (pkg_t,oclType_t)
      | _ -> failwith "unsupported oclType_t"
      in match binding_list_option with
	None -> failwith "binding_list should be present"
      | Some binding_list ->
	  (* id_t (pkg_t,oclType_t) are still passed as independent argument 
	     to clarify the target type for the given output pattern *)
	  let (template_list, definition_list_list) = unzip (List.map (b2mp id_t (pkg_t,oclType_t) gamma) binding_list) in
	  (`tree (da, [(`label (da,oclType_t),bundle_template_list template_list)]),List.concat definition_list_list)


(* translatability predicates for guard expressions *)
(* ideally arbitrary boolean expressions composed by 
   these expressions should be translatable *)
let rec isIsempty (guard : oclExp) : bool =
  match guard with
    Not g -> isIsempty g
  | Dot (_,OpCall ("isEmpty",[])) -> true
  | _ -> false

let isPrimBoolean (guard : oclExp) (gamma:gamma) : bool =
  let rec ipb guard =
  match guard with
    Not g -> ipb g
  | Dot (ref, NvCall feature) ->
      (let (pkg,ocltype) = resolve_ref ref gamma in
      match feature2type feature (pkg,ocltype) gamma with
	A2URef  (pkg,typ) ->
	  Format.printf "feature %s is not primitive (%s)@." feature typ; 
	  false
      | A2UPrim  prim ->
	  (match prim with 
	    A2UBol -> true
	  | _ -> Format.printf "feature %s is primitive but not boolean@." feature;
	      false ))
  | _ -> false
 in ipb guard

let rule2mp (gamma : gamma) (rule : moduleElement) : (unit branch * (unit definition list)) =
  let Rule (MatchedRule(id_r,inPattern,outPattern_option)) = rule in
  let gamma = intern_rulename id_r gamma in
  match outPattern_option with
    None -> failwith "ommitted outPattern is not supported" 
  | Some (To outPattern) ->
      match inPattern with
	From (InPat(id_s,oclType_s,_),guard_option) ->
	  (* id_s : "s" *)
	  match oclType_s with
	    OclModelElement (pkg_s, oclType_s) ->
	      (* pkg_s : "ClassDiagram", oclType_s : "Class" *)
	      let gamma = intern_vartype id_s (pkg_s,oclType_s) gamma in
	      (* since bindings for each output pattern may refer other
		 model element variables, they are registered to the type
		 environment before processing each output pattern *)
              let gamma = List.fold_right (fun (OutPat (id_t,oclType_t, _, _)) ->
		match oclType_t with 
		  OclModelElement (pkg_t,oclType_t) ->
		intern_vartype id_t (pkg_t,oclType_t)
		| _ -> failwith "unsupported oclType_t") outPattern gamma in
              (* it should create one single cycle expression,
                 but tentatively bundles the templates for each outpat using 
		 bundle_template_list *)
	      let (mbodies,definition_list_list) = (unzip @@ (List.map (op2mp gamma))) outPattern in
	      let id_m = lookup_modulename gamma in
	      (`branch (`fun_name id_m, `argument (`label_const (`label (da,oclType_s)), `var (da,"$g")), 
			`letvalue (da,`var (da,"$" ^ id_s),`var (da,"$g"), 
                        let body = bundle_template_list mbodies in
			match guard_option with
			  None -> body
			| Some guard ->
			    Format.printf "guard found for model element id %s@." id_s;
			    (* Compilation of the guard *)
			    let oclexpr2unql exp : unit template =
			      let rec ref2rppXvar ref : ((unit rpp) * string) = match ref with
				Vref name -> (`eps, name)
			      | Dot (Vref name, NvCall feature) ->
				  (`label (da,feature), name)
			      | Dot (ref, NvCall feature) ->
				  let (rpp,name)= ref2rppXvar ref in
				  (`concat (`concat (rpp,`any), `label (da,feature)),name)
			      | _ -> failwith "ref2rppXvar: unsupported OCL expression"
			      in match ref2rppXvar exp with
				(`eps,name) -> `var (da,"$" ^ name) 
			      | (#rpp as rpp, name) ->
				  `expr (da, {action = `query (da,`var (da,"$g"));
					      where  = [`pat_in (`tree [(rpp,`var (da,"$g"))], `var (da,"$" ^ name))];
					       }) in
			    (* Compilation of the guard should take place here using UnQL 
			       if expression with isEmpty.  *)
			    (* not p.ownedElement.isEmpty()
			      = (Not (Dot (Dot (Vref "p", NvCall "ownedElement"), OpCall ("isEmpty", []))))
                              =>
                              if (not isempty(select $temp where {ownedElement: $temp} in $p)) then
                                  (* body *)
                              else {}
			     *)
			    if isIsempty guard then
			      let gv_emptytest = newgvname () in
			      let (bc,e) =
				let rec a2u guard : (unit bool_cond * unit template) =
				  match guard with
				    Not g ->
				      let (bc,e) = a2u g in
				      (`unary (da,`NOT,bc),e)
				  | Dot (exp,OpCall ("isEmpty",[])) ->
				      (`unary (da,`IsEmpty,`var (da,gv_emptytest)),(oclexpr2unql exp))
				  | _ -> failwith "invalid isempty OCL expr" in
				a2u guard in
			      (* caveat : UnQL's isempty accepts only value expressions as
				 arguments, so we have to bind the graph value to a variable *)
                              `letvalue (da,`var (da,gv_emptytest),e,
				   	 `ifcond (da,bc,body,`tree (da,[])))
			    else if (isPrimBoolean guard gamma) then
			   (*   not p.isMultivalued
			      (Not (Dot (Vref "s", NvCall "multiValued")))
			      =>  multiValued : exists an edge with multiValued = true
                                  not ...     : exists an edge with multiValued = false
                                  
                              if (not isempty(select {dummy:{}} where {mutiValued.Boolean.true:$dummy} in $s))
			       s.owner.mutiValued
			       (Dot (Dot (Vref "s", NvCall "owner"), NvCall "multiValued"))
			      letval $g = (select {dummy:{}} 
				           where {owner._.multiValued.Boolean:$g1} in $s,
                                                 {true : $dummy } in $g1) in
                              if (not isempty($g)) then body else {} *)
			      let oclexpr2unql (b:bool) exp : unit template =
				let rec ref2rppXvar ref : ((unit rpp) * string) = match ref with
				  Vref name -> (`eps,name)
				| Dot (Vref name, NvCall feature) ->
				    (`label (da,feature), name)
				| Dot (ref, NvCall feature) ->
				    let (rpp,name)= ref2rppXvar ref in
				    (`concat (`concat (rpp,`any), `label (da,feature)),name) 
				| _ -> failwith "ref2rppXvar: unsupported OCL expression"
				in
				let (rpp,name) = 
				  match ref2rppXvar exp with
				    (`eps,name) -> (`label (da,"Boolean"),name)
				  | (#rpp as rpp, name) -> (`concat (rpp,`label (da,"Boolean")),name)
				in
				`expr (da, {action = `query (da,`tree (da,[`label (da,"dummy"),`tree (da,[])]));
					    where  = [`pat_in (`tree [(rpp,`var (da,"$g1"))], `var (da,"$" ^ name));
						      `pat_in (`tree [(`label_const (`bool (da,b)),`var (da,"$dummy"))],`var (da,"$g1")) 
						    ];
					  }) in
			      let gv_emptytest = newgvname () in
			      let (bc,e) =
				let rec a2u (b : bool) guard : (unit bool_cond * unit template) =
				  match guard with
				    Not g -> a2u (not b) g
				  | Dot _ ->
				      (`unary (da,`NOT,`unary (da,`IsEmpty,`var (da,gv_emptytest))),(oclexpr2unql b guard))
				  | _ -> failwith "invalid boolean OCL expr" in
				a2u true guard in
			      (* caveat : UnQL's isempty accepts only value expressions as
				 arguments, so we have to bind the graph value to a variable *)
                              `letvalue (da,`var (da,gv_emptytest),e,
				   	 `ifcond (da,bc,body,`tree (da,[])))
                            else (* Nothing should be produced for unsupported guards. *)
			      `tree (da,[])
		       )),List.concat definition_list_list)
	  | _ -> failwith "unsupported oclType in inPat"
	  

let atlMin2unql (atl_module : atl_module) (immdic : mm_dictionary) (ommdic : mm_dictionary) : unit expr =
  let Module (id_m, out_oclModel_list, in_oclModel_list, rules) = atl_module in
  let gamma = match out_oclModel_list with
    [OclModel (_, out_package)] -> intern_mmdic out_package ommdic empty_gamma
  | _ -> failwith "non-singleton output OclModel" in
  let gamma = match in_oclModel_list with
    [OclModel (_, in_package)] -> intern_mmdic in_package immdic gamma
  | _ -> failwith "non-singleton input OclModel" in
  let gamma = intern_modulename id_m gamma in
  let branch_list,def_list_list =  unzip (List.map (rule2mp gamma) rules) in
  (* 
    Postporcessing function to cope with dangling attribute edge for the 
    model elements that did not get translated, like {attr:{}}
    Currently there is no good way to prevent this because in the fully
    mutually recursive function we cannot inspect the result of 
    another call to sibling functions, 
     for  
       col_Class2Table({attr:$g}) = {col: Class2Relational($g)}
     to change
       col_Class2Table({attr:$g}) = 
       if isempty Class2Relational($g) 
       then {}
       else 
          {col:Class2Relational($g)}
       
       currently, the best we could do is to test $g 
       for exactly the same guard as the type of $g has,
          and use the result to decide whether to make
          recursive call or to produce empty.
  *)
  let fixClassifier_defs = 
    [`def
           [`branch
              (`fun_name "fixClassifier", `argument (`label ((), "String"), `var ((), "$g")),
               `tree ((), [(`label ((), "String"), `var ((), "$g"))]));
            `branch
              (`fun_name "fixClassifier", `argument (`label ((), "Int"), `var ((), "$g")),
               `tree ((), [(`label ((), "Int"), `var ((), "$g"))]));
            `branch
              (`fun_name "fixClassifier", `argument (`label ((), "Boolean"), `var ((), "$g")),
               `tree ((), [(`label ((), "Boolean"), `var ((), "$g"))]));
            `branch
              (`fun_name "fixClassifier", `argument (`label ((), "Float"), `var ((), "$g")),
               `tree ((), [(`label ((), "Float"), `var ((), "$g"))]));
            `branch
              (`fun_name "fixClassifier", `argument (`var ((), "$l"), `var ((), "$g")),
               `tree
                 ((),
                  [(`var ((), "$l"),
                    `app_exp ((), `fun_name "fixFeatures", `var ((), "$g")))]))];
         `def
           [`branch
              (`fun_name "fixFeatures", `argument (`var ((), "$l"), `var ((), "$g")),
               `ifcond
                 ((), `unary ((), `IsEmpty, `var ((), "$g")), `tree ((), []),
                  `tree
                    ((),
                     [(`var ((), "$l"),
                       `app_exp ((), `fun_name "fixClassifier", `var ((), "$g")))])))]] in
  let uq = {action = `query (da,`letrec_exp (da,
   List.concat def_list_list @  fixClassifier_defs @
  [`def (branch_list @ [
   (* catch all default rule produces empty graph, to make sure
      nothing is produded when the rule is omitted. *)
       `branch ( `fun_name (id_m), 
		 `argument (`var (da,"$l"), `var (da,"$g")),`tree (da,[]))])],
			     (
   			        `app_exp ((), `fun_name "fixClassifier", 
					`app_exp (da, `fun_name id_m, `var (da,"$db"))
				       ) 
			     )));  where = [];} in
  uq

let atlMin2unql_driver atl_file ikm3_file ikm3_pkg okm3_file okm3_pkg : unit expr =
     let atlMin = parseatl_file atl_file in
     let ikm3   = parseKm3_file ikm3_file in
     let okm3   = parseKm3_file okm3_file in
     let immdic = clean_mm_dictionary (make_mm_dictionary ikm3) in
     let ommdic = clean_mm_dictionary (make_mm_dictionary okm3) in
     atlMin2unql atlMin immdic ommdic
  
(*
let atl = parseatl_file "/Users/hidaka/proj/BiG/git/AtlanModSVN/Bidirectionality/hidaka/doc/examples/massimoExample/AdaptedATL/SimpleClass2RelationalIDs.atl"
let atl = parseatl_file "/Users/hidaka/proj/BiG/git/AtlanModSVN/Bidirectionality/hidaka/ATL-GT/examples/ASE15Class2Relational.atl"
let ikm3   = parseKm3_file "/Users/hidaka/proj/big/git/AtlanModSVN/Bidirectionality/hidaka/ATL-GT/examples/Sample-Class.km3"
let immdic = clean_mm_dictionary (make_mm_dictionary ikm3)
let okm3   = parseKm3_file "/Users/hidaka/proj/big/git/AtlanModSVN/Bidirectionality/hidaka/ATL-GT/examples/Table.km3"
let ommdic = clean_mm_dictionary (make_mm_dictionary okm3)
let unql = atlMin2unql atl immdic ommdic 
let _ = PrintUnQL.print_expr unql
*)

(*

let atl = parseatl_file "/Users/hidaka/proj/BiG/git/AtlanModSVN/Bidirectionality/hidaka/ATL-GT/examples/ASE15Class2Relational.atl"
*)
