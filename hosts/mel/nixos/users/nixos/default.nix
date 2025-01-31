{ ... }:
{
  users.users.nixos = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" ];
  };

  shared.ssh-keys.users = [ "nixos" ];

  home-manager.users.nixos = import ./home.nix;
}
