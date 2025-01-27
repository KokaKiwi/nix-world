{ config, pkgs, ... }:
let
  packageLib = config.lib.package;
in {
  programs.ferdium = {
    enable = true;
    package = let
      ferdium = pkgs.nur.repos.kokakiwi.ferdium;
      launcher = pkgs.writeShellScript "ferdium" ''
        ELECTRON_IS_DEV=0 exec /usr/bin/electron ${ferdium}/share/ferdium "$@"
      '';
    in packageLib.wrapPackage ferdium { } ''
      rm -f $out/bin/ferdium
      cp -T ${launcher} $out/bin/ferdium
    '';
  };
}
