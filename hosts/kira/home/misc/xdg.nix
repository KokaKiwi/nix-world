{ pkgs, lib, ... }:
{
  home.activation = {
    updateDesktopMenu = lib.hm.dag.entryAfter ["writeBoundary"] ''
      ${pkgs.xdg-utils}/bin/xdg-desktop-menu forceupdate --mode user
    '';
  }
  ;
}
