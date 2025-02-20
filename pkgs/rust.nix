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
    rust_1_83 = {
      channel = "1.83.0";
      hash = "sha256-s1RPtyvDGJaX/BisLT+ifVfuhDT1nZkZ1NcK8sbwELM=";
    };
    rust_1_84 = {
      channel = "1.84.1";
      hash = "sha256-vMlz0zHduoXtrlu0Kj1jEp71tYFXyymACW8L4jzrzNA=";
    };
    rust_1_85 = {
      channel = "1.85.0";
      hash = "sha256-AJ6LX/Q/Er9kS15bn9iflkUwcgYqRQxiOIL2ToVAXaU=";
    };

    stable = rust_1_85;
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
