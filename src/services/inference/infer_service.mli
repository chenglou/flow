(**
 * Copyright (c) 2013-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the "flow" directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 *
 *)

open Utils_js

val infer:
  options: Options.t ->
  workers: Worker.t list option ->
  save_errors: (filename list -> ErrorsFlow.ErrorSet.t list -> unit) ->
  save_suppressions: (filename list -> ErrorsFlow.ErrorSuppressions.t list -> unit) ->
  FilenameSet.t ->
  filename list

val apply_docblock_overrides:
 Context.metadata ->
 Docblock.t ->
 Context.metadata
