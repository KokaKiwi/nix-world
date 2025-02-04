{ ... }:
{
  imports = [
    ./nixos
    ./root
  ];

  users.groups.media = { };

  cluster.ssh.users = {
    nixos = { };
    root = { };
  };
}
