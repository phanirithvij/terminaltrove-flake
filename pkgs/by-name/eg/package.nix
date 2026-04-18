{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "eg";
  version = "1.2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "srsudar";
    repo = "eg";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ltL+p7y5pY0bdQu0xsbYC7BwXfqJfV7nw+krzyQAeFY=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  doCheck = true;
  checkInputs = with python3.pkgs; [ mock ];
  nativeCheckInputs = with python3.pkgs; [ pytestCheckHook ];

  pythonImportsCheck = [ "eg" ];

  meta = {
    description = "Useful examples at the command line";
    homepage = "https://github.com/srsudar/eg";
    license = lib.licenses.mit;
    mainProgram = "eg";
    maintainers = with lib.maintainers; [ phanirithvij ];
  };
})
