{ fetchFromGitLab

, rustPlatform
}:
rustPlatform.buildRustPackage {
  pname = "cargo-shell";
  version = "0-unstable-2024-11-05";

  src = fetchFromGitLab {
    domain = "gitlab.kokakiwi.net";
    owner = "rusted/tools";
    repo = "cargo-shell";
    rev = "87101dbdcc36752ca6bdb922dd7bc0a727d9a6a8";
    hash = "sha256-MOFbu/KEsFjzctKN5s+uFYOCu9QsKL56bhh+lsCdTuM=";
  };

  cargoHash = "sha256-PUUOx1FU4Ooy46i0AascTv5E5It019f3UVc2Fu1mZuw=";

  meta = {
    mainProgram = "cargo-shell";
  };
}
