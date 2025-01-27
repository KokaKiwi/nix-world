{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.services.module-server;
in {
  options.services.module-server = {
    enable = mkEnableOption "module-server";

    package = mkPackageOption pkgs "module-server" {};
  };

  config = mkIf cfg.enable {
    systemd.user.services."module-server" = {
      Unit = {
        Description = "A simple, modulable HTTP server to serve local doc for different 'modules'.";
        After = [ "systemd-tmpfiles-setup.service" ];
      };
      Service = {
        Restart = "on-failure";
        ExecStart = "${getExe cfg.package}";
        Environment = [ "NO_SCSS=1" ];
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };
}
