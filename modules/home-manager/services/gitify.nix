{ config, pkgs, lib, ... }:
let
  cfg = config.services.gitify;
in {
  options.services.gitify = with lib; {
    enable = mkEnableOption "gitify";
    package = mkPackageOption pkgs "gitify" { };
  };

  config = with lib; mkIf cfg.enable {
    systemd.user.services.gitify = {
      Unit = {
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart = "${cfg.package}/bin/gitify";
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
