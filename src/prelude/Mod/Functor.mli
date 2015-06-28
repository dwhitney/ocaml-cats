open Sig
open Ty

module Identity : sig
  module Def : FUNCTOR with module T = Con.Identity.Poly
  include (module type of Def)
  include (module type of Ext.Functor.Make(Def))
end

module Option : sig
  module Def : FUNCTOR with module T = Con.Option.Poly
  include (module type of Def)
  include (module type of Ext.Functor.Make(Def))
end

module List : sig
  module Def : FUNCTOR with module T = Con.List.Poly
  include (module type of Def)
  include (module type of Ext.Functor.Make(Def))
end
