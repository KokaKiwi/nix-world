{ config, lib, ... }:
let
  cfg = config.services.tmux;
in {
  options.services.tmux = with lib; {
    enable = mkEnableOption "tmux systemd service";
  };

  config = with lib; mkIf cfg.enable {
    systemd.user.services."tmux" = mkIf cfg.enable {
      Unit = {
        Description = "Start tmux in detached session";
        After = [ "systemd-tmpfiles-setup.service" ];
      };

      Service = {
        Type = "forking";
        ExecStart = "${getExe config.programs.tmux.package} -2 new-session -s ${config.home.username} -dP";
        ExecStop = "${getExe config.programs.tmux.package} kill-session -t ${config.home.username}";
      };

      Install = {
        WantedBy = [ "environment.target" ];
      };
    };
  };
}
