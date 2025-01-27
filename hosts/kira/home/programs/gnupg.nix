{ pkgs, ... }:
{
  programs.gpg = {
    enable = true;
    package = pkgs.kiwiPackages.gnupg;

    settings = {
      keyserver = "hkps://keys.openpgp.org";
    };
  };
}
