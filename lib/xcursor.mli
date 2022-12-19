module Cursor = Cursor
(** Cursor file modules.

    Contains functions used for cursor files which contain the images
    and metadata for cursors. *)

val paths : unit -> string list
(** List of file paths to search.

 Checks the 'XCURSOR_PATH' environment variable. *)

val size : unit -> int
(** Expected size of cursor.

 Gets the 'XCURSOR_SIZE' or defaults to 16. *)
