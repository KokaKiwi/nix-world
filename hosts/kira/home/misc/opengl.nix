{ pkgs, ... }:
{
  opengl = {
    vaDrivers = with pkgs; [ intel-media-driver ];
  };
}
