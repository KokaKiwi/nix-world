{ ... }:
{
  imports = [
    ./backups.nix
    ./gotosocial.nix
    ./openssh.nix
    ./postgresql.nix
    ./prometheus-exporters.nix
    ./webserver.nix
  ];

  services = {
    uptimed.enable = true;
  };
}
