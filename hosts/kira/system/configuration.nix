{ ... }:
{
  imports = [
    ./services
  ];

  networking.firewall.enable = false;
}
