{ lib

, fetchFromGitHub

, rustPlatform
}:
rustPlatform.buildRustPackage rec {
  pname = "b3sum";
  version = "1.5.5";

  src = fetchFromGitHub {
    owner = "BLAKE3-team";
    repo = "BLAKE3";
    rev = "refs/tags/${version}";
    hash = "sha256-2M8OQNmtWwfDcbZYspaxpGz2clpfILru//4+P6dClNw=";
  };

  sourceRoot = "${src.name}/b3sum";
  cargoHash = "sha256-xQZV8Cluc04CEkL/+4yJTgkk2rm/qgmQqvHjK0oo4t8=";

  meta = {
    description = "BLAKE3 cryptographic hash function";
    mainProgram = "b3sum";
    homepage = "https://github.com/BLAKE3-team/BLAKE3/";
    license = with lib.licenses; [ cc0 asl20 asl20-llvm ];
    changelog = "https://github.com/BLAKE3-team/BLAKE3/releases/tag/${version}";
    maintainers = with lib.maintainers; [ fpletz ivan ];
  };
}
