{ config, ... }:
let
  cfg = config.services.grafana;
  prometheusCfg = config.services.prometheus;

  serverSettings = cfg.settings.server;
in {
  services.grafana = {
    enable = true;

    settings = {
      server = {
        http_addr = "127.0.0.1";
        http_port = 3000;

        domain = "monit.kiwivault.lan";
        root_url = "https://monit.kiwivault.lan";
      };
    };

    provision = {
      enable = true;

      datasources = {
        settings = {
          datasources = [
            {
              name = "Prometheus";
              type = "prometheus";
              uid = "prometheus-local";

              url = "http://${prometheusCfg.listenAddress}:${toString prometheusCfg.port}";

              jsonData = {
                httpMethod = "POST";
              };
            }
          ];
        };
      };
    };
  };

  webserver.services.monit = {
    proxyPass = "http://${serverSettings.http_addr}:${toString serverSettings.http_port}";
  };
}
