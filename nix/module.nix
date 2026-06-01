inputs:
{
  lib,
  pkgs,
  config,
  ...
}:

let
  cfg = config.programs.eiddew;

  pkgs' = import ../default.nix { inherit pkgs; };
in
{
  options = {
    programs.eiddew = {
      enable = lib.mkEnableOption "eiddew";

      autoStart = lib.mkEnableOption "Automatically start eiddew on login" // {
        default = true;
      };

      package = lib.mkPackageOption pkgs' "eiddew" { };

      packageOverrides = lib.mkOption {
        type = lib.types.lazyAttrsOf lib.types.anything;
        default = { };
        description = "Arguments to add to the package override";
        example = lib.literalExpression ''
          {
            nil = pkgs.nil.override { nix = pkgs.lix; };
          }
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.eiddew = {
      package = pkgs'.eiddew.override (cfg.packageOverrides);
    };

    home.packages = [ cfg.package ];

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
        ExecStart = "${cfg.package}/bin/eiddew -a";
        Restart = "on-failure";
      };
    };
  };
}
