open Lambda 

let expr1 = Abs ( "1", App(Var "1", Abs( "2", Var "2" ) ) )
let expr2 = App( expr1, expr1 )

let expr3 = Abs("x", App(Var("g") , App(Var("x"),Var("x")) ))
let ycombinator = Abs("g", App(expr3,expr3) )

let expr = ref expr2 
let expr_lit = ref ""

let parse_input exprin = 
  try
  let lexbuf = Lexing.from_string exprin in
    let result =  Parser.input Lexer.expression lexbuf in 
      result
    with Parsing.Parse_error -> expr2 | Lexer.End_of_file -> ycombinator 


(****)

let height = 600
let width = 600

module ColorDic = Map.Make(String)

let _ = Random.self_init ()

(*let new_color () = 
  let r1 = Random.int 99 and r2 = Random.int 99 in
  "#FF" ^ string_of_int r1 ^ string_of_int r2 *)

let c = ref 0

let rec assign_color tree dic = 
  match tree with 
    | Var s -> if not (ColorDic.mem s dic) then (c := (!c + 1 mod 7); ColorDic.add s (!c) dic) else dic
    | Abs (s,e1) -> let dic = (if not (ColorDic.mem s dic) then (c := (!c + 1 mod 7); ColorDic.add s !c dic ) else dic) in
                    assign_color e1 dic
    | App (e1,e2) -> let dic = assign_color e1 dic in 
                     assign_color e2 dic

let colorAssoc = ref (assign_color !expr ColorDic.empty) 

(****)

module Html = Dom_html

(* Ressources *)

let old_alligator = Html.createImg Html.window##document
let alligators = Array.init 7 (fun i -> Html.createImg Html.window##document )
let eggs = Array.init 7 (fun i -> Html.createImg Html.window##document )

let init_media () = 
  old_alligator##src <- Js.string "static/pic/old.png" ;
  alligators.(0)##src <- Js.string "static/pic/alligator_blue.png" ;
  alligators.(1)##src <- Js.string "static/pic/alligator_brown.png" ;
  alligators.(2)##src <- Js.string "static/pic/alligator_green.png" ;
  alligators.(3)##src <- Js.string "static/pic/alligator_lemon.png" ;
  alligators.(4)##src <- Js.string "static/pic/alligator_olive.png" ;
  alligators.(5)##src <- Js.string "static/pic/alligator_red.png" ;
  alligators.(6)##src <- Js.string "static/pic/alligator_yellow.png" ;
  eggs.(0)##src <- Js.string "static/pic/egg_blue.png" ;
  eggs.(1)##src <- Js.string "static/pic/egg_brown.png" ;
  eggs.(2)##src <- Js.string "static/pic/egg_green.png" ;
  eggs.(3)##src <- Js.string "static/pic/egg_lemon.png" ;
  eggs.(4)##src <- Js.string "static/pic/egg_olive.png" ;
  eggs.(5)##src <- Js.string "static/pic/egg_red.png" ;
  eggs.(6)##src <- Js.string "static/pic/egg_yellow.png" ;
  ()
  


let lambda_input name =
  let res = Html.window##document##createDocumentFragment() in
  Dom.appendChild res (Html.window##document##createTextNode(Js.string name));
  let input = Html.createInput ~_type:(Js.string "text") Html.window##document in
  input##value <- Js.string "";
  input##onchange <- Html.handler
    (fun _ ->
       begin try
         expr_lit := (Js.to_string (input##value))
       with Invalid_argument _ ->
         ()
       end;
       input##value <- Js.string !expr_lit;
       Js._false);
  Dom.appendChild res input;
  res

let button name callback =
  let res = Html.window##document##createDocumentFragment() in
  let input = Html.createInput ~_type:(Js.string "submit") Html.window##document in
  input##value <- Js.string name;
  input##onclick <- Html.handler callback;
  Dom.appendChild res input;
  res

let rec tile c tree (x:float) (y:float) dic : (float*float)=
  match tree with
    | Var s -> (*c##fillStyle <- Js.string (ColorDic.find s dic);
               c##fillRect(x+.5., y, 10., 10.); *)
               let egg = eggs.( ColorDic.find s dic ) in
               c##drawImage_withSize(egg, x-.5., y, 40., 40.);
               (30.,35.)
    | Abs (s,e1) -> let (x1, y1) =  tile c e1 x (y +. 70.) dic in
                    (*c##fillStyle <- Js.string (ColorDic.find s dic); 
                    c##fillRect(x +. (x1/.2.) -. 10., y, 20., 10.);   *)
                    let abs = if x1 > 70. then (x1/.2.) -. 35. else 0. in 
                    let alligator = alligators.( ColorDic.find s dic ) in
                    c##drawImage_withSize(alligator, x+. abs, y, 70., 70.); 
                    (max x1 70., y1 +. 70.)
    | App (e1, e2) -> let x1, y1 = tile c e1 x (y +. 50.) dic in
                      let x2, y2 = tile c e2 (x+.x1) (y+.50.) dic in
                      c##drawImage_withSize(old_alligator, x+.x1 -.30., y-.5., 60., 60.); 
                      (x1+.x2, (max y1 y2) +. 50. ) 


let create_canvas () =
  let d = Html.window##document in
  let c = Html.createCanvas d in
  c##width <- height;
  c##height <- width;
  c

let redraw ctx canvas tree dic =
  let c = canvas##getContext (Html._2d_) in
  c##clearRect (0., 0., float canvas##width, float canvas##height);
  let _ = tile c tree 0. 0. dic in
  ctx##drawImage_fromCanvas (canvas, 0., 0.)
  

let (>>=) = Lwt.bind

let loop c c' tree dic =
  tree := step !tree;
  dic := assign_color !tree !dic;
  redraw c c' !tree !dic


let start _ =
  let c = create_canvas () in
  let c' = create_canvas () in
  let section = (Js.Opt.get (Html.window##document##getElementById(Js.string "content")) (fun () -> assert false)) in
  Dom.appendChild section c;
  let c = c##getContext (Html._2d_) in
  c##globalCompositeOperation <- Js.string "copy";
  let main_div =
    (Js.Opt.get (Html.window##document##getElementById(Js.string "main"))
      (fun () -> assert false))
  in (Dom.appendChild main_div
    (button "Pas Suivant"
       (fun _ ->
          loop c c' expr colorAssoc;
          Js._false)));
  Dom.appendChild main_div
    (button "Nouvelle Expression"
       (fun _ ->
          expr := parse_input !expr_lit;
          colorAssoc := assign_color !expr !colorAssoc;
          redraw c c' !expr !colorAssoc; 
          Js._false));
  Dom.appendChild main_div (Html.createBr Html.window##document);
  Dom.appendChild main_div (lambda_input "Votre lambda expression : ");
  init_media ();
  redraw c c' !expr !colorAssoc;
  Js._false 

let _ =
Html.window##onload <- Html.handler start
