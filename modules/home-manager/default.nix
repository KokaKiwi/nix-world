{ sources, ... }:
{
  imports = [
    "${sources.catppuccin}/modules/home-manager"
    "${sources.declarative-cachix}/home-manager.nix"

    ./lib
    ./misc
    ./programs
    ./services
  ];
}
