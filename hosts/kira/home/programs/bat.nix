{ config, pkgs, lib, ... }:
let
  cfg = config.programs.bat;

  batman = pkgs.bat-extras.batman.override {
    bat = cfg.package;
  };

  mapSyntax = lib.mapAttrsToList (name: value: "${name}:${value}");
in {
  programs.bat = {
    enable = true;
    package = pkgs.bat.override {
      inherit (pkgs.rustTools.rust) rustPlatform;
    };

    config = {
      italic-text = "always";
      paging = "always";
      style = lib.concatStringsSep "," [
        "numbers"
        "changes"
        "header-filename"
        "header-filesize"
        "grid"
      ];
      map-syntax = mapSyntax {
        ".ignore" = "Git Ignore";
      };
    };
  };

  programs.fish.interactiveShellInit = "${lib.getExe batman} --export-env | source";
}
