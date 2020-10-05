open Cmdliner

module Let_syntax = struct
  let ( let+ ) t f = Term.(const f $ t)

  let ( and+ ) a b = Term.(const (fun x y -> x, y) $ a $ b)
end

type classes = 
    | Functor
    | Monoid
    | Applicative
    | Unknown

let classes_of_str s =
    match s with
    | "functor" -> Functor
    | "monoid"  -> Monoid
    | "applicative" -> Applicative
    | _ -> Unknown

let test_applicative () =
    let open Typeclasses.Applicative.ListApplicative in
    let add_two_list xs ys =
        let add = ( + ) in
        apply (apply (pure add) xs) ys
    in
    let add_two_list_second xs ys =
        let add = ( + ) in
        apply (map add xs) ys
    in
    let xs = [1;2;3] in
    let ys = [4;5;6] in
    match add_two_list xs ys = add_two_list_second xs ys with
    | true -> print_endline "test applicative passed"
    | false -> print_endline "test applicative failure"

let test_functor () =
    let () = match Typeclasses.Functor.TFL.test_id [] with
        | true -> print_endline "test_id passed"
        | false -> print_endline "test_id failure"
    in
    match Typeclasses.Functor.OFL.test_compose (Some 2) with
        | true -> print_endline "test_compose passed"
        | false -> print_endline "test_compose failure"

let test v s =
    let () = if v = true then print_endline "Start program!" else () in
    match classes_of_str s with
    | Functor -> test_functor ()
    | Applicative -> test_applicative ()
    | Monoid -> print_endline "Not implemented"
    | Unknown -> print_endline ("Unknown typeclass: " ^ s)

let classes =
    let doc = "Typeclass to test." in
    Arg.(value & pos 0 string "functor" & info [] ~docv:"CLASS" ~doc)

let verbose =
    let doc = "Enable verbose mode." in
    Arg.(value & opt bool false & info ["v" ; "verbose"] ~docv:"VERBOSE" ~doc)

let test_t = Term.(const test $ verbose $ classes)

let info =
    let doc = "Type Class Testing Program" in
    let man = [
        `S Manpage.s_bugs;
        `P "Email bug reports to <zzz@fzzz.com>."
    ] in
    Term.info "test" ~version:"0.0.1" ~doc ~exits:Term.default_exits ~man

let () = 
    Term.exit @@ Term.eval (test_t, info)

