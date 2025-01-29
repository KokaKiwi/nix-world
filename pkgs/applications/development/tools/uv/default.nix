{ lib, stdenv

, fetchFromGitHub

, python3Packages
, rustPlatform
, darwin

, cmake
, installShellFiles
, pkg-config
, rustc
, cargo

, libiconv
}:
python3Packages.buildPythonApplication rec {
  pname = "uv";
  version = "0.5.25";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "astral-sh";
    repo = "uv";
    rev = "refs/tags/${version}";
    hash = "sha256-nDZaS3Yc7Z8gKyl2+HTpwoTTJKJDZCTQIiZazICvlvQ=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "async_zip-0.0.17" = "sha256-VfQg2ZY5F2cFoYQZrtf2DHj0lWgivZtFaFJKZ4oyYdo=";
      "pubgrub-0.2.1" = "sha256-E3b07gWplHcWI1x9bGL3ITHLQC486mDt0fpRxXwfpWU=";
      "tl-0.7.8" = "sha256-F06zVeSZA4adT6AzLzz1i9uxpI1b8P1h+05fFfjm3GQ=";
    };
  };

  nativeBuildInputs = [
    cmake
    installShellFiles
    pkg-config
    rustc cargo
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  buildInputs = [
    libiconv
  ] ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    SystemConfiguration
  ]);

  dontUseCmakeConfigure = true;

  cargoBuildFlags = [
    "--package"
    "uv"
  ];

  postInstall = ''
    export HOME=$TMPDIR

    installShellCompletion --cmd uv \
      --bash <($out/bin/uv --generate-shell-completion bash) \
      --fish <($out/bin/uv --generate-shell-completion fish) \
      --zsh <($out/bin/uv --generate-shell-completion zsh)
  '';

  pythonImportsCheck = [ "uv" ];

  meta = {
    description = "Extremely fast Python package installer and resolver, written in Rust";
    homepage = "https://github.com/astral-sh/uv";
    changelog = "https://github.com/astral-sh/uv/blob/${src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "uv";
  };
}
