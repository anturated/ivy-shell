{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    inputs@{ self, nixpkgs }:
    let
      inherit (nixpkgs) lib;

      forAllSystems =
        f: lib.genAttrs lib.systems.flakeExposed (system: f (import nixpkgs { inherit system; }));

      # do this bs so we have nix run .
      mkPackages =
        default: pkgs:
        let
          generatedPackages = import ./default.nix { inherit pkgs; };
          defaultPackage = lib.optionalAttrs default { default = generatedPackages.eiddew; };
        in
        generatedPackages // defaultPackage;
    in
    {
      legacyPackages = forAllSystems (mkPackages true);
      packages = forAllSystems (mkPackages true);

      homeModules.default = import ./nix/module.nix inputs;

      overlays.default = _: mkPackages false;

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
