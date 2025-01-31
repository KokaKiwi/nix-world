{ ... }:
{
  imports = [
    ./nixos
    ./root
  ];

  users.groups.media = { };

  shared.ssh-keys.users = [ "root" "nixos" ];
}
