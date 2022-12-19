open Cursor_card32.Parser
open Angstrom

type 'a t = {
  width : Cursor_card32.t;
  height : Cursor_card32.t;
  x_hot : Cursor_card32.t;
  y_hot : Cursor_card32.t;
  delay : Cursor_card32.t option;
  pixels : 'a;
}

type header = int t

module Header = struct
  type t = header

  let len = 36
  let point_parser = lift2 (fun x y -> (x, y)) any_card32 any_card32
  let delay_parser = any_card32 >>| fun i -> if i == 0 then Some i else None
  let max_size = 0xff

  let parser =
    let header =
      any_card32 <* Cursor_header.Index.Type.image_type_parser <* any_card32
      <* card32 1
    and aux (header, (width, height), (x_hot, y_hot), delay) =
      let failed_str =
        Array.find_map
          (fun (fail, str) -> if fail then Some str else None)
          [|
            (height > max_size, "height");
            (width > max_size, "width");
            (x_hot > width, "x_hot");
            (y_hot > height, "y_hot");
          |]
      in
      match failed_str with
      | Some field -> fail (Printf.sprintf "image field '%s' is invalid" field)
      | None -> return { width; height; x_hot; y_hot; delay; pixels = header }
    in
    lift4
      (fun header dims hot delay -> (header, dims, hot, delay))
      header point_parser point_parser delay_parser
    >>= aux
end
