{ ... }:
{
  imports = [
    ./lib.nix

    ./misc

    ./systemd.nix

    ./config/networking.nix
    ./config/nix.nix

    ./networking/firewall.nix

    ./security/dhparams.nix

    ./services/databases/postgresql.nix
    ./services/monitoring/osquery.nix
    ./services/networking/dnsproxy.nix
    ./services/networking/kresd.nix
    ./services/networking/yggdrasil.nix
    ./services/security/tor.nix
    ./services/security/vanta-agent.nix
    ./services/system/nix-daemon.nix
    ./services/system/uptimed.nix
  ];
}
