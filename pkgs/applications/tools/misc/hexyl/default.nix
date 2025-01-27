{ lib

, fetchFromGitHub

, rustPlatform
}:
rustPlatform.buildRustPackage rec {
  pname = "hexyl";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-TmFvv+jzOSM8kKCxBbUoDsUjKRPTplhWheVfIjS5nsY=";
  };

  cargoHash = "sha256-nfz5tpqJSPJvYDvzsl0tQHv0olLOi1d1PTo3lFDmIkI=";

  meta = with lib; {
    description = "Command-line hex viewer";
    longDescription = ''
      `hexyl` is a simple hex viewer for the terminal. It uses a colored
      output to distinguish different categories of bytes (NULL bytes,
      printable ASCII characters, ASCII whitespace characters, other ASCII
      characters and non-ASCII).
    '';
    homepage = "https://github.com/sharkdp/hexyl";
    changelog = "https://github.com/sharkdp/hexyl/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ dywedir figsoda SuperSandro2000 ];
    mainProgram = "hexyl";
  };
}
