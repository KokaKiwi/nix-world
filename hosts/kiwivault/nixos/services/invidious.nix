{ config, pkgs, sources, ... }:
let
  cfg = config.services.invidious;

  unstablePkgs = import sources.nixpkgs { };

  port = 13000;
  companionPort = 13001;

  yaml = pkgs.formats.yaml { };
  settings = yaml.generate "invidious-settings.yml" { };
in if false then {
  virtualisation.oci-containers.containers = {
    invidious = {
      image = "quay.io/invidious/invidious:companion";
      extraOptions = [
        "--network=host"
      ];
      volumes = [ ];
    };
  };

  webserver.services.tube = {
    proxyPass = "http://127.0.0.1:${toString port}";
  };
} else {
  services.invidious = {
    enable = true;
    package = unstablePkgs.invidious;

    domain = "tube.kiwivault.internal";

    address = "127.0.0.1";
    port = 13000;

    settings = {
      db.user = "invidious";

      external_port = 443;

      https_only = true;
      statistics_enabled = true;
      captcha_enabled = false;

      default_user_preferences = {
        dark_mode = "true";
        quality = "dash";
        region = "FR";
      };
    };
  };

  webserver.services.tube = {
    proxyPass = "http://${cfg.address}:${toString cfg.port}";
  };
}
