(*
 * Copyright (c) 2013 - present Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 *)

open! IStd

(** Make sure callbacks are always unregistered. drive the point home by reporting possible NPE's *)
(* TODO: complain if onDestroy is not defined, yet the activity has View fields *)

module P = Printf

(* The report_error method with arguments: activity_typ, fld, fld_typ, pname, pdesc 
Defines how to report the error, called when an error is found
*)
let report_error activity_typ fld fld_typ pname pdesc =
  let contains_anonymous_class = "CHECKERS_ACTIVITY_CONTAINS_ANONYMOUS_CLASS" in
  let description = Localise.desc_activity_contains_anonymous_class activity_typ fld fld_typ pname in
  let exn =  Exceptions.Checkers (contains_anonymous_class, description) in
  let loc = Procdesc.get_loc pdesc in
  Reporting.log_error pname ~loc exn

(* checker definition *)
let callback_activity_contains_anonymous_class_java
    pname_java { Callbacks.proc_desc; tenv } =
  (* TODO: complain if onDestroyView is not defined, yet the Fragment has View fields *)
  (* TODO: handle fields nullified in callees in the same file *)
  let is_anonymous_inner_class = Typ.Procname.java_is_anonymous_inner_class proc_name (Typ.Procname.java_get_method pname_java) in
  if is_anonymous_inner_class then
    begin
      let class_typename =
        Typ.Name.Java.from_string (Typ.Procname.java_get_class_name pname_java) in
      match Tenv.lookup tenv class_typename with
      | Some { fields } when AndroidFramework.is_activity tenv class_typename ->
          let declared_view_fields =
            List.filter ~f:(is_declared_view_typ class_typename) fields in
          let fields_nullified = PatternMatch.get_fields_nullified proc_desc in
          (* report if a field is declared by C, but not nulled out in C.onDestroyView *)
          List.iter
            ~f:(fun (fname, fld_typ, _) ->
                if not (Fieldname.Set.mem fname fields_nullified) then
                  report_error
                    (Tstruct class_typename) fname fld_typ summary proc_desc)
            declared_view_fields
      | _ -> ()
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
