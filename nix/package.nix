{ writeShellApplication, quickshell }:

writeShellApplication {
  name = "eiddew";

  runtimeInputs = [
    quickshell
  ];

  text = ''
    #!/usr/bin/env bash
    set -euo pipefail
    SRC=${../src}
  ''
  + builtins.readFile ./script.sh;
}
