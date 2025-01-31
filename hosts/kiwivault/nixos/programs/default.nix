{ pkgs, ... }:
{
  imports = [
    ./neovim.nix
  ];

  cluster.programs = {
    eza.enable = true;
    htop.enable = true;
  };

  environment.systemPackages = with pkgs; [
    bat mediainfo pipe-rename
    ncdu jq mkvtoolnix-cli
    yt-dlp
    smartmontools usbutils
    ffmpeg_7
    lsof
  ];
}
