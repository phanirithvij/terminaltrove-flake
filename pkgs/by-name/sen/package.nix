{
  lib,
  python3,
  fetchFromGitHub,
  nix-update-script,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "sen";
  version = "0.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "TomasTomecek";
    repo = "sen";
    tag = version;
    hash = "sha256-aCCnwCmdrDVeEttRd19Xjxq/gglQyltiQAfNewFDj8M=";
  };

  patches = [
    # pyproject has "sen" included in setuptools packages
    # but "sen/tui" directory is not being copied to the final python lib
    ./0001-fix-sources.patch
  ];

  build-system = with python3.pkgs; [
    setuptools
    wheel
  ];

  dependencies = with python3.pkgs; [
    docker
    urwid
    urwidtrees
  ];

  # still some warnings in the test output
  nativeCheckInputs = with python3.pkgs; [
    flexmock
    pytest
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "sen"
    "sen.tui"
  ];

  # no --version flag

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal User Interface for containers";
    homepage = "https://github.com/TomasTomecek/sen";
    changelog = "https://github.com/TomasTomecek/sen/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "sen";
    maintainers = with lib.maintainers; [ phanirithvij ];
  };
}
