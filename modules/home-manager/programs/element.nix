{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.programs.element;
in {
  options.programs.element = {
    enable = mkEnableOption "element";

    package = mkPackageOption pkgs "element-desktop" { };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];
  };
}
