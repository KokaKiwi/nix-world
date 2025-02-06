{ lib, stdenv

, fetchFromGitHub

, rustPlatform
, installShellFiles

, pkg-config

, openssl

, curl
}:
rustPlatform.buildRustPackage rec {
  pname = "miniserve";
  version = "0.29.0";

  src = fetchFromGitHub {
    owner = "svenstaro";
    repo = "miniserve";
    tag = "v${version}";
    hash = "sha256-HHTNBqMYf7WrqJl5adPmH87xfrzV4TKJckpwTPiiw7w=";
  };

  cargoHash = "sha256-1cl0k+fYJNMUQSCqIJCi/YjrE7LNu2poZ8fuW8F4J6k=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  doCheck = false;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    $out/bin/miniserve --print-manpage >miniserve.1
    installManPage miniserve.1

    installShellCompletion --cmd miniserve \
      --bash <($out/bin/miniserve --print-completions bash) \
      --fish <($out/bin/miniserve --print-completions fish) \
      --zsh <($out/bin/miniserve --print-completions zsh)
  '';

  meta = with lib; {
    description = "CLI tool to serve files and directories over HTTP";
    homepage = "https://github.com/svenstaro/miniserve";
    changelog = "https://github.com/svenstaro/miniserve/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "miniserve";
  };
}
