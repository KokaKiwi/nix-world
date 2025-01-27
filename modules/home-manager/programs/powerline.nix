{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.programs.powerline;
in {
  options = {
    programs.powerline = {
      enable = mkEnableOption "Powerline";

      package = mkPackageOption pkgs "powerline" { };

      integrations = {
        tmux = mkEnableOption "Powerline TMUX integration";
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      home.packages = [ cfg.package ];

      systemd.user.services."powerline-daemon" = {
        Unit = {
          Description = "powerline-daemon - Daemon that improves powerline performance";
          Documentation = [
            "man:powerline-daemon(1)"
            "https://powerline.readthedocs.org/en/latest/"
          ];
        };
        Service = {
          ExecStart = "${cfg.package}/bin/powerline-daemon --foreground";
        };
        Install = {
          WantedBy = [ "default.target" ];
        };
      };
    }
    (mkIf cfg.integrations.tmux {
      programs.tmux.extraConfig = ''
        source '${cfg.package}/share/tmux/powerline.conf'
      '';

      systemd.user.services."tmux" = {
        Unit = {
          After = [ "powerline-daemon.service" ];
        };
      };
    })
  ]);
}
