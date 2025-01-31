{
  nixpkgs.version = "24.11";

  useLix = true;

  nixos = {
    configuration = ./nixos/configuration.nix;

    deployment.targetHost = "kiwivault.ygg";

    integrations.home-manager = true;
    integrations.srvos = true;
  };
}
