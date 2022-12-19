{
  description = "A very basic flake";

  inputs = {
    nix-filter.url = "github:numtide/nix-filter";
  };

  outputs = { self, nixpkgs, nix-filter }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    src = nix-filter.lib {
      root = ./.;
      include = [
        "dune-project"
        (nix-filter.lib.inDirectory "bin")
        (nix-filter.lib.inDirectory "lib")
        (nix-filter.lib.inDirectory "test")
      ];
    };
    ocamlPackages = pkgs.ocamlPackages;
    propagatedBuildInputs = with ocamlPackages; [
      angstrom
      bigstringaf
    ];
    xcursor = ocamlPackages.
      buildDunePackage {
        inherit src propagatedBuildInputs;
        pname = "xcursor";
        version = "0.1.0.git";
        duneVersion = "3";
        strictDeps = true;
        doCheck = true;
        preBuild = ''
          dune build xcursor.opam
        '';
      };
  in {
    packages.${system} = {
      inherit xcursor;
      default = self.packages.${system}.xcursor;
    };
    devShells.${system}.default = with pkgs;
      mkShell {
        buildInputs = [
          pkg-config
          ocamlformat
          dune-release
        ] ++ (with ocamlPackages;
          [
            dune_3
            ocaml
            utop
            findlib
            ocaml-lsp
            odoc
            wayland
            logs
          ]) ++ propagatedBuildInputs;
    };
  };
}
