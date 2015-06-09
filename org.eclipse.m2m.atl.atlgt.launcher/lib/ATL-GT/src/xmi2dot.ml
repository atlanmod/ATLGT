(* transform the xmi format to the dot format by xmi2dot function
 * and transform ATL (currently ATLMin) to unql by atl2unql function. 
 *)

(* how to run this by interpreter
  In src/, 
  > make run-ocaml
  > #load "xml-light.cma";;
  > #load "Str.cma";;
  > #use "xmi2dot.ml";;
*)

exception Unexpected of string
exception NotImplemented of string
exception NotFound

let rec foldr f a xs =
  match xs with
    [] -> a
  |  x :: xs -> f x (foldr f a xs)

type ty = string
type name = string
type field = name * ty 

(* consider later
type field =
    IsAbstract of bool
  | Name of string
  | Owner of ...
  | Multivalued of bool
  | Type of ...
*)

type num = int
type path = string
type cl = Class of num * name * field list * (name * num) list 
type cl' = Class' of num * name * field list * (name * path) list 

type melem = 
    CLSS of num * field list * (name * ty * num) list 
  | ATTR of num * field list * (name * ty * num) list 
  | DTYP of num * field list * (name * ty * num) list 

type melem'' = 
  | ATTR'' of num * field list * (name * num) list 

type attr' = 
    ATTR' of num * field list * (name * path) list 

(*
let sampleXml = Xml.parse_file "Sample.xmi" 
let classXml = Xml.parse_file "Class2Relational/Class/Class.xmi" 
*)

let num = ref 0
let nextNum () = (num:=!num+1;!num)
let attrNum = ref 0
let nextAttrNum () = (attrNum:=!attrNum-1;!attrNum)
let setZero () = (num:=0)
let setAttrZero () = (attrNum:=0)

let getNamefromPathStr str = 
  match Str.split (Str.regexp "/") str with
    _::name::[] -> name
  | _ -> raise (Unexpected "getNamefromPathStr")

let getNum1 path = path

let getAttributes children =
  let attr child =
    match child with
      Xml.Element ("eStructuralFeatures", 
		   ("xsi:type", "ecore:EAttribute") :: 
		   ("name", attribute) ::
		   ("ordered",_) ::
		   (_, _) ::
		   ("eType", ty) :: [],
		   _)
      -> [(attribute, ty)]
    | _ -> []
  in List.concat (List.map attr children)    

let rec refName xs =
  match xs with
    ("name", referenceName) :: _ -> referenceName
  | _ :: xs -> refName xs
  | [] -> raise (Unexpected "refName")

let rec eType xs =
  match xs with
    ("eType", ty) :: _ -> ty
  | _ :: xs -> eType xs
  | [] -> raise (Unexpected "eType")

let getReferences children =
  let attr child =
    match child with
      Xml.Element ("eStructuralFeatures", 
		   ("xsi:type", "ecore:EReference") :: xs,
		   _)
      -> [(refName xs, getNum1 (eType xs))]  (* we need to find the number *)
    | _ -> []
  in List.concat (List.map attr children)

