{
  lib,
  rustPlatform,
  fetchFromGitHub,
  git,
  pkg-config,
  openssl,
  erlang,
}:
rustPlatform.buildRustPackage rec {
  pname = "gleam";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "gleam-lang";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-Qt2VQhbiNNORrGUR5LHeBb0q/EIqPNPz/adljj6xpS4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-7oawxv1s8BJsOxGuADKjf4XqJ/UT+zYOrPQCbQljArM=";

  nativeBuildInputs = [
    git
    pkg-config
  ];

  buildInputs = [
    openssl
    erlang
  ];

  meta = with lib; {
    description = "Statically typed language for the Erlang VM";
    mainProgram = "gleam";
    homepage = "https://gleam.run/";
    changelog = "https://github.com/gleam-lang/gleam/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = teams.beam.members ++ [ lib.maintainers.philtaken ];
  };
}
