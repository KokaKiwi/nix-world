{ config, lib, nixosModulesPath, ... }:
let
  inherit (config.lib) systemd;

  cfg = config.services.yggdrasil;
in {
  imports = [
    (nixosModulesPath + "/services/networking/yggdrasil.nix")
  ];

  systemd.services.yggdrasil-persistent-keys = lib.mkIf (cfg.enable && cfg.persistentKeys) {
    wantedBy = lib.mkForce [ "system-manager.target" ];
  };
  systemd.services.yggdrasil = lib.mkIf cfg.enable systemd.systemService;
}
