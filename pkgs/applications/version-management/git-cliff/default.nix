{ lib

, fetchFromGitHub

, installShellFiles
, rustPlatform
}:
rustPlatform.buildRustPackage rec {
  pname = "git-cliff";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "git-cliff";
    rev = "v${version}";
    hash = "sha256-B421xXt7TrBJVwi04vygnw9t5o7/KLVpuItQtwV4E24=";
  };

  cargoHash = "sha256-1Y19QhM/n8Kv+qf605nRF3EYjbbw7Mxs62cZWRJjuEo=";

  nativeBuildInputs = [
    installShellFiles
  ];

  # attempts to run the program on .git in src which is not deterministic
  doCheck = false;

  postInstall = ''
    mkdir generated

    OUT_DIR=generated $out/bin/git-cliff-completions
    OUT_DIR=generated $out/bin/git-cliff-mangen

    installManPage generated/git-cliff.1
    installShellCompletion \
      --bash generated/git-cliff.bash \
      --fish generated/git-cliff.fish \
      --zsh generated/_git-cliff

    rm $out/bin/git-cliff-*
  '';

  meta = with lib; {
    description = "Highly customizable Changelog Generator that follows Conventional Commit specifications";
    homepage = "https://github.com/orhun/git-cliff";
    changelog = "https://github.com/orhun/git-cliff/blob/v${version}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ siraben ];
    mainProgram = "git-cliff";
  };
}
