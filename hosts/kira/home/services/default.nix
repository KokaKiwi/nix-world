{ ... }:
{
  imports = [
    ./activate-linux.nix
    ./aria2.nix
    ./espanso.nix
    ./gpg-agent.nix
    ./kubo.nix
    ./nextcloud.nix
    ./nix-web.nix
    ./podman.nix
    ./pueue.nix
    ./syncthing.nix
  ];

  services = {
    module-server.enable = true;
    solaar.enable = true;
    tmux.enable = true;
  };
}
