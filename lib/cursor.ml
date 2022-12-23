module Card32 = Cursor_card32
module Header = Cursor_header
module Image = Cursor_image

type t = { header : Header.t; data : Bigstringaf.t }

open Angstrom

let of_bigstring data =
  parse_bigstring ~consume:Consume.Prefix Header.parser data
  |> Result.map (fun header -> { header; data })

let of_descr ?pos ?size descr =
  Unix.(
    let size =
      match size with Some size -> size | None -> (fstat descr).st_size
    in
    let ga =
      Unix.map_file
        ?pos:(Option.map Int64.of_int pos)
        descr Bigarray.Char Bigarray.c_layout false [| size |]
    in
    Bigarray.array1_of_genarray ga |> of_bigstring)

open Header.Index

let toc_len t = t.header.toc_len

let image_indices ?size { header; data } =
  List.to_seq header.toc
  |> Seq.filter_map (fun { type_; position } ->
         match type_ with
         | Image notional_size ->
             let cond =
               size
               |> Option.map (Int.equal notional_size)
               |> Option.value ~default:true
             in
             if cond then
               let ba = Bigarray.Array1.sub data position Image.Header.len in
               let ret =
                 parse_bigstring ~consume:Consume.Prefix Image.Header.parser ba
                 |> Result.map
                      Image.(fun t -> { t with pixels = position + t.pixels })
               in
               Some
                 (Result.map_error
                    (fun err ->
                      Printf.sprintf "invalid image header at '%i', '%s'"
                        position err)
                    ret)
             else None
         | _ -> None)

let images ?size t =
  let data = t.data in
  let aux t =
    Image.(
      (* A pixel is of the format 'ARGB_8888' *)
      let ofs = t.pixels and len = t.width * t.height * 4 in
      let pixels = Bigarray.Array1.sub data ofs len in
      { t with pixels })
  in
  image_indices ?size t |> Seq.map (fun res -> res |> Result.map aux)
