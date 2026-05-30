let
  lockfile = builtins.fromJSON (builtins.readFile ./flake.lock);
  node = lockfile.nodes.nixpkgs.locked;
  nixpkgs' = fetchTarball {
    url = "https://github.com/${node.owner}/${node.repo}/archive/${node.rev}.tar.gz";
    sha256 = node.narHash;
  };
in
{
  nixpkgs ? nixpkgs',
  pkgs ? import nixpkgs {
    inherit system;
  },
  lib ? pkgs.lib,
  system ? builtins.currentSystem,
}:

lib.makeScope pkgs.newScope (self: {
  eiddew = self.callPackage ./nix/package.nix { };
})
