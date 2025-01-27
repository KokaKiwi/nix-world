{ lib

, fetchFromGitHub

, rustPlatform
, installShellFiles

, cmake
, git
, pkg-config
, zstd
}:
rustPlatform.buildRustPackage rec {
  pname = "onefetch";
  version = "2.23.1";

  src = fetchFromGitHub {
    owner = "o2sh";
    repo = "onefetch";
    rev = version;
    hash = "sha256-lQxv2gwZOGtxJrXjxvjBnbl225ppSs3cVNCfePFeqEE=";
  };

  cargoHash = "sha256-DBZW/DKRPiV29OZLvUG8ls4kPuuw14FEDQfYn7pTSrs=";

  nativeBuildInputs = [ cmake installShellFiles pkg-config ];

  buildInputs = [ zstd ];

  nativeCheckInputs = [
    git
  ];

  env.ZSTD_SYS_USE_PKG_CONFIG = 1;

  preCheck = ''
    git init
    git config user.name nixbld
    git config user.email nixbld@example.com
    git add .
    git commit -m test
  '';

  postInstall = ''
    installShellCompletion --cmd onefetch \
      --bash <($out/bin/onefetch --generate bash) \
      --fish <($out/bin/onefetch --generate fish) \
      --zsh <($out/bin/onefetch --generate zsh)
  '';

  meta = with lib; {
    description = "Git repository summary on your terminal";
    homepage = "https://github.com/o2sh/onefetch";
    changelog = "https://github.com/o2sh/onefetch/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    mainProgram = "onefetch";
  };
}
