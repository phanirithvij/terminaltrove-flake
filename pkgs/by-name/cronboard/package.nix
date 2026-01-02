{
  lib,
  python3,
  fetchFromGitHub,

  cron,

  dt-croniter, # TODO remove once in nixpkgs
}:

python3.pkgs.buildPythonApplication rec {
  pname = "cronboard";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "antoniorodr";
    repo = "cronboard";
    tag = "v${version}";
    hash = "sha256-Vh0YQ9UjqemjbC8mPY262b1KZGSjwowd/ALO3EFGIPc=";
  };

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    bcrypt
    cron-descriptor
    croniter
    dt-croniter
    paramiko
    pytest
    pytest-asyncio
    python-crontab
    textual
    textual-autocomplete
    textual-dev
    tomlkit
  ];

  pythonImportsCheck = [ "cronboard" ];

  preFixup = ''
    makeWrapperArgs+=(--prefix PATH : ${lib.makeBinPath [ cron ]})
  '';

  # no --help or --version

  meta = {
    description = "A terminal-based dashboard for managing cron jobs locally and on servers";
    homepage = "https://github.com/antoniorodr/cronboard";
    changelog = "https://github.com/antoniorodr/cronboard/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "cronboard";
    maintainers = with lib.maintainers; [ phanirithvij ];
  };
}
