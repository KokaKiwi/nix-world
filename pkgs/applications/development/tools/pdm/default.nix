{ lib

, fetchPypi

, installShellFiles
, python3Packages

, runtimeShell
}: let
  resolvelib = python3Packages.resolvelib.overridePythonAttrs (super: rec {
    version = "1.1.0";

    src = fetchPypi {
      pname = "resolvelib";
      inherit version;
      hash = "sha256-toWR73SPWMHioqwo0JYbNYauiyX2CwuppeTz2Hwdank=";
    };

    doCheck = false;
  });
  # pdm wants an outdated version of hishel
  hishel = python3Packages.hishel.overridePythonAttrs (super: rec {
    version = "0.0.33";

    src = fetchPypi {
      pname = "hishel";
      inherit version;
      hash = "sha256-q1smYdXiJS8wX9D7IOjHa/qz6nNFjyDyWRxTw3snAIk=";
    };

    dependencies = super.dependencies ++ (with python3Packages; [
      typing-extensions
    ]);

    doCheck = false;
  });
in python3Packages.buildPythonApplication rec {
  pname = "pdm";
  version = "2.22.3";
  pyproject = true;

  disabled = python3Packages.pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9AnTe0T2uZOOTu0L0MqAFtFc1FFDN2QNb5YqdNAitBI=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  build-system = with python3Packages; [
    pdm-backend
    pdm-build-locked
  ];

  dependencies = with python3Packages; [
    blinker
    dep-logic
    filelock
    findpython
    hishel
    httpx
    installer
    msgpack
    packaging
    pbs-installer
    platformdirs
    pyproject-hooks
    python-dotenv
    resolvelib
    rich
    shellingham
    tomlkit
    unearth
    virtualenv
  ]
  ++ httpx.optional-dependencies.socks
  ++ lib.optionals (pythonOlder "3.11") [
    tomli
  ]
  ++ lib.optionals (pythonOlder "3.10") [
    importlib-metadata
  ]
  ++ lib.optionals (pythonAtLeast "3.10") [
    truststore
  ];

  makeWrapperArgs = [
    "--set PDM_CHECK_UPDATE 0"
  ];

  preInstall = ''
    # Silence network warning during pypaInstallPhase
    # by disabling latest version check
    export PDM_CHECK_UPDATE=0
  '';

  postInstall = ''
    export PDM_LOG_DIR=/tmp/pdm/log

    installShellCompletion --cmd pdm \
      --bash <($out/bin/pdm completion bash) \
      --fish <($out/bin/pdm completion fish) \
      --zsh <($out/bin/pdm completion zsh)

    unset PDM_LOG_DIR
  '';

  nativeCheckInputs = with python3Packages; [
    first
    pytestCheckHook
    pytest-mock
    pytest-xdist
    pytest-httpserver
  ];

  pytestFlagsArray = [
    "-m 'not network'"
  ];

  preCheck = ''
    export HOME=$TMPDIR
    substituteInPlace tests/cli/test_run.py \
      --replace-warn "/bin/bash" "${runtimeShell}"
  '';

  disabledTests = [
    # fails to locate setuptools (maybe upstream bug)
    "test_convert_setup_py_project"
    # pythonfinder isn't aware of nix's python infrastructure
    "test_use_wrapper_python"

    # touches the network
    "test_find_candidates_from_find_links"
    "test_lock_all_with_excluded_groups"
    "test_find_interpreters_with_PDM_IGNORE_ACTIVE_VENV"
    "test_build_distributions"
    "test_init_project_respect_version_file"

    "test_run_script_with_inline_metadata"
    "test_build_with_no_isolation"
  ];

  meta = with lib; {
    homepage = "https://pdm-project.org";
    changelog = "https://github.com/pdm-project/pdm/releases/tag/${version}";
    description = "A modern Python package and dependency manager supporting the latest PEP standards";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
    mainProgram = "pdm";
  };
}
