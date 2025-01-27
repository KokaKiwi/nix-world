{ config, lib, nixosModulesPath, ... }:
let
  inherit (config.lib) systemd;

  cfg = config.services.dnsproxy;
in {
  imports = [
    (nixosModulesPath + "/services/networking/dnsproxy.nix")
  ];

  systemd.services.dnsproxy = lib.mkIf cfg.enable systemd.systemService;
}
