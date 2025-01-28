{ config, pkgs, lib, ... }:
let
  cfg = config.nix;
in {
  options.nix = with lib; {
    enable = mkEnableOption "nix daemon";
    package = mkPackageOption pkgs "nix" { };

    daemonCPUSchedPolicy = lib.mkOption {
      type = lib.types.enum [
        "other"
        "batch"
        "idle"
      ];
      default = "other";
      example = "batch";
      description = ''
        Nix daemon process CPU scheduling policy. This policy propagates to
        build processes. `other` is the default scheduling
        policy for regular tasks. The `batch` policy is
        similar to `other`, but optimised for
        non-interactive tasks. `idle` is for extremely
        low-priority tasks that should only be run when no other task
        requires CPU time.

        Please note that while using the `idle` policy may
        greatly improve responsiveness of a system performing expensive
        builds, it may also slow down and potentially starve crucial
        configuration updates during load.

        `idle` may therefore be a sensible policy for
        systems that experience only intermittent phases of high CPU load,
        such as desktop or portable computers used interactively. Other
        systems should use the `other` or
        `batch` policy instead.

        For more fine-grained resource control, please refer to
        {manpage}`systemd.resource-control(5)` and adjust
        {option}`systemd.services.nix-daemon` directly.
      '';
    };

    daemonIOSchedClass = lib.mkOption {
      type = lib.types.enum [
        "best-effort"
        "idle"
      ];
      default = "best-effort";
      example = "idle";
      description = ''
        Nix daemon process I/O scheduling class. This class propagates to
        build processes. `best-effort` is the default
        class for regular tasks. The `idle` class is for
        extremely low-priority tasks that should only perform I/O when no
        other task does.

        Please note that while using the `idle` scheduling
        class can improve responsiveness of a system performing expensive
        builds, it might also slow down or starve crucial configuration
        updates during load.

        `idle` may therefore be a sensible class for
        systems that experience only intermittent phases of high I/O load,
        such as desktop or portable computers used interactively. Other
        systems should use the `best-effort` class.
      '';
    };

    daemonIOSchedPriority = lib.mkOption {
      type = lib.types.int;
      default = 4;
      example = 1;
      description = ''
        Nix daemon process I/O scheduling priority. This priority propagates
        to build processes. The supported priorities depend on the
        scheduling policy: With idle, priorities are not used in scheduling
        decisions. best-effort supports values in the range 0 (high) to 7
        (low).
      '';
    };

    # Environment variables for running Nix.
    envVars = lib.mkOption {
      type = lib.types.attrs;
      internal = true;
      default = { };
      description = "Environment variables used by Nix.";
    };
  };

  config = with lib; mkIf cfg.enable {
    systemd.packages = [ cfg.package ];
    systemd.tmpfiles.packages = [ cfg.package ];

    systemd.services.nix-daemon = {
      path = [
        cfg.package
      ];
      environment = cfg.envVars // {
        CURL_CA_BUNDLE = "/etc/ssl/certs/ca-certificates.crt";
      };

      description = "Nix Daemon";
      documentation = [
        "man:nix-daemon"
        "https://docs.lix.systems/manual/lix/stable"
      ];

      unitConfig = {
        RequiresMountsFor = [
          "/nix/store"
          "/nix/var"
          "/nix/var/nix/db"
        ];
        ConditionPathIsReadWrite = [
          "/nix/var/nix/daemon-socket"
        ];
      };
      serviceConfig = {
        ExecStart = "@${cfg.package}/bin/nix-daemon nix-daemon --daemon";

        KillMode = "process";

        CPUSchedulingPolicy = cfg.daemonCPUSchedPolicy;
        IOSchedulingClass = cfg.daemonIOSchedClass;
        IOSchedulingPriority = cfg.daemonIOSchedPriority;
        LimitNOFILE = 1048576;
        TasksMax = 1048576;
        Delegate = "yes";
      };

      wantedBy = [ "system-manager.target" ];

      restartTriggers = [
        config.environment.etc."nix/nix.conf".source
      ];
      stopIfChanged = false;
    };

    systemd.sockets.nix-daemon = {
      description = "Nix Daemon Socket";

      unitConfig = {
        RequiresMountsFor = [ "/nix/store" ];
        ConditionPathIsReadWrite = [ "/nix/var/nix/daemon-socket" ];
      };
      socketConfig.ListenStream = "/nix/var/nix/daemon-socket/socket";

      wantedBy = [ "system-manager.target" ];
    };
  };
}
