# ocaml-prelude

A small OCaml prelude for algebraic and categorical concepts

Inspired by the Purescript prelude.

### Examples

```ocaml
(* Existentials for list functor *)
let ex0 () : int = let module E = Exists(Functor.List) in
  let pkg = E.into [0; 1; 2; 3; 4] in (* pack *)
  E.from pkg { E.ap = List.length }   (* elim *)

(* Bifunctor for tuple *)
let ex1 () : int * string =
  Bifunctor.Tuple.bimap (fun x -> x * 2) string_of_float
    (42, 3.14159)

(* Semigroupoid for (->) *)
let ex2 () : int = let open Semigroupoid.Fn in
  (fun x -> x + 1) %> (fun x -> x * 2) @@ 10

(* Monoid for list *)
let ex3 () : int list =
  let module M = Monoid.List(struct type el = int end) in
  M.op [0;1;2;3] [4;5;6;7]

(* Foldable for list *)
let ex4 () : int =
  let module F = Foldable.List in
  let module Add = Monoid.Additive.Int in
  let module Mul = Monoid.Multiplicative.Int in
  let input = [1; 2; 3; 4; 5] in
  let lhs = F.fold_map (module Add) Ambient.id input in
  let rhs = F.fold_map (module Mul) Ambient.id input in
    Add.op lhs rhs

(* Applicative for list *)
let ex5 () : int list =
  let module A = Applicative.List in
  A.apply [(fun x -> x * 2); (fun x -> x * 4); (fun x -> x * 8)] [1; 2; 3]

(* Traversable for list *)
let ex6 () : int list list =
  let open Semigroupoid.Fun in
  let module A = Applicative.List in
  let module T = Traversable.List in
  (* not very interesting but it works … *)
  let res = T.traverse (module A) (A.T.code %> A.pure) [0; 1; 2; 3; 4] in
  A.T.elem res (* = [[0; 1; 2; 3; 4]] *)
```

### Building

Building the code requires the following:

* `ocaml`

If you have `opam` you may optionally to switch to a new ocaml environment:

1. `opam switch install prelude -A 4.02.2` # (optional) switch to a new ocaml env
2. `opam pin add prelude . -n`

The `prelude` library can be built with `ocamlbuild` using the build script:

1. `./script/build`

### Experimenting

With [`utop`](https://github.com/diml/utop) installed (`opam install utop`) you
can compile and load the library in the toplevel:

1. `./script/top`

Once `utop` is loaded, definitions are available under the `Prelude` module.