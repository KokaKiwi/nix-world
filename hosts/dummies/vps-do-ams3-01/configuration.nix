{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "vps-do-ams3-01";

  system.stateVersion = "24.11";
}
