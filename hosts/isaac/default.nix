{
  nixpkgs.version = "24.11";

  nixos = {
    configuration = ./nixos/configuration.nix;

    integrations.home-manager = true;
    integrations.srvos = true;
  };
}
