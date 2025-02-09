{ pkgs, lib, ... }:
{
  imports = [
    ./misc
    ./programs
    ./services
  ]
  ++ lib.optional (builtins.pathExists ./private) ./private;

  home.stateVersion = "24.05";

  home.username = "kokakiwi";
  home.homeDirectory = "/home/kokakiwi";

  home.preferXdgDirectories = true;
  home.enableDebugInfo = true;

  targets.genericLinux.enable = true;

  xdg = {
    enable = true;
    mime.enable = false;
  };

  nix.gc.automatic = true;

  news.display = "silent";

  i18n.glibcLocales = pkgs.glibcLocales.override {
    allLocales = false;
    locales = [
      "fr_FR.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
      "en_GB.UTF-8/UTF-8"
    ];
  };
}
