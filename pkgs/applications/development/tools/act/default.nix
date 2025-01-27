{ lib

, fetchFromGitHub

, buildGoModule
}:
buildGoModule rec {
  pname = "act";
  version = "0.2.71";

  src = fetchFromGitHub {
    owner = "nektos";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-ykZ6n9v56G5PZNTYdkGp8xveA7gzYhICkBoCCx3s0ew=";
  };

  vendorHash = "sha256-zCiqIl08s00U/DQkUhbb/qrjWof9xzBf4EznuvE4rlE=";

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
