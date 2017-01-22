(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
(*
 command line front end for TestUnCALutil.edit_normg for updating graphs on normalized views.
 Features:
   1. contract (normalize).
   2. edit on contracted view.
   3. do backward transformation of normalization to reflect the edit to the source.
   4. one can stop after normalization and save it to a file.
  
 Arguments:
  -src src.dot    : Source graph to contract is loaded from src.dot.
                    If -batch is not given and the view is updated by the user, while
                    -usrc usrc.dot is missing, then src.dot is updated according to the updated view.
  -batch          : Operate in batch mode. Stop after forward transformation if -usrc is missing.
                    If -usrc usrc.dot is also given, dst.dot is loaded as updated view and the corresponding
                    updated source is written in usrc.dot (batch backward mode).
                    In non-batch (interactive) mode, view is presented by bdotty and
                    the edits on the contracted view is reflected to the source.
  -dst dst.dot    : Contracted view is saved to dst.dot.
                    When not in batch mode, view after edit is saved to dst.dot if the
                    view is actually edited.
                    dst.dot becomes input in batch backward mode. 
  -usrc usrc.dot  : Updated source graph is written to usrc.dot.
                    If it is missing and the view is updated on bdotty, then src.dot is overwritten.

 Flow:
 1. load source graph from src.dot
 2. contract the source
 3. if -batch option is given and usrc is missing, then save the contracted graph to dst.dot
 4. else 
    4.1 if batch, dst and usrc given, (* batch backward *) load the content from dst.dot
    4.2 else 
     4.2.1 let user edit it (& save)
     4.2.2 if user saved and dst.dot is given, save the view to dst.dot
    4.3 denormalize the updated view.
    4.4 save the updated source to usrc.dot if given or src.dot otherwise.
        save takes place in non-batch mode only if user updated the view.

Examples:
  Preview or view update
  % contract -src src.dot
    Contract the graph loaded from src.dot and show the result with bdotty.
    If user save the result, then the corresponding updated source is written to src.dot
    [load src.dot -> contract to tmp.dot -> bdotty tmp.dot                    (-> expand and save to src.dot) ]

  Interactive edit with saved updated view
  % contract -src src.dot -dst dst.dot
    Contract the graph loaded from src.dot and show the result with bdotty. Save the result to dst.dot.
    If user save the result, then the corresponding updated source is written to src.dot
    [load src.dot -> contract to tmp.dot -> bdotty tmp.dot -> save to dst.dot (-> expand and save to src.dot) ]

  Batch forward
  % contract -src src.dot -dst dst.dot -batch
    Contract the graph loaded from src.dot and save the result to dst.dot.
    [load src.dot -> contract to tmp.dot ->                   save to dst.dot ]

  Batch backward
  % contract -src src.dot -dst dst.dot -usrc usrc.dot -batch
    Updated target is loaded from dst.dot and reflects the update
     to modified source usrc.dot
    [load src.dot -> contract to tmp.dot ->  load dst.dot                     -> expand and save to usrc.dot ]

  Interactive edit with saved updated view, without overwriting the original source
  % contract -src src.dot -dst dst.dot -usrc usrc.dot
    Contract the graph loaded from src.dot and show the result with bdotty. Save the result to dst.dot.
    If user save the result, then the corresponding updated source is written to usrc.dot.
    [load src.dot -> contract to tmp.dot -> bdotty tmp.dot -> save to dst.dot -> expand and save to usrc.dot ]
*)
open TestUnCALutil
open Dotutil
open UnCALDMutil
open Format
open Version

type contract_config = {
    mutable src_file   : string ; (* source DOT file (IN/OUT) *)
    mutable dst_file   : string ; (* view DOT file (IN/OUT) *)
    mutable usrc_file  : string ; (* updated source DOT file (OUT) *)
    mutable batch_flag : bool   ; (* batch mode if true *)
}

let default_config = { src_file = ""; dst_file = ""; usrc_file = "";
                      batch_flag = false; }

let speclist =
  let cf = default_config in
  Arg.align
    [
     ("-src",  Arg.String (fun s->cf.src_file<-s),      " source DOT file (IN)");
     ("-dst",  Arg.String (fun s->cf.dst_file<-s),      " view DOT file (IN/OUT) ");
     ("-usrc", Arg.String (fun s->cf.usrc_file<-s),     " updated source DOT file (OUT) ");
     ("-batch",Arg.Unit   (fun()->cf.batch_flag<-true), " turn on batch mode");
   ]

let speclist = add_version_spec speclist

let usage_msg = 
  "Usage: "^Sys.executable_name^" -src src.dot [-batch] [-dst dst.dot] [-usrc usrc.dot] [-v]"

let read_args () = 
  let cf = default_config in 
  Arg.parse speclist (fun s -> ()) usage_msg; cf 

let failwith_msg msg =
  fprintf err_formatter "%s@." msg;
  Arg.usage speclist usage_msg; exit 1

(* execute contraction *) 
let _ =
  let cf = read_args () in
  let _ = print_version () in
  (* check arguments *)
  if      cf.src_file = "" then failwith_msg "Source DOT file unspecified."
  else
    let g = loadDot_file cf.src_file in
    let g' = edit_normg ~batch:cf.batch_flag ~dst:cf.dst_file ~usrc:cf.usrc_file g in
    if cf.usrc_file = "" && (not (g =.= g')) then
      let dot = g2dot g' in
      dumpDot ~shape:`ellipse dot cf.src_file 

