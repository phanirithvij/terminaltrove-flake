# From https://github.com/nix-community/nur-combined/blob/main/repos/nagy/pkgs/python3-packages/flameshow.nix
{
  lib,
  fetchFromGitHub,
  python3Packages,

  iteround, # TODO remove this once lands in nixpkgs python packages
  versionCheckHook,
  nix-update-script,
}:

python3Packages.buildPythonApplication rec {
  pname = "flameshow";
  version = "1.1.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "laixintao";
    repo = "flameshow";
    rev = "v${version}";
    hash = "sha256-Nx8RJmw7UAsNQ+Akg01oz+raFx9iinXMcXHDA45/yeo=";
  };

  nativeBuildInputs = with python3Packages; [
    poetry-core
  ];

  propagatedBuildInputs = with python3Packages; [
    click
    typing-extensions
    textual
    protobuf5
    iteround
  ];

  pythonRelaxDeps = [
    "protobuf"
    "iteround"
    "textual"
  ];

  doInstallCheck = true;
  versionCheckProgramArg = "--version";
  nativeInstallCheckInputs = [ versionCheckHook ];

  pythonImportsCheck = [ "flameshow" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A terminal Flamegraph viewer";
    homepage = "https://github.com/laixintao/flameshow";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    mainProgram = "flameshow";
    maintainers = with lib.maintainers; [
      nagy
      phanirithvij
    ];
  };
}
