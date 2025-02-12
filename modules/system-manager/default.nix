{ ... }:
{
  imports = [
    ./lib.nix

    ./misc

    ./systemd.nix

    ./config/networking.nix
    ./config/nix.nix

    ./networking/firewall.nix

    ./security/dhparams.nix

    ./services
  ];
}
