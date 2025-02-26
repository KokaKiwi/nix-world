{ config, lib, nixosModulesPath, ... }:
let
  cfg = config.services.kresd;
in {
  imports = [
    (nixosModulesPath + "/services/networking/kresd.nix")
  ];

  systemd.targets.kresd = lib.mkIf cfg.enable {
    wantedBy = lib.mkForce [ "system-manager.target" ];
  };
}
