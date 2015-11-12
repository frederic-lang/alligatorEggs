val expr1 : Lambda.lambda
val expr2 : Lambda.lambda
val expr3 : Lambda.lambda
val ycombinator : Lambda.lambda
val expr : Lambda.lambda ref
val expr_lit : string ref
val parse_input : string -> Lambda.lambda
val height : int
val width : int
module ColorDic :
  sig
    type key = String.t
    type 'a t = 'a Map.Make(String).t
    val empty : 'a t
    val is_empty : 'a t -> bool
    val mem : key -> 'a t -> bool
    val add : key -> 'a -> 'a t -> 'a t
    val singleton : key -> 'a -> 'a t
    val remove : key -> 'a t -> 'a t
    val merge :
      (key -> 'a option -> 'b option -> 'c option) -> 'a t -> 'b t -> 'c t
    val compare : ('a -> 'a -> int) -> 'a t -> 'a t -> int
    val equal : ('a -> 'a -> bool) -> 'a t -> 'a t -> bool
    val iter : (key -> 'a -> unit) -> 'a t -> unit
    val fold : (key -> 'a -> 'b -> 'b) -> 'a t -> 'b -> 'b
    val for_all : (key -> 'a -> bool) -> 'a t -> bool
    val exists : (key -> 'a -> bool) -> 'a t -> bool
    val filter : (key -> 'a -> bool) -> 'a t -> 'a t
    val partition : (key -> 'a -> bool) -> 'a t -> 'a t * 'a t
    val cardinal : 'a t -> int
    val bindings : 'a t -> (key * 'a) list
    val min_binding : 'a t -> key * 'a
    val max_binding : 'a t -> key * 'a
    val choose : 'a t -> key * 'a
    val split : key -> 'a t -> 'a t * 'a option * 'a t
    val find : key -> 'a t -> 'a
    val map : ('a -> 'b) -> 'a t -> 'b t
    val mapi : (key -> 'a -> 'b) -> 'a t -> 'b t
  end
val assign_color : Lambda.lambda -> int ColorDic.t -> int ColorDic.t
module Html = Dom_html
val lambda_input : string -> Dom.documentFragment Js.t
val button :
  string -> (Html.mouseEvent Js.t -> bool Js.t) -> Dom.documentFragment Js.t
val old_alligator : Html.imageElement Js.t
val tile :
  < drawImage_withSize : Html.imageElement Js.t ->
                         float -> float -> float -> float -> 'a Js.meth;
    fillRect : float -> float -> float -> float -> 'b Js.meth;
    fillStyle : < set : Js.js_string Js.t -> unit; .. > Js.gen_prop; .. >
  Js.t ->
  Lambda.lambda -> float -> float -> int ColorDic.t -> float * float
val create_canvas : unit -> Html.canvasElement Js.t
val redraw :
  < drawImage_fromCanvas : (< getContext : Html.context ->
                                           < clearRect : float ->
                                                         float ->
                                                         float ->
                                                         float -> 'b Js.meth;
                                             drawImage_withSize : Html.imageElement
                                                                  Js.t ->
                                                                  float ->
                                                                  float ->
                                                                  float ->
                                                                  float ->
                                                                  'c Js.meth;
                                             fillRect : float ->
                                                        float ->
                                                        float ->
                                                        float -> 'd Js.meth;
                                             fillStyle : < set : Js.js_string
                                                                 Js.t -> 
                                                                 unit;
                                                           .. >
                                                         Js.gen_prop;
                                             .. >
                                           Js.t Js.meth;
                              height : < get : int; .. > Js.gen_prop;
                              width : < get : int; .. > Js.gen_prop; .. >
                            as 'a)
                           Js.t -> float -> float -> 'e Js.meth;
    .. >
  Js.t -> 'a Js.t -> Lambda.lambda -> int ColorDic.t -> 'e
val ( >>= ) : 'a Lwt.t -> ('a -> 'b Lwt.t) -> 'b Lwt.t
val loop :
  < drawImage_fromCanvas : (< getContext : Html.context ->
                                           < clearRect : float ->
                                                         float ->
                                                         float ->
                                                         float -> 'b Js.meth;
                                             drawImage_withSize : Html.imageElement
                                                                  Js.t ->
                                                                  float ->
                                                                  float ->
                                                                  float ->
                                                                  float ->
                                                                  'c Js.meth;
                                             fillRect : float ->
                                                        float ->
                                                        float ->
                                                        float -> 'd Js.meth;
                                             fillStyle : < set : Js.js_string
                                                                 Js.t -> 
                                                                 unit;
                                                           .. >
                                                         Js.gen_prop;
                                             .. >
                                           Js.t Js.meth;
                              height : < get : int; .. > Js.gen_prop;
                              width : < get : int; .. > Js.gen_prop; .. >
                            as 'a)
                           Js.t -> float -> float -> 'e Js.meth;
    .. >
  Js.t -> 'a Js.t -> Lambda.lambda ref -> int ColorDic.t ref -> 'e
val start : 'a -> bool Js.t
