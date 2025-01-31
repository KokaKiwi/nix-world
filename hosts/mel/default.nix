{
  nixpkgs.version = "24.11";

  nixos = {
    configuration = ./nixos/configuration.nix;

    deployment.targetUser = "nixos";

    integrations.home-manager = true;
  };
}
