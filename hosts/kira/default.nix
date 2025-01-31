{ secretsPath, ... }:
{
  useLix = true;

  nixpkgs.config = {
    allowUnfree = true;
  };

  home = {
    configuration = ./home/configuration.nix;

    extraSpecialArgs = {
      inherit secretsPath;
    };
  };
  system = {
    configuration = ./system/configuration.nix;
  };
}
