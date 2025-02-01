{ sources, ... }:
{
  imports = [
    "${sources.catppuccin}/modules/home-manager"
    "${sources.declarative-cachix}/home-manager.nix"

    ./lib/package.nix
    ./lib/python.nix

    ./misc/data.nix
    ./misc/env.nix
    ./misc/home.nix
    ./misc/nix.nix
    ./misc/opengl.nix
    ./misc/upgrade-diff.nix

    ./programs/act.nix
    ./programs/aura.nix
    ./programs/bpython.nix
    ./programs/discord.nix
    ./programs/element.nix
    ./programs/eza.nix
    ./programs/ferdium.nix
    ./programs/fish.nix
    ./programs/gajim.nix
    ./programs/git.nix
    ./programs/glab.nix
    ./programs/glances.nix
    ./programs/glow.nix
    ./programs/hub.nix
    ./programs/kde.nix
    ./programs/kitty.nix
    ./programs/lan-mouse.nix
    ./programs/litecli.nix
    ./programs/mise.nix
    ./programs/mux.nix
    ./programs/neovim.nix
    ./programs/nix-init.nix
    ./programs/nvchecker.nix
    ./programs/paru.nix
    ./programs/pgcli.nix
    ./programs/powerline.nix
    ./programs/ptpython.nix
    ./programs/rust.nix
    ./programs/silicon.nix
    ./programs/ssh.nix
    ./programs/starship.nix
    ./programs/szurubooru-cli.nix
    ./programs/taplo.nix
    ./programs/tmux.nix
    ./programs/xh.nix

    ./services/aria2.nix
    ./services/gitify.nix
    ./services/kubo.nix
    ./services/module-server.nix
    ./services/nix-web.nix
    ./services/solaar.nix
    ./services/tmux.nix
  ];
}
