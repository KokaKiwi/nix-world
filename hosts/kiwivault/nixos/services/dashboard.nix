let
  port = 4000;
in {
  virtualisation.oci-containers.containers.dashboard = {
    image = "ghcr.io/ajnart/homarr:latest";
    ports = [
      "127.0.0.1:${toString port}:7575"
    ];
    volumes = [
      "dashboard-config:/app/data/configs"
      "dashboard-icons:/app/public/icons"
      "dashboard-data:/data"
    ];
  };

  webserver.services.dashboard = {
    default = true;
    proxyPass = "http://127.0.0.1:${toString port}";
  };
}
