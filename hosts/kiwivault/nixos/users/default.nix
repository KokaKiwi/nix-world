{ ... }:
{
  imports = [
    ./nixos
    ./root
  ];

  users.groups.media = { };

  cluster.ssh = {
    keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII7KXVL6BFeXypWcBnvNUl4NJjLDonio5csxT+RgRaCy kokakiwi@KIWI-GAMES-ARCH"
    ];

    users.nixos = { };
    users.root = { };
  };
}
