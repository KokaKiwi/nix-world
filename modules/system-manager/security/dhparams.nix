{ config, lib, nixosModulesPath, ... }:
let
  cfg = config.security.dhparams;

  dhparamsService = {
    wantedBy = lib.mkForce [ "system-manager.target" ];

    serviceConfig = {
      User = lib.mkForce "root";
      Group = lib.mkForce "root";
    };
  };
in {
  imports = [
    (nixosModulesPath + "/security/dhparams.nix")
  ];

  systemd.services = lib.mkIf (cfg.enable && cfg.stateful) ({
    dhparams-init = dhparamsService;
  } // lib.mapAttrs' (name: _: lib.nameValuePair "dhparams-gen-${name}" dhparamsService) cfg.params);
}
