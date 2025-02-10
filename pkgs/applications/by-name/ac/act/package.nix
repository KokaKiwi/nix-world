{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule rec {
  pname = "act";
  version = "0.2.74";

  src = fetchFromGitHub {
    owner = "nektos";
    repo = "act";
    tag = "v${version}";
    hash = "sha256-UfETstrK8iAGbCn2BRjI8eRkFp/RGVYe0S1P8P8MUHg=";
  };

  vendorHash = "sha256-NIXiXD1JCtvgTG7QPSMCjQfZSSEcdMUKdqureSWDB4k=";

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  meta = {
    description = "Run your GitHub Actions locally";
    mainProgram = "act";
    homepage = "https://github.com/nektos/act";
    changelog = "https://github.com/nektos/act/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      Br1ght0ne
      kashw2
    ];
  };
}
