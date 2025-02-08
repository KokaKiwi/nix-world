{ pkgs, ... }:
{
  imports = [
    ./services
  ];

  nix = {
    enable = true;

    settings = {
      cores = 4;
      max-jobs = 1;
      system-features = [ ];

      sandbox = true;
      trusted-users = [ "@wheel" ];

      experimental-features = [ "cgroups" ];
      use-cgroups = true;

      build-dir = "/var/lib/nix";
    };
  };

  networking.firewall.enable = false;

  environment.systemPackages = [
    pkgs.kiwiPackages.dwarfs
  ];
}
