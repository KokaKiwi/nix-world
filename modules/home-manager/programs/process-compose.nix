{ config, pkgs, lib, sources, ... }:
let
  inherit (config.lib) ctp;

  cfg = config.programs.process-compose;
  ctpCfg = config.catppuccin.process-compose;

  settingsFormat = pkgs.formats.yaml { };
in {
  options.catppuccin.process-compose = ctp.mkCatppuccinOption { name = "process-compose"; };

  options.programs.process-compose = with lib; {
    enable = mkEnableOption "process-compose";
    package = mkPackageOption pkgs "process-compose" { };

    settings = mkOption {
      type = settingsFormat.type;
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    catppuccin.sources = {
      process-compose = config.catppuccin.sources.buildCatppuccinPort rec {
        pname = "process-compose";

        src = sources."catppuccin/process-compose" // {
          rev = src.revision;
        };
      };
    };

    xdg.configFile."process-compose/settings.yml" = lib.mkIf (cfg.settings != { }) {
      source = settingsFormat.generate "process-compose-settings.yml" cfg.settings;
    };
    xdg.configFile."process-compose/theme.yml" = lib.mkIf ctpCfg.enable {
      source = "${config.catppuccin.sources.process-compose}/catppuccin-${ctpCfg.flavor}.yaml";
    };
  };
}
