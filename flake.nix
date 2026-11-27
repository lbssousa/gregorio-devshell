{
  description = "Devshell for building and testing Gregorio (gregorio + gregorio-test)";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      forAll = f: nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" ] (s: f nixpkgs.legacyPackages.${s});
    in {
      devShells = forAll (pkgs:
        let
          # Full scheme: GregorioRef (built by build.sh) and gregorio-test
          # pull in a long tail of packages and fonts.
          tex = pkgs.texliveFull;
        in {
          default = pkgs.mkShell {
            packages = with pkgs; [
              # build
              autoconf automake libtool pkg-config gnumake gcc bison flex
              (fontforge.override { withPython = true; }) (python3.withPackages (p: [ p.pygments ])) lua5_3
              # tex
              tex
              # test harness
              imagemagick ghostscript poppler-utils diffutils gnused gawk
              findutils coreutils valgrind git
            ];
            shellHook = ''
              # Local TEXMFHOME so the freshly built GregorioTeX shadows the
              # one shipped in TeX Live. Install with: ./install-gtex.sh user
              export TEXMFHOME="''${GREGORIO_TEXMFHOME:-$HOME/.cache/gregorio-devshell/texmf}"
              export TEXMFVAR="$HOME/.cache/gregorio-devshell/texmf-var"
              mkdir -p "$TEXMFHOME" "$TEXMFVAR"
              echo "gregorio devshell: TEXMFHOME=$TEXMFHOME"
            '';
          };
        });
    };
}
