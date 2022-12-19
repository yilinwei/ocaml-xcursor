open Angstrom

type t = int

module Parser = struct
  let any_card32 = LE.any_int32 >>| Int32.to_int
  let card32 i = LE.int32 (Int32.of_int i)
end
