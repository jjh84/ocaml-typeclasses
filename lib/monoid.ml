
module type MONOID = sig
    type t
    val empty: t
    val append: t -> t -> t
end

module TestMonoid (M : MONOID) = struct
    let test_left_id x = M.append M.empty x = x
    let test_right_id x = M.append x M.empty = x

    let test_assoc x y z =
        M.append x (M.append y z) = M.append (M.append x y) z
end

module IntAddMonoid : MONOID with type t = int = struct
    type t = int
    let empty = 0
    let append = ( + )
end

module MonoidUtils (M:MONOID) = struct
    include M
    let ( <+> ) x y = append x y
    let concat xs = List.fold_left ( <+> ) empty xs
end

module type TYPE = sig type t end

module ListMonoid (T : TYPE) : MONOID with type t = T.t list = struct 
    type t = T.t list
    let empty = []
    let append xs ys = xs @ ys
end

let concat (type a) xs =
    let module MU = MonoidUtils (ListMonoid(struct type t = a end)) in
    MU.concat xs