{ config, pkgs, lib, ... }:
let
  cfg = config.programs.lan-mouse;

  tomlFormat = pkgs.formats.toml { };
in {
  options.programs.lan-mouse = with lib; {
    enable = mkEnableOption "lan-mouse";

    package = mkPackageOption pkgs "lan-mouse" { };

    systemd = mkOption {
      type = types.bool;
      default = false;
      description = "Enable systemd service";
    };

    settings = mkOption {
      type = tomlFormat.type;
      default = { };
    };
  };

  config = with lib; mkIf cfg.enable {
    home.packages = [ cfg.package ];

    systemd.user.services.lan-mouse = mkIf cfg.systemd {
      Unit = {
        Description = "lan-mouse daemon";
        Requires = [ "graphical-session.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${cfg.package}/bin/lan-mouse --daemon";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };

    xdg.configFile."lan-mouse/config.toml" = mkIf (cfg.settings != { }) {
      source = tomlFormat.generate "config.toml" cfg.settings;
    };
  };
}
