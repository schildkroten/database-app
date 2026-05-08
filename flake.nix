{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default-linux";
  };

  outputs =
    {
      self,
      nixpkgs,
      systems,
      ...
    }:
    let
      inherit (nixpkgs.lib) attrValues;

      perSystem =
        attrs: nixpkgs.lib.genAttrs (import systems) (system: attrs (import nixpkgs { inherit system; }));
    in
    {
      packages = perSystem (pkgs: {
        nordic-shell = pkgs.stdenv.mkDerivation {
          name = "database-app";
          src = ./.;

          nativeBuildInputs = attrValues {
            inherit (pkgs)
              meson
              ninja
              pkg-config
              gobject-introspection
              wrapGAppsHook4
              blueprint-compiler
              dart-sass
              vala
              ;
          };

          buildInputs = attrValues {
            inherit (pkgs)
              gtk4
              gtk4-layer-shell
              libadwaita
							sqlite
              ;
          };

          meta.mainProgram = "database-app";
        };

        default = self.packages.${pkgs.stdenv.hostPlatform.system}.nordic-shell;
      });

      devShells = perSystem (pkgs: {
        default = pkgs.mkShell {
          nativeBuildInputs =
            with self.packages.${pkgs.stdenv.hostPlatform.system};
            nordic-shell.nativeBuildInputs;
          buildInputs = with self.packages.${pkgs.stdenv.hostPlatform.system}; nordic-shell.buildInputs;
        };
      });
    };
}
