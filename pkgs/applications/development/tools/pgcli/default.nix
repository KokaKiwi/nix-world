{ lib, stdenv

, fetchFromGitHub

, buildPythonPackage
, pytestCheckHook

, setuptools

, cli-helpers
, click
, configobj
, prompt-toolkit
, psycopg
, pygments
, sqlparse
, pgspecial
, setproctitle
, keyring
, sshtunnel
, mock
}:
buildPythonPackage rec {
  pname = "pgcli";
  version = "4.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dbcli";
    repo = "pgcli";
    rev = "v${version}";
    hash = "sha256-ycF0dAh+TJXc+lwstB18rOZopaYRvI7Am+FkyAmUjkM=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    cli-helpers
    click
    configobj
    prompt-toolkit
    psycopg
    pygments
    sqlparse
    pgspecial
    setproctitle
    keyring
    sshtunnel
  ] ++ cli-helpers.optional-dependencies.styles;

  nativeCheckInputs = [ pytestCheckHook mock ];

  disabledTests = [
    "test_application_name_in_env"
  ] ++ lib.optionals stdenv.isDarwin [ "test_application_name_db_uri" ];

  meta = with lib; {
    description = "Command-line interface for PostgreSQL";
    mainProgram = "pgcli";
    longDescription = ''
      Rich command-line interface for PostgreSQL with auto-completion and
      syntax highlighting.
    '';
    homepage = "https://pgcli.com";
    changelog = "https://github.com/dbcli/pgcli/raw/v${version}/changelog.rst";
    license = licenses.bsd3;
  };
}
