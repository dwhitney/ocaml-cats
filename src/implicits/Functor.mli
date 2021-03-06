open Cats
open Cats.Sig
open Cats.TyCon

val map : (implicit M : FUNCTOR)
  -> ('a -> 'b)
  -> ('a M.T.el -> 'b M.T.el)

implicit module Option : module type of Mod.Functor.Option
implicit module List : module type of Mod.Functor.List
