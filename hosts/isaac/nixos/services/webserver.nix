{ pkgs, ... }:
{
  services.nginx = {
    package = pkgs.nginxQuic;

    appendConfig = ''
      worker_processes auto;
    '';
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "kokakiwi+letsencrypt@kokakiwi.net";
  };
}