let processTopChild cls =
  match cls with
    Xml.Element ("eClassifiers", 
		 ("xsi:type", "ecore:EClass") :: ("name", className) :: _,
		 children)
    -> [Class' (nextNum(), className, getAttributes children, getReferences children)]
  | Xml.Element _ -> []
  | _ -> raise (Unexpected "processTopChild")

let rec findClass children =
  match children with
    child :: children ->
      (match child with
	Xml.Element (_, _,
		     Xml.Element (_, 
				  (_, "ecore:EClass")::_,
				  _) :: _)
	-> child
      | _ -> findClass children)
  | [] -> raise NotFound

let processToplevel xml = 
  match xml with
    Xml.Element ("ecore:EPackage", attributes, children)
    -> List.concat (List.map processTopChild children)
  | Xml.Element ("xmi:XMI", attributes, children)
    -> 
      let Xml.Element ("ecore:EPackage", attributes, children) = findClass children
      in List.concat (List.map processTopChild children)
  | _ -> raise (Unexpected "processTolevel")
	
(* xmi2dot takes an xmi file inputXmiFile and a dot file outputDotFile
   and transform the contents of the xmi file to the dot format
   which is written to the dot file.
*)

let rec getNum2 name classes = 
  match classes with
    (Class' (num ,n,_,_)) :: classes -> 
      if n = name then num
      else getNum2 name classes
  | [] -> raise (Unexpected "getNum2")

let rec repNameWithNum classes =
  let g (refName, pathStr) = 
    let name = getNamefromPathStr pathStr in
    (refName,getNum2 name classes) in
  let f (Class' (num,name,eAttributes,eReferences)) =
    (Class (num,name,eAttributes,List.map g eReferences)) in
  List.map f classes


let field2dot vertexID (name,ty) =
  let vertexID1 = nextNum() in
  let vertexID2 = nextNum() in
  let vertexID3 = nextNum() in
  let edge1 = Dot.DEdge (Dot.DVtx (UnCALDM.Bid vertexID),
			 [Dot.DELabel (UnCAL.ALLbl name)],
			 Dot.DVtx (UnCALDM.Bid vertexID1)) in
  let edge2 = Dot.DEdge (Dot.DVtx (UnCALDM.Bid vertexID1),
			  [Dot.DELabel (UnCAL.ALLbl "String")],
			  Dot.DVtx (UnCALDM.Bid vertexID2)) in
  let edge3 = Dot.DEdge (Dot.DVtx (UnCALDM.Bid vertexID2),
			 [Dot.DELabel (UnCAL.ALStr ty)],
			 Dot.DVtx (UnCALDM.Bid vertexID3)) in
  [edge1; edge2; edge3]

let edge2dot vertexID1 (refName, vertexID2) =
  let vertexID = nextNum() in
  let edge1 = Dot.DEdge (Dot.DVtx (UnCALDM.Bid vertexID1),
			[Dot.DELabel (UnCAL.ALLbl refName)],
			Dot.DVtx (UnCALDM.Bid vertexID)) in
  let edge2 = Dot.DEdge (Dot.DVtx (UnCALDM.Bid vertexID),
			[Dot.DELabel (UnCAL.ALLbl "ClassName")],
			Dot.DVtx (UnCALDM.Bid vertexID2)) in
  [edge1;edge2]

let class2dot rootID (Class (num,name,fields,edges)) =
  let e1 = Dot.DEdge (Dot.DVtx (UnCALDM.Bid rootID), 
		     [Dot.DELabel (UnCAL.ALLbl "ClassName")],
		     Dot.DVtx (UnCALDM.Bid num)) in
  let vertexID = nextNum() in
  let e2 = Dot.DEdge (Dot.DVtx (UnCALDM.Bid num), 
		     [Dot.DELabel (UnCAL.ALLbl name)],
		     Dot.DVtx (UnCALDM.Bid vertexID)) in
  let fds = List.concat (List.map (field2dot vertexID) fields) in
  let edgs = List.concat (List.map (edge2dot vertexID) edges) in
  let vertexID3 = nextNum() in
  let e3 = Dot.DEdge (Dot.DVtx (UnCALDM.Bid num), 
		     [Dot.DELabel (UnCAL.ALInt num)],
		     Dot.DVtx (UnCALDM.Bid vertexID3)) in
  List.concat [[e1;e2;e3]; fds; edgs]

let rec genNums n1 n2 =
  if n1=n2 then [n2]
  else n1 :: (genNums (n1+1) n2)

let genVertices num =
  let num2vertex num = Dot.DNode (Dot.DVtx (UnCALDM.Bid num), [Dot.DNLabel ([], [])]) in
  let rootVertex = Dot.DNode (Dot.DVtx (UnCALDM.Bid 0), [Dot.DNLabel (["&"], [])]) in
  let nums = genNums 1 num in
  rootVertex :: List.map num2vertex nums

let genVertices_Class num numMinus =
  let num2vertex num = Dot.DNode (Dot.DVtx (UnCALDM.Bid num), [Dot.DNLabel ([], [])]) in
  let rootVertex = Dot.DNode (Dot.DVtx (UnCALDM.Bid 0), [Dot.DNLabel (["&"], [])]) in
  let nums = genNums 1 num in
  let numsMinus = genNums numMinus (-1) in
  rootVertex :: 
    List.map num2vertex (List.append nums numsMinus)
    
let classes2dot classes =
  let rootID = 0 in 
  let edges = List.concat (List.map (class2dot rootID) classes) in
  let vertices = genVertices (!num) in
  let stmt_list = List.concat [vertices;edges] in
  {Dot.graph_id = "g"; Dot.stmt_list = stmt_list}

let xmi2dot_ecore inputXmiFile outputDotFile = 
  let xml = Xml.parse_file inputXmiFile in
  let _ = setZero () in
  let _ = setAttrZero () in
  let classes = repNameWithNum (processToplevel xml) in
  let dot = classes2dot classes in
  Dotutil.dumpDot dot outputDotFile

(*
let baa () = xmi2dot_ecore "atl2unql/Sample.xmi" "atl2unql/Sample.dot"
let baa2 () = 
  xmi2dot_ecore "atl2unql/Class2Relational/Class/Class.xmi" "atl2unql/Class.dot"
*)

(*
 * Transformation function for 
 * models that conforms to Class.ecore or Class.km3
 * like Sample-Class.xmi.
 *)

let cName elems = 
  match elems with
      ("xsi:type", "class:Attribute") :: _ -> "Attribute"
    | _ -> raise (Unexpected "cName")

let rec filterSome xs =
  match xs with
    (Some x) :: xs -> x :: filterSome xs
  | None :: xs -> filterSome xs
  | [] -> []

let rec unzip xs = 
  match xs with
    (x1,x2) :: xs -> 
      let (rs1, rs2) = unzip xs in
      (x1::rs1, x2::rs2)
  | [] -> ([], [])

let rec getFields elems =
  match elems with
      ("xsi:type",_) :: elems -> getFields elems
    | ("type", _) :: elems -> getFields elems
    | elem :: elems -> elem :: getFields elems
    | [] -> []

let rec getType elems =
  match elems with
      ("type",ty) :: elems -> 
(*
	("type", "Class", ty) (* the second element should be searched from the whole xmi. This may be "Datatype" in some cases. *)
*)
	("type", ty) 
    | elem :: elems -> getType elems
    | [] -> raise (Unexpected "getType")

let getAttributes_Class children =
  let attr child =
    match child with
	Xml.Element ("attr", elems, _)
	-> 
	  let className = cName elems in 
	  let num = nextAttrNum() in
	  let fields = getFields elems in
	  let ref = getType elems in
	  let melem' = ATTR' (num, fields, [ref]) in
	  Some (("attr", "Attribute", num), melem')
      | _ -> None 
  in
  unzip (filterSome (List.map attr children))

let getFields_Class children =
  [("isAbstract", "false")]
    
let processTopChild_Class cls =
  match cls with
      Xml.Element ("class:Class", name, children)
      -> 
	let (attrs, innerMelems) = getAttributes_Class children in
	(CLSS (nextNum(), 
	       List.append name (getFields_Class children),
	       attrs),
	 innerMelems)
    | Xml.Element ("class:DataType", name, children)
      -> (DTYP (nextNum(), name, []), [])
    | Xml.Element (s, _,_) 
      -> (Printf.printf "class = %s " s;
	  raise (Unexpected "temp")      )
    | _ -> 
	raise (Unexpected "processTopChild_Class")

let processToplevel_Class xml =
  match xml with
  | Xml.Element ("xmi:XMI", attributes, children)
    -> 
      let (melems, innerMelemsList) = 
	unzip (List.map processTopChild_Class children) in
      (melems, List.concat innerMelemsList)
  | _ -> raise (Unexpected "processTolevel")

let getNumfromPathStr str = 
  match Str.split (Str.regexp "/") str with
    num::[] -> int_of_string num
  | _ -> raise (Unexpected "getNumfromPathStr")

let rec repNameWithNum_Class melems =
  let g (refName, pathStr) = 
    let num = getNumfromPathStr pathStr in 
    (refName,num+1) 
  in
  let f (ATTR' (num, eAttributes, eReferences)) =
    (ATTR'' (num, eAttributes, List.map g eReferences)) 
  in
  List.map f melems

let field2dot_Class = field2dot

let edge2dot_Class vertexID1 (refName, tyName, vertexID2) =
  let vertexID = nextNum() in
  let edge1 = Dot.DEdge (Dot.DVtx (UnCALDM.Bid vertexID1),
			[Dot.DELabel (UnCAL.ALLbl refName)],
			Dot.DVtx (UnCALDM.Bid vertexID)) in
  let edge2 = Dot.DEdge (Dot.DVtx (UnCALDM.Bid vertexID),
			[Dot.DELabel (UnCAL.ALLbl tyName)],
			Dot.DVtx (UnCALDM.Bid vertexID2)) in
  [edge1;edge2]

let toplevelClass2dot rootID toplevelMElem =
  match toplevelMElem with
      CLSS (num,fields,edges) ->
	let e1 = Dot.DEdge (Dot.DVtx (UnCALDM.Bid rootID), 
			    [Dot.DELabel (UnCAL.ALLbl "Class")],
			    Dot.DVtx (UnCALDM.Bid num)) in
	let vertexID = num in
	let fds = List.concat (List.map (field2dot_Class vertexID) fields) in
	let edgs = List.concat (List.map (edge2dot_Class vertexID) edges) in
	let vertexID3 = nextNum() in
	let e3 = Dot.DEdge (Dot.DVtx (UnCALDM.Bid num), 
			    [Dot.DELabel (UnCAL.ALInt num)],
			    Dot.DVtx (UnCALDM.Bid vertexID3)) in
	List.concat [[e1;e3]; fds; edgs]
    | DTYP (num, fields, edges) ->
        let e1 = Dot.DEdge (Dot.DVtx (UnCALDM.Bid rootID), 
			    [Dot.DELabel (UnCAL.ALLbl "DataType")],
			    Dot.DVtx (UnCALDM.Bid num)) in
	let vertexID = num in
	let fds = List.concat (List.map (field2dot_Class vertexID) fields) in
	let edgs = List.concat (List.map (edge2dot_Class vertexID) edges) in
	let vertexID3 = nextNum() in
	let e3 = Dot.DEdge (Dot.DVtx (UnCALDM.Bid num), 
			    [Dot.DELabel (UnCAL.ALInt num)],
			    Dot.DVtx (UnCALDM.Bid vertexID3)) in
	List.concat [[e1;e3]; fds; edgs]

(* This function assumes that Attribute has only one incoming edge. *)
let attr2dot (ATTR (num,fields,edges)) =
  let vertexID = num in
  let fds = List.concat (List.map (field2dot_Class vertexID) fields) in
  let edgs = List.concat (List.map (edge2dot_Class vertexID) edges) in
  let vertexID3 = nextNum() in
  let e3 = Dot.DEdge (Dot.DVtx (UnCALDM.Bid num), 
		      [Dot.DELabel (UnCAL.ALInt num)],
		      Dot.DVtx (UnCALDM.Bid vertexID3)) in
  List.concat [[e3]; fds; edgs]
    
let melems2dot (toplevelClss, innerAttrs) =
  let rootID = 0 in 
  let edges1 = List.concat (List.map (toplevelClass2dot rootID) toplevelClss) in
  let edges2 = List.concat (List.map attr2dot innerAttrs) in
  let vertices = genVertices_Class (!num) (!attrNum) in
  let stmt_list = List.concat [vertices;edges1;edges2] in
  {Dot.graph_id = "g"; Dot.stmt_list = stmt_list}

let rec addClass toplevelMElems innerMElems'' =
  let rec findClass number toplevelMElems =
    match toplevelMElems with
	(CLSS (num, fields, attrs)) :: toplevelMElems ->
	  if num==number then
	    "Class"
	  else findClass number toplevelMElems
      | (DTYP (num, fields, attrs)) :: toplevelMElems ->
	  if num==number then
	    "Datatype"
	  else findClass number toplevelMElems
      | [] -> raise (Unexpected "addClass")
  in    
  let addCls (name, num) =
    let cls = findClass num toplevelMElems in
    (name, cls, num)
  in
  let f (ATTR'' (num, fields, name_num_list)) =
    let name_cls_num_list = List.map addCls name_num_list in
    ATTR (num, fields, name_cls_num_list)
  in List.map f innerMElems''

let xmi2dot_Class inputXmiFile outputDotFile =
  let xml = Xml.parse_file inputXmiFile in
  let _ = setZero () in
  let (toplevelMElems, innerMElems') = processToplevel_Class xml in
  let innerMElems'' = repNameWithNum_Class innerMElems' in
  let innerMElems = addClass toplevelMElems innerMElems'' in
  let dot = melems2dot (toplevelMElems, innerMElems) in
  Dotutil.dumpDot dot outputDotFile

let xmi2dot = xmi2dot_Class

(* xmi2dot_Class only deals with xmi file in Massimo-san's format,
   so foo1 () does not succeed. *)

let foo1 () = 
  xmi2dot_Class
    "../../doc/examples/massimoExample/StandardATL/Sample-Class.xmi" 
    "Sample-Class.dot"

let foo2 () = 
  xmi2dot_Class
    "../../doc/examples/massimoExample/AdaptedATL/Sample-Class.xmi" 
    "Sample-Class-Adapted.dot"

(* 
 * Below are the functions for transforming ATLMin to UnQL. 
 *)

let num1 = ref 0
let makeFreshVar () = 
  (num1:=!num1+1; `var ((), "$a" ^ string_of_int (!num1)))
let num2 = ref 0
let makeFreshName () = 
  (num2:=!num2+1; "f" ^ string_of_int (!num2))

let rec oclExp2unqlBindList p oclExp = 
  match oclExp with
      Atl.Vref id ->
	[`pat_in (p, `var ((), ("$" ^ id)))]
    | Atl.Str s -> 
      [`pat_in (p, 
		`tree ((),
		       [(`string ((), s), 
			 `tree ((),[]))
		       ]))]
    | Atl.Dot (oclExp, Atl.NvCall id) -> 
      let freshVar = makeFreshVar () in
      List.append
	(oclExp2unqlBindList freshVar oclExp)
	[`pat_in (`tree [(`label ((), id), p)], 
		  freshVar)]
    | Atl.Dot (oclExp1, Atl.OpCall ("concat", [oclExp2])) -> 
      let l1 = makeFreshVar () in
      let l2 = makeFreshVar () in
      List.concat
	[oclExp2unqlBindList (`tree ( [(l1, `tree ( []))])) oclExp1;
	 oclExp2unqlBindList (`tree ( [(l2, `tree ( []))])) oclExp2;
	 [`pat_in (p, 
		   `tree ((), 
			  [(`binary ((), `CONCAT, l1, l2), 
			    `tree ((), []))]
		   )
	  )
	 ]
	]
(*    | Atl.StrCat (oclExp1, oclExp2) -> *)
    | _ -> raise (Unexpected "oclExp2unqlBindList")
      
let bind2unql (Atl.Bind (m, oclExp)) = 
  let freshVar = makeFreshVar ()
  in
  `expr ((), 
	 {UnQL.action=`query ((), `tree (() ,[`label ((), m), freshVar]));
	  UnQL.where= oclExp2unqlBindList freshVar oclExp})

let rec
    bindList2unql bindList = match bindList with
      [bind] -> bind2unql bind
    | bind::bindList -> `union ((), 
				     bind2unql bind, 
				     bindList2unql bindList)
    | _ -> raise (Unexpected "bindList2unql")

let outPat2unql (ty, bindList) =
  `tree ((), [(`label ((), ty), 
		    bindList2unql bindList)])

let takeModel ty =
  match ty with
    Atl.OclModelElement (metamodel, model) -> model 
  | _ -> raise (Unexpected "makeDef")

let makeDef (Atl.OutPat (id, ty, _, binds)) =
  let ty = takeModel ty in
  let binds = match binds with
    Some binds -> binds
  | None -> [] in
  `def 
    [`branch (`fun_name id, 
		   `argument (`var ((), "$dummy"), 
				   `tree []), 
		   outPat2unql (ty, binds))]
    
let outPatList2unql outPatList = 
  let defs = List.map makeDef outPatList
  in
  let t1 = match defs with 
    [`def [`branch (`fun_name f,_,_)]] -> f
  | _ -> raise (Unexpected "outPatList2unql")
  in
  `letrec_exp 
    ((), 
     defs, 
     `app_exp ((),
		    `fun_name t1, 
		    `tree ((), 
				[(`label ((), "dummy"), 
				  `tree ((), []))])))

let inPat2arg1 (Atl.InPat (id,ty,_)) = 
  let ty = takeModel ty in
  `argument (`label ((), ty), `var ((), "$" ^ id))

let inPat2arg2 (Atl.InPat (id,ty,_)) = 
  `argument (`var ((), "$l"), `var ((), "$" ^ id))

let atlrule2defs atlRule = 
  let (r, inPat, outPat) = match atlRule with
    Atl.Rule (Atl.MatchedRule (r,fromPart,toPart)) -> (r,fromPart,toPart) in
  let inPat = match inPat with
    Atl.From (inPat, _) -> inPat in
  let outPatList = match outPat with
    Some (Atl.To outPatList) -> outPatList
  | _ -> raise (Unexpected "atlrule2defs") in
  let f1 = makeFreshName() in
  let arg1 = inPat2arg1 inPat in
  let body1 = outPatList2unql outPatList in
  let arg2 = inPat2arg2 inPat in
  let argName (Atl.InPat (id,_,_)) = "$" ^ id in
  let recBody r l1 l2 = 
    `tree ((),
	   [(`var ((), l1),
	     `app_exp ((),
		       `fun_name r,
		       `var ((), l2)))]) in
  let body2 = recBody r "$l" (argName inPat) in
  let def1 = `def [`branch (`fun_name f1, arg1, body1);
			`branch (`fun_name f1, arg2, body2)
		      ] in
  let def2 = `def 
      [`branch (`fun_name r, 
		     `argument (`label ((), "ClassName"), 
				     `var ((), "$g1")),
		     `tree ((), 
			    [(`label ((), "ClassName"), 
			      `app_exp ((), 
					`fun_name f1,
					`var ((), "$g1")))])); 
       `branch (`fun_name r, 
		`argument (`var ((), "$l"), 
				`var ((), "$g1")),
		`tree ((), 
		       [(`var ((), "$l"), 
			 `app_exp ((), 
					`fun_name r, 
					`var ((), "$g1")))]))] in
  [def1; def2]

let atlrule2defs_Class atlRule = 
  let (r, inPat, outPat) = match atlRule with
    Atl.Rule (Atl.MatchedRule (r,fromPart,toPart)) -> (r,fromPart,toPart) in
  let inPat = match inPat with
    Atl.From (inPat, _) -> inPat in
  let outPatList = match outPat with
    Some (Atl.To outPatList) -> outPatList
  | _ -> raise (Unexpected "atlrule2defs_Class") in
  let f1 = makeFreshName() in
  let arg1 = inPat2arg1 inPat in
  let body1 = outPatList2unql outPatList in
  let arg2 = inPat2arg2 inPat in
  let argName (Atl.InPat (id,_,_)) = "$" ^ id in
  let recBody r l1 l2 = 
    `tree ((),
	   [(`var ((), l1),
	     `app_exp ((),
		       `fun_name r,
		       `var ((), l2)))]) in
  let body2 = recBody r "$l" (argName inPat) in
  let def1 = `def [`branch (`fun_name f1, arg1, body1);
			`branch (`fun_name f1, arg2, body2)
		      ] in
  let def2 = `def 
      [`branch (`fun_name r, 
		     `argument (`label ((), "Class"), 
				     `var ((), "$g1")),
		     `tree ((), 
			    [(`label ((), "Class"), 
			      `app_exp ((), 
					`fun_name f1,
					`var ((), "$g1")))])); 
       `branch (`fun_name r, 
		`argument (`var ((), "$l"), 
				`var ((), "$g1")),
		`tree ((), 
		       [(`var ((), "$l"), 
			 `app_exp ((), 
					`fun_name r, 
					`var ((), "$g1")))]))] in
  [def1; def2]

let atlrules2unqlexpr atlrules =
  let encodedDefs = List.concat (List.map atlrule2defs atlrules) in
  let ruleName (Atl.Rule (Atl.MatchedRule (r,_,_))) = r in
  let ruleNames = List.map ruleName atlrules in
  let e = 
    foldr 
      (fun f e -> `app_exp ((), `fun_name f, e))
      (`var ((), "$db"))
      ruleNames in
  `letrec_exp ((), encodedDefs, e)

let atlrules2unqlexpr_Class atlrules =
  let encodedDefs = List.concat (List.map atlrule2defs_Class atlrules) in
  let ruleName (Atl.Rule (Atl.MatchedRule (r,_,_))) = r in
  let ruleNames = List.map ruleName atlrules in
  let e = 
    foldr 
      (fun f e -> `app_exp ((), `fun_name f, e))
      (`var ((), "$db"))
      ruleNames in
  `letrec_exp ((), encodedDefs, e)

let atlrules2unql atlrules =
  {UnQL.action = `query ((), (atlrules2unqlexpr atlrules));
   UnQL.where= []}

let atlrules2unql_Class atlrules =
  {UnQL.action = `query ((), (atlrules2unqlexpr_Class atlrules));
   UnQL.where= []}

let atlMin2unql atl = 
  match atl with
    Atl.Module (_, 
		[Atl.OclModel ("OUT", outMetaModelName)],
		[Atl.OclModel ("IN", inMetaModelName)],
		atlrules)
    -> atlrules2unql atlrules
  | _ -> raise (Unexpected "atlMin2unql")

let atlMin2unql_Class atl = 
  match atl with
    Atl.Module (_, 
		[Atl.OclModel ("OUT", outMetaModelName)],
		[Atl.OclModel ("IN", inMetaModelName)],
		atlrules)
    -> atlrules2unql_Class atlrules
  | _ -> raise (Unexpected "atlMin2unql_Class")

let atl2unql inputATLFileName =
  let parseatl_file = Parse.parse_file ~parse:Parseatl.entry ~lex:Lexatl.token in
  let atlMin = parseatl_file inputATLFileName in
  let unql = atlMin2unql atlMin in
  PrintUnQL.print_expr unql

let atl2unql_Class inputATLFileName =
  let parseatl_file = Parse.parse_file ~parse:Parseatl.entry ~lex:Lexatl.token in
  let atlMin = parseatl_file inputATLFileName in
  let unql = atlMin2unql_Class atlMin in
  PrintUnQL.print_expr unql

let atl2unql = atl2unql_Class 

(* we intend to transform the atl in this example. *)
let foo3 () = 
  atl2unql "../../doc/examples/massimoExample/AdaptedATL/SimpleClass2RelationalIDs.atl" 

(* we do not intend to transform the atl in this example. *)
let foo4 () = 
  atl2unql "../../doc/examples/massimoExample/StandardATL/SimpleClass2Relational.atl"

let foo5() =
  let parseatl_file = Parse.parse_file ~parse:Parseatl.entry ~lex:Lexatl.token in
  let atlMin = parseatl_file "../../doc/examples/massimoExample/AdaptedATL/SimpleClass2RelationalIDs.atl" in
  atlMin

