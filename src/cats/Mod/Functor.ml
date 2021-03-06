open Sig
open TyCon

module Cofree (F : FUNCTOR) = struct
  module Def = Def.Functor.Cofree(F)
  module Ext = Ext.Functor.Make(Def)
  include Def
  include Ext
end

module Identity = struct
  module Def = Def.Functor.Identity
  module Ext = Ext.Functor.Make(Def)
  include Def
  include Ext
end

module Option = struct
  module Def = Def.Functor.Option
  module Ext = Ext.Functor.Make(Def)
  include Def
  include Ext
end

module List = struct
  module Def = Def.Functor.List
  module Ext = Ext.Functor.Make(Def)
  include Def
  include Ext
end
