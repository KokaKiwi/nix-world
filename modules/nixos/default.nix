{ ... }:
{
  imports = [
    ./home-manager

    ./misc/deployment.nix
    ./misc/secrets.nix

    ./networking/openssh.nix

    ./programs/eza.nix
    ./programs/htop.nix

    ./services/gotosocial.nix
    ./services/searchix.nix
  ];
}
