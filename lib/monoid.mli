module type MONOID = sig type t val empty : t val append : t -> t -> t end
module TestMonoid :
  functor (M : MONOID) ->
    sig
      val test_left_id : M.t -> bool
      val test_right_id : M.t -> bool
      val test_assoc : M.t -> M.t -> M.t -> bool
    end
module IntAddMonoid :
  sig type t = int val empty : t val append : t -> t -> t end
module MonoidUtils :
  functor (M : MONOID) ->
    sig
      type t = M.t
      val empty : t
      val append : t -> t -> t
      val ( <+> ) : t -> t -> t
      val concat : t list -> t
    end
module type TYPE = sig type t end
module ListMonoid :
  functor (T : TYPE) ->
    sig type t = T.t list val empty : t val append : t -> t -> t end
val concat : 'a list list -> 'a list