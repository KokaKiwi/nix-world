{
  nixpkgs.version = "24.11";

  secrets.file = ./secrets.yml;

  nixos = {
    configuration = ./nixos/configuration.nix;

    integrations.home-manager = true;
    integrations.srvos = true;
  };
}
