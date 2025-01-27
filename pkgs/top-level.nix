{ pkgs, lib

, sources

, importSub
}:
let
  nur-kokakiwi = let
    devMode = false;
  in if devMode
  then ../../nur-packages
  else sources."nur/kokakiwi";
in rec {
  kiwiPackages = importSub ./kiwi-packages { };
  rustTools = importSub ./rust.nix { };

  stdenv-adapters = import ./stdenv/adapters.nix {
    inherit pkgs;
  };
  mkLLVMStdenv = llvmPackages: lib.pipe llvmPackages.stdenv [
    (stdenv-adapters.overrideBintools llvmPackages.bintools)
    stdenv-adapters.useLLDLinker
  ];
  llvmStdenv = mkLLVMStdenv kiwiPackages.llvmPackages;

  fenix = import sources.fenix {
    inherit pkgs lib;
  };

  nixgl = import sources.nixgl {
    inherit pkgs;
    enable32bits = false;
  };

  nur = import sources.nur {
    nurpkgs = pkgs;
    inherit pkgs;

    repoOverrides = {
      kokakiwi = import nur-kokakiwi {
        inherit pkgs;
      };
    };
  };
}
