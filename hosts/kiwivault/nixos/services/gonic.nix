{ config, ... }:
let
  cfg = config.services.gonic;

  dataDir = "/var/data/media/music";
in {
  services.gonic = {
    enable = true;

    settings = {
      playlists-path = "${dataDir}/playlists";
      podcast-path = "${dataDir}/podcast";

      music-path = [
        "/var/data/sync/Music"
      ];
    };
  };

  webserver.services.gonic = {
    proxyPass = "http://${cfg.settings.listen-addr}";
  };
}
