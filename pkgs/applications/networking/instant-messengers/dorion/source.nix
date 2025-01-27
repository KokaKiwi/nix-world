{ lib, stdenv

, fetchurl
, fetchFromGitHub

, rust
, rustPlatform
, pnpm

, cargo
, rustc
, nodejs
, pkg-config
, wrapGAppsHook3

, openssl
, gtk3
, webkitgtk_4_1
, libappindicator
, libayatana-appindicator
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "dorion";
  version = "6.2.0";

  src = fetchFromGitHub {
    owner = "SpikeHD";
    repo = "Dorion";
    rev = "v${finalAttrs.version}";
    hash = "sha256-7isOL/853IMOUkepbu81INNFgjTHpo9dyvPaxMkBU1U=";
  };

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-Exl70+eeGpzn84Wt4RzEfA12fVASuJkVXYgR1dvXL3U=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "rsrpc-0.16.4" = "sha256-UQR9y06T7/bai5s7Re9RxQaUmJ/XBQbwtJBP9rBaNzk=";
      "simple-websockets-0.1.6" = "sha256-iySzwntHw5Wf5HwKMBYL8mrMl7kjGZrZonL7/zrkeCo=";
      "window_titles-0.1.0" = "sha256-lk2T+6curAwqOUuQ8RtYCjX2ygGBgzt4ILBAMV+ql0w=";
    };
  };
  cargoRoot = "src-tauri";

  shelterInjector = let
    commit = "1971f9ab320038d94f314b3c45c47ae8add6ab0b";
  in fetchurl {
    url = "https://raw.githubusercontent.com/uwu/shelter-builds/${commit}/shelter.js";
    hash = "sha256-dxCZd4W3Hxk7mPC6jqXbJWaoqyMr2ll5IdPESElvjMo=";
  };

  updater = rustPlatform.buildRustPackage {
    name = "${finalAttrs.pname}-updater-${finalAttrs.version}";
    src = "${finalAttrs.src}/updater";

    cargoHash = "sha256-Q0yA4utoZTK/ugx5m0qogswKBUPKsHs5Ho4Qi69cMjo=";

    nativeBuildInputs = [
      pkg-config
    ];

    buildInputs = [
      openssl
    ];

    doCheck = false;
  };

  postPatch = ''
    rm src-tauri/Cargo.lock
    ln -s ${./Cargo.lock} src-tauri/Cargo.lock
  '';

  patches = [
    ./remove-patches.patch
  ];

  nativeBuildInputs = [
    pnpm.configHook
    rustPlatform.cargoSetupHook

    cargo
    rustc
    nodejs

    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    openssl
    gtk3
    webkitgtk_4_1
    libappindicator
    libayatana-appindicator
  ];

  buildPhase = ''
    runHook preBuild

    cargoBuildType="''${cargoBuildType:-release}"
    export "CARGO_PROFILE_''${cargoBuildType@U}_STRIP"=false

    export CARGO_TARGET_DIR="$(pwd)/target"

    cp $shelterInjector src-tauri/injection/shelter.js
    cp -t src-tauri $updater/bin/updater*

    ${rust.envVars.setEnv} pnpm tauri build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/SpikeHD/Dorion";
    description = "Tiny alternative Discord client";
    license = licenses.gpl3Only;
    mainProgram = "dorion";
  };
})
