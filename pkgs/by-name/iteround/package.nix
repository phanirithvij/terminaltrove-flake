# From https://github.com/nix-community/nur-combined/blob/main/repos/nagy/pkgs/python3-packages/iteround.nix
{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonPackage rec {
  pname = "iteround";
  version = "1.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cgdeboer";
    repo = "iteround";
    rev = "v${version}";
    hash = "sha256-0lHu01MTf+rdrUYuRDR2IUvQQKcw7NZXBOw+nbEmPMc=";
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools
    wheel
  ];

  pythonImportsCheck = [ "iteround" ];

  meta = {
    description = "Rounds iterables (arrays, lists, sets, etc) while maintaining the sum of the initial array";
    homepage = "https://pypi.org/project/iteround/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nagy ];
    mainProgram = "iteround";
  };
}
