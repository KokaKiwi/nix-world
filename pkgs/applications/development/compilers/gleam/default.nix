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
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "gleam-lang";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-gBVr4kAec8hrDBiRXa/sQUNYvgSX3nTVMwFGYRFCbSA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-tYSqE+bn0GUQe/xVBZTh37XsMyzFnmxgVCL0II2/3jQ=";

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
