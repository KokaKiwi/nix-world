{ pkgs, ... }:
{
  services.postgresql = {
    enable = true;
    enableJIT = true;
    package = pkgs.postgresql_17;
    extensions = ps: with ps; [ postgis ];

    ensureDatabases = [ "praise" "baloto" ];
    ensureUsers = [
      {
        name = "praise";
        ensureDBOwnership = true;
      }
      {
        name = "baloto";
        ensureDBOwnership = true;
      }
    ];

    authentication = ''
      local all all trust
      host all all 127.0.0.1/32 trust
    '';

    initdbArgs = [
      "--data-checksums"
    ];
  };
}
