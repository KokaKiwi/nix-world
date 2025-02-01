{ lib

, fetchFromGitLab

, rustPlatform

, pkg-config
, capnproto
, installShellFiles

, openssl
, sqlite
, nettle
}:
rustPlatform.buildRustPackage rec {
  pname = "sequoia-sq";
  version = "1.2.0";

  src = fetchFromGitLab {
    owner = "sequoia-pgp";
    repo = "sequoia-sq";
    tag = "v${version}";
    hash = "sha256-8vOlgqFt9kMTG8ENW9I24YNsrKdhwFnhvF3srdpm/zY=";
  };

  cargoHash = "sha256-MYdLZDkujjYmQTXURwoKVHBLrn1EX4ScZqpiuUEssXo=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
    capnproto
    installShellFiles
  ];

  buildInputs = [
    openssl
    sqlite
    nettle
  ];

  checkFlags = let
    skipTests = [
      # Requires network
      "cli::download::sq_download"
    ];
  in map (testName: "--skip=${testName}") skipTests;

  # Needed for tests to be able to create a ~/.local/share/sequoia directory
  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  env.ASSET_OUT_DIR = "/tmp/";

  doCheck = true;

  postInstall = ''
    installManPage /tmp/man-pages/*.*
    installShellCompletion \
      --cmd sq \
      --bash /tmp/shell-completions/sq.bash \
      --fish /tmp/shell-completions/sq.fish \
      --zsh /tmp/shell-completions/_sq
  '';

  meta = {
    description = "Cool new OpenPGP implementation";
    homepage = "https://sequoia-pgp.org/";
    changelog = "https://gitlab.com/sequoia-pgp/sequoia-sq/-/blob/v${version}/NEWS";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      minijackson
      doronbehar
      dvn0
    ];
    mainProgram = "sq";
  };
}
