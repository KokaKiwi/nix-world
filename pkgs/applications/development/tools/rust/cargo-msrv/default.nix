{ lib

, fetchFromGitHub

, rustPlatform

, pkg-config
, makeWrapper

, openssl
, rustup
}:
rustPlatform.buildRustPackage rec {
  pname = "cargo-msrv";
  version = "0.17.1";

  src = fetchFromGitHub {
    owner = "foresterre";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-cRdnx9K+EkVEKtPxQk+gXK6nkgkpWhpYij/5e7pFzMU=";
  };

  cargoHash = "sha256-Hs/bdDpJFQ0w+Ds2L5at06Sw3F+5bXu5HU798gR9/9Q=";

  # Integration tests fail
  doCheck = false;

  nativeBuildInputs = [ pkg-config makeWrapper ];

  buildInputs = [ openssl ];

  # Depends at run-time on having rustup in PATH
  postInstall = ''
    wrapProgram $out/bin/cargo-msrv \
      --prefix PATH : ${lib.makeBinPath [ rustup ]};
  '';

  meta = with lib; {
    description = "Cargo subcommand \"msrv\": assists with finding your minimum supported Rust version (MSRV)";
    mainProgram = "cargo-msrv";
    homepage = "https://github.com/foresterre/cargo-msrv";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ otavio matthiasbeyer ];
  };
}
