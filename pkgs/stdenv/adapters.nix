{ pkgs, lib ? pkgs.lib, config ? pkgs.config }:
let
  defaultMkDerivationFromStdenv = let
    builder = import "${pkgs.path}/pkgs/stdenv/generic/make-derivation.nix" {
      inherit lib config;
    };
  in stdenv: (builder stdenv).mkDerivation;

  withOldMkDerivation = stdenvSuper: f: stdenvSelf: let
    mkDerivationFromStdenv = stdenvSuper.mkDerivationFromStdenv or defaultMkDerivationFromStdenv;
    mkDerivation = mkDerivationFromStdenv stdenvSelf;
  in f stdenvSelf mkDerivation;

  extendMkDerivationArgs = old: f: withOldMkDerivation old (_: mkDerivationSuper: args:
    (mkDerivationSuper args).overrideAttrs f);
in rec {
  extendDerivationAttrs = f: stdenv: stdenv.override (super: {
    mkDerivationFromStdenv = extendMkDerivationArgs super f;
  });

  overrideBintools = bintools: stdenv: stdenv.override (super: {
    cc = super.cc.override {
      inherit bintools;
    };
  });

  useLLDLinker = extendDerivationAttrs (args: {
    env.NIX_CFLAGS_LINK = toString (args.NIX_CFLAGS_LINK or "") + " -fuse-ld=lld";
  });
}
