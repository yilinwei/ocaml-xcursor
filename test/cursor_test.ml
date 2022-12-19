open Xcursor

let test_cursor file =
  let contents = In_channel.open_bin file |> In_channel.input_all in
  let ba = Bigstringaf.of_string ~off:0 ~len:(String.length contents) contents in
  let ret = Cursor.from_bigstring ba in
  assert (Result.is_ok ret);
  let cursor = Result.get_ok ret in
  assert (Cursor.toc_len cursor > 0);
  Cursor.image_indices cursor
  |> Seq.iter (fun each -> assert (Result.is_ok each));
  Cursor.images cursor
  |> Seq.iter (fun each -> assert (Result.is_ok each))


let () =
  let args = Sys.argv in
  assert (Array.length args > 1);
  Array.to_list args |> List.tl |> List.iter test_cursor
