{ config, pkgs, sources, ... }:
let
  cfg = config.services.qbittorrent;

  unstablePkgs = import sources.nixpkgs { };

  qbittorrent-server = unstablePkgs.qbittorrent.override {
    guiSupport = false;
    trackerSearch = true;
    webuiSupport = true;
  };
in {
  services.qbittorrent = {
    enable = true;

    package = qbittorrent-server;

    initSettings = {
      Preferences.WebUI = {
        HostHeaderValidation = false;

        LocalHostAuth = false;
        AuthSubnetWhitelistEnabled = true;
        AuthSubnetWhitelist = [
          "10.42.0.0/24"
          "192.168.1.0/24"
        ];
      };
      Session.DefaultSavePath = "/var/data/media/downloads";
    };
  };

  systemd.services.qbittorrent = {
    netns = "qbittorrent";
  };

  users.groups.media.members = [ cfg.user ];

  networking.netns.namespaces.qbittorrent = {
    startScript = ''
      ip link add wg0 type wireguard
      ${pkgs.wireguard-tools}/bin/wg setconf wg0 ${config.lib.secrets.path "ccvpn-fr.conf"}

      ip link set wg0 netns $nsName

      ip -n $nsName address add 10.128.4.139/32 dev wg0
      ip -n $nsName -6 address add fd64:e20:68a3::48b/128 dev wg0

      ip -n $nsName link set wg0 up

      ip -n $nsName route add default dev wg0
      ip -n $nsName -6 route add default dev wg0
    '';

    dns = [ "1.1.1.1" ];

    veth = {
      enable = true;
      name = "veth-ns0";

      hostIp = "10.42.0.1/24";
      containerIp = "10.42.0.2/24";
    };
  };

  webserver.services.torrents = {
    proxyPass = "http://10.42.0.2:8080";
  };

  secrets."ccvpn-fr.conf" = { };
}
