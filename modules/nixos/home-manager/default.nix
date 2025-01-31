{ sources, ... }:
{
  home-manager = {
    sharedModules = [
      ./programs/just.nix
    ];

    extraSpecialArgs = {
      inherit sources;
    };
  };
}
