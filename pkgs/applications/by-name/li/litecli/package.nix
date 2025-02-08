{
  lib,
  python3Packages,
  fetchFromGitHub,
}:
python3Packages.buildPythonApplication rec {
  pname = "litecli";
  version = "1.14.4";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "dbcli";
    repo = "litecli";
    rev = "v${version}";
    hash = "sha256-9irlOQ3oJU1AYHgsdjdPgPaVY9Sk/fOwsui59CabwsE=";
  };

  dependencies = with python3Packages; [
    cli-helpers
    click
    configobj
    prompt-toolkit
    pygments
    sqlparse
    setuptools
    pip
  ]
  ++ cli-helpers.optional-dependencies.styles;

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    mock
  ];

  pythonImportsCheck = [ "litecli" ];

  disabledTests = [
    "test_auto_escaped_col_names"
    "test_llm_"
  ];

  meta = with lib; {
    description = "Command-line interface for SQLite";
    mainProgram = "litecli";
    longDescription = ''
      A command-line client for SQLite databases that has auto-completion and syntax highlighting.
    '';
    homepage = "https://litecli.com";
    changelog = "https://github.com/dbcli/litecli/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ Scriptkiddi ];
  };
}
