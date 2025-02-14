{ config, lib, nur, ... }:
let
  cfg = config.services.edgee;
in {
  imports = [
    nur.repos.kokakiwi.modules.nixos.services.edgee
  ];

  config = lib.mkIf cfg.enable {
    services.edgee.package = lib.mkDefault nur.repos.kokakiwi.edgee;

    systemd.services.edgee.wantedBy = lib.mkForce [ "system-manager.target" ];
  };
}
