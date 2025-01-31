{ ... }:
{
  services.yggdrasil = {
    enable = true;
    persistentKeys = true;

    settings = {
      Peers = [
        "tls://137.74.95.130:41312"
        "tls://[2001:41d0:1004:3382::1]:41312"
      ];
      IfName = "ygg0";
    };
  };
}
