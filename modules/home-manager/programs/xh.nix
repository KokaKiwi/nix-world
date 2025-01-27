{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.programs.xh;

  settingsFormat = pkgs.formats.json { };

  settingsType = types.submodule {
    options = {
      defaultOptions = mkOption {
        type = with types; nullOr (listOf str);
        default = null;
      };
    };
  };

  normalizedSettings = optionalAttrs (cfg.settings.defaultOptions != null) {
    default_options = cfg.settings.defaultOptions;
  };
in {
  options.programs.xh = {
    enable = mkEnableOption "xh";

    package = mkPackageOption pkgs "xh" { };

    settings = mkOption {
      type = settingsType;
      default = { };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    xdg.configFile."xh/config.json" = mkIf (normalizedSettings != { }) {
      source = settingsFormat.generate "xh-config.json" normalizedSettings;
    };
  };
}
