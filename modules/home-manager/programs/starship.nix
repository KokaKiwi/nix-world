{ config, lib, ... }:
with lib;
let
  cfg = config.programs.starship;

  mkPreset = name:
    importTOML "${cfg.package.src}/docs/public/presets/toml/${name}.toml";
in {
  options.programs.starship = {
    transience = {
      enable = mkEnableOption "The TransientPrompt feature of Starship";

      module = mkOption {
        type = with types; nullOr str;
        default = "character";
      };

      command = mkOption {
        type = with types; either str lines;
        default = "${getExe cfg.package} module ${cfg.transience.module}";
      };

      rprompt = {
        enable = mkEnableOption "Right prompt for TransientPrompt";

        module = mkOption {
          type = with types; nullOr str;
          default = "time";
        };

        command = mkOption {
          type = with types; either str lines;
          default = "${getExe cfg.package} module ${cfg.transience.rprompt.module}";
        };
      };
    };

    presets = mkOption {
      type = with types; listOf str;
      default = [ ];
    };
  };

  config = mkMerge [
    (mkIf cfg.transience.enable {
      programs.starship.enableTransience = true;

      programs.fish.interactiveShellInit = ''
        function starship_transient_prompt_func
          ${cfg.transience.command}
        end
      '' + optionalString cfg.transience.rprompt.enable ''
        function starship_transient_rprompt_func
          ${cfg.transience.rprompt.command}
        end
      '';
    })
    {
      programs.starship.settings = mkMerge (map mkPreset cfg.presets);
    }
  ];
}
