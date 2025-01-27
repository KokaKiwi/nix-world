{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.programs.litecli;

  configFormat = pkgs.formats.ini {
    mkKeyValue = lib.generators.mkKeyValueDefault {
      mkValueString = value:
        if builtins.isString value then value
        else if value == true then "True"
        else if value == false then "False"
        else if value == null then "None"
        else toString value;
    } " = ";
  };
in {
  options.programs.litecli = {
    enable = mkEnableOption "litecli";

    package = mkPackageOption pkgs "litecli" { };

    config = mkOption {
      type = configFormat.type;
      default = { };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    xdg.configFile."litecli/config".source =
      configFormat.generate "litecli-config.ini" cfg.config;
  };
}
