{ config, lib, nixosModulesPath, ... }:
let
  cfg = config.services.postgresql;
in {
  imports = [
    (nixosModulesPath + "/services/databases/postgresql.nix")
  ];

  config = lib.mkIf cfg.enable {
    services.postgresql = { };

    systemd.services.postgresql = {
      wantedBy = lib.mkForce [ "system-manager.target" ];
    };
  };
}
