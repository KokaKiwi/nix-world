{ lib

, fetchFromGitHub

, rustPlatform
, installShellFiles
}:
rustPlatform.buildRustPackage rec {
  pname = "procs";
  version = "0.14.9";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = "procs";
    rev = "v${version}";
    hash = "sha256-lm9bGu2AIVulVBcMzEpxxek5g6ajQmBENHeHV210g0k=";
  };

  cargoHash = "sha256-zruW6Cf7zspqv8LadCIXZ0iQdlQ7CVfWhkxLwDA+IFc=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    for shell in bash fish zsh; do
      $out/bin/procs --gen-completion $shell
    done
    installShellCompletion procs.{bash,fish} --zsh _procs
  '';

  meta = with lib; {
    description = "Modern replacement for ps written in Rust";
    homepage = "https://github.com/dalance/procs";
    changelog = "https://github.com/dalance/procs/raw/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne sciencentistguy ];
    mainProgram = "procs";
  };
}
