{ ... }:
{
  useLix = true;

  nixpkgs.config = {
    allowUnfree = true;
  };

  home = {
    configuration = ./home/configuration.nix;
  };
  system = {
    configuration = ./system/configuration.nix;
  };
}
