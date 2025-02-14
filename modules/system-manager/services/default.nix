{
  imports = [
    ./databases/postgresql.nix
    ./monitoring/osquery.nix
    ./networking/dnsproxy.nix
    ./networking/kresd.nix
    ./networking/yggdrasil.nix
    ./security/tor.nix
    ./security/vanta-agent.nix
    ./system/nix-daemon.nix
    ./system/uptimed.nix
    ./web-servers/edgee.nix
  ];
}
