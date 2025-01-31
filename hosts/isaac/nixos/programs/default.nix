{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    htop bat
  ];
}
