{ pkgs, util }:
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
    b3sum._override = true;
    cargo-about = {
      inherit (rustTools.stable) rustPlatform;
    };
    cargo-deny = {
      inherit (rustTools.stable) rustPlatform;
    };
    cargo-udeps._override = true;
    commitizen._callPackage = pkgs.python3Packages.callPackage;
    kitty = {
      go = pkgs.go_1_23;
      buildGoModule = pkgs.buildGo123Module;
    };
    mise = {
      inherit (rustTools.stable) rustPlatform;
    };
    module-server = {
      inherit (rustTools.stable) cargo;
    };
    rustowl = drv: let
      toolchain = pkgs.fenix.fromToolchainFile {
        dir = "${drv.src}/rustowl";
      };

      rustPlatform = pkgs.rustTools.makeRustPlatform toolchain;
    in {
      inherit rustPlatform;
    };
    syncthingtray._callPackage = kdePackages.callPackage;
    tor = {
      _override = true;

      systemd = pkgs.systemdMinimal;
    };
  };
} // {
  inherit (nixd) nixf nixt nixd;
}
