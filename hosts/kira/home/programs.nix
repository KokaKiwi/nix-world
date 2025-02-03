{ ... }:
{
  imports = [
    ./programs/act.nix
    ./programs/aura.nix
    ./programs/bash.nix
    ./programs/bat.nix
    ./programs/bpython.nix
    ./programs/discord.nix
    ./programs/element.nix
    ./programs/ferdium.nix
    ./programs/fish.nix
    ./programs/gajim.nix
    ./programs/gdb.nix
    ./programs/gh.nix
    ./programs/git.nix
    ./programs/gnupg.nix
    ./programs/hyfetch.nix
    ./programs/kde.nix
    ./programs/kitty.nix
    ./programs/litecli.nix
    ./programs/llvm.nix
    ./programs/man.nix
    ./programs/mise.nix
    ./programs/mux.nix
    ./programs/neovim.nix
    ./programs/nix-index.nix
    ./programs/nushell.nix
    ./programs/nvchecker.nix
    ./programs/openssh.nix
    ./programs/password-store.nix
    ./programs/pgcli.nix
    ./programs/process-compose.nix
    ./programs/ptpython.nix
    ./programs/rust.nix
    ./programs/sccache.nix
    ./programs/silicon.nix
    ./programs/starship.nix
    ./programs/taplo.nix
    ./programs/tmux.nix
    ./programs/vscode.nix
    ./programs/xh.nix
    ./programs/yazi.nix
  ];

  programs = {
    aura.enable = true;
    fd.enable = true;
    gitui.enable = true;
    glab.enable = true;
    glances.enable = true;
    glow.enable = true;
    hub.enable = true;
    nix-init.enable = true;
    szurubooru-cli.enable = true;
    yt-dlp.enable = true;
    zoxide.enable = true;
  };
}
