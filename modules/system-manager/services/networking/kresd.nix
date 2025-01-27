{ config, lib, nixosModulesPath, ... }:
let
  cfg = config.services.kresd;
in {
  imports = [
    (nixosModulesPath + "/services/networking/kresd.nix")
  ];

  systemd.targets.kresd = lib.mkIf cfg.enable {
    wantedBy = lib.mkForce [ "system-manager.target" ];
    wants = lib.mkForce (map (i: "kresd@${toString i}.service") (lib.range 1 cfg.instances));
  };
}
