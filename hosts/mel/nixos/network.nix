{ ... }:
{
  imports = [
    ./network/wireguard.nix
    ./network/yggdrasil.nix
  ];

  networking.hostName = "mel";

  networking.nftables.enable = true;
  networking.firewall = {
    enable = true;
  };
}
