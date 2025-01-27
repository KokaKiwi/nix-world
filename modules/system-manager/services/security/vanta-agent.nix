{ config, lib, nur, ... }:
let
  cfg = config.services.vanta-agent;
in {
  imports = [
    nur.repos.kokakiwi.modules.nixos.services.vanta-agent
  ];

  config = lib.mkIf cfg.enable {
    services.vanta-agent.package = lib.mkDefault nur.repos.kokakiwi.vanta-agent;

    systemd.services.vanta-agent.wantedBy = lib.mkForce [ "system-manager.target" ];
  };
}
