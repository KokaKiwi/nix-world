{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.programs.password-store;
in {
  home.packages = mkIf cfg.enable (with pkgs; [
    docker-credential-helpers
  ]);

  programs.password-store = {
    enable = true;
    package = let
      pass = pkgs.pass.override {
        dmenuSupport = false;
        x11Support = false;
        waylandSupport = true;

        inherit pass;
      };
    in pass.withExtensions (exts: with exts; [
      pass-file
      pass-otp
    ]);
  };
}
