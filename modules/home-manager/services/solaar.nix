{ config, pkgs, lib, ... }:
let
  cfg = config.services.solaar;
in {
  options.services.solaar = with lib; {
    enable = mkEnableOption "solaar";
    package = mkPackageOption pkgs "solaar" { };
  };

  config = with lib; mkIf cfg.enable {
    systemd.user.services.solaar = {
      Unit = {
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Service = {
        Environment = [
          "PATH=${config.home.profileDirectory}/bin"
          "LC_ALL=en_US.UTF-8"
        ];
        ExecStart = "${cfg.package}/bin/solaar --window=hide";
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
