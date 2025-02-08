{ fetchFromGitHub, rustPlatform}:
rustPlatform.buildRustPackage rec {
  pname = "usage";
  version = "2.0.4";

  src = fetchFromGitHub {
    owner = "jdx";
    repo = "usage";
    rev = "v${version}";
    hash = "sha256-B/jphWQUZdNsMANscn/BgfKqCmSsHGMyib4Ll9jt+GM=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-R4ura11MBGI7MnYWcldrJn7ybGrRyM3ZHCLxALJVF4s=";

  checkFlags = [
    "--skip=complete_word_mounted"
  ];

  meta = {
    mainProgram = "usage";
  };
}
