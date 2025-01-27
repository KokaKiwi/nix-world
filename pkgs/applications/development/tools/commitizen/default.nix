{ lib, stdenv

, fetchFromGitHub

, python3Packages

, installShellFiles

, git
}:
python3Packages.buildPythonPackage rec {
  pname = "commitizen";
  version = "4.1.0";
  pyproject = true;

  disabled = python3Packages.pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "commitizen-tools";
    repo = "commitizen";
    rev = "refs/tags/v${version}";
    hash = "sha256-f3uusTNGMK6a3Plh6FHBeM8vEXDZW31o9E0i+sWsBgE=";
  };

  pythonRelaxDeps = [
    "argcomplete"
    "decli"
  ];

  build-system = with python3Packages; [ poetry-core ];

  nativeBuildInputs = [ installShellFiles ];

  dependencies = with python3Packages; [
    argcomplete
    charset-normalizer
    colorama
    decli
    importlib-metadata
    jinja2
    packaging
    pyyaml
    questionary
    termcolor
    tomlkit
  ];

  nativeCheckInputs = with python3Packages; [
    argcomplete
    deprecated
    git
    py
    pytest-freezer
    pytest-mock
    pytest-regressions
    pytest7CheckHook
  ];

  doCheck = true;

  pythonImportsCheck = [ "commitizen" ];

  # The tests require a functional git installation
  # which requires a valid HOME directory.
  preCheck = ''
    export HOME="$(mktemp -d)"

    git config --global user.name "Nix Builder"
    git config --global user.email "nix-builder@nixos.org"
    git init .
  '';

  # NB: These tests require complex GnuPG setup
  disabledTests = [
    "test_bump_minor_increment_signed"
    "test_bump_minor_increment_signed_config_file"
    "test_bump_on_git_with_hooks_no_verify_enabled"
    "test_bump_on_git_with_hooks_no_verify_disabled"
    "test_bump_pre_commit_changelog"
    "test_bump_pre_commit_changelog_fails_always"
    "test_get_commits_with_signature"
    # fatal: not a git repository (or any of the parent directories): .git
    "test_commitizen_debug_excepthook"

    "test_changelog_from_rev_latest_version_dry_run"
  ];

  postInstall =
    let
      register-python-argcomplete = lib.getExe' python3Packages.argcomplete "register-python-argcomplete";
    in
    lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      installShellCompletion --cmd cz \
        --bash <(${register-python-argcomplete} --shell bash $out/bin/cz) \
        --zsh <(${register-python-argcomplete} --shell zsh $out/bin/cz) \
        --fish <(${register-python-argcomplete} --shell fish $out/bin/cz)
    '';

  meta = with lib; {
    description = "Tool to create committing rules for projects, auto bump versions, and generate changelogs";
    homepage = "https://github.com/commitizen-tools/commitizen";
    changelog = "https://github.com/commitizen-tools/commitizen/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    mainProgram = "cz";
    maintainers = with maintainers; [
      lovesegfault
      anthonyroussel
    ];
  };
}
