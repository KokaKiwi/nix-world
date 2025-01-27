{ lib

, fetchFromGitHub

, rustPlatform

, pkg-config
, bzip2
, openssl
}:
rustPlatform.buildRustPackage rec {
  pname = "cargo-make";
  version = "0.37.24";

  src = fetchFromGitHub {
    owner = "sagiegurari";
    repo = "cargo-make";
    rev = version;
    hash = "sha256-hrUd4J15cDyd78BVVzi8jiDqJI1dE35WUdOo6Tq8gH8=";
  };

  cargoHash = "sha256-kSoEqiaKeS0VYk7MTir6twY/gXJWjEbS+nFlC3CH8HU=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    bzip2
    openssl
  ];

  # Some tests fail because they need network access.
  # However, Travis ensures a proper build.
  # See also:
  #   https://travis-ci.org/sagiegurari/cargo-make
  doCheck = false;

  meta = with lib; {
    description = "Rust task runner and build tool";
    homepage = "https://github.com/sagiegurari/cargo-make";
    changelog = "https://github.com/sagiegurari/cargo-make/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda xrelkd ];
    mainProgram = "cargo-make";
  };
}
