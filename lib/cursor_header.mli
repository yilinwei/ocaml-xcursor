module Index : sig
  module Type : sig
    type comment_subtype = Copyright | License | Other
    type t = Comment of comment_subtype | Image of int

    val comment_subtype_parser : comment_subtype Angstrom.t
    val image_type_parser : unit Angstrom.t
    val image_parser : t Angstrom.t
    val comment_parser : t Angstrom.t
    val parser : t Angstrom.t
  end

  type t = { type_ : Type.t; position : int }

  val parser : t option Angstrom.t
  (** Parser for an index entry.
      
      Returns none if unknown. *)
end

type t = { version : int; toc : Index.t list; toc_len : int }
(** Contents of the cursor file.

    Cursor files have a backwards-compatible versioning scheme; unknown
    fields and entry types are skipped. This library currently implements
    version 1 of the format. *)

val parser : t Angstrom.t
(** Parser for cursor header. *)

val len : int
(** Expected length in bytes of header. *)
