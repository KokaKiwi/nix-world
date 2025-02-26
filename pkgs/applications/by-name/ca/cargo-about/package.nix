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
  pname = "cargo-about";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "EmbarkStudios";
    repo = "cargo-about";
    rev = version;
    sha256 = "sha256-ZqQLMjvwnmUqQNP5A5je5UliU25ng0dC5hvdDwaH/pM=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-LDY2uQAlJctjEoT48shBktBEcO+OOlWZwcFk23P+y+U=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    zstd
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  meta = with lib; {
    description = "Cargo plugin to generate list of all licenses for a crate";
    homepage = "https://github.com/EmbarkStudios/cargo-about";
    changelog = "https://github.com/EmbarkStudios/cargo-about/blob/${version}/CHANGELOG.md";
    license = with licenses; [
      mit # or
      asl20
    ];
    maintainers = with maintainers; [
      evanjs
      figsoda
      matthiasbeyer
    ];
    mainProgram = "cargo-about";
  };
}
