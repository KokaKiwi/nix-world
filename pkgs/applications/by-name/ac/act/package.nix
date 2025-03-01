{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule rec {
  pname = "act";
  version = "0.2.75";

  src = fetchFromGitHub {
    owner = "nektos";
    repo = "act";
    tag = "v${version}";
    hash = "sha256-YIhgS1kQ9EKoIaSp/zGVQmWXyYZranEQU9onQW3gD0k=";
  };

  vendorHash = "sha256-LKNajCwb33syv9KcNHKYIGTnAN8r7PkGilDB3HnKkY4=";

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
