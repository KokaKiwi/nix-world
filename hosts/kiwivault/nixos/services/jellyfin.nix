{ config, ... }:
let
  cfg = config.services.jellyfin;
in {
  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  services.minidlna = {
    enable = true;
    settings = {
      friendly_name = "KIWIVAULT";
      media_dir = [
        "V,/var/data/media/videos"
      ];
    };
  };

  users.groups.media.members = [
    cfg.user
    "minidlna"
  ];

  webserver.services.media = {
    proxyPass = "http://192.168.1.80:8096";
  };

  cluster.world.packages = [ cfg.package ];
}
