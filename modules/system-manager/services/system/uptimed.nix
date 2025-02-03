{ config, lib, nixosModulesPath, ... }:
let
  cfg = config.services.uptimed;
in {
  imports = [
    (nixosModulesPath + "/services/system/uptimed.nix")
  ];

  config = lib.mkIf cfg.enable {
    systemd.services.uptimed = {
      serviceConfig.DynamicUser = true;
      wantedBy = lib.mkForce [ "system-manager.target" ];
    };
  };
}
