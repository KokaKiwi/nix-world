{ config, pkgs, lib, ... }:
let
  cfg = config.cluster.networking.openssh;
in {
  options.cluster.networking.openssh = with lib; {
    enable = mkEnableOption "sshd" // { default = true; };

    package = mkPackageOption pkgs "openssh" { };
  };

  config = with lib; mkIf cfg.enable {
    programs.ssh.package = cfg.package;

    services.openssh = {
      enable = true;
      startWhenNeeded = mkDefault false;

      hostKeys = mkDefault [
        {
          type = "ed25519";
          path = "/etc/ssh/ssh_host_ed25519_key";
        }
      ];

      settings = {
        PasswordAuthentication = mkDefault false;
      };
    };
  };
}
