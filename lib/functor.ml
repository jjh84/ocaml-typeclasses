
module type FUNCTOR = sig
    type 'a t
    val map : ('a -> 'b) -> 'a t -> 'b t
end

(* 'with type' is used to expose type of ListFunctor *)
module ListFunctor : FUNCTOR with type 'a t = 'a list = struct 
    type 'a t = 'a list
    let map f = List.map f
end

module OptionFunctor : FUNCTOR with type 'a t = 'a option = struct
    type 'a t = 'a option
    let map f x = 
        match x with
        | Some a -> Some (f a)
        | None -> None
end

module TestFunctor (F : FUNCTOR) = struct
    open Aux

    let test_id x = F.map id x = x

    (* Test Structure Preserving Law that is (f.g)(x) == f(g(x)) *)
    let test_compose xs =
        let f x = x mod 2 in
        let g x = x - 1 in
        F.map (g >> f) xs = F.map f (F.map g xs)
end

module TFL = TestFunctor (ListFunctor)
module OFL = TestFunctor (OptionFunctor)
