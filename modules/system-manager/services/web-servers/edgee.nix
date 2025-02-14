{ config, lib, nur, ... }:
let
  cfg = config.services.edgee;
in {
  imports = [
    nur.repos.kokakiwi.modules.nixos.services.edgee
  ];

  config = lib.mkIf cfg.enable {
    systemd.services.edgee.wantedBy = lib.mkForce [ "system-manager.target" ];
  };
}
