{ config, lib, nixosModulesPath, ... }:
let
  cfg = config.services.tor;
in {
  imports = [
    (nixosModulesPath + "/services/security/tor.nix")
  ];

  systemd.services.tor = lib.mkIf cfg.enable {
    wantedBy = lib.mkForce [ "system-manager.target" ];
  };
}
