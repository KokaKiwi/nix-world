{ config, lib, ... }:
let
  inherit (config.lib) secrets;

  cfg = config.webserver;

  serviceType = with lib; types.submodule ({ name, config, ... }: {
    options = {
      enable = mkEnableOption "Web service ${config.name}" // { default = true; };

      name = mkOption {
        type = types.str;
        default = name;
      };

      default = mkOption {
        type = types.bool;
        default = false;
      };
      proxyPass = mkOption {
        type = with types; nullOr str;
        default = null;
      };

      extraConfig = mkOption {
        type = types.attrs;
        default = { };
      };
    };
  });
in {
  options.webserver = with lib; {
    services = mkOption {
      type = types.attrsOf serviceType;
      default = { };
    };
  };

  config = {
    services.nginx = {
      enable = true;

      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      virtualHosts = lib.mapAttrs' (_: service: let
        hostConfig = with lib; mkMerge [
          {
            serverName = "${service.name}.kiwivault.internal";
            serverAliases = [
              "${service.name}.kiwivault.ygg"
              "${service.name}.kiwivault.lan"
            ];

            inherit (service) default;
          }
          {
            forceSSL = true;

            sslCertificate = secrets.path "nginx-cert.cert";
            sslCertificateKey = secrets.path "nginx-cert.key";
          }
          (mkIf (service.proxyPass != null) {
            locations."/" = {
              inherit (service) proxyPass;
              proxyWebsockets = true;
            };
          })
          service.extraConfig
        ];
      in lib.nameValuePair service.name hostConfig)
      (lib.filterAttrs (_: service: service.enable) cfg.services);
    };

    secrets = {
      "nginx-cert.cert" = {
        inherit (config.services.nginx) user group;
      };
      "nginx-cert.key" = {
        inherit (config.services.nginx) user group;
      };
    };

    users.groups.keys.members = [ config.services.nginx.user ];
  };
}
