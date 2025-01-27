{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.services.aria2;

  settingsFormat = pkgs.formats.keyValue {
    listsAsDuplicateKeys = true;
  };

  sessionPath = "${config.xdg.stateHome}/aria2.session";

  settingsFile = settingsFormat.generate "aria2.conf" cfg.settings;

  baseArgs =
    [
      "--enable-rpc"
      "--save-session=${sessionPath}"
    ]
    ++ optional (cfg.settings != { }) "--conf-path=${settingsFile}";
  allArgs = concatStringsSep " " (baseArgs ++ (toList cfg.extraArgs));
in {
  options.services.aria2 = {
    enable = mkEnableOption "aria2";

    package = mkPackageOption pkgs "aria2" { };

    downloadDir = mkOption {
      type = with types; either path str;
      default = config.xdg.userDirs.download;
    };

    extraArgs = mkOption {
      type = with types; either (listOf str) (separatedString " ");
      default = [ ];
    };

    settings = mkOption {
      type = settingsFormat.type;
      default = { };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    systemd.user.services.aria2d = {
      Unit = {
        Description = "Aria2 RPC daemon";
        After = [ "systemd-tmpfiles-setup.service" ];
      };
      Service = {
        Restart = "on-abort";
        ExecStart = "${getExe cfg.package} ${allArgs}";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };

    services.aria2.settings = {
      dir = mkDefault (toString cfg.downloadDir);
    };

    xdg.configFile."aria2/aria2.conf" = mkIf (cfg.settings != { }) {
      source = settingsFile;
    };
  };
}
