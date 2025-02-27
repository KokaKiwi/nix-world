{
  lib,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
}:
rustPlatform.buildRustPackage rec {
  pname = "du-dust";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "bootandy";
    repo = "dust";
    tag = "v${version}";
    hash = "sha256-pb7IscmC21GNYWclW95Ctz+QGinn1VqN5QEyc6j9aQA=";

    # Remove unicode file names which leads to different checksums on HFS+
    # vs. other filesystems because of unicode normalisation.
    postFetch = ''
      rm -r $out/tests/test_dir_unicode/
    '';
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-z4T2Vb0ylL4N5drS6D408Nt/f5cxF85Saqut6qArDak=";

  nativeBuildInputs = [ installShellFiles ];

  doCheck = false;

  postInstall = ''
    installManPage man-page/dust.1
    installShellCompletion completions/dust.{bash,fish} --zsh completions/_dust
  '';

  meta = {
    description = "du + rust = dust. Like du but more intuitive";
    homepage = "https://github.com/bootandy/dust";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aaronjheng ];
    mainProgram = "dust";
  };
}
