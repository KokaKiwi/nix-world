{ fetchFromGitHub, rustPlatform}:
rustPlatform.buildRustPackage rec {
  pname = "usage";
  version = "2.0.5";

  src = fetchFromGitHub {
    owner = "jdx";
    repo = "usage";
    rev = "v${version}";
    hash = "sha256-No/BDBW/NRnF81UOuAMrAs4cXEdzEAxnmkn67mReUcM=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-W/CuXzwacarxgVv12TMVfo7Fr9qKJ7aZIO8xf4SygNA=";

  checkFlags = [
    "--skip=complete_word_mounted"
  ];

  meta = {
    mainProgram = "usage";
  };
}
