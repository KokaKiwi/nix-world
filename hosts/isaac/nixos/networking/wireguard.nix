{ config, ... }:
let
  inherit (config.lib) secrets;
in {
  networking.firewall.allowedUDPPorts = [
    config.networking.wireguard.interfaces."wg0".listenPort
  ];
  networking.wireguard.interfaces."wg0" = {
    ips = [
      "10.30.0.3/32"
      "fdc9:1312:acab:9ee9::3/128"
    ];
    listenPort = 51820;

    privateKeyFile = secrets.path "wireguard-private-key";

    peers = [
      {
        publicKey = "kiwi2lrdSAwMz+dINGKH7vtQNZKy5+Vy9JbcXUOflnk=";
        allowedIPs = [
          "10.30.0.0/24"
          "fdc9:1312:acab:9ee9::/64"
        ];
        endpoint = "[2001:41d0:1004:3382::1]:48781";
        persistentKeepalive = 25;
        presharedKeyFile = secrets.path "wireguard-preshared-key-alyx";
      }
    ];
  };

  secrets = {
    "wireguard-private-key" = { };
    "wireguard-preshared-key-alyx" = { };
  };
}
