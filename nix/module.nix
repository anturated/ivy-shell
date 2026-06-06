{
  lib,
  pkgs,
  config,
  ...
}:

let
  package = pkgs.callPackage ./package.nix { };
  cfg = config.programs.eiddew;
in
{
  options = {
    programs.eiddew = {
      enable = lib.mkEnableOption "eiddew";

      autoStart = lib.mkEnableOption "Automatically start eiddew on login" // {
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ package ];

    systemd.user.services.eiddew = lib.mkIf cfg.autoStart {
      Unit = {
        Description = "Eiddew shell";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };

      Service = {
        Type = "simple";
        ExecStart = "${package}/bin/eiddew -a";
        Restart = "on-failure";
      };
    };
  };
}
