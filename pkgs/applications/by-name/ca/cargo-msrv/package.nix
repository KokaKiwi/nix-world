{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  rustup,
  openssl,
  stdenv,
  makeWrapper,
}:
rustPlatform.buildRustPackage rec {
  pname = "cargo-msrv";
  version = "0.18.1";

  src = fetchFromGitHub {
    owner = "foresterre";
    repo = pname;
    tag = "v${version}";
    sha256 = "sha256-WdOulXPtluoKElWW8I1H0wsC+1rFKTVh4iBjyc2brV4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-+jpLGoBUKLYU9Hp1Ai+rgoCKU+EMN8ENs12c5Fj5uGg=";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ openssl ];

  # Integration tests fail
  doCheck = false;

  # Depends at run-time on having rustup in PATH
  postInstall = ''
    wrapProgram $out/bin/cargo-msrv --prefix PATH : ${lib.makeBinPath [ rustup ]};
  '';

  meta = with lib; {
    description = "Cargo subcommand \"msrv\": assists with finding your minimum supported Rust version (MSRV)";
    mainProgram = "cargo-msrv";
    homepage = "https://github.com/foresterre/cargo-msrv";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [
      otavio
      matthiasbeyer
    ];
  };
}
