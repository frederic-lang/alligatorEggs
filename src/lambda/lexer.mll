{
  open Parser
  exception End_of_file
}

let id = ['a'-'z' 'A'-'Z']['a'-'z' '0'-'9']*

rule expression = parse
  | id '.' as var
    {STR (String.sub var 0 ((String.length var)-1)) }
  | id as var
    {VAR var}
  | ['\\'] { ABS }
  | ['('] { APP }
  | eof { EOF }
  | _ {expression lexbuf}

  {}