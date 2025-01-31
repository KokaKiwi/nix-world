{ pkgs, ... }:
{
  imports = [
    ./firewall.nix
    ./shadowsocks.nix
    ./systemd-networkd.nix
    ./yggdrasil.nix
  ];

  networking.hostName = "kiwivault";
  networking.nameservers = [
    "192.168.1.1"
  ];

  environment.systemPackages = with pkgs; [
    wireguard-tools
  ];
}
