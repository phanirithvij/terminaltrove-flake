{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonPackage (finalAttrs: {
  pname = "myloginpath";
  version = "0.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PyMySQL";
    repo = "myloginpath";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2D3x+6d2mUAbCtXVPtrYnTFgBlNmYLorZ1FTWzfaNAc=";
  };

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    cryptography
  ];

  pythonImportsCheck = [ "myloginpath" ];

  meta = {
    description = "MySQL's login path file reader";
    homepage = "https://github.com/PyMySQL/myloginpath";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ phanirithvij ];
  };
})
