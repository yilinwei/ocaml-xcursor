module Cursor = Cursor

let default_paths = [ "~/.icons"; "/usr/share/icons"; "/usr/share/pixmaps" ]

let paths () =
  Sys.getenv_opt "XCURSOR_PATH"
  |> Option.map (String.split_on_char ':')
  |> Option.value ~default:default_paths

let size () =
  Sys.getenv_opt "XCURSOR_SIZE"
  |> Option.map int_of_string |> Option.value ~default:16
