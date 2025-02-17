{ ... }:
{
  imports = [
    ./misc/shared

    ./networking/openssh.nix

    ./programs/eza.nix
    ./programs/htop.nix

    ./services/archiveteam-warrior.nix
    ./services/gotosocial.nix
    ./services/searchix.nix
  ];
}
