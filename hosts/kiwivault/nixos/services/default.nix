{ ... }:
{
  imports = [
    ./monitoring

    ./borgbackup.nix
    ./dashboard.nix
    ./gonic.nix
    ./invidious.nix
    ./jellyfin.nix
    ./libvirt.nix
    ./maybe.nix
    ./paperless.nix
    ./pueue.nix
    ./qbittorrent.nix
    ./samba.nix
    ./syncthing.nix
    ./webserver.nix
  ];

  services.uptimed.enable = true;

  virtualisation.oci-containers.backend = "podman";
}
