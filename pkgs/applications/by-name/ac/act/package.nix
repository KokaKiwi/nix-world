{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule rec {
  pname = "act";
  version = "0.2.73";

  src = fetchFromGitHub {
    owner = "nektos";
    repo = "act";
    tag = "v${version}";
    hash = "sha256-bQZwEBk8F3h/o+SA3lTZO73GPLLpB49afTuA1204dkA=";
  };

  vendorHash = "sha256-vstuA9sti+DsCnXlUA9AkmHvb9BUecM8KtQLghtO3JI=";

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
