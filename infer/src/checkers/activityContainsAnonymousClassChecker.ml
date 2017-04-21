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

(* The report_error method with arguments: activity_typ, fld, fld_typ, pname, pdesc 
Defines how to report the error, called when an error is found
*)
let report_error activity_typ pname pdesc =
  let anonymous_class = "CHECKERS_ACTIVITY_CONTAINS_ANONYMOUS_CLASS" in
  let description = Localise.desc_activity_contains_anonymous_class activity_typ pname in
  let exn =  Exceptions.Checkers (anonymous_class, description) in
  let loc = Procdesc.get_loc pdesc in
  Reporting.log_error pname ~loc exn

(* checker definition *)
let callback_activity_contains_anonymous_class_java
    pname_java pname_t { Callbacks.proc_desc; summary; tenv } =
  (* Define class name variable*)
  let class_typename =
    Typ.Name.Java.from_string (Typ.Procname.java_get_class_name pname_java) in
  if Typ.Procname.java_is_anonymous_inner_class pname_t then
    report_error (Tstruct class_typename) (Typ.Procname.Java pname_java) proc_desc

(* main *)
let callback_activity_contains_anonymous_class ({ Callbacks.summary } as args) : Specs.summary =
  let proc_name = Specs.get_proc_name summary in
  begin
    match proc_name with
    | Typ.Procname.Java pname_java ->
        callback_activity_contains_anonymous_class_java pname_java proc_name args
    | _ ->
        ()
  end;
  summary
  