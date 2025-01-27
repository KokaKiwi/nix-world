{ config, pkgs, lib, ... }:
let
  cfg = config.home.shell;
in {
  options.home.shell = with lib; {
    package = mkPackageOption pkgs "bash" { };
    exeName = mkOption {
      type = with types; nullOr str;
      default = null;
    };

    fullPath = mkOption {
      type = types.str;
      readOnly = true;
      default = if cfg.exeName != null
        then "${cfg.package}/bin/${cfg.exeName}"
        else lib.getExe cfg.package;
    };
  };
}
