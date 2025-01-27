{ lib

, fetchFromGitHub

, rustPlatform
}:
rustPlatform.buildRustPackage rec {
  pname = "hd";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "parasyte";
    repo = "hd";
    rev = "refs/tags/${version}";
    hash = "sha256-mHstW7MlTpe3/P+ouJ4x6+pMtInebED+raX6joIoQMc=";
  };

  cargoHash = "sha256-HXKndCkFtYZ+kPPShRxL7yLqvfuBhbva/8n54ynZffQ=";

  meta = {
    description = "Hex Display: A modern xxd alternative";
    homepage = "https://github.com/parasyte/hd";
    license = lib.licenses.mit;
    mainProgram = "hd";
  };
}
