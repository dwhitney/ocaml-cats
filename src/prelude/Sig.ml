open Ty.Sig

(* The Sig module collects structure signatures. *)

module type UNIVERSAL = sig
  module T : Unary.Invariant.CO
  type poly = { ap : 'x. 'x T.el }
  type t
  val into : poly -> t
  val from : t -> poly
end

module type EXISTENTIAL = sig
  module T : Unary.Invariant.CO
  type 'r elim = { ap : 'x. 'x T.el -> 'r }
  type t
  val into : 'a T.el -> t
  val from : t -> ('r elim -> 'r)
end

module type SEMIGROUP = sig
  module T : Nullary.CO
  val op : T.el -> T.el -> T.el
end

module type MONOID = sig
  include SEMIGROUP
  val unit : T.el
end

module type SEMIRING = sig
  module T : Nullary.CO
  val zero : T.el
  val add : T.el -> T.el -> T.el
  val one : T.el
  val mul : T.el -> T.el -> T.el
end

module type MODULOSEMIRING = sig
  include SEMIRING
  val div : T.el -> T.el -> T.el
  val modulo : T.el -> T.el -> T.el
end

module type RING = sig
  include SEMIRING
  val sub : T.el -> T.el -> T.el
end

module type DIVISIONRING = sig
  include RING
  include MODULOSEMIRING with module T := T
end

module type POSITIVE = sig
  exception InvalidDiv
  type code = B | O | I
  type t
  val head : t -> code
  val one : t
  val mul2 : t -> t
  val mul2s : t -> t
  val div2 : t -> t
  val div2p : t -> t
end

module type FUNCTOR = sig
  module T : Unary.Covariant.CO
  val map : ('a -> 'b) -> ('a T.el -> 'b T.el)
end

module type BIFUNCTOR = sig
  module T : Binary.Covariant.CO
  val bimap : ('a -> 'b) -> ('c -> 'd) -> (('a, 'c) T.el -> ('b, 'd) T.el)
end

module type PRESHEAF = sig
  module T : Unary.Contravariant.CO
  val premap : ('a -> 'b) -> ('b T.el -> 'a T.el)
end

module type PROFUNCTOR = sig
  module T : Binary.ContraCovariant.CO
  val dimap : ('a -> 'b) -> ('c -> 'd) -> (('b, 'c) T.el -> ('a, 'd) T.el)
end

module type SEMIGROUPOID = sig
  include PROFUNCTOR
  val compose : ('b, 'c) T.el -> ('a, 'b) T.el -> ('a, 'c) T.el
end

module type CATEGORY = sig
  include PROFUNCTOR
  val id : ('a, 'a) T.el
end

module type END = sig
  module Hom : PROFUNCTOR
  type poly = { ap : 'x. ('x, 'x) Hom.T.el }
  type t
  val into : poly -> t
  val from : t -> poly
end

module type COEND = sig
  module Hom : PROFUNCTOR
  type 'r elim = { ap : 'x. ('x, 'x) Hom.T.el -> 'r }
  type t
  val into : ('a, 'a) Hom.T.el -> t
  val from : t -> ('r elim -> 'r)
end

module type TRANSFORM = sig
  module F : FUNCTOR
  module G : FUNCTOR
  type t = { ap : 'x. 'x F.T.el -> 'x G.T.el }
end

module type RAN = sig
  module G : FUNCTOR
  module H : FUNCTOR
  type 'a t
  type 'f nat = { ap : 'x. ('x G.T.el, 'f) Ty.ap -> 'x H.T.el }
  val into : (module FUNCTOR with type T.co = 'f)
    -> 'f nat -> (('a, 'f) Ty.ap -> 'a t)
end

module type LAN = sig
  module G : FUNCTOR
  module H : FUNCTOR
  type 'a t
  type 'f nat = { ap : 'x. 'x H.T.el -> ('x G.T.el, 'f) Ty.ap }
  val into : (module FUNCTOR with type T.co = 'f)
    -> 'f nat -> ('a t -> ('a, 'f) Ty.ap)
end

module type PRODUCT = sig
  include BIFUNCTOR
  val fst : ('a, 'b) T.el -> 'a
  val snd : ('a, 'b) T.el -> 'b
  val pair : ('x -> 'a) -> ('x -> 'b) -> ('x -> ('a, 'b) T.el)
end

module type COPRODUCT = sig
  include BIFUNCTOR
  val inl : 'a -> ('a, 'b) T.el
  val inr : 'b -> ('a, 'b) T.el
  val case : ('a -> 'x) -> ('b -> 'x) -> (('a, 'b) T.el -> 'x)
end

module type APPLY = sig
  include FUNCTOR
  val apply : ('a -> 'b) T.el -> ('a T.el -> 'b T.el)
end

module type APPLICATIVE = sig
  include APPLY
  val pure : 'a -> 'a T.el
end

module type BIND = sig
  include APPLY
  val bind : 'a T.el -> ('a -> 'b T.el) -> 'b T.el
end

module type MONAD = sig
  include APPLICATIVE
  include BIND with module T := T
end

module type EXTEND = sig
  include FUNCTOR
  val extend : ('a T.el -> 'b) -> ('a T.el -> 'b T.el)
end

module type COMONAD = sig
  include EXTEND
  val extract : 'a T.el -> 'a
end

module type FOLDABLE = sig
  module T : Unary.Invariant.CO
  val foldr : ('a -> 'b -> 'b) -> ('b -> 'a T.el -> 'b)
  val foldl : ('b -> 'a -> 'b) -> ('b -> 'a T.el -> 'b)
  val fold_map : (module MONOID with type T.el = 'm)
    -> ('a -> 'm) -> ('a T.el -> 'm)
end

module type TRAVERSABLE = sig
  include FUNCTOR
  include FOLDABLE with module T := T
  val traverse : (module APPLICATIVE with type T.co = 'm)
    -> ('a -> ('b, 'm) Ty.ap) -> ('a T.el -> ('b T.el, 'm) Ty.ap)
  val sequence : (module APPLICATIVE with type T.co = 'm)
    -> ('a, 'm) Ty.ap T.el -> ('a T.el, 'm) Ty.ap
end
