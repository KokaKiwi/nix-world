{ config, pkgs, lib, ... }:
let
  nginxService = config.systemd.services.nginx;

  localDevServices = {
    doc = "127.0.0.1:8123";
    dev = "127.0.0.1:8000";
    nix = "127.0.0.1:8649";
    df-consul = "127.0.0.1:8500";
    df-nomad = "127.0.0.1:4646";
  };
in {
  services.nginx = {
    enable = true;
    package = pkgs.nur.repos.kokakiwi.freenginx;

    recommendedTlsSettings = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedZstdSettings = true;
    recommendedProxySettings = true;
    recommendedBrotliSettings = true;

    sslDhparam = config.security.dhparams.params.nginx.path;

    virtualHosts = {
      "nix-search.local.dev" = {
        forceSSL = true;

        sslCertificate = nginxService.credentials."local-dev.crt".path;
        sslCertificateKey = nginxService.credentials."local-dev.key".path;

        locations."/" = {
          root = "/tmp/nix-search";
        };
      };
    } // lib.mapAttrs' (name: target: lib.nameValuePair "${name}.local.dev" {
      forceSSL = true;

      sslCertificate = nginxService.credentials."local-dev.crt".path;
      sslCertificateKey = nginxService.credentials."local-dev.key".path;

      locations."/" = {
        proxyPass = "http://${target}";
      };
    }) localDevServices;
  };

  systemd.services.nginx = {
    serviceConfig = {
      BindReadOnlyPaths = [
        "/home/kokakiwi/projects/nix/home-manager/result-search:/tmp/nix-search:norbind"
      ];
    };

    credentials = {
      "local-dev.crt".source = "/etc/ssl/local/local-dev.crt";
      "local-dev.key".source = "/etc/ssl/local/local-dev.key";
    };
  };

  security.dhparams = {
    enable = true;
    params.nginx = { };
  };
}
