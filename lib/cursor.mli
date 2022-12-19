module Card32 = Cursor_card32
module Header = Cursor_header
module Image = Cursor_image

type t = { header : Header.t; data : Bigstringaf.t }
(** Cursor file with parsed header. *)

val from_bigstring : Bigstringaf.t -> (t, string) result
(** Get a cursor from parsing a bigstring. *)

val from_fd : Unix.file_descr -> (t, string) result
(** Get a cursor from parsing a memory-mapped a Unix file descriptor.

 The file descriptor must have at least read permissions. *)

val toc_len : t -> int
(** The number of entries in the table of contents. *)

val image_indices : ?size:int -> t -> (int Image.t, string) result Seq.t
(** Return a lazy sequence of image indices in the table of contents.

    If size is specified, filter by the notional size (i.e. the subtype) of the index.

    {!Cursor.Image.t.pixels} is the offset from the start of {!t.data}. *)

val images : ?size:int -> t -> (Bigstringaf.t Image.t, string) result Seq.t
(** Return a lazy sequence of images in the cursor.

 See {!image_indices} for more information.*)
