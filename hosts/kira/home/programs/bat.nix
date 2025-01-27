{ pkgs, lib, ... }:
let
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
      pager = "${lib.getExe pkgs.less} --RAW-CONTROL-CHARS --quit-if-one-screen";
      map-syntax = mapSyntax {
        ".ignore" = "Git Ignore";
      };
    };
  };
}
