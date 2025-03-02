{ pkgs, ... }:
{
  services.nginx = {
    package = pkgs.nginxQuic.override {
      modules = [ ];
    };

    appendConfig = ''
      worker_processes auto;
    '';
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "kokakiwi+letsencrypt@kokakiwi.net";
  };
}
