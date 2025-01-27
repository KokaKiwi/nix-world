{ lib

, fetchFromGitHub
, fetchFromGitLab

, makeWrapper
, python3Packages

, cargo
}:
let
  aiohttp-mako = python3Packages.buildPythonPackage {
    pname = "aiohttp-mako";
    version = "0.4.0";
    format = "setuptools";

    src = fetchFromGitHub {
      owner = "aio-libs";
      repo = "aiohttp-mako";
      rev = "8fb66bd35b8cb4a2fa91e33f3dff918e4798a15a";
      hash = "sha256-1Z8SAziKmiuxIgfjCemUpknywmZEMdTRNiXal4/Onug=";
    };

    nativeBuildInputs = with python3Packages; [
      pip
      setuptools
    ];
    propagatedBuildInputs = with python3Packages; [
      aiohttp
      mako
    ];
  };
in python3Packages.buildPythonApplication {
  pname = "module-server";
  version = "0.1.1-unstable-2024-10-09";
  format = "pyproject";

  src = fetchFromGitLab {
    domain = "gitlab.kokakiwi.net";
    owner = "web";
    repo = "module-server";
    rev = "dc621bcf02056365e2eadf867a2cd632e1f7e668";
    hash = "sha256-rZT7sm/AQlEyOfFzKSQn7pPoEBnaurfCcsLrNCifJW0=";
  };

  nativeBuildInputs = with python3Packages; [
    makeWrapper

    hatchling
  ];
  propagatedBuildInputs = with python3Packages; [
    aiohttp
    aiohttp-mako
    appdirs
    asyncinotify
    click
    pydantic
    libsass
    python-slugify
    ruamel-yaml
    semver
    yarl
    yattag
    loguru
  ];

  configurePhase = ''
    python -m module_server --compile-style
  '';

  postInstall = ''
    wrapProgram $out/bin/module-server \
      --prefix PATH : "${lib.makeBinPath [ cargo ]}"
  '';

  meta = {
    mainProgram = "module-server";
  };
}
