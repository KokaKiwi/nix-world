{ ... }:
{
  services.kubo = {
    enable = true;

    settings = {
      API.HTTPHeaders = {
        Access-Control-Allow-Origin = [ "*" ];
      };
    };
  };
}
