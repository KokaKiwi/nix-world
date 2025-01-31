{ ... }:
{
  systemd.network = {
    enable = true;

    netdevs."20-br0" = {
      netdevConfig = {
        Kind = "bridge";
        Name = "br0";
      };
    };

    networks."10-eno1" = {
      matchConfig.Name = "eno1";
      networkConfig.Bridge = "br0";
      linkConfig.RequiredForOnline = "enslaved";
    };

    networks."20-br0" = {
      matchConfig.Name = "br0";
      address = [
        "192.168.1.80/24"
      ];
      routes = [
        {
          Gateway = "192.168.1.1";
        }
      ];
      networkConfig = {
        IPv6AcceptRA = true;
      };
      linkConfig.RequiredForOnline = "routable";
    };
  };

  networking.useDHCP = false;
}
