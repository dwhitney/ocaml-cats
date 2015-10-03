open Sig
open TyCon

module Tuple = struct
  open Amb.Product
  module T = TC.Tuple

  let bifoldr f g i p =
    f (fst p) (g (snd p) i)

  let bifoldl f g i p =
    g (f i (fst p)) (snd p)

  let bifold_map (type m) (m : m monoid) f g p =
    let module M = (val m) in
    M.op (f (fst p)) (g (snd p))
end

module Variant = struct
  open Amb.Coproduct
  module T = TC.Variant

  let bifoldr f g i v = 
    from (Amb.flip f i) (Amb.flip g i) v

  let bifoldl f g i v =
    from (f i) (g i) v

  let bifold_map _ = from
end
