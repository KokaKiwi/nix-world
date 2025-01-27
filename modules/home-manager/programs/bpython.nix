{ config, pkgs, lib, ... }:
let
  cfg = config.programs.bpython;

  iniFormat = pkgs.formats.ini {
    mkKeyValue = lib.generators.mkKeyValueDefault { } " = ";
  };
in {
  options.programs.bpython = with lib; {
    enable = mkEnableOption "bpython";

    package = mkPackageOption pkgs.python3Packages "bpython" { };

    config = mkOption {
      type = iniFormat.type;
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    xdg.configFile."bpython/config" = lib.mkIf (cfg.config != { }) {
      source = iniFormat.generate "config" cfg.config;
    };
  };
}
