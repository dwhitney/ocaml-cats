open Sig
open TyCon

module Make : functor (M : MODULOSEMIRING) -> sig open M
  val (/@) : T.el -> T.el -> T.el
  val (%@) : T.el -> T.el -> T.el
end
