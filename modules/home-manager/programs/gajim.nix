{ config, pkgs, lib, ... }:
let
  cfg = config.programs.gajim;
in {
  options.programs.gajim = with lib; {
    enable = mkEnableOption "gajim";
    package = mkPackageOption pkgs "gajim" { };
  };

  config = with lib; mkIf cfg.enable {
    home.packages = [ cfg.package ];
  };
}
