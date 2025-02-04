{ ... }:
{
  users.users.nixos = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" ];
  };

  cluster.ssh.users.nixos = { };

  home-manager.users.nixos = import ./home.nix;
}
