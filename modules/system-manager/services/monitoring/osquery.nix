{ config, lib, nixosModulesPath, ... }:
let
  cfg = config.services.osquery;
in {
  imports = [
    (nixosModulesPath + "/services/monitoring/osquery.nix")
  ];

  config = lib.mkIf cfg.enable {
    systemd.services.osqueryd = {
      wantedBy = lib.mkForce [ "system-manager.target" ];
    };
  };
}
