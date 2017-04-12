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
(* TODO: complain if onDestroyView is not defined, yet the Fragment has View fields *)

module P = Printf

(* The report_error method with arguments: activity_typ, fld, fld_typ, pname, pdesc 
Defines how to report the error, called when an error is found
*)
let report_error activity_typ fld fld_typ pname pdesc =
  let retained_view = "CHECKERS_ACTIVITY_RETAINS_STATIC_VIEW" in
  let description = Localise.desc_activity_retains_static_view activity_typ fld fld_typ pname in
  let exn =  Exceptions.Checkers (retained_view, description) in
  let loc = Procdesc.get_loc pdesc in
  Reporting.log_error pname ~loc exn

(* checker definition *)
let callback_activity_retains_static_view_java
    pname_java { Callbacks.proc_desc; tenv } =

  (* checker macro: check if the name of the analyzed function is "onDestroy" *)
  let is_on_destroy = String.equal (Procname.java_get_method pname_java) "onDestroy" in

  (* checker macro: checks if the field [tname] is a view *)
  let fld_typ_is_view = function
    | Typ.Tptr (Tstruct tname, _) -> AndroidFramework.is_view tenv tname
    | _ -> false in

  (* is [fldname] a View type declared by [class_typename]? *)
  let is_declared_view_typ class_typename (fldname, fld_typ, _) =
    let fld_classname = Typename.Java.from_string (Ident.java_fieldname_get_class fldname) in
    Typename.equal fld_classname class_typename && fld_typ_is_view fld_typ in

  if true then (* original was [if is_on_destroy then], checks for a specific analyzed function*)
    begin

      (* DEBUG print class name *)
      let mystring = (Procname.java_get_class_name pname_java) in
      Printf.printf "a %s \n" mystring;

      (* Define class name variable*)
      let class_typename =
        Typename.Java.from_string (Procname.java_get_class_name pname_java) in

      (* get all the fields in the class if it is an activity*)
      match Tenv.lookup tenv class_typename with
      | Some { fields } when AndroidFramework.is_activity tenv class_typename -> (*run the following if fields are found in an activity *)

	begin

          (* DEBUG print class name *)
          let mystring = (Procname.java_get_class_name pname_java) in
          Printf.printf "  b %s \n" mystring;

          (* filter the declared views from all the fields *)
          let declared_view_fields =
            List.filter ~f:(is_declared_view_typ class_typename) fields in

          (* get all the nullified fields *)
          let fields_nullified = PatternMatch.get_fields_nullified proc_desc in

          (* report if a field is declared by C, but not nulled out in C.onDestroyView *)
          begin

          (* DEBUG print class name, number of views, and number of fields *)
          let mystring = (Procname.java_get_class_name pname_java) in
          let myint1 = (List.length declared_view_fields) in
          let myint2 = (List.length fields) in
          Printf.printf "    c %s # of declared view fields is %d out of %d of fields\n" mystring myint1 myint2;

          (* iterate over all declared views *)
          List.iter
            ~f:(fun (fname, fld_typ, _) ->
               begin

              (* DEBUG print *)
               Printf.printf "    d\n";

               (* check if the declared field in not nullified *)
               if not (Ident.FieldSet.mem fname fields_nullified) then
                 begin

                   (* DEBUG print class name *)
                   let mystring = (Procname.java_get_class_name pname_java) in
                   Printf.printf "      e %s \n" mystring;

                   (* report an error! found a declared view field which is not nullified *)
                   report_error (Tstruct class_typename) fname fld_typ (Procname.Java pname_java) proc_desc

                 end

               end
	       )
            declared_view_fields

          end
        end
      | _ -> () (* do nothing if no fileds in activity found *)
    end

(* main *)
let callback_activity_retains_static_view ({ Callbacks.proc_name } as args) =
  match proc_name with
  | Procname.Java pname_java -> (* if the analyzer function is a java function *)
      callback_activity_retains_static_view_java pname_java args
  | _ -> () (* do nothing if this is not a java function *)
