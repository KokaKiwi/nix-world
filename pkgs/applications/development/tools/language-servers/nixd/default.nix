{ lib, stdenv

, fetchFromGitHub

, meson
, cmake
, ninja
, python3
, pkg-config

, gtest
, boost
, nlohmann_json
, nix
, llvmPackages

, nixf
, nixt
}:
let
  common = rec {
    version = "2.6.0";

    src = fetchFromGitHub {
      owner = "nix-community";
      repo = "nixd";
      rev = version;
      hash = "sha256-gYC7nbZsTDOA1cJIw9JRjwjgkvSzrlQonGTT21EZeWM=";
    };

    nativeBuildInputs = [
      meson
      ninja
      python3
      pkg-config
    ];

    mesonBuildType = "release";

    strictDeps = true;

    doCheck = true;

    meta = {
      homepage = "https://github.com/nix-community/nixd";
      changelog = "https://github.com/nix-community/nixd/releases/tag/${version}";
      license = lib.licenses.lgpl3Plus;
      maintainers = with lib.maintainers; [
        inclyc
        Ruixi-rebirth
        aleksana
        redyf
      ];
      platforms = lib.platforms.unix;
    };
  };
in {
  pname = "nixd";
  inherit (common) version;

  nixf = stdenv.mkDerivation (common // {
    pname = "nixf";

    sourceRoot = "${common.src.name}/libnixf";

    outputs = [
      "out"
      "dev"
    ];

    buildInputs = [
      gtest
      boost
      nlohmann_json
    ];

    meta = common.meta // {
      description = "Nix language frontend, parser & semantic analysis";
      mainProgram = "nixf-tidy";
    };
  });

  nixt = stdenv.mkDerivation (common // {
    pname = "nixt";

    sourceRoot = "${common.src.name}/libnixt";

    outputs = [
      "out"
      "dev"
    ];

    buildInputs = [
      nix
      gtest
      boost
    ];

    env.CXXFLAGS = "-include ${nix.dev}/include/nix/config.h";

    meta = common.meta // {
      description = "Supporting library that wraps C++ nix";
    };
  });

  nixd = stdenv.mkDerivation (common // {
    pname = "nixd";

    sourceRoot = "${common.src.name}/nixd";

    buildInputs = [
      nix
      nixf
      nixt
      llvmPackages.llvm
      gtest
      boost
    ];

    nativeBuildInputs = common.nativeBuildInputs ++ [ cmake ];

    env.CXXFLAGS = "-include ${nix.dev}/include/nix/config.h";

    # See https://github.com/nix-community/nixd/issues/519
    doCheck = false;

    meta = common.meta // {
      description = "Feature-rich Nix language server interoperating with C++ nix";
      mainProgram = "nixd";
    };
  });
}
