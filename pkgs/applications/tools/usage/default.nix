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

  cargoHash = "sha256-rbhgrbchT/5t39QOVULO+rIKr0oFAQ8Z8KEo3MWyRYM=";

  checkFlags = [
    "--skip=complete_word_mounted"
  ];

  meta = {
    mainProgram = "usage";
  };
}
