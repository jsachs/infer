(*
 * Copyright (c) 2013 - present Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 *)

open! IStd

module P = Printf

let report_error activity_typ fld fld_typ summary pdesc =
  let pname = Procdesc.get_proc_name pdesc in
  let anonymous_class = "CHECKERS_ACTIVITY_CONTAINS_ANONYMOUS_CLASS" in
  let description = Localise.desc_activity_contains_anonymous_class activity_typ fld fld_typ pname in
  let exn =  Exceptions.Checkers (anonymous_class, description) in
  let loc = Procdesc.get_loc pdesc in
  Reporting.log_error_from_summary summary ~loc exn

(* checker definition *)
let callback_activity_contains_anonymous_class_java
    pname_java { Callbacks.proc_desc; summary; tenv } =
  (* TODO: complain if onDestroyView is not defined, yet the Fragment has View fields *)
  (* TODO: handle fields nullified in callees in the same file *)
  let is_anonymous_inner_class = Typ.Procname.java_is_anonymous_inner_class pname_java in
  if is_anonymous_inner_class then
    begin
      let class_typename =
        Typ.Name.Java.from_string (Typ.Procname.java_get_class_name pname_java) in
      report_error
        (Tstruct class_typename) fname fld_typ summary proc_desc
    end

let callback_activity_contains_anonymous_class ({ Callbacks.summary } as args) : Specs.summary =
  let proc_name = Specs.get_proc_name summary in
  begin
    match proc_name  with
    | Typ.Procname.Java pname_java ->
        callback_activity_contains_anonymous_class_java pname_java args
    | _ ->
        ()
  end;
  summary
