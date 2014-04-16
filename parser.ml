let parse_raw_expr str =
  let lexbuf = Lexing.from_string str in
  Input_parser.expr Input_lexer.token lexbuf

let parse_expr str =
  let raw = parse_raw_expr str in
  Environment.transform_raw_expr raw

let parse_string str =
  let _ = Environment.reset() in
  let lexbuf = Lexing.from_string str in
  Input_parser.first Input_lexer.token lexbuf

let parse_file fname =
  let lines = Lib.load_file fname in
  let str = String.concat "\n" lines in
  parse_string str
