(* GRoundTram 0.9.5
 * http://www.biglab.org/
 * Copyright(c) 2008-2011, The BiG Team.
 *
 * MIT Licensed - http://www.biglab.org/src/mit-license.txt
 *
 *)
(** 
  Generic command line interface for all commands 
 *)

open Version
open Format

(**
 {b specification }
  {[
     gtram <command> [<args>]
  ]}

  for command specific help,

  {[
     gtram <command> --help
  ]}

 {b implementation }

  Invoke <command> with arguments passed directly to the command.
  <command> is captured by annonymous argument function annon_fun
  parameter to Arg.arse. Following command-specific arguments
  are captured by Arg.Rest parameter.
*)

type config = {
    mutable subcommand : string; (** name of subcommands *)
    mutable args       : string; (** arguments of the subcommands *)
    mutable debug      : bool  ; (** debug flag *)
  }

let default_config = {
  subcommand = "";
  args       = "";
  debug      = false;
}

let speclist =
  let cf = default_config in
  Arg.align
    [
     ("-d", Arg.Unit (fun()->cf.debug<-true),             " set debug flag");
     ("--", Arg.Rest (fun s->cf.args<-cf.args ^ " " ^ s), " parameters to commands");
   ]

let speclist = add_version_spec speclist

let usage_msg = "Usage: "
  ^Sys.executable_name^ " [-v] [-d] [-help] [--help] <command> -- [<args>]
where <command> corresponds to one of the following:
    unqlplus        execute UnQL+ transformation/validate graph against KM3 schema.
    desugar         converts UnQL+ file bsto equivalent UnCAL files.
    uncalcmd        execute UnCAL unidirectionally.
    fwd_uncal       foward execution of UnQL+/UnCAL for in-place updates.
    bwd_uncal       backward execution of UnQL+/UnCAL for in-place updates.
    bwdIg_uncal     bidirectional execution of UnCAL for insertions.
    bwdI_enum_uncal bidirectional execution of UnCAL for insertions based on candidate enumeration.
    fwdI_uncal      forward execution of UnCAL for insertions based on insertion units.
    bwdI_uncal      backward execution of UnCAL for insertions based on insertion units.
    chkuncal        static typechecking of UnQL+/UnCAL.
    
for command specific help, pass '--help' for <args> part."
let get_subcommand (subcommand:string) : unit =
  if default_config.subcommand <> "" then raise (Arg.Bad ("command " ^  default_config.subcommand ^ " already specified"))
  else default_config.subcommand <- subcommand
  
let read_args () =
  Arg.parse speclist get_subcommand usage_msg; default_config

let failwith_msg msg =
  fprintf err_formatter "%s@." msg;
  Arg.usage speclist usage_msg; exit 1

let _ = 
  let cf = read_args () in
  let _ = print_version () in
  if      cf.subcommand = "" then failwith_msg "command unspecified."
  else 
    begin
      let cmd = (cf.subcommand ^ " " ^ cf.args) in
      if cf.debug then printf "executing command %s@." cmd;
      Sys.command cmd
  end

