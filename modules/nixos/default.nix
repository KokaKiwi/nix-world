{ ... }:
{
  imports = [
    ./misc/shared

    ./networking/openssh.nix

    ./programs/eza.nix
    ./programs/htop.nix

    ./services/gotosocial.nix
    ./services/searchix.nix
  ];
}
