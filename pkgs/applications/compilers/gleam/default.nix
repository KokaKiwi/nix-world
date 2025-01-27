{ lib

, fetchFromGitHub

, rustPlatform

, gitMinimal
, pkg-config
, openssl
}:
rustPlatform.buildRustPackage rec {
  pname = "gleam";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "gleam-lang";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-Nr8OpinQ1Dmo6e8XpBYrtaRRhcX2s1TW/5nM1LxApGg=";
  };

  nativeBuildInputs = [ gitMinimal pkg-config ];

  buildInputs = [ openssl ];

  cargoHash = "sha256-E1iowktT7oK259WY6AopfvinQuRT1yMnORbJn9Ly+3E=";

  meta = with lib; {
    description = "A statically typed language for the Erlang VM";
    mainProgram = "gleam";
    homepage = "https://gleam.run/";
    license = licenses.asl20;
    maintainers = teams.beam.members;
  };
}
