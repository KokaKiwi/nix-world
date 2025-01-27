{ pkgs, ... }:
{
  services.gpg-agent = {
    enable = true;

    enableSshSupport = true;

    defaultCacheTtl = 2592000;
    maxCacheTtl = 2592000;

    pinentryPackage = pkgs.pinentry-curses;
  };
}
