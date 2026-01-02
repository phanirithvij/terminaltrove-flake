{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "rhit";
  version = "2.0.4";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = "rhit";
    tag = "v${version}";
    hash = "sha256-JPEtATa57/ODYTbandGQkDdE8yBAGu6uXXuGEMaVg58=";
  };

  cargoHash = "sha256-CfjZK9CqZC45rk0Gucl0K7El6QOOt2/DRv1gQK/QJx4=";

  doInstallCheck = true;
  versionCheckProgramArg = "--version";
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A nginx log explorer";
    homepage = "https://dystroy.org/rhit/";
    changelog = "https://github.com/Canop/rhit/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "rhit";
    maintainers = with lib.maintainers; [ phanirithvij ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
