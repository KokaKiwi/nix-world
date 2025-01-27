{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.programs.ferdium;
in {
  options.programs.ferdium = {
    enable = mkEnableOption "Ferdium";

    package = mkPackageOption pkgs "ferdium" {};
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];
  };
}
