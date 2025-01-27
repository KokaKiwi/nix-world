{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.programs.kde.akonadi;

  iniFormat = pkgs.formats.ini { };
in {
  options.programs.kde.akonadi = {
    enable = mkEnableOption "akonadi";
    postgresql = mkPackageOption pkgs "postgresql" { };

    dataDir = mkOption {
      type = types.str;
      default = "${config.xdg.dataHome}/akonadi/db_data";
    };
  };

  config = mkIf cfg.enable {
    xdg.configFile."akonadi/akonadiserverrc".source = iniFormat.generate "akonadiserverrc" {
      Debug = {
        Tracer = "dbus";
      };
      "%General" = {
        Driver = "QPSQL";
      };
      QPSQL = {
        Name = "akonadi";
        StartServer = true;
        Host = "/run/user/1000/akonadi";
        PgData = cfg.dataDir;
        InitDbPath = "${cfg.postgresql}/bin/initdb";
        ServerPath = "${cfg.postgresql}/bin/pg_ctl";
      };
    };
  };
}
