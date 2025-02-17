{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "vps-do-nyc1-01";

  system.stateVersion = "24.11";
}
