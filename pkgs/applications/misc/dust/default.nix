{ lib

, fetchFromGitHub

, rustPlatform
, installShellFiles
}:
rustPlatform.buildRustPackage rec {
  pname = "dust";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "bootandy";
    repo = "dust";
    rev = "v${version}";
    hash = "sha256-oaDJLDFI193tSzUDqQI/Lvrks0FLYTMLrrwigXwJ+rY=";
    # Remove unicode file names which leads to different checksums on HFS+
    # vs. other filesystems because of unicode normalisation.
    postFetch = ''
      rm -r $out/tests/test_dir_unicode/
    '';
  };

  cargoHash = "sha256-q0QfmzvUhkN3M5IHswBsFJgly2SwZJz/AE+d7PGED50=";

  nativeBuildInputs = [ installShellFiles ];

  doCheck = false;

  postInstall = ''
    installManPage man-page/dust.1
    installShellCompletion completions/dust.{bash,fish} --zsh completions/_dust
  '';

  meta = with lib; {
    description = "du + rust = dust. Like du but more intuitive";
    homepage = "https://github.com/bootandy/dust";
    license = licenses.asl20;
    maintainers = with maintainers; [ aaronjheng ];
    mainProgram = "dust";
  };
}
