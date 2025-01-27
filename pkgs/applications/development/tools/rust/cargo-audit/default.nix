{ lib, stdenv
, darwin

, fetchCrate

, rustPlatform

, pkg-config

, openssl
, zlib
}:
rustPlatform.buildRustPackage rec {
  pname = "cargo-audit";
  version = "0.21.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-h8fB+aA/MPeOm9w9Clf4IAR/h1yRGwUU8EoWCJ3JaMc=";
  };

  cargoHash = "sha256-Q0oXe6obI5tap4YrMGhj8X5OeWDOPRowx9ZVWE4+zcI=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    zlib
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin (with darwin.apple_sdk.frameworks; [
    Security
    SystemConfiguration
  ]);

  buildFeatures = [ "fix" ];

  # The tests require network access which is not available in sandboxed Nix builds.
  doCheck = false;

  meta = with lib; {
    description = "Audit Cargo.lock files for crates with security vulnerabilities";
    mainProgram = "cargo-audit";
    homepage = "https://rustsec.org";
    changelog = "https://github.com/rustsec/rustsec/blob/cargo-audit/v${version}/cargo-audit/CHANGELOG.md";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ basvandijk figsoda jk ];
  };
}
