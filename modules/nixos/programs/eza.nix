{ config, pkgs, lib, ... }:
let
  cfg = config.cluster.programs.eza;
in {
  options.cluster.programs.eza = with lib; {
    enable = mkEnableOption "eza";

    package = mkPackageOption pkgs "eza" { };
  };

  config = with lib; mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ eza ];

    environment.shellAliases = {
      ls = "eza -g";
      ll = "ls -l";
    };
  };
}
