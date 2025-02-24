{ pkgs, lib, ... }:
{
  services.kresd = {
    enable = true;
    package = let
      knot-resolver = pkgs.knot-resolver.override {
        extraFeatures = true;
      };
    in knot-resolver;

    extraConfig = lib.readFile ../files/kresd.conf;
  };
}
