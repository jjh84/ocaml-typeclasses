val ( << ) : ('a -> 'b) -> ('c -> 'a) -> 'c -> 'b
val ( >> ) : ('a -> 'b) -> ('b -> 'c) -> 'a -> 'c
val id : 'a -> 'a
val const : 'a -> 'b -> 'a
val string_of_list : char list -> String.t
val list_of_string : String.t -> char list