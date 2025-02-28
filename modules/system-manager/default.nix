{ ... }:
{
  imports = [
    ./lib.nix

    ./misc

    ./config/networking.nix
    ./config/nix.nix

    ./networking/firewall.nix

    ./security/dhparams.nix

    ./services
    ./system

    ./virtualisation/docker.nix
  ];
}
