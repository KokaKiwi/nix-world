{ ... }:
{
  users.users.nixos = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" ];
    linger = true;
  };

  home-manager.users.nixos = ./home.nix;
}
