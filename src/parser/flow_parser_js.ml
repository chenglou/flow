(**
 * Copyright (c) 2013-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the "flow" directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 *
 *)

external createRegex : string -> string -> _ = "RegExp" [@@bs.new]

module JsTranslator : sig
  val translation_errors: (Loc.t * Parse_error.t) list ref
  include Estree_translator.Translator
end = struct
  type t

  let translation_errors = ref []
  let string = [%bs.raw "function (x) {return x;}"]
  let bool = [%bs.raw "function (x) {x ? 1 : 0;}"]
  let obj = [%bs.raw "function(arr) {let ret = {}; arr.forEach(function(a) {ret[a[0]]=a[1];}); return ret}"]
  let array = [%bs.raw "function (x) {return x;}"]
  let number = [%bs.raw "function (x) {return x;}"]
  let null = [%bs.raw "null"]
  let regexp loc pattern flags =
    let regexp = try
      createRegex pattern flags
    with _ ->
      translation_errors := (loc, Parse_error.InvalidRegExp)::!translation_errors;
      (* Invalid RegExp. We already validated the flags, but we've been
       * too lazy to write a JS regexp parser in Ocaml, so we didn't know
       * the pattern was invalid. We'll recover with an empty pattern.
       *)
      createRegex "" flags
    in
    regexp
end

external throw : _ -> _ = "throw" [@@bs.call]

(* let parse_options jsopts = Parser_env.(
  let opts = default_parse_options in

  let decorators = Js.Unsafe.get jsopts "esproposal_decorators" in
  let opts = if Js.Optdef.test decorators
    then { opts with esproposal_decorators = Js.to_bool decorators; }
    else opts in

  let class_instance_fields = Js.Unsafe.get jsopts "esproposal_class_instance_fields" in
  let opts = if Js.Optdef.test class_instance_fields
    then { opts with esproposal_class_instance_fields = Js.to_bool class_instance_fields; }
    else opts in

  let class_static_fields = Js.Unsafe.get jsopts "esproposal_class_static_fields" in
  let opts = if Js.Optdef.test class_static_fields
    then { opts with esproposal_class_static_fields = Js.to_bool class_static_fields; }
    else opts in

  let export_star_as = Js.Unsafe.get jsopts "esproposal_export_star_as" in
  let opts = if Js.Optdef.test export_star_as
    then { opts with esproposal_export_star_as = Js.to_bool export_star_as; }
    else opts in

  let types = Js.Unsafe.get jsopts "types" in
  let opts = if Js.Optdef.test types
    then { opts with types = Js.to_bool types; }
    else opts in

  opts
) *)

external setRetErrors : _ -> string -> _ -> unit = "" [@@bs.set_index]
external setEName : _ -> string -> _ -> unit = "" [@@bs.set_index]
external newError : _ -> _ = "Error" [@@bs.new]

let parse content options =
  (* let parse_options = Some (parse_options options) in *)
  let parse_options = None in
  try
    let (ocaml_ast, errors) = Parser_flow.program ~fail:false ~parse_options content in
    JsTranslator.translation_errors := [];
    let module Translate = Estree_translator.Translate (JsTranslator)  in
    let ret = Translate.program ocaml_ast in
    let translation_errors = !JsTranslator.translation_errors in
    setRetErrors ret "errors" (Translate.errors (errors @ translation_errors));
    ret
  with Parse_error.Error l ->
    let e = newError ((string_of_int (List.length l)) ^ " errors") in
    setEName e "name" "Parse Error";
    ignore (throw e);
    [%bs.raw "{}"]
