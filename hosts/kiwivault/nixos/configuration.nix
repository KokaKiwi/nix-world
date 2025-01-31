{ pkgs, srvos, ... }:
{
  imports = [
    ../../_shared

    srvos.common
    srvos.mixins-nginx
    srvos.mixins-systemd-boot

    ./hardware
    ./networking
    ./programs
    ./services
    ./users
  ];

  boot.loader = {
    systemd-boot = {
      enable = true;
      editor = false;

      configurationLimit = 10;

      memtest86.enable = true;
    };
    efi.canTouchEfiVariables = true;
  };

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "nixos" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      randomizedDelaySec = "30min";
    };

    nixPath = [
      "nixpkgs=${pkgs.path}"
    ];
  };

  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  console.keyMap = "fr";
  time.timeZone = "Europe/Paris";
  environment.enableAllTerminfo = true;

  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;

  services.dbus.implementation = "broker";

  security.sudo = {
    execWheelOnly = true;
  };

  system.stateVersion = "23.11";
}
