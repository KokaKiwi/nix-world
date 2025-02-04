{ ... }:
{
  imports = [
    ./root
    ./nixos
  ];

  cluster.ssh.users = {
    nixos = { };
    root = { };
  };
}
