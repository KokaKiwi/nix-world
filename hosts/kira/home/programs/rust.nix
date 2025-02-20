{ config, pkgs, lib, ... }:
let
  cfg = config.programs.rust;

  llvmPackages = pkgs.llvmPackages_latest;

  mkStablePackage = drv: drv.override {
    inherit (pkgs.rustTools.rust) rustPlatform;
  };

  cargoPlugins = [
    "about" "binutils" "bloat" "cache" "criterion"
    "nextest" "expand" "deny" "outdated"
    "show-asm" "msrv" "depgraph" "udeps"
    "ndk" "tarpaulin" "cross" "release"
    "wipe" "sort" "leptos" "component"
    "c-next" "make" "audit" "pgo"
    "semver-checks" "edit"
  ];
  extraPackages = [
    (pkgs.kiwiPackages.cargo-setup-project.override {
      cargoBin = "cargo-mommy";
    })
    (mkStablePackage pkgs.nur.repos.kokakiwi.streampager)
  ] ++ (with pkgs; [
    rust-bindgen
    wasm-tools
    wit-bindgen
    worker-build
    kiwiPackages.cargo-pgrx
  ]);
in {
  home.packages = map (pluginName: pkgs."cargo-${pluginName}") cargoPlugins
    ++ extraPackages;

  programs.rust = {
    cargoConfig = {
      build = {
        jobs = 6;

        rustc-wrapper = "${config.programs.sccache.package}/bin/sccache";
      };

      alias = {
        gen = "generate";
      };

      target.x86_64-unknown-linux-gnu = {
        linker = "${llvmPackages.clang}/bin/clang";
      };

      profile.dev = {
        opt-level = 0;
        debug = 2;
        incremental = true;
        codegen-units = 512;
      };
      profile.release-plus = {
        opt-level = 3;
        lto = "thin";
        incremental = false;
        codegen-units = 1;
        split-debuginfo = "off";
      };

      registries.crates-io = {
        protocol = "sparse";
      };
    };

    cargo-generate = {
      enable = true;

      config = {
        favorites = let
          templates = {
            leptos = { };
          };
        in lib.mapAttrs (name: config: {
          path = toString ../files/cargo-templates/${name};
        }) templates;
      };
    };

    cargo-mommy = {
      enable = true;
      package = mkStablePackage pkgs.cargo-mommy;

      config = {
        roles = "mxtress";
        pronouns = "their";
        little = [ "bot" "drone" "doll" "toy" ];
      };
    };
  };

  programs.fish = {
    functions = {
      cargo = ''
        if test "$SAFE_CARGO" = "1"
          command cargo $argv
        else
          ${cfg.cargo-mommy.package}/bin/cargo-mommy $argv
        end
      '';
    };
  };
}
