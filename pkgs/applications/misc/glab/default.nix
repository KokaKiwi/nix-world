{ lib, stdenv

, fetchFromGitLab
, installShellFiles

, buildGoModule
}:
buildGoModule rec {
  pname = "glab";
  version = "1.52.0";

  src = fetchFromGitLab {
    owner=  "gitlab-org";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-XK/6b2KWwyHev3zVyNKJlOHTenloO28dXgG1ZazE54Q=";
  };

  vendorHash = "sha256-0Mx7QbQQbRhtBcsRWdnSJvEXAtUus/n/KzXTi33ekvc=";

  ldflags = [
    "-s" "-w"
    "-X main.version=${version}"
  ];

  subPackages = [ "cmd/glab" ];

  nativeBuildInputs = [ installShellFiles ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  postInstall = lib.optionalString (stdenv.hostPlatform == stdenv.buildPlatform) ''
    make manpage
    installManPage share/man/man1/*

    installShellCompletion --cmd glab \
      --bash <($out/bin/glab completion -s bash) \
      --fish <($out/bin/glab completion -s fish) \
      --zsh <($out/bin/glab completion -s zsh)
  '';

  meta = {
    license = lib.licenses.mit;
    homepage = "https://gitlab.com/gitlab-org/cli";
    changelog = "https://gitlab.com/gitlab-org/cli/-/releases/v${version}";
    mainProgram = "glab";
  };
}
