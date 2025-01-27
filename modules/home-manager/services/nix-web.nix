{ config, pkgs, lib, ... }:
let
  cfg = config.services.nix-web;
in {
  options.services.nix-web = with lib; {
    enable = mkEnableOption "nix-web";

    package = mkPackageOption pkgs "nix-web" { };

    listenAddr = mkOption {
      type = types.str;
      default = "127.0.0.1:8649";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services."nix-web" = {
      Unit = {
        Description = "Nix Web UI";
      };
      Service = {
        Restart = "on-failure";
        ExecStart = "${cfg.package}/bin/nix-web -v --http-listen ${cfg.listenAddr}";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };
}
