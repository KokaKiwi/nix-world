{ lib

, fetchFromGitHub

, rustPlatform

, pkg-config

, openssl
}:
rustPlatform.buildRustPackage rec {
  pname = "cargo-outdated";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "kbknapp";
    repo = "cargo-outdated";
    rev = "refs/tags/v${version}";
    hash = "sha256-dSrIn9c/5VaegZHtBiYTgwW20AjMxP61XlfS+rkvnz8=";
  };

  cargoHash = "sha256-VadzSb4mK3d+s7q44cW+UaJQSRwuzsoSc+ShYTdNfKU=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  meta = with lib; {
    description = "Cargo subcommand for displaying when Rust dependencies are out of date";
    mainProgram = "cargo-outdated";
    homepage = "https://github.com/kbknapp/cargo-outdated";
    changelog = "https://github.com/kbknapp/cargo-outdated/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ ivan matthiasbeyer ];
  };
}
