open Sig
open TyCon

module Make (F : FUNCTOR) = struct
  type 'a t =
    | Leaf of 'a
    | Fork of 'a t F.T.el
  module T = TC1(struct type nonrec 'a t = 'a t end)
end
