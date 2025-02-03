{ ... }:
{
  imports = [
    ./dnsproxy.nix
    ./kresd.nix
    ./postgresql.nix
    ./tor.nix
    ./webserver.nix
    ./yggdrasil.nix
  ];

  services = {
    uptimed.enable = true;
  };
}
