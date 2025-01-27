{ lib, stdenv

, fetchFromGitHub

, buildGoModule

, asciidoctor
, installShellFiles

, git
}:
buildGoModule rec {
  pname = "git-lfs";
  version = "3.6.1";

  src = fetchFromGitHub {
    owner = "git-lfs";
    repo = "git-lfs";
    rev = "v${version}";
    hash = "sha256-zZ9VYWVV+8G3gojj1m74syvsYM1mX0YT4hKnpkdMAQk=";
  };

  vendorHash = "sha256-JT0r/hs7ZRtsYh4aXy+v8BjwiLvRJ10e4yRirqmWVW0=";

  nativeBuildInputs = [ asciidoctor installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/git-lfs/git-lfs/v${lib.versions.major version}/config.Vendor=${version}"
  ];

  subPackages = [ "." ];

  preBuild = ''
    GOARCH= go generate ./commands
  '';

  postBuild = ''
    make man
  '';

  nativeCheckInputs = [ git ];

  preCheck = ''
    unset subPackages
  '';

  postInstall = ''
    installManPage man/man*/*
  '' + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd git-lfs \
      --bash <($out/bin/git-lfs completion bash) \
      --fish <($out/bin/git-lfs completion fish) \
      --zsh <($out/bin/git-lfs completion zsh)
  '';

  meta = with lib; {
    description = "Git extension for versioning large files";
    homepage = "https://git-lfs.github.com/";
    changelog = "https://github.com/git-lfs/git-lfs/raw/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ twey ];
    mainProgram = "git-lfs";
  };
}
