{ config, ... }:
let
  inherit (config.lib) secrets;

  port = 4001;

  environment = {
    SELF_HOSTED = "true";
    RAILS_FORCE_SSL = "false";
    RAILS_ASSUME_SSL = "false";
    GOOD_JOB_EXECUTION_MODE = "async";
    DB_HOST = "maybe-db";
    POSTGRES_DB = "maybe";
    POSTGRES_USER = "maybe";
  };
  environmentFiles = [
    (secrets.path "maybe.env")
  ];
in {
  virtualisation.oci-containers.containers = {
    maybe = {
      image = "ghcr.io/maybe-finance/maybe:latest";
      ports = [
        "127.0.0.1:${toString port}:3000"
      ];
      dependsOn = [ "maybe-db" ];
      inherit environment environmentFiles;
      volumes = [
        "maybe-app-data:/rails/storage"
      ];
    };
    maybe-db = {
      image = "postgres:17-alpine";
      inherit environment environmentFiles;
      volumes = [
        "maybe-db-data:/var/lib/postgresql/data"
      ];
    };
  };

  secrets."maybe.env" = { };

  webserver.services.maybe = {
    proxyPass = "http://127.0.0.1:${toString port}";
  };
}
