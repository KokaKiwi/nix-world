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
}
