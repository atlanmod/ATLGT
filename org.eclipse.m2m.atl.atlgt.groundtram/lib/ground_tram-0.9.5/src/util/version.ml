(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
let system_name	= "GRoundTram"
let version	= "0.9.5"
let date	= "20150310"

let version_string = version^" ("^date^")"

let v_flag = ref false (* print version info *)

let add_version_spec speclist =
  let spec = ("-v",   Arg.Set v_flag, " print version info") in
  Arg.align (spec::speclist)

let print_version () = 
  if !v_flag then 
    begin 
      print_endline (system_name ^ " version " ^ version_string);
      if !Arg.current = 2 
      then 
	(* only -v option is specified so do not complain for missing mandatory
	   option but exit silently *) 
	exit 0
    end

  
       




