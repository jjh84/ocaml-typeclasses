module type APPLICATIVE =
  sig
    type 'a t
    val map : ('a -> 'b) -> 'a t -> 'b t
    val pure : 'a -> 'a t
    val apply : ('a -> 'b) t -> 'a t -> 'b t
  end

module ListApplicative :
  sig
    type 'a t = 'a list
    val map : ('a -> 'b) -> 'a t -> 'b t
    val pure : 'a -> 'a t
    val apply : ('a -> 'b) t -> 'a t -> 'b t
  end

module OptionApplicative :
  sig
    type 'a t = 'a option
    val map : ('a -> 'b) -> 'a t -> 'b t
    val pure : 'a -> 'a t
    val apply : ('a -> 'b) t -> 'a t -> 'b t
  end

module ApplicativeUtils :
  functor (A : APPLICATIVE) ->
    sig
      type 'a t = 'a A.t
      val map : ('a -> 'b) -> 'a t -> 'b t
      val pure : 'a -> 'a t
      val apply : ('a -> 'b) t -> 'a t -> 'b t
      val ( <$> ) : ('a -> 'b) -> 'a t -> 'b t
      val ( <*> ) : ('a -> 'b) t -> 'a t -> 'b t
      val ( <* ) : 'a t -> 'b t -> 'a t
      val ( *> ) : 'a t -> 'b t -> 'b t
      val liftA2 : ('a -> 'b -> 'c) -> 'a t -> 'b t -> 'c t
    end

module LAU :
  sig
    type 'a t = 'a ListApplicative.t
    val map : ('a -> 'b) -> 'a t -> 'b t
    val pure : 'a -> 'a t
    val apply : ('a -> 'b) t -> 'a t -> 'b t
    val ( <$> ) : ('a -> 'b) -> 'a t -> 'b t
    val ( <*> ) : ('a -> 'b) t -> 'a t -> 'b t
    val ( <* ) : 'a t -> 'b t -> 'a t
    val ( *> ) : 'a t -> 'b t -> 'b t
    val liftA2 : ('a -> 'b -> 'c) -> 'a t -> 'b t -> 'c t
  end

module OAU :
  sig
    type 'a t = 'a OptionApplicative.t
    val map : ('a -> 'b) -> 'a t -> 'b t
    val pure : 'a -> 'a t
    val apply : ('a -> 'b) t -> 'a t -> 'b t
    val ( <$> ) : ('a -> 'b) -> 'a t -> 'b t
    val ( <*> ) : ('a -> 'b) t -> 'a t -> 'b t
    val ( <* ) : 'a t -> 'b t -> 'a t
    val ( *> ) : 'a t -> 'b t -> 'b t
    val liftA2 : ('a -> 'b -> 'c) -> 'a t -> 'b t -> 'c t
  end

val f1 : float -> float -> float option
val f2 : float -> float -> float OAU.t