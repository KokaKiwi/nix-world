{ config, lib, sources, ... }:
let
  inherit (config.lib) ctp;

  cfg = config.programs.eza;
in {
  options.programs.eza = with lib; {
    theme = mkOption {
      type = with types; nullOr path;
      default = null;
    };

    catppuccin = ctp.mkCatppuccinOption {
      name = "eza";
    };
  };

  config = with lib; {
    xdg.configFile."eza/theme.yml" = mkIf (cfg.theme != null) {
      source = cfg.theme;
    };

    programs.eza.theme = mkIf cfg.catppuccin.enable "${sources.eza-themes}/themes/catppuccin.yml";
  };
}
