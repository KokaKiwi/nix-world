{ config, pkgs, lib, ... }:
let
  cfg = config.programs.glances;

  iniFormat = pkgs.formats.ini { };
in {
  options.programs.glances = with lib; {
    enable = mkEnableOption "glances";

    package = mkPackageOption pkgs "glances" { };

    settings = mkOption {
      type = iniFormat.type;
      default = { };
    };
  };

  config = with lib; mkIf cfg.enable {
    home.packages = [ cfg.package ];

    xdg.configFile."glances/glances.conf" = mkIf (cfg.settings != { }) {
      source = iniFormat.generate "glances.conf" cfg.settings;
    };
  };
}
