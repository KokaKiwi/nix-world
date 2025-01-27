{ secretsPath, ... }:
{
  useLix = true;

  nixpkgs.config = {
    allowUnfree = true;
  };

  systems = {
    home = {
      builder = "home-manager";

      configuration = ./home/configuration.nix;

      extraSpecialArgs = {
        inherit secretsPath;
      };
    };
    system = {
      builder = "system-manager";

      configuration = ./system/configuration.nix;
    };
  };
}
