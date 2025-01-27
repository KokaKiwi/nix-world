{ lib, ... }:
let
  serviceType = with lib; types.submodule ({ name, config, ... }: let
    serviceName = name;

    credentialOption = types.submodule ({ name, ... }: {
      options = {
        source = mkOption {
          type = types.path;
        };

        path = mkOption {
          type = types.path;
          readOnly = true;
        };
      };

      config = {
        path = "/run/credentials/${serviceName}.service/${name}";
      };
    });
  in {
    options.credentials = mkOption {
      type = types.attrsOf credentialOption;
      default = { };
    };

    config = {
      serviceConfig.LoadCredential = lib.mapAttrsToList (credentialName: credential:
        "${credentialName}:${credential.source}"
      ) config.credentials;
    };
  });
in {
  options.systemd.services = with lib; mkOption {
    type = types.attrsOf serviceType;
  };

  config = {
    lib.systemd = {
      systemService = {
        wantedBy = lib.mkForce [ "system-manager.target" ];

        serviceConfig = {
          DynamicUser = lib.mkForce true;
          User = lib.mkForce null;
          Group = lib.mkForce null;
        };
      };
    };
  };
}
