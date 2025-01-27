{ ... }:
{
  services.dnsproxy = {
    enable = true;

    settings = {
      listen-addrs = [ "127.0.0.1" ];
      listen-ports = [ 5553 ];

      max-go-routines = 0;
      ratelimit = 0;
      ratelimit-subnet-len-ipv4 = 24;
      ratelimit-subnet-len-ipv6 = 64;
      udp-buf-size = 0;

      http3 = true;

      upstream-mode = "parallel";
      bootstrap = [
        "https://1.1.1.1/dns-query"
        "1.1.1.1:53"
      ];
      upstream = [
        "https://doh.mullvad.net/dns-query"
        "https://dns.njal.la/dns-query"
        "https://ns0.fdn.fr/dns-query"
        "https://ns1.fdn.fr/dns-query"
        "https://doh.dns4all.eu/dns-query"
        "sdns://AQMAAAAAAAAAETk0LjE0MC4xNC4xNDo1NDQzINErR_JS3PLCu_iZEIbq95zkSV2LFsigxDIuUso_OQhzIjIuZG5zY3J5cHQuZGVmYXVsdC5uczEuYWRndWFyZC5jb20"
      ];
    };
  };
}
