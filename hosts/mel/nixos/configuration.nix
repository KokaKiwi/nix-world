{ pkgs, sources, ... }:
{
  imports = [
    ../../_shared

    "${sources.vpsadminos}/os/lib/nixos-container/vpsadminos.nix"
    "${sources.srvos}/nixos/common/update-diff.nix"

    ./network.nix

    ./users/nixos

    ./programs/neovim.nix

    ./services/openssh.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = [ "root" "nixos" ];

  time.timeZone = "Europe/Paris";

  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;

  security.sudo.wheelNeedsPassword = false;

  boot.systemdExecutable = "/run/current-system/systemd/lib/systemd/systemd";
  systemd.extraConfig = ''
    DefaultTimeoutStartSec = 900s
  '';
  services.dbus.implementation = "broker";

  cluster.programs = {
    eza.enable = true;
    htop.enable = true;
  };

  fileSystems."/mnt/nas" = {
    device = "172.16.130.253:/nas/5803/vps-25707";
    fsType = "nfs";
    options = [ "nofail" ];
  };

  environment.systemPackages = with pkgs; [
    bat
  ];

  system.stateVersion = "23.11";
}
