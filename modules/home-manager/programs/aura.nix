{ config, pkgs, lib, ... }:
let
  cfg = config.programs.aura;

  tomlFormat = pkgs.formats.toml { };
in {
  options.programs.aura = with lib; {
    enable = mkEnableOption "aura";

    package = mkPackageOption pkgs "aura" { };

    settings = mkOption {
      type = tomlFormat.type;
      default = { };
    };
  };

  config = with lib; mkIf cfg.enable {
    home.packages = [ cfg.package ];

    xdg.configFile."aura/config.toml" = mkIf (cfg.settings != { }) {
      source = tomlFormat.generate "aura/config.toml" cfg.settings;
    };
  };
}
