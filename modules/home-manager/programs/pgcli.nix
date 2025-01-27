{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.programs.pgcli;

  settingsFormat = pkgs.formats.ini {};

  settingsType = types.submodule {
    freeformType = settingsFormat.type;

    options = {};
  };
in {
  options.programs.pgcli = {
    enable = mkEnableOption "pgcli";

    package = mkPackageOption pkgs "pgcli" {};

    settings = mkOption {
      type = with types; either path settingsType;
      default = { };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    xdg.configFile."pgcli/config".source = if builtins.isAttrs cfg.settings
      then settingsFormat.generate "pgcli.ini" cfg.settings
      else cfg.settings;
  };
}
