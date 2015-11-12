type lambda = 	Var of string |
				Abs of string * lambda |
				App of lambda * lambda

let nextVal = ref 0

let gen () =
	nextVal := !nextVal + 1;
	"v" ^ (string_of_int !nextVal)

let rec listiter2 f l arg =
	match l with
	| [] -> ()
	| (h::t) -> f h arg;
				listiter2 f t arg

let rec listmap2 f l arg =
	match l with
	| [] -> []
	| (h::t) -> (f h arg) :: (listmap2 f t arg)

let rec listmap3 f l arg1 arg2 =
	match l with
	| [] -> []
	| (h::t) -> (f h arg1 arg2) :: (listmap3 f t arg1 arg2)

let rec printlambda l t =
	for i = 0 to t do
		print_string "  "
	done;
	match l with
		| Var(v) 		-> 	print_string v;	print_string "\n"
		| Abs(v, e) 	-> 	print_string "l."; print_string v; print_string "\n";
							printlambda e (t+1)
		| App(m, n) 	-> 	print_string "App\n";
							printlambda m (t+1);
							printlambda n (t+1)

let rec search v buf =
	match buf with
	| [] 			-> "nil"
	| (v1, g1)::b 	-> 	if (String.compare v v1 = 0) then
							g1
						else
						search v b

let rec replaceBuf buf x g0 = 
	match buf with
	| [] 			-> 	[]
	| (v, g1)::b 	-> 	if (String.compare v x = 0) then 
							[(v, g0)]@replaceBuf b x g0
						else 
							[(v, g1)]@replaceBuf b x g0

let rec aconversion l buf =
	match l with
		| Var(v) 		-> let x = search v buf in
								begin
									match x with
									| "nil" -> Var(v)
									| y -> Var(y)
								end
		| Abs(v, e) 	-> let x = search v buf in
								if (String.compare "nil" x = 0) then
									let buf2 = List.append buf [(v, v)] in
										Abs(v, aconversion e buf2)
								else if (String.compare v x = 0) then
									let g = gen() in
										Abs(g, aconversion e (replaceBuf buf x g))
								else
									Abs(x, aconversion e buf)
		| App(m, n) 	-> App(aconversion m buf, aconversion n buf)

let rec replace e var r = (* l[var/r] *)
	match e with
		| Var(v) 		->	if (String.compare v var = 0) then r else e
		| Abs(v, e) 	-> Abs(v, replace e var r)
		| App(m, n)		-> App(replace m var r, replace n var r)

let rec constructLambda lambdaList =
	match lambdaList with
		| [] 		-> Var("nil")
		| v1::[] 	-> v1
		| v1::v2 	-> App(v1, constructLambda v2)

let rec breduction l =
	match l with
		| Var(_) 		-> 	l
		| Abs(v, e) 	-> 	Abs(v, breduction e)
		| App(m, n) 	-> 	begin
							match m with
								| Var(_) -> 	begin
												match n with
													| App(_, _) -> App(m, breduction n)
													| _ 		-> l
												end
								| Abs(v, e) ->	begin
												match n with
													| App(m2, n2) 	-> App((replace e v m2), n2)
													| _ 			-> replace e v n
												end
								| App(_, _) -> 	App(breduction m, n)
							end

let step e = 
	let e1 = breduction e in
		aconversion e1 []

let expr = 	App(
				Abs("a", 
					Abs("s", 
						Abs("z",
							App(
								Var("s"),
								App(Var("a"),
									App(Var("s"),
										Var("z")
										)
									)
								)
							)
						)
					),
				Abs("s", 
					Abs("z",
						Var("z"))
					)
			)
let () = printlambda expr 0
let expr = step expr
let () = printlambda expr 0
let expr = step expr
let () = printlambda expr 0
let expr = step expr
let () = printlambda expr 0
let expr = step expr
let () = printlambda expr 0
let expr = step expr
let () = printlambda expr 0
let expr = step expr
let () = printlambda expr 0