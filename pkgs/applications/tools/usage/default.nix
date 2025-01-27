{ fetchFromGitHub, rustPlatform}:
rustPlatform.buildRustPackage rec {
  pname = "usage";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "jdx";
    repo = "usage";
    rev = "v${version}";
    hash = "sha256-bS8wMtmD7UPctP+8yDm8KylLIPzPuk6dt9ilWQzFvY0=";
  };

  cargoHash = "sha256-z/McKMlLvr/YBzXSCLFZk9PSIBnrweU7tIPjTwTeiuQ=";

  checkFlags = [
    "--skip=complete_word_mounted"
  ];

  meta = {
    mainProgram = "usage";
  };
}
