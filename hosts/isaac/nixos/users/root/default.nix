{ ... }:
{
  users.users.root = {
    linger = true;
  };

  home-manager.users.root = ./home.nix;
}
