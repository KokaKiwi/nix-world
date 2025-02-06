{ lib, stdenv
, buildPackages

, fetchFromGitHub

, rustPlatform

, cmake
, installShellFiles
, pkg-config

, versionCheckHook
}:
rustPlatform.buildRustPackage rec {
  pname = "uv";
  version = "0.5.29";

  src = fetchFromGitHub {
    owner = "astral-sh";
    repo = "uv";
    tag = version;
    hash = "sha256-EWm1sjmDAmMQoGoRqgtFMlXwi8n/iCdahsoRERhhulc=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-gBygAspjCzZqDnjHH4J1WUsrIjpiB55Vr33qj1nv+FM=";

  nativeBuildInputs = [
    cmake
    installShellFiles
    pkg-config
  ];

  dontUseCmakeConfigure = true;

  cargoBuildFlags = [
    "--package"
    "uv"
  ];

  # Tests require python3
  doCheck = false;

  postInstall = let
    emulator = stdenv.hostPlatform.emulator buildPackages;
  in ''
    installShellCompletion --cmd uv \
      --bash <(${emulator} $out/bin/uv generate-shell-completion bash) \
      --fish <(${emulator} $out/bin/uv generate-shell-completion fish) \
      --zsh <(${emulator} $out/bin/uv generate-shell-completion zsh)
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  meta = {
    description = "Extremely fast Python package installer and resolver, written in Rust";
    homepage = "https://github.com/astral-sh/uv";
    changelog = "https://github.com/astral-sh/uv/blob/${version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "uv";
  };
}
