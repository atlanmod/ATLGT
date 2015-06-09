(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
open Format

type bwd_config =  {
    mutable ei_file      : string; (* editinfo file *)
    mutable ipt_node     : int;    (* flat node ID *)
  }

let default_config = { ei_file = "";  ipt_node     = (-1);    }

let speclist = 
  let cf = default_config in 
  Arg.align
    [
     ("-ei",  Arg.String (fun s->cf.ei_file      <-s), " editinfo produced by forward trans.");
     ("-ipt",  Arg.Int   (fun k->cf.ipt_node<-k),      " flat node ID in the view");
   ]

let usage_msg = "Usage: "^Sys.executable_name^" -ipt node -ei fwd_result.ei"

let read_args () = 
  let cf = default_config in 
  Arg.parse speclist (fun s -> ()) usage_msg; cf 

let failwith_msg msg =
  fprintf err_formatter "%s@." msg;
  Arg.usage speclist usage_msg; exit 1

let _ = 
  let cf = read_args () in
       if cf.ei_file       = "" then failwith_msg "editinfo file unspecified."
  else if cf.ipt_node      = -1 then failwith_msg "flat ID unspecified or invalid"
  else 

    let ipt = cf.ipt_node in
      print_string
        begin match ipt with
        (* -ge is ON *)
        | 1027 -> "InT(13)\nHub(5,&z1,12)\nFrE(InT(5),(5,c,4),12)\nHub(4,&z1,12)\nFrE(InT(5),(4,c,4),12)\n"
        | 1045 -> "FrE(InT(2),(5,b,3),12)\nHub(3,&z1,12)\nFrE(InT(9),(3,a,1),12)\n"
        | 1041 -> "FrE(InT(8),(5,a,2),12)\nHub(2,&z1,12)\nFrE(InT(9),(2,a,1),12)\n"
        | 1036 -> "Hub(1,&z1,12)\nFrE(InT(3),(1,d,0),12)\n"
        | 1028 -> "FrE(InT(2),(1,d,0),12)\nHub(0,&z1,12)\n"
        (* -ge is OFF *)
(*        | 1027 -> "Hub(5,&z1,12)\n" (* "InT(13)\n" *) *)
       | 1055 -> "Hub(5,&z1,12)\n"
           (* *)
           | 1049 -> "FrE(InT(5),(5,c,4),12)\n"
           | 1054 -> "Hub(4,&z1,12)\n"
           | 1040 -> "FrE(InT(5),(4,c,4),12)\n"
           (* *)
           | 1047
           | 1048
           | 1046 -> "FrE(InT(3),(5,b,3),12)\n"
(*           | 1045 -> "Hub(3,&z1,12)\n" (* "FrE(InT(2),(5,b,3),12)\n" *) *)
           | 1053 -> "Hub(3,&z1,12)\n"
           | 1039
           | 1038
           | 1037 -> "FrE(InT(9),(3,a,1),12)\n"
(*           | 1036 -> "FrE(InT(8),(3,a,1),12)\n"*)
           (* *)
           | 1044
           | 1043
           | 1042 -> "FrE(InT(9),(5,a,2),12)\n"
(*           | 1041 -> "Hub(2,&z1,12)\n" (* "FrE(InT(8),(5,a,2),12)\n" *) *)
           | 1052 -> "Hub(2,&z1,12)\n"
           | 1035
           | 1034
           | 1033 -> "FrE(InT(9),(2,a,1),12)\n"
           | 1032 -> "FrE(InT(8),(2,a,1),12)\n"
               (* *)
                | 1051 -> "Hub(1,&z1,12)\n"
                | 1031
                | 1030
                | 1029 -> "FrE(InT(3),(1,d,0),12)\n"
(*                | 1028 -> "Hub(0,&z1,12)\n" (* "FrE(InT(2),(1,d,0),12)\n" *)*)
                | 1050 -> "Hub(0,&z1,12)\n"
        (* no matching node *)
        | _ -> ""
        end

