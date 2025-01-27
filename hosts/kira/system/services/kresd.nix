{ pkgs, lib, ... }:
{
  services.kresd = {
    enable = true;
    package = let
      knot-resolver = pkgs.knot-resolver.override {
        extraFeatures = true;
      };
    in knot-resolver;

    instances = 2;

    extraConfig = lib.readFile ../files/kresd.conf;
  };
}
