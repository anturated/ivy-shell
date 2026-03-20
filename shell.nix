{ pkgs ? import <nixpkgs> {} }:

let
  qtEnv = with pkgs.qt6; env "qt-custom-${qtbase.version}" 
    [
      qtdeclarative
      qtmultimedia
    ];

in
  pkgs.mkShellNoCC {
    buildInputs = [
      qtEnv
      # pkgs.libsForQt5.qt5.qtmultimedia
      # pkgs.kdePackages.qtmultimedia
      # pkgs.kdePackages.qt5compat
      pkgs.fish
    ];
  }

