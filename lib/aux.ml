let ( << ) f g x = f (g x)
let ( >> ) f g = g << f
let id x = x
let const x _ = x
let string_of_list = List.to_seq >> String.of_seq
let list_of_string = String.to_seq >> List.of_seq