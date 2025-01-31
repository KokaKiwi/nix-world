{ config, lib, ... }:
let
  inherit (config.lib) secrets;

  secretType = with lib; types.submodule {
    freeformType = types.attrs;

    options = { };
  };

  extraServiceType = with lib; types.submodule ({ config, ... }: {
    options = {
      secrets = mkOption {
        type = with types; listOf str;
        default = [ ];
      };
    };

    config = {
      serviceConfig.LoadCredential = map (name:
        "${name}:${secrets.path name}"
      ) config.secrets;
    };
  });
in {
  options = with lib; {
    secrets = mkOption {
      type = types.attrsOf secretType;
      default = { };
    };

    systemd.services = mkOption {
      type = types.attrsOf extraServiceType;
    };
  };

  config = {
    sops.secrets = lib.mapAttrs secrets.define config.secrets;

    lib.secrets = rec {
      define = name: keyConfig: keyConfig;

      get = name: config.sops.secrets.${name};
      path = name: (get name).path;
    };
  };
}
