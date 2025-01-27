{ config, pkgs, ... }:
{
  programs.nix-index = {
    enable = true;
    package = pkgs.nix-index.override {
      nix = config.nix.package;
    };
  };
}
