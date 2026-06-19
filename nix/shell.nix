{
  qt6,
  mkShellNoCC,
  quickshell,
}:

let
  qtEnv =
    with qt6;
    env "qt-eiddew-${qtbase.version}" [
      qtdeclarative
      qtmultimedia
    ];
in
mkShellNoCC {
  packages = [
    qtEnv
    quickshell
  ];
}
