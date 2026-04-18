{
  lib,
  fetchFromGitHub,
  python3,
}:
python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "recoverpy";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "PabloLec";
    repo = "RecoverPy";
    tag = finalAttrs.version;
    hash = "sha256-j7xnOzT/Gzmv+mLdt1r6r26xBxD35rdRlC2HmNFZO0o=";
  };

  pyproject = true;

  build-system = with python3.pkgs; [ hatchling ];

  dependencies = with python3.pkgs; [ textual ];

  pythonRelaxDeps = [ "textual" ];

  doCheck = true;
  pytestFlagsArray = [
    "-o"
    "asyncio_default_fixture_loop_scope=session"
  ];
  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
    pytest-asyncio
    pytest-mock
  ];

  pythonImportsCheck = [ "recoverpy" ];

  meta = {
    description = "Interactively find and recover deleted or overwritten files from your terminal";
    homepage = "https://github.com/PabloLec/RecoverPy";
    license = lib.licenses.gpl3Only;
    mainProgram = "recoverpy";
    maintainers = with lib.maintainers; [ phanirithvij ];
  };
})
