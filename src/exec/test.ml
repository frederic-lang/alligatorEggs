open Lambda

let _ =
          try
            let lexbuf = Lexing.from_channel stdin in
            while true do
              let result = Parser.input Lexer.expression lexbuf
               in
               printlambda result 0; print_newline()
            done
          with End_of_file ->
            exit 0