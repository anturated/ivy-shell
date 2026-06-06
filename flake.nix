{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      inherit (nixpkgs) lib;

      forAllSystems =
        f: lib.genAttrs lib.systems.flakeExposed (system: f (import nixpkgs { inherit system; }));
    in
    {
      packages = forAllSystems (pkgs: {
        default = self.packages.${pkgs.stdenv.hostPlatform.system}.eiddew;
        eiddew = pkgs.callPackage ./nix/package.nix { };
      });

      homeModules.default = import ./nix/module.nix;

      devShells = forAllSystems (
        pkgs:
        let
          qtEnv =
            with pkgs.qt6;
            env "qt-eiddew-${qtbase.version}" [
              qtdeclarative
              qtmultimedia
            ];
        in
        {
          default = pkgs.mkShellNoCC {
            packages = [
              qtEnv
              pkgs.quickshell
            ];
          };
        }
      );
    };
}
