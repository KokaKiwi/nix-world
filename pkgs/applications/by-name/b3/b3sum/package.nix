{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "b3sum";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "BLAKE3-team";
    repo = "BLAKE3";
    tag = version;
    hash = "sha256-YJ3rRzpmF6oS8p377CEoRteARCD1lr/L7/fbN5poUXw=";
  };

  cargoRoot = "b3sum";
  buildAndTestSubdir = cargoRoot;

  useFetchCargoVendor = true;
  cargoHash = "sha256-eO0KgAuli2x8w4WHKZUK6D2KV7DmwiLKuX6FRKgNJOw=";

  meta = {
    description = "BLAKE3 cryptographic hash function";
    mainProgram = "b3sum";
    homepage = "https://github.com/BLAKE3-team/BLAKE3/";
    maintainers = with lib.maintainers; [
      fpletz
      ivan
    ];
    license = with lib.licenses; [
      cc0
      asl20
    ];
    changelog = "https://github.com/BLAKE3-team/BLAKE3/releases/tag/${version}";
  };
}
