{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  zstd,
  stdenv,
  darwin,
}:
rustPlatform.buildRustPackage rec {
  pname = "cargo-deny";
  version = "0.18.1";

  src = fetchFromGitHub {
    owner = "EmbarkStudios";
    repo = "cargo-deny";
    rev = version;
    hash = "sha256-BP8j1FsrS9dXXneRoh6CkKaOFLlRPJn+r23dDnoay5o=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-z+l5CJ/20xkY6ZnFT9r1tVamzhzgDiehgmZFdjg2L6A=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    zstd
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  # tests require internet access
  doCheck = false;

  meta = with lib; {
    description = "Cargo plugin to generate list of all licenses for a crate";
    mainProgram = "cargo-deny";
    homepage = "https://github.com/EmbarkStudios/cargo-deny";
    changelog = "https://github.com/EmbarkStudios/cargo-deny/blob/${version}/CHANGELOG.md";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [
      figsoda
      matthiasbeyer
      jk
    ];
  };
}
