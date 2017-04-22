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

(* the report_error method with arguments: activity_typ, fld, fld_typ, pname, pdesc 
   defines how to report the error, called when an error is found *)
let report_error activity_typ fld fld_typ pname pdesc =
  let retained_view = "CHECKERS_ACTIVITY_RETAINS_STATIC_VIEW" in
  let description = Localise.desc_activity_retains_static_view activity_typ fld fld_typ pname in
  let exn =  Exceptions.Checkers (retained_view, description) in
  let loc = Procdesc.get_loc pdesc in
  Reporting.log_error pname ~loc exn

(* checker definition *)
let callback_activity_retains_static_view_java
    pname_java { Callbacks.proc_desc; summary; tenv } =

  (* boolean macro: check if the name of the analyzed function is "onDestroy" *)
  let is_on_destroy = String.equal (Typ.Procname.java_get_method pname_java) "onDestroy" in

  (* boolean macro: checks if the field [tname] is a view *)
  let fld_typ_is_view = function
    | Typ.Tptr (Tstruct tname, _) -> AndroidFramework.is_view tenv tname
    | _ -> false in

  (* boolean checker: is [fldname] a View type declared by [class_typename]? *)
  let is_declared_view_typ class_typename (fldname, fld_typ, _) =
    let fld_classname = Typ.Name.Java.from_string (Fieldname.java_get_class fldname) in
    Typ.Name.equal fld_classname class_typename && fld_typ_is_view fld_typ in

  if is_on_destroy then (* checks for a specific analyzed function is onDestroy *)
    begin

      (* define class name variable*)
      let class_typename =
        Typ.Name.Java.from_string (Typ.Procname.java_get_class_name pname_java) in

      (* get all the fields in the class if it is an activity*)
      match Tenv.lookup tenv class_typename with
      | Some { statics } when AndroidFramework.is_activity tenv class_typename -> (*run the following if fields are found in an activity *)

	begin

          (* filter the declared views from all the fields *)
          let declared_view_fields =
            List.filter ~f:(is_declared_view_typ class_typename) statics in

          (* get all the nullified fields *)
          let fields_nullified = PatternMatch.get_statics_nullified proc_desc in

          (* report if a field is declared by the class, but not nulled out in onDestroy *)
          begin
          (* iterate over all declared views *)
          List.iter
            ~f:(fun (fname, fld_typ, _) ->
               begin
               (* check if the declared field in not nullified *)
               if not (Fieldname.Set.mem fname fields_nullified) then
                 begin
                   (* report an error! found a declared view field which is not nullified *)
                   report_error (Tstruct class_typename) fname fld_typ (Typ.Procname.Java pname_java) proc_desc
                 end
               end
	       )
            declared_view_fields
          end
        end
      | _ -> () (* do nothing if no fields in activity found *)
    end

(* main *)
let callback_activity_retains_static_view ({ Callbacks.summary } as args) : Specs.summary =
  let proc_name = Specs.get_proc_name summary in
  begin
    match proc_name  with
    | Typ.Procname.Java pname_java ->
        callback_activity_retains_static_view_java pname_java args
    | _ ->
        ()
  end;
  summary
