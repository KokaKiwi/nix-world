{ pkgs, sources }:
let
  inherit (pkgs) kiwiPackages;
  inherit (pkgs) kdePackages rustTools;
  callPackage = kiwiPackages.callPackageIfNewer;

  nixd = callPackage ./development/tools/language-servers/nixd {
    _override = true;

    llvmPackages = pkgs.llvmPackages_19;

    _overrideArgs = {
      nix = pkgs.nixVersions.stable_upstream;
    };
  };
in {
  activate-linux = callPackage ./misc/activate-linux {
    _override = true;
  };
  bitwarden-cli = callPackage ./misc/bitwarden-cli { };
  cargo-c-next = callPackage ./development/tools/rust/cargo-c { };
  cargo-shell = callPackage ./development/tools/rust/cargo-shell { };
  fixx = callPackage "${sources.ixx}/fixx/derivation.nix" { };
  hoppscotch = callPackage ./by-name/ho/hoppscotch { };
  ixx = callPackage "${sources.ixx}/ixx/derivation.nix" { };
  kitty = callPackage ./terminal-emulators/kitty {
    go = pkgs.go_1_23;
    buildGoModule = pkgs.buildGo123Module;
  };
  kitty-themes = callPackage ./terminal-emulators/kitty/themes.nix { };
  mise = callPackage ./development/tools/mise { };
  module-server = callPackage ./misc/module-server {
    inherit (rustTools.stable) cargo;
  };
  mux = callPackage ./misc/mux { };
  inherit (nixd) nixf nixt nixd;
  syncthing = callPackage ./networking/syncthing { };
  syncthingtray = kdePackages.callPackage ./misc/syncthingtray { };
  szurubooru-cli = callPackage ./misc/booru-cli { };
  tor = callPackage ./tools/security/tor {
    _override = true;

    systemd = pkgs.systemdMinimal;
  };
  usage = callPackage ./tools/usage { };
  vesktop = callPackage ./misc/vesktop {
    pnpm = pkgs.pnpm_9;
  };
  xinspect = callPackage ./development/tools/xinspect { };
  yt-dlp = callPackage ./misc/yt-dlp { };
}
