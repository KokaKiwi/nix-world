{ lib

, fetchFromGitHub

, installShellFiles
, rustPlatform

, nix-eval-jobs
}:
rustPlatform.buildRustPackage {
  pname = "colmena";
  version = "0.4.0-unstable-2024-12-22";

  src = fetchFromGitHub {
    owner = "zhaofengli";
    repo = "colmena";
    rev = "a6b51f5feae9bfb145daa37fd0220595acb7871e";
    hash = "sha256-LLpiqfOGBippRax9F33kSJ/Imt8gJXb6o0JwSBiNHCk=";
  };

  cargoHash = "sha256-AkCKvPubj+/fIh669EOQMo8MCqyZjinOko47F7RqVq8=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [ nix-eval-jobs ];

  NIX_EVAL_JOBS = "${nix-eval-jobs}/bin/nix-eval-jobs";

  doCheck = false;

  postInstall = ''
    installShellCompletion --cmd colmena \
      --bash <($out/bin/colmena gen-completions bash) \
      --fish <($out/bin/colmena gen-completions fish) \
      --zsh <($out/bin/colmena gen-completions zsh)
  '';

  meta = with lib; {
    description = "A simple, stateless NixOS deployment tool";
    homepage = "https://github.com/zhaofengli/colmena";
    license = licenses.mit;
    mainProgram = "colmena";
  };
}
