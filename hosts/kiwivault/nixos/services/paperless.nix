{ config, pkgs, lib, ... }:
let
  cfg = config.services.paperless;
in {
  services.paperless = {
    enable = false;

    package = pkgs.paperless-ngx.overridePythonAttrs (prev: {
      disabledTests = prev.disabledTests ++ [
        # Flaky tests
        "test_rtl_language_detection"
      ];
    });

    dataDir = "/var/data/paperless";
    passwordFile = config.lib.secrets.path "paperless-admin-password";

    settings = {
      PAPERLESS_OCR_LANGUAGE = "fra";
    };
  };

  secrets."paperless-admin-password" = lib.mkIf cfg.enable {
    inherit (cfg) user;
    inherit (config.users.users.${cfg.user}) group;
  };

  users.groups.keys.members = lib.mkIf cfg.enable [ cfg.user ];

  webserver.services.paperless = lib.mkIf cfg.enable {
    proxyPass = "http://${cfg.address}:${toString cfg.port}";
  };
}
