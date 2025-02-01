{ lib

, fetchFromGitHub

, buildGoModule
}:
buildGoModule rec {
  pname = "act";
  version = "0.2.72";

  src = fetchFromGitHub {
    owner = "nektos";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-7tllNoloKlwBYL4TQY0o2ojbCtT0zG9GrU3xeRJu298=";
  };

  vendorHash = "sha256-Px+pftEqpf/JhN11vNxYWIKVhUsrtd+XLIDaEAJHkX0=";

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  meta = with lib; {
    description = "Run your GitHub Actions locally";
    mainProgram = "act";
    homepage = "https://github.com/nektos/act";
    changelog = "https://github.com/nektos/act/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne kashw2 ];
  };
}
