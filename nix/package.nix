{
  lib,
  quickshell,
  maple-mono,
  stdenvNoCC,
  makeWrapper,
}:

stdenvNoCC.mkDerivation {
  name = "eiddew";

  nativeBuildInputs = [ makeWrapper ];

  runtimeInputs = [
    quickshell
    maple-mono.truetype
  ];

  src = ../src;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib"
    cp -r . "$out/lib/src"

    makeWrapper ${lib.getExe quickshell} "$out/bin/eiddew" \
      --add-flags "-p $out/lib/src"

    runHook postInstall
  '';
}
