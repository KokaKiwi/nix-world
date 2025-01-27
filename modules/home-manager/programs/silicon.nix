{ config, pkgs, lib, ... }:
with lib;
let
  inherit (config.lib) ctp;

  cfg = config.programs.silicon;

  fileOption = types.submodule {
    options = {
      src = mkOption {
        type = types.path;
      };

      file = mkOption {
        type = with types; nullOr str;
        default = null;
      };
    };
  };
in {
  options.programs.silicon = {
    enable = mkEnableOption "silicon, create beautiful image of your source code";

    package = mkPackageOption pkgs "silicon" { };

    catppuccin = ctp.mkCatppuccinOption {
      name = "silicon";
    };

    settings = mkOption {
      type = types.lines;
      default = "";
    };

    themes = mkOption {
      type = types.attrsOf fileOption;
      default = { };
    };
    syntaxes = mkOption {
      type = types.attrsOf fileOption;
      default = { };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    xdg.configFile = mkMerge ([
      {
        "silicon/config" = mkIf (cfg.settings != "") {
          text = cfg.settings;
        };
      }
    ] ++ (flip mapAttrsToList cfg.themes (name: theme: {
      "silicon/themes/${name}.tmTheme" = {
        source = if theme.file == null then theme.src else "${theme.src}/${theme.file}";
      };
    })) ++ (flip mapAttrsToList cfg.syntaxes (name: syntax: {
      "silicon/syntaxes/${name}.sublime-syntax" = {
        source = if syntax.file == null then syntax.src else "${syntax.src}/${syntax.file}";
      };
    })));

    programs.silicon = let
      themeName = "Catppuccin-${ctp.mkUpper cfg.catppuccin.flavor}";
    in mkIf cfg.catppuccin.enable {
      settings = ''
        --theme "${themeName}"
      '';

      themes.${themeName} = {
        src = config.catppuccin.sources.bat;
        file = "Catppuccin ${ctp.mkUpper cfg.catppuccin.flavor}.tmTheme";
      };
    };

    home.activation.siliconCache = hm.dag.entryAfter [ "linkGeneration" ] ''
      (
        export XDG_CACHE_HOME=${escapeShellArg config.xdg.cacheHome}
        verboseEcho "Rebuilding silicon theme cache..."

        mkdir -p ${config.xdg.configHome}/silicon/{themes,syntaxes}
        cd ${config.xdg.configHome}/silicon
        run ${getExe cfg.package} --build-cache
      )
    '';
  };
}
