type 'a t = {
  width : int;
  height : int;
  x_hot : int;
  y_hot : int;
  delay : int option;
  pixels : 'a;
}

type header = int t

module Header : sig
  type t = header

  val len : int
  (** Expected length of image header. *)

  val parser : t Angstrom.t
  (** Parser for image header.
      
        {!Cursor.Image.t.pixels} is the offset from the start of the header. *)
end
