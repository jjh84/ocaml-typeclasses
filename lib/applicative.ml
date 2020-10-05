open Aux

module type APPLICATIVE = sig
    include Functor.FUNCTOR
    val pure : 'a -> 'a t
    val apply : ('a -> 'b) t -> 'a t -> 'b t
end

module ListApplicative : APPLICATIVE with type 'a t = 'a list = struct
    include Functor.ListFunctor

    let pure x = [x]

    let apply fs xs =
        Monoid.concat @@ map (fun f -> map (fun x -> f x) xs) fs
end

module OptionApplicative : APPLICATIVE with type 'a t = 'a option = struct
    include Functor.OptionFunctor

    let pure x = Some x

    let apply fo xo =
        match fo, xo with
        | Some f, Some x -> Some (f x)
        | _ -> None
end

module ApplicativeUtils (A:APPLICATIVE) = struct
    include A
    let ( <$> ) f     = map f
    let ( <*> ) f     = apply f
    let ( <* )  x y   = const <$> x <*> y
    let ( *> )  x y   = (fun _ y -> y) <$> x <*> y
    let liftA2  f x y = f <$> x <*> y
end

module LAU = ApplicativeUtils (ListApplicative)
module OAU = ApplicativeUtils (OptionApplicative)

(* Example *)
let ( //. ) n d = 
    if d = 0. then None else Some (n /. d)

let ssqrt x =
    if x < 0. then None else Some (sqrt x)

(* One approache to calculate f(x, y) = (x/y) + sqrt(x) - sqrt(y) *)
let f1 x y =
    match x //. y, ssqrt x, ssqrt y with 
    | Some z, Some r1, Some r2 -> Some (z +. r1 -. r2)
    | _ -> None

(* Second approache *)
let f2 x y =
    let open OAU in
    (fun z r1 r2 -> z +. r1 -. r2) <$> (x //. y) <*> ssqrt x <*> ssqrt y
