{ config, lib, ... }:
let
  cfg = config.services.archiveteam-warrior;
in {
  options.services.archiveteam-warrior = with lib; {
    enable = mkEnableOption "ArchiveTeam Warrior";

    nickname = mkOption {
      type = types.str;
    };

    project = mkOption {
      type = types.nullOr types.str;
      default = null;
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers = {
      archiveteam-warrior = {
        image = "atdr.meo.ws/archiveteam/warrior-dockerfile";
        ports = [ "8001:8001" ];
        labels = {
          "io.containers.autoupdate" = "registry";
        };
        environment = {
          DOWNLOADER = cfg.nickname;
          SELECTED_PROJECT = lib.mkIf (cfg.project != null) cfg.project;
          WARRIOR_ID = lib.mkDefault config.networking.hostName;
        };
      };
    };
  };
}
