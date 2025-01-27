{ config, ... }:
{
  services.podman = { };

  home.packages = [
    config.services.podman.package
  ];
}
