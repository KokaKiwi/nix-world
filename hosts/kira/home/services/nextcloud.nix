{ config, pkgs, ... }:
{
  services.nextcloud-client = {
    enable = true;
    package = with config.lib; opengl.wrapPackage pkgs.nextcloud-client { };
    startInBackground = true;
  };
}
