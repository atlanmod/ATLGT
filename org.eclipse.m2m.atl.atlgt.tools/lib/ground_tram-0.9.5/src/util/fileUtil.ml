(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
(* Utilities for file operation *)

open Unix

let path_concat path name =
  if path = "." then
    name
  else
    Filename.concat path name

let find_file paths filename = try
  let found_path =
    List.find (fun path ->
                 let name = path_concat path filename in
                 try access name [F_OK;R_OK]; (stat name).st_kind = S_REG
                 with Unix_error _ -> false) ("."::paths) in
  path_concat found_path filename
with Not_found ->
  failwith ("FileUtil.find_file: "^filename^" not found")
