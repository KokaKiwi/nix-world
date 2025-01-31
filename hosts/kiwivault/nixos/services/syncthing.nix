{ config, ... }:
let
  cfg = config.services.syncthing;

  syncDir = "/var/data/sync";
in {
  services.syncthing = {
    enable = true;
    configDir = cfg.dataDir + "/config";

    settings = {
      devices = {
        "KIWI-GAMES" = {
          id = "EFK7AJE-Z7332RJ-SACA6XE-2YVV5RC-CEZPC57-ZGZIEQX-5IXS3C6-TMCWTQW";
        };
        "kira" = {
          id = "E53NZ3O-EY4RBWM-GPOPT6P-YQFMQNM-DNYGAN5-I42DHLL-N5WEH3H-J7GJBAN";
        };
        "stella" = {
          id = "PI5MKH3-5LZ35YS-WSEFD3N-QL6JZCJ-7NSIOFC-DGKOXFJ-NVQ7OYW-MVKQSAO";
        };
      };
      folders = {
        default = {
          label = "Default";
          path = "${syncDir}/Sync";
          devices = [ "KIWI-GAMES" "kira" ];
          versioning = {
            type = "simple";
            params.keep = "5";
          };
        };
        wallpapers = {
          label = "Wallpapers";
          path = "${syncDir}/Wallpapers";
          devices = [ "KIWI-GAMES" "kira" ];
          versioning = {
            type = "simple";
            params.keep = "5";
          };
        };
        music = {
          id = "wyta8-hhkvt";
          label = "Music";
          path = "${syncDir}/Music";
          devices = [ "kira" ];
          versioning = {
            type = "simple";
            params.keep = "5";
          };
        };
        android-music = {
          id = "Android-Music";
          label = "Android Music";
          path = "${syncDir}/Android-Music";
          devices = [ "kira" "stella" ];
          versioning = {
            type = "simple";
            params.keep = "5";
          };
        };
        drone-stuff = {
          id = "ocnbw-drone-stuff";
          label = "Drone Stuff";
          path = "${syncDir}/Drone-Stuff";
          devices = [ "KIWI-GAMES" "kira" "stella" ];
          versioning = {
            type = "simple";
            params.keep = "5";
          };
        };
      };

      gui.insecureSkipHostcheck = true;
    };
  };

  webserver.services.syncthing = {
    proxyPass = "http://${cfg.guiAddress}";
  };
}
