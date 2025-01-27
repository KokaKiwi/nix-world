{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.programs.glab;

  settingsFormat = pkgs.formats.yaml {};
in {
  options.programs.glab = {
    enable = mkEnableOption "glab";

    package = mkPackageOption pkgs "glab" { };

    aliases = mkOption {
      type = with types; attrsOf str;
      default = { };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    xdg.configFile = {
      "glab-cli/aliases.yml" = mkIf (cfg.aliases != { }) {
        source = settingsFormat.generate "glab-aliases.yml" cfg.aliases;
      };
    };
  };
}
