{ config, lib, nixosModulesPath, ... }:
let
  cfg = config.networking.firewall;

  nftables = config.networking.nftables;
in {
  imports = [
    (nixosModulesPath + "/services/networking/firewall.nix")
    (nixosModulesPath + "/services/networking/firewall-iptables.nix")
    (nixosModulesPath + "/services/networking/firewall-nftables.nix")
    (nixosModulesPath + "/services/networking/nftables.nix")
  ];

  config = lib.mkIf cfg.enable {
    networking.nftables = {
      enable = lib.mkDefault true;
      checkRulesetRedirects = { };
    };

    systemd.services.nftables = lib.mkIf nftables.enable {
      wantedBy = lib.mkForce [ "system-manager.target" ];
    };
  };
}
