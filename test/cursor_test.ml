open Xcursor

let test_cursor file =
  let fd = Unix.(openfile file [ O_RDONLY ] 0) in
  let ret = Cursor.from_fd fd in
  assert (Result.is_ok ret);
  let cursor = Result.get_ok ret in
  assert (Cursor.toc_len cursor > 0);
  Cursor.image_indices cursor
  |> Seq.iter (fun each -> assert (Result.is_ok each));
  Cursor.images cursor |> Seq.iter (fun each -> assert (Result.is_ok each));
  Unix.close fd

let () =
  let args = Sys.argv in
  assert (Array.length args > 1);
  Array.to_list args |> List.tl |> List.iter test_cursor
