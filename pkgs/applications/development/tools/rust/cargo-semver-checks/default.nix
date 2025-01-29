{ lib

, fetchFromGitHub

, rustPlatform
}:
rustPlatform.buildRustPackage rec {
  pname = "cargo-semver-checks";
  version = "0.39.0";

  src = fetchFromGitHub {
    owner = "obi1kenobi";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ZP0Zu9NLhJNsVwKiAj5RuGdZn5Q3meJW7/U+quAdoxw=";
  };

  cargoHash = "sha256-uBRlGz+iQLR/KkvVOOIGmfDy9mr2E4ntsNfTwnxPqyk=";

  doCheck = false;

  meta = with lib; {
    description = "Tool to scan your Rust crate for semver violations";
    mainProgram = "cargo-semver-checks";
    homepage = "https://github.com/obi1kenobi/cargo-semver-checks";
    changelog = "https://github.com/obi1kenobi/cargo-semver-checks/releases/tag/v${version}";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda matthiasbeyer ];
  };
}
