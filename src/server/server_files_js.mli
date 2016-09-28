(**
 * Copyright (c) 2013-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the "flow" directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 *
 *)

val config_file: PathFlow.t -> string
val init_file: tmp_dir:string -> PathFlow.t -> string
val recheck_file: tmp_dir:string -> PathFlow.t -> string
val lock_file: tmp_dir:string -> PathFlow.t -> string
val pids_file: tmp_dir:string -> PathFlow.t -> string
val socket_file: tmp_dir:string -> PathFlow.t -> string
val dfind_log_file: tmp_dir:string -> PathFlow.t -> string
val log_file: tmp_dir:string -> PathFlow.t -> FlowConfig.Opts.t -> PathFlow.t
