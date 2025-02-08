{ lib, stdenv, darwin

, fetchFromGitHub

, rustPlatform

, pkg-config

, bzip2
, openssl
, zlib
}:
rustPlatform.buildRustPackage rec {
  pname = "cargo-pgrx";
  version = "0.12.9";

  src = fetchFromGitHub {
    owner = "pgcentralfoundation";
    repo = "pgrx";
    rev = "v${version}";
    hash = "sha256-LXcL4zGRDA5NlznrFZeNnfVYX/waUPGvlqtSUXnJoys=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-uVwmjY6hCSpCrfhNBmSeOh8UtGHVDL1ET/K08/K8q3c=";

  cargoBuildFlags = [ "-p" "cargo-pgrx" ];
  cargoTestFlags = cargoBuildFlags;

  nativeBuildInputs = lib.optionals stdenv.isLinux [
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.isLinux [
    bzip2
    openssl
    zlib
  ] ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    Security
  ]);

  checkFlags = [
    "--skip=command::schema::tests::test_parse_managed_postmasters"
  ];

  meta = with lib; {
    description = "Build Postgres Extensions with Rust";
    homepage = "https://github.com/pgcentralfoundation/pgrx";
    changelog = "https://github.com/pgcentralfoundation/pgrx/releases/tag/v${version}";
    license = licenses.mit;
    mainProgram = "cargo-pgrx";
  };
}
