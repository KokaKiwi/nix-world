{ pkgs, srvos, ... }:
{
  imports = [
    ../../_shared

    srvos.common
    srvos.mixins-cloud-init
    srvos.mixins-nginx
    srvos.mixins-trusted-nix-caches

    ./hardware

    ./networking

    ./programs
    ./services

    ./users
  ];

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "@wheel" ];
    };

    nixPath = [
      "nixpkgs=${pkgs.path}"
    ];
  };

  console.keyMap = "fr";
  time.timeZone = "Europe/Paris";
  environment.enableAllTerminfo = true;

  networking.useDHCP = false;
  networking.useNetworkd = true;
  networking.hostName = "isaac";

  nixpkgs.overlays = [
    (self: super: import ./pkgs {
      pkgs = self;
      inherit super;
    })
  ];

  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;

  services.dbus.implementation = "broker";

  security.sudo = {
    execWheelOnly = true;
  };

  system.stateVersion = "24.05";
}
