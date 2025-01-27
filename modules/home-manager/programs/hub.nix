{ config, pkgs, lib, ...}:
with lib;
let
  cfg = config.programs.hub;

  yamlFormat = pkgs.formats.yaml {};

  settingsType = types.submodule {
    freeformType = yamlFormat.type;

    options = {};
  };
in {
  options = {
    programs.hub = {
      enable = mkEnableOption "Enable hub";

      package = mkPackageOption pkgs "hub" {};

      settings = mkOption {
        type = types.nullOr settingsType;
        default = null;
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    xdg.configFile."hub" = mkIf (cfg.settings != null) {
      source = yamlformat.generate "hub-config.yml" cfg.settings;
    };
  };
}
