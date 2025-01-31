{ config, ... }:
let
  exporters = config.services.prometheus.exporters;
in {
  services.prometheus = {
    enable = true;

    listenAddress = "127.0.0.1";
    port = 9099;

    checkConfig = "syntax-only";

    scrapeConfigs = [
      {
        job_name = "node-exporter";
        static_configs = [
          {
            targets = [
              "${exporters.node.listenAddress}:${toString exporters.node.port}"
            ];
          }
        ];
      }
      {
        job_name = "smartctl";
        static_configs = [
          {
            targets = [
              "${exporters.smartctl.listenAddress}:${toString exporters.smartctl.port}"
            ];
          }
        ];
      }
      {
        job_name = "hass";
        static_configs = [
          {
            targets = [ "192.168.1.81:8123" ];
          }
        ];
        metrics_path = "/api/prometheus";
        bearer_token_file = "/run/credentials/prometheus.service/prometheus-hass-token";
        scrape_interval = "1m";
      }
    ];
  };

  systemd.services.prometheus = {
    serviceConfig = {
      LoadCredential = [
        "prometheus-hass-token:${config.lib.secrets.path "prometheus-hass-token"}"
      ];
    };
  };

  secrets."prometheus-hass-token" = { };
}
