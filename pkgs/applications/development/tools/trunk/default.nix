{ lib

, fetchFromGitHub

, rustPlatform

, pkg-config

, openssl
}:
rustPlatform.buildRustPackage rec {
  pname = "trunk";
  version = "0.21.7";

  src = fetchFromGitHub {
    owner = "trunk-rs";
    repo = "trunk";
    rev = "v${version}";
    hash = "sha256-VAAGHM2GDrvZvOTRPkxSFs6pzDQGhi6vPpprKJSZKUw=";
  };

  cargoHash = "sha256-lc/X9KtA9eW1GN9Nhok3oCMNEuhRZjhseHCAFcpuvIU=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  checkFlags = [
    # requires network
    "--skip=tools::tests::download_and_install_binaries"
  ];

  meta = with lib; {
    homepage = "https://github.com/trunk-rs/trunk";
    description = "Build, bundle & ship your Rust WASM application to the web";
    mainProgram = "trunk";
    maintainers = with maintainers; [ freezeboy ctron ];
    license = with licenses; [ asl20 ];
  };
}
