(lang dune 3.6)

(name xcursor)

(generate_opam_files true)

(source (github yilinwei/ocaml-xcursor))
(authors "Yilin Wei")
(maintainers "Yilin Wei")
(documentation "https://yilinwei.github.io/ocaml-xcursor")
(license MIT)

(package
 (name xcursor)
 (synopsis "A pure implementation of Xcursor in Ocaml")
 (description "Xcursor is a de-facto standard for using cursors on Linux systems from Freedesktop. It defines a set
 of standard paths to search, a file format and a configuration format for users to customise cursors for desktop
 applications.")
 (version 0.1.0)
 (depends
   (ocaml (>= 4.13.0))
   (bigstringaf (>= 0.9.0))
   (angstrom (>= 0.15.0)))
 (tags
  (desktop gui cursor xcursor)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-projects
