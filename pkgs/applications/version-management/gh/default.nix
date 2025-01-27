{ lib, stdenv

, fetchFromGitHub

, buildGoModule
, installShellFiles
}:
buildGoModule rec {
  pname = "gh";
  version = "2.65.0";

  src = fetchFromGitHub {
    owner = "cli";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-Rg6GAItG0OFDCK7rEuJs6i4QWHK3sveIh6UQVlA37mg=";
  };

  vendorHash = "sha256-MVjZUT1OEMAJZVsbCRg/ds57QgyiL9rLRfIo4HHHSmU=";

  nativeBuildInputs = [ installShellFiles ];

  buildPhase = ''
    runHook preBuild
    make GO_LDFLAGS="-s -w" GH_VERSION=${version} bin/gh ${lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) "manpages"}
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 bin/gh -t $out/bin
   '' + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installManPage share/man/*/*.[1-9]

    installShellCompletion --cmd gh \
      --bash <($out/bin/gh completion -s bash) \
      --fish <($out/bin/gh completion -s fish) \
      --zsh <($out/bin/gh completion -s zsh)
  '' + ''
    runHook postInstall
  '';

  # most tests require network access
  doCheck = false;

  meta = with lib; {
    description = "GitHub CLI tool";
    homepage = "https://cli.github.com/";
    changelog = "https://github.com/cli/cli/releases/tag/v${version}";
    license = licenses.mit;
    mainProgram = "gh";
    maintainers = with maintainers; [ zowoq ];
  };
}
