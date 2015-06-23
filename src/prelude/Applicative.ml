open Sig

module Option = struct
  module Def = struct
    include Apply.Option.Def
    let pure x = Some x
  end
  include Def
end

module List = struct
  module Def = struct
    include Apply.List.Def
    let pure x = [x]
  end
  include Def
end
