{ lib

, fetchFromGitHub

, rustPlatform

, pkg-config
, openssl

, withLsp ? true
}:
rustPlatform.buildRustPackage rec {
  pname = "taplo";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "tamasfe";
    repo = "taplo";
    rev = version;
    hash = "sha256-7zhMRPkiR0aQC70iii/WshBnWx+ZomIhllDbUzIzzio=";
  };

  cargoHash = "sha256-oxtYGXAJ68Ulk42kvA+JfANnR1wXSatE9rpN8dudAsA=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  buildFeatures = lib.optional withLsp "lsp";

  meta = with lib; {
    description = "TOML toolkit written in Rust";
    homepage = "https://taplo.tamasfe.dev";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "taplo";
  };
}
