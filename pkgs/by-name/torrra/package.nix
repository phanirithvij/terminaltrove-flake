{
  lib,
  python3,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "torrra";
  version = "2.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "stabldev";
    repo = "torrra";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gGT0S0DHDH/lJVfjCbRNdOI6hckyY8eJxRUSz+Afeso=";
  };

  build-system = with python3.pkgs; [
    hatchling
  ];

  dependencies = with python3.pkgs; [
    click
    diskcache
    httpx
    libtorrent-rasterbar
    platformdirs
    textual
    tomli-w
  ];

  optional-dependencies = with python3.pkgs; {
    docs = [
      myst-parser
      qiskit-sphinx-theme
      sphinx
      sphinx-copybutton
    ];
  };

  # libtorrent not installed (but it is, just doesn't have wheel metadata)
  dontCheckRuntimeDeps = true;

  pythonRelaxDeps = [ "click" ];

  pythonRemoveDeps = [
    "libtorrent-windows-dll"
  ];

  pythonImportsCheck = [
    "torrra"
    "libtorrent"
  ];

  doInstallCheck = true;
  versionCheckProgramArg = "--version";
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A Python tool that lets you search and download torrents without leaving your CLI";
    homepage = "https://github.com/stabldev/torrra";
    license = lib.licenses.mit;
    mainProgram = "torrra";
    maintainers = with lib.maintainers; [ phanirithvij ];
  };
})
