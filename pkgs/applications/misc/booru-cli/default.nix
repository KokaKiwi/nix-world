{ lib

, fetchFromGitLab

, python3Packages
}:
python3Packages.buildPythonApplication {
  pname = "szurubooru-cli";
  version = "0-unstable-2024-08-09";
  pyproject = true;

  src = fetchFromGitLab {
    domain = "gitlab.kokakiwi.net";
    owner = "kokakiwi";
    repo = "szurubooru-cli";
    rev = "4e28a1113e1bf88c13ddf92236514ace6a787ff4";
    hash = "sha256-ZWvH8ajAe7Y6klAj42XprRrqqaNBua4QNe7RRtS8HJ0=";
  };

  nativeBuildInputs = with python3Packages; [
    pdm-backend
  ];

  propagatedBuildInputs = with python3Packages; [
    httpx h2
    rtoml
    tqdm
    typer
    devtools
  ];

  pythonImportsCheck = [ "booru" ];

  meta = with lib; {
    description = "";
    homepage = "https://gitlab.kokakiwi.net/kokakiwi/szurubooru-cli";
    mainProgram = "szurubooru-cli";
  };
}
