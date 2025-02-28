{ config, lib, nixosModulesPath, ... }:
let
  cfg = config.services.gitlab-runner;
in {
  imports = [
    (nixosModulesPath + "/services/continuous-integration/gitlab-runner.nix")
  ];

  config = lib.mkIf cfg.enable {
    systemd.services.gitlab-runner = {
      wantedBy = lib.mkForce [ "system-manager.target" ];
    };
  };
}
