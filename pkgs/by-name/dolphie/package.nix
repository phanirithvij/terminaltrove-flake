{
  lib,
  python3,
  fetchFromGitHub,

  myloginpath, # remove once lands in nixpkgs

  versionCheckHook,
  nix-update-script,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "dolphie";
  version = "6.11.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "charles-001";
    repo = "dolphie";
    tag = version;
    hash = "sha256-MKEDq7EPgizcIVwA9y5VudLRYWWLTsqKqlrh/mb5RxQ=";
  };

  build-system = with python3.pkgs; [
    poetry-core
  ];

  dependencies = with python3.pkgs; [
    loguru
    myloginpath
    orjson
    packaging
    plotext
    psutil
    pymysql
    requests
    rich
    sqlparse
    textual
    zstandard
  ];

  pythonRelaxDeps = true;

  pythonImportsCheck = [ "dolphie" ];

  doInstallCheck = true;
  versionCheckProgramArg = "--version";
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Your single pane of glass for real-time analytics into MySQL/MariaDB & ProxySQL";
    homepage = "https://github.com/charles-001/dolphie";
    license = lib.licenses.gpl3Only;
    mainProgram = "dolphie";
    maintainers = with lib.maintainers; [ phanirithvij ];
  };
}
