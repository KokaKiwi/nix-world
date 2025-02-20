{ pkgs, lib }:
let
  makeRustPlatform = rustToolchain: let
    rustToolchain' = rustToolchain // {
      targetPlatforms = rustToolchain.targetPlatforms or pkgs.rustc.targetPlatforms;
      tier1TargetPlatforms = rustToolchain.tier1TargetPlatforms or pkgs.rustc.tier1TargetPlatforms;
      badTargetPlatforms = rustToolchain.badTargetPlatforms or pkgs.rustc.badTargetPlatforms;
    };
  in pkgs.makeRustPlatform {
    rustc = rustToolchain';
    cargo = rustToolchain';
  } // {
    override = args: pkgs.makeRustPlatform (args // {
      rustc = rustToolchain';
      cargo = rustToolchain';
    });
  };

  versions = rec {
    rust_1_79 = {
      channel = "1.79.0";
      hash = "sha256-Ngiz76YP4HTY75GGdH2P+APE/DEIx2R/Dn+BwwOyzZU=";
    };
    rust_1_80 = {
      channel = "1.80.1";
      hash = "sha256-3jVIIf5XPnUU1CRaTyAiO0XHVbJl12MSx3eucTXCjtE=";
    };
    rust_1_81 = {
      channel = "1.81.0";
      hash = "sha256-VZZnlyP69+Y3crrLHQyJirqlHrTtGTsyiSnZB8jEvVo=";
    };
    rust_1_82 = {
      channel = "1.82.0";
      hash = "sha256-yMuSb5eQPO/bHv+Bcf/US8LVMbf/G/0MSfiPwBhiPpk=";
    };
    rust_1_83 = {
      channel = "1.83.0";
      hash = "sha256-s1RPtyvDGJaX/BisLT+ifVfuhDT1nZkZ1NcK8sbwELM=";
    };
    rust_1_84 = {
      channel = "1.84.1";
      hash = "sha256-vMlz0zHduoXtrlu0Kj1jEp71tYFXyymACW8L4jzrzNA=";
    };

    stable = rust_1_84;
    rust = stable;
  };

  rustToolchains = let
    mkToolchain = {
      channel,
      hash ? lib.fakeHash,
      extraComponents ? [ ],
    }: with pkgs.fenix; let
      toolchain = toolchainOf {
        inherit channel;
        sha256 = hash;
      };
    in combine ([
      toolchain.rustc
      toolchain.cargo
      toolchain.rust-src
    ] ++ map (componentName: toolchain.${componentName}) extraComponents);
  in lib.mapAttrs (name: attrs:
    mkToolchain attrs
  ) versions;

  rustPlatforms = lib.mapAttrs (name: attrs:
    makeRustPlatform rustToolchains.${name}
  ) versions;
in {
  inherit makeRustPlatform;
  inherit rustToolchains rustPlatforms;
} // lib.mapAttrs (name: attrs: rec {
  rustPlatform = rustPlatforms.${name};
  rustToolchain = rustToolchains.${name};

  rustc = rustToolchain;
  cargo = rustToolchain;
}) versions
