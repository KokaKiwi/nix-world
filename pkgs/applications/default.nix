{ pkgs, sources, util }:
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
in util.callPackagesRecursive {
  directory = ./.;

  inherit callPackage;

  overrides = {
    activate-linux._override = true;
    commitizen._callPackage = pkgs.python3Packages.callPackage;
    kitty = {
      go = pkgs.go_1_23;
      buildGoModule = pkgs.buildGo123Module;
    };
    module-server = {
      inherit (rustTools.stable) cargo;
    };
    syncthingtray._callPackage = kdePackages.callPackage;
    tor = {
      _override = true;

      systemd = pkgs.systemdMinimal;
    };
    vesktop = {
      pnpm = pkgs.pnpm_9;
    };
  };
} // {
  fixx = callPackage "${sources.ixx}/fixx/derivation.nix" { };
  ixx = callPackage "${sources.ixx}/ixx/derivation.nix" { };
  inherit (nixd) nixf nixt nixd;
}
