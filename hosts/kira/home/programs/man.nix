{ pkgs, ... }:
{
  programs.man = {
    enable = true;
    package = pkgs.kiwiPackages.man-db;

    generateCaches = true;
  };
}
