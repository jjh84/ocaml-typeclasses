open Aux

module CS = Set.Make(Char)

module Option = struct
    let map f = function
        | None -> None
        | Some x -> Some (f x)

    let bind o f =
        match o with
        | None -> None
        | Some x -> f x

    let product o1 o2 =
        match o1, o2 with
        | Some x, Some y -> Some (x, y)
        | _ -> None

    module Syntax = struct
        let (let+) x f = map f x
        let (and+) o1 o2 = product o1 o2
        let (let*) x f = bind x f
    end
end

module Parser = struct
    type 'a t =
        (* Primitive parsers *)
        | Fail   : string -> 'a t
        | Empty  : unit t
        | Return : 'a     -> 'a t
        | Symbol : char   -> char t
        
        (* Composition - applicative *)
        | Map     : ('a -> 'b) * 'a t -> 'b t
        | Product : 'a t * 'b t       -> ('a * 'b) t
        (* Composition - alternative *)
        | Either  : 'a t * 'a t       -> 'a t

    let empty = Empty

    let fail m = Fail m

    let return x = Return x

    let symbol c = Symbol c

    let map f x = Map (f, x)

    let product p q = Product (p, q)

    let either p q = Either (p, q)

    module Syntax = struct
        let (let+) p f = map f p
        let (and+) p q = product p q
    end

    module Ops = struct
        open Syntax
        let ( <$> ) f p = map f p
        let ( <|> ) p q = either p q
        let ( <*> ) pf px = let+ f = pf and+ x = px in f x
        let ( *> ) p q = (fun _ x -> x) <$> p <*> q
        let ( <* ) p q = const <$> p <*> q
    end
end
