open Interval
open List
open Lib
open Expr

let gen_bb_opt_code tolx tolfx fmt =
  let nl = Format.pp_print_newline fmt in
  let p str = Format.pp_print_string fmt str; nl() in
  let p' = Format.pp_print_string fmt in

  let head () = 
    p "open Interval";
    p "" in

  let tail () =
    p "";
    p "let _ =";
    p (Format.sprintf 
	 "  let int, fint, p, pv = B_and_b.branch_and_bound f_x f_X start_interval %f %f in"
	 tolx tolfx);
    p "  print_I fint; print_newline ();";
    p "  Printf.printf \"max = %f\" pv;";
    p "  flush stdout"; in

  let start_interval var_bounds =
    let rec bounds i strs =
      match strs with
	| [] ->
	  p "| _ -> failwith \"Out of boundaries\"";
	| str :: rest ->
	  p (Format.sprintf "| %d -> %s" i str);
	  bounds (i + 1) rest in
    let n = length var_bounds in
    let strs = map 
      (fun b -> Format.sprintf "{low = %f; high = %f}" b.low b.high) var_bounds in
    nl();
    p (Format.sprintf "let start_interval = Array.init %d (function" n);
    bounds 0 strs;
    p ")";
    nl() in

  let expr var_names e = 
    let rec vars i vs =
      match vs with
	| [] -> ()
	| v :: rest ->
	  p (Format.sprintf "  let %s = input_array.(%d) in" v i);
	  vars (i + 1) rest in
    p "let f_x input_array = ";
    vars 0 var_names;
    print_expr_in_env ocaml_float_print_env fmt e;
    nl();
    p "let f_X input_array = ";
    vars 0 var_names;
    print_expr_in_env ocaml_interval_print_env fmt e;
    nl() in

  fun (var_bound, e) ->
    let var_names = vars_in_expr e in
    let var_bounds = map var_bound var_names in
    head();
    start_interval var_bounds;
    expr var_names e;
    tail()


let min_max_expr tolx tolfx var_bound e =
  let ml_name = "b_and_b/bb.ml" in
  let gen = gen_bb_opt_code tolx tolfx in
  let _ = write_to_file ml_name gen (var_bound, e) in
  let cmd = "ocamlc -I ../INTERVAL -I b_and_b -o bb ../INTERVAL/libinterval.a ../INTERVAL/interval.cma b_and_b/pqueue.ml b_and_b/b_and_b.ml b_and_b/bb.ml" in
  let _ = run_cmd cmd in
  let ss = run_cmd "./bb" in
  ss