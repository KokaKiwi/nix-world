{ config, pkgs, lib, ... }:
with lib;
let
  inherit (config.lib) ctp;

  cfg = config.programs.glow;

  settinsFormat = pkgs.formats.yaml {};

  styleSettings = types.submodule {
    options = {
      src = mkOption {
        type = types.path;
        description = "Path to the styles folder";
      };
      path = mkOption {
        type = types.str;
        description = "Subpath of the theme file within the source";
      };
    };
  };

  settings = let
    style = if builtins.isString cfg.style
      then cfg.style
      else "${cfg.style.src}/${cfg.style.path}";
  in {
    inherit style;
    inherit (cfg) local mouse pager width;
  };
in {
  options.programs.glow = {
    enable = mkEnableOption "glow";

    package = mkPackageOption pkgs "glow" { };

    catppuccin = ctp.mkCatppuccinOption {
      name = "glow";
    };

    style = mkOption {
      type = with types; either str styleSettings;
      default = "auto";
      description = "style name or JSON path";
    };

    local = mkOption {
      type = types.bool;
      default = false;
      description = "show local files only; no network (TUI-mode only)";
    };

    mouse = mkOption {
      type = types.bool;
      default = true;
      description = "mouse support (TUI-mode only)";
    };

    pager = mkOption {
      type = types.bool;
      default = true;
      description = "use pager to display markdown";
    };

    width = mkOption {
      type = types.ints.positive;
      default = 120;
      description = "word-wrap at width";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    xdg.configFile."glow/glow.yml".source =
      settinsFormat.generate "glow.yml" settings;

    programs.glow = mkIf cfg.catppuccin.enable {
      style = {
        src = config.catppuccin.sources.glamour;
        path = "catppuccin-${cfg.catppuccin.flavor}.json";
      };
    };
  };
}
