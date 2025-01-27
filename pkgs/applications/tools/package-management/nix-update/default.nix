{ lib
, callPackage

, fetchFromGitHub

, python3

, nix
, nix-prefetch-git
, nixpkgs-review

, nix-update
}:
python3.pkgs.buildPythonApplication rec {
  pname = "nix-update";
  version = "1.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "nix-update";
    rev = "refs/tags/${version}";
    hash = "sha256-I9p2CLvzu9DMUCQynQAYski6kwo/NZHdIxCXLpgzOac=";
  };

  build-system = [
    python3.pkgs.setuptools
  ];

  makeWrapperArgs = [
    "--prefix" "PATH" ":" (lib.makeBinPath [ nix nix-prefetch-git nixpkgs-review ])
  ];

  checkPhase = ''
    runHook preCheck

    $out/bin/nix-update --help >/dev/null

    runHook postCheck
  '';

  passthru = {
    nix-update-script = callPackage ./nix-update-script.nix {
      inherit nix-update;
    };
  };

  meta = with lib; {
    description = "Swiss-knife for updating nix packages";
    inherit (src.meta) homepage;
    changelog = "https://github.com/Mic92/nix-update/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda mic92 ];
    mainProgram = "nix-update";
    platforms = platforms.all;
  };
}
