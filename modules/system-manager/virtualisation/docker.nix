{ config, lib, nixosModulesPath, ... }:
let
  cfg = config.virtualisation.docker;
in {
  imports = [
    (nixosModulesPath + "/virtualisation/docker.nix")
  ];

  config = lib.mkIf cfg.enable {
    systemd.services.docker = {
      wantedBy = lib.mkForce [ "system-manager.target" ];
    };
  };
}
