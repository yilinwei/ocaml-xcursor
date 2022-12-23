(* https://chromium.googlesource.com/external/wayland/wayland/+/refs/heads/master/cursor/xcursor.c *)

open Angstrom
open Cursor_card32.Parser

let magic = string "Xcur"

module Index = struct
  module Type = struct
    type comment_subtype = Copyright | License | Other

    let comment_subtype_parser =
      any_card32 >>= function
      | 1 -> return Copyright
      | 2 -> return License
      | 3 -> return Other
      | n -> fail (Printf.sprintf "invalid comment subtype '%i'" n)

    type t = Comment of comment_subtype | Image of int

    let image_type_parser = card32 0xfffd0002
    let image_parser = image_type_parser *> any_card32 >>| fun n -> Image n

    let comment_parser =
      card32 0xfffe001 *> comment_subtype_parser >>| fun t -> Comment t

    let parser = image_parser <|> comment_parser
  end

  type t = { type_ : Type.t; position : int }

  let parser =
    lift2
      (fun type_ position -> Some { type_; position })
      Type.parser any_card32
end

type t = { version : int; toc : Index.t list; toc_len : int }

let len = 16

let parser =
  lift3
    (fun header version ntoc -> (version, ntoc, header - len))
    (magic *> any_card32) any_card32 any_card32
  >>= fun (version, toc_len, skip) ->
  advance skip *> count toc_len Index.parser >>| fun toc ->
  { version; toc = List.filter_map Fun.id toc; toc_len }
