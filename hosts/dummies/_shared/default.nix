{ pkgs, srvos, ... }:
{
  imports = [
    srvos.common
    srvos.mixins-cloud-init
    srvos.mixins-trusted-nix-caches

    ./users.nix
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

  services.dbus.implementation = "broker";

  security.sudo = {
    execWheelOnly = true;
  };
}
