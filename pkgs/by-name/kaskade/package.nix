{
  lib,
  python3,
  fetchFromGitHub,

  versionCheckHook,
  writableTmpDirAsHomeHook,

  nix-update-script,

  pkgs, # TODO remove when upstreamed to nixpkgs
  kaskade, # self
}:

python3.pkgs.buildPythonPackage rec {
  pname = "kaskade";
  version = "4.0.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sauljabin";
    repo = "kaskade";
    tag = "v${version}";
    hash = "sha256-Vi3wphk6lGcscLCmtW3lnXA8xGm/nDyjYCv6pndR7es=";
  };

  patches = [
    # remove "poetry run ..."
    ./0001-fix-test-script.patch
    # fix e2e tests default timeouts
    ./0002-e2e-add-timeouts.patch
  ];

  build-system = with python3.pkgs; [
    poetry-core
  ];

  dependencies =
    with python3.pkgs;
    [
      cloup
      textual
      confluent-kafka
    ]
    # all of confluent-kafka deps are required, none are optional
    ++ lib.concatAttrValues confluent-kafka.optional-dependencies;

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
    python3.pkgs.faker
  ]
  ++ dependencies;

  pythonRelaxDeps = [ "confluent-kafka" ];

  pythonImportsCheck = [ "kaskade" ];

  # checkPhase for python maps to the installCheckPhase
  # runhook preinstallcheck fixes versioncheckhook
  checkPhase = ''
    runHook preCheck
    runHook preInstallCheck

    python -m scripts.tests

    runHook postInstallCheck
    runHook postCheck
  '';

  # doInstallCheck is true by default for buildPython*
  versionCheckProgramArg = "--version";
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };
  # TODO ngipkgs layout for exposing tests/packages etc.
  passthru.tests.e2e =
    (pkgs.extend (
      _: _: {
        inherit kaskade;
      }
    )).testers.runNixOSTest
      { imports = [ ./tests-e2e.nix ]; };

  meta = {
    description = "Text user interface for kafka";
    homepage = "https://github.com/sauljabin/kaskade";
    changelog = "https://github.com/sauljabin/kaskade/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "kaskade";
    maintainers = with lib.maintainers; [ phanirithvij ];
  };
}
