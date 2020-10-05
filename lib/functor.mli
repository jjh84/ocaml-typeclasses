module type FUNCTOR = sig type 'a t val map : ('a -> 'b) -> 'a t -> 'b t end
module ListFunctor :
  sig type 'a t = 'a list val map : ('a -> 'b) -> 'a t -> 'b t end
module OptionFunctor :
  sig type 'a t = 'a option val map : ('a -> 'b) -> 'a t -> 'b t end
module TestFunctor :
  functor (F : FUNCTOR) ->
    sig val test_id : 'a F.t -> bool val test_compose : int F.t -> bool end
module TFL :
  sig
    val test_id : 'a ListFunctor.t -> bool
    val test_compose : int ListFunctor.t -> bool
  end
module OFL :
  sig
    val test_id : 'a OptionFunctor.t -> bool
    val test_compose : int OptionFunctor.t -> bool
  end