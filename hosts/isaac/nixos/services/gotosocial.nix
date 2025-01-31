{ config, ... }:
let
  inherit (config.lib) secrets;

  cfg = config.services.gotosocial;
in {
  services.gotosocial = {
    enable = true;
    setupPostgresqlDB = true;

    environmentFile = secrets.path "gotosocial.env";

    settings = {
      application-name = "Bots Are Gay";

      host = "botsare.gay";
      bind-address = "127.0.0.1";
      port = 17890;
      protocol = "https";

      instance-expose-suspended = true;
      instance-expose-suspended-web = true;

      accounts-registration-open = true;
      accounts-reason-required = true;

      storage-backend = "s3";
      storage-s3-endpoint = "s3.gra.io.cloud.ovh.net";
      storage-s3-bucket = "gts-assets";

      web-pages-base-dir = ./gts-pages;
    };
  };

  systemd.services.gotosocial.stopIfChanged = false;

  services.nginx = {
    clientMaxBodySize = "40M";

    virtualHosts.${cfg.settings.host} = {
      forceSSL = true;
      enableACME = true;
      quic = true;

      locations."/assets/" = {
        alias = "${cfg.settings.web-asset-base-dir}/";

        extraConfig = ''
          autoindex off;
          expires 5m;
          add_header Cache-Control "public";
        '';
      };

      locations."/fileserver/" = {
        recommendedProxySettings = true;

        proxyPass = "http://${cfg.settings.bind-address}:${toString cfg.settings.port}";

        extraConfig = ''
          add_header Cache-Control "private, immutable";
        '';
      };

      locations."/" = {
        recommendedProxySettings = true;

        proxyWebsockets = true;
        proxyPass = "http://${cfg.settings.bind-address}:${toString cfg.settings.port}";
      };
    };
  };

  secrets."gotosocial.env" = { };
}
