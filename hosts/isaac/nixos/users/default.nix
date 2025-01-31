{ ... }:
{
  imports = [
    ./root
    ./nixos
  ];

  shared.ssh-keys.users = [ "root" "nixos" ];
}
